resource "aws_placement_group" "placement-group-cluster" {
  name     = "ec2-placement-group-cluster"
  strategy = "cluster"

}

resource "aws_placement_group" "placement-group-spread" {
  name         = "ec2-placement-group-spread"
  strategy     = "spread"
  spread_level = "rack" //host

}

resource "aws_placement_group" "placement-group-partition" {
  name            = "ec2-placement-group-partition"
  strategy        = "partition"
  partition_count = 4

}