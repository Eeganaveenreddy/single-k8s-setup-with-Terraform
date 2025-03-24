node_groups = {
    dev = {
        desired_size = 2
        max_size = 4
        min_size = 1
        instance_types = ["t3.medium"]
    }
    prod = {
        desired_size = 3
        max_size = 5
        min_size = 2
        instance_types = ["t3.medium"]
    }
}