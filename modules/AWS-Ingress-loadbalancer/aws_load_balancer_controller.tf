resource "kubernetes_service_account" "alb_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller_role.arn
    }
  }
}
data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "my_cluster" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks_auth" {
  name = data.aws_eks_cluster.my_cluster.name
}

data "tls_certificate" "tls_cert" {
  url = data.aws_eks_cluster.my_cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "oidc_resource" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.tls_cert.certificates.0.sha1_fingerprint]
  url = data.aws_eks_cluster.my_cluster.identity.0.oidc.0.issuer
}

data "aws_iam_openid_connect_provider" "oidc" {
  arn = aws_iam_openid_connect_provider.oidc_resource.arn
}

resource "aws_iam_role_policy_attachment" "alb_controller_policy" {
  policy_arn = aws_iam_policy.alb_controller_policy.arn
  role       = aws_iam_role.alb_controller_role.name
}


resource "aws_iam_role" "alb_controller_role" {
  name = "eks-alb-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        # Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.my_cluster.identity[0].oidc[0].issuer, "https://", "")}"
        Federated = data.aws_iam_openid_connect_provider.oidc.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(data.aws_eks_cluster.my_cluster.identity.0.oidc.0.issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}

# Create Kubernetes ClusterRole for permissions
resource "kubernetes_cluster_role" "alb_cluster_role" {
  metadata {
    name = "aws-load-balancer-controller-cluster-role"
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["list", "watch"]
  }
  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingressclasses"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses", "ingresses/status"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
  rule {
    api_groups = ["elbv2.k8s.aws"]
    resources  = ["targetgroupbindings", "targetgroupbindings/status"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses", "ingresses/status"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
  rule {
    api_groups = [""]
    resources  = ["services"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["elbv2.k8s.aws"]
    resources  = ["ingressclassparams"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["configmaps", "endpoints", "nodes"]
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
  }
}

# Bind the Role to the Service Account
resource "kubernetes_cluster_role_binding" "alb_controller_role_binding" {
  metadata {
    name = "aws-load-balancer-controller-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.alb_cluster_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.alb_controller.metadata[0].name
    namespace = "kube-system"
  }
}


resource "null_resource" "alb_crds" {
  provisioner "local-exec" {
    command = "kubectl apply -k https://github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"
  }
}

# Deploy AWS Load Balancer Controller
resource "kubernetes_deployment" "alb_controller_deployment" {
  depends_on = [null_resource.alb_crds]

  metadata {
    name      = "aws-load-balancer-controller"

    
    namespace = "kube-system"
    labels = {
      app = "aws-load-balancer-controller"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "aws-load-balancer-controller"
      }
    }
    
    template {
      metadata {
        labels = {
          app = "aws-load-balancer-controller"
        }
      }

      spec {
        # Add serviceAccountName here
        service_account_name = "aws-load-balancer-controller"

        container {
          image = "602401143452.dkr.ecr.us-west-2.amazonaws.com/amazon/aws-load-balancer-controller:v2.6.1"
          name  = "aws-load-balancer-controller"

          security_context {
            run_as_non_root = false
            run_as_user     = 0
          }

          args = [
            "--cluster-name=${var.eks_cluster_name}",
            "--ingress-class=alb",
            "--aws-region=ap-south-1"
          ]

          env {
            name  = "AWS_REGION"
            value = "ap-south-1"
          }
          # Mount the secret to the expected path
          volume_mount {
            name       = "tls-cert"
            mount_path = "/tmp/k8s-webhook-server/serving-certs"
            read_only  = true
          }
        }
        volume {
          name = "tls-cert"
          secret {
            secret_name = "aws-load-balancer-webhook-tls"
          }
        }
      }
      
    }
  }
}

resource "kubernetes_secret" "alb_webhook_tls" {
  metadata {
    name      = "aws-load-balancer-webhook-tls"
    namespace = "kube-system"
  }

  data = {
    "tls.crt" = file("${path.module}/tls.crt")
    "tls.key" = file("${path.module}/tls.key")
  }

  type = "kubernetes.io/tls"
}
