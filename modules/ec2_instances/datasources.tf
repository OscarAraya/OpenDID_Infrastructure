data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"]
  filter { 
    name    = "name"
    values  = ["al2023-ami-*-kernel-6.1-x86_64"]
    }
}