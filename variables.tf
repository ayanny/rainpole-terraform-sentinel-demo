variable "vpccidr" {
  description = "Large CIDR used for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "AWS_ACCESS_KEY" {
  description = "AWS AWS_ACCESS_KEY"
  type = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS SECRET ACCESS KEY"
  type = string
}

variable "region" {
  description = "AWS region to provision resources"
  type        = string
  default     = "ca-central-1"
}

variable "environment" {
  description = "Environment in which to deploy resources. This should correlate to Github branches and is configured in Terraform Cloud"
  type        = string
}

variable "service" {
  description = "Name of service to be deployed"
  type        = string
  default     = "fake-service"
}

variable "webapp" {
  description = "Number of web app instances to be deployed"
  type        = number
  default     = 1
}

variable "apiapp" {
  description = "Number of api app instances to be deployed"
  type        = number
  default     = 2
}

variable "cacheapp" {
  description = "Number of cache app instances to be deployed"
  type        = number
  default     = 2
}

variable "payapp" {
  description = "Number of payment app instances to be deployed"
  type        = number
  default     = 2
}

variable "dataapp" {
  description = "Number of data app instances to be deployed"
  type        = number
  default     = 1
}

variable "webport" {
  description = "Port value used for web application and associated security groups"
  type        = string
  default     = "9090"
}

variable "apiport" {
  description = "Port value used for api application and associated security groups"
  type        = string
  default     = "9191"
}

variable "cacheport" {
  description = "Port value used for cache application and associated security groups"
  type        = string
  default     = "9292"
}

variable "payport" {
  description = "Port value used for payments application and associated security groups"
  type        = string
  default     = "9393"
}

variable "dataport" {
  description = "Port value used for data application and associated security groups."
  type        = string
  default     = "9494"
}

variable "webinstance" {
  description = "Instance type to deploy web app with. This is set per workspace in Terraform Cloud."
  type        = string
}

variable "apiinstance" {
  description = "Instance type to deploy api app with. This is set per workspace in Terraform Cloud."
  type        = string
}

variable "cacheinstance" {
  description = "Instance type to deploy cache app with. This is set per workspace in Terraform Cloud."
  type        = string
}

variable "payinstance" {
  description = "Instance type to deploy payment app with. This is set per workspace in Terraform Cloud."
  type        = string
}

variable "datainstance" {
  description = "Instance type to deploy data app with. This is set per workspace in Terraform Cloud."
  type        = string
}