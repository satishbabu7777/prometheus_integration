resource "aws_eks_node_group" "booking" {
  cluster_name    = aws_eks_cluster.booking.name
  node_group_name = "booking-workers"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  subnet_ids = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]

  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker1,
    aws_iam_role_policy_attachment.worker2,
    aws_iam_role_policy_attachment.worker3
  ]
}