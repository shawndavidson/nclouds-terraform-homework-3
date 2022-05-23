# Module: auto-scaling-group
# The purpose of this module is to declare the resources need to establish an AWS 
# Auto-Scaling Group


resource "aws_autoscaling_group" "auto_scaling_group" {
  name_prefix          = "${var.project}-auto-scaling-group"
 
  launch_configuration  = "${var.launch_configuration}"
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  force_delete         = true
  vpc_zone_identifier  = "${var.subnet_ids}"

  lifecycle {
    create_before_destroy = true
  }
}
