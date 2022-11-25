data "cloudinit_config" "webtemplate" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.cwd}/cloudinitweb.yaml", {
      service_name = var.service
    })
  }
}

data "cloudinit_config" "apitemplate" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.cwd}/cloudinitapi.yaml", {
      service_name = var.service
    })
  }
}

data "cloudinit_config" "cachetemplate" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.cwd}/cloudinitcache.yaml", {
      service_name = var.service
    })
  }
}

data "cloudinit_config" "paytemplate" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.cwd}/cloudinitpay.yaml", {
      service_name = var.service
    })
  }
}

data "cloudinit_config" "datatemplate" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.cwd}/cloudinitdata.yaml", {
      service_name = var.service
    })
  }
}