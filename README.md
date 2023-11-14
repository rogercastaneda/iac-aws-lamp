# About

This basic project is about to setup a lamp environment using autoscaling, load balancing, ssl configuration, RDS and an mounted volume with EFS.

The project creates the following resources:
- 1 RDS instance
- 1 EC2 instance (Launch Configuration, Autoscaling)
- 1 Application Load Balancer (SSL need to point to an existing ACM resource)
- Private and Public subnets
- 1 EFS volume

## Configuration

Inside of the **dev** folder

Create the file `terraform.tfvars` 
```
DB_USER=""
DB_PASSWORD=""
DB_NAME=""
vpc_id="vpc-"
key_name=
web_instance_type=
db_instance_type=
domain=
```

Also update the `aws_ami` name and profile name in `provider.tf`.

## Plan and Apply
Check the changes are ok running
```
terraform plan
```

Apply the changes
```
terraform apply
```


## Destroy

You can destroy all the resources with the following command
```
terraform destroy
```

## AMI

I created an AMI with this the following commands and I used it as base for the autoscaling configuration.

```
apt-get update && apt-get upgrade -y
apt autoremove && autoclean -y
apt-get install -y apache2
apt-get install -y php php-mysql php-curl php-gd php-mbstring php-soap php-xml php-xmlrpc php-zip

a2enmod rewrite
systemctl restart apache2

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
```