data "aws_ip_ranges" "ip_ranges" {
      regions = ["us-west-1"]
      services = ["ec2"]
}

output "ip_range_ec2" {
  value = data.aws_ip_ranges.ip_ranges.cidr_blocks
}

resource "aws_security_group" "us-west-security-group-https" {
      name = "us-west-security-group-https"

      ingress {
            from_port = "443"
            to_port = "443"
            protocol = "tcp"
            cidr_blocks = data.aws_ip_ranges.ip_ranges.cidr_blocks
            ipv6_cidr_blocks = data.aws_ip_ranges.ip_ranges.ipv6_cidr_blocks
      }
}

