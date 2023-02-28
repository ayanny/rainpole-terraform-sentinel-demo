// Modules
module "tfplan-functions" {
  source = "../common-functions/tfplan-functions/tfplan-functions.sentinel"
}

module "tfstate-functions" {
  source = "../common-functions/tfstate-functions/tfstate-functions.sentinel"
}

module "tfconfig-functions" {
  source = "../common-functions/tfconfig-functions/tfconfig-functions.sentinel"
}

module "aws-functions" {
  source = "./aws-functions/aws-functions.sentinel"
}

// Policy

policy "check-ec2-application-tags" {
  source = "./check-ec2-application-tags.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "check-ec2-environment-tags-all" {
  source = "./check-ec2-environment-tags-all.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "restrict-ec2-instance-type-web" {
  source = "./restrict-ec2-instance-type-web.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "restrict-ec2-instance-type-api" {
  source = "./restrict-ec2-instance-type-api.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "restrict-ec2-instance-type-cache" {
  source = "./restrict-ec2-instance-type-cache.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "restrict-ec2-instance-type-pay" {
  source = "./restrict-ec2-instance-type-pay.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "restrict-ec2-instance-type-data" {
  source = "./restrict-ec2-instance-type-data.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "require-most-recent-AMI-version" {
  source = "./require-most-recent-AMI-version.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "restrict-ami-owners" {
  source = "./restrict-ami-owners.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "restrict-availability-zones" {
  source = "./restrict-availability-zones.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "restrict-production-deployment-times" {
  source = "./restrict-production-deployment-times.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "restrict-ec2-instance-type-environment" {
  source = "./restrict-ec2-instance-type-environment.sentinel"
  enforcement_level = "soft-mandatory"
}

