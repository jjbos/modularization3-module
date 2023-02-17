module "ec2_instance_app" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.3.0"

  for_each               = toset([for v in range(var.count_app_instances) : tostring(v)])
  name                   = format("ec2-%s-app-%s", local.env_short, var.app_name)
  ami                    = data.aws_ami.al2_ami.image_id
  instance_type          = var.ec2_type_app
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.sgp_app.id]
  subnet_id              = "${element(data.aws_subnets.aws_private_subnets.ids, each.key)}"

  root_block_device = [{
    volume_size = "10"
    encrypted   = true
    volume_type = "gp3"
    kms_key_id  = aws_kms_key.kms_app.arn
  }]

  metadata_options = {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

}
