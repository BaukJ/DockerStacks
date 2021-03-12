locals {
  multi_node = var.cluster_type != "single"

  tags = {
    Name    = "Jakub.Jasko Training"
    Owner   = "Jakub.Jasko"
    Reason  = "Training"
    Project = "CI/CD Code School - Kuba"
  }
}
