resource "aws_efs_file_system" "wp" {
  creation_token = "efs-${local.env}"
}

resource "aws_efs_mount_target" "mt" {
  file_system_id = aws_efs_file_system.vol.id
  subnet_id      = aws_default_subnet.default_az1.id

  security_groups = [
    aws_security_group.web.id,
  ]
}

resource "aws_efs_mount_target" "mt2" {
  file_system_id = aws_efs_file_system.vol.id
  subnet_id      = aws_default_subnet.default_az2.id

  security_groups = [
    aws_security_group.web.id,
  ]
}
resource "aws_efs_mount_target" "mt3" {
  file_system_id = aws_efs_file_system.vol.id
  subnet_id      = aws_default_subnet.default_az3.id

  security_groups = [
    aws_security_group.web.id,
  ]
}
