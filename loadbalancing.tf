#Creates Load Balancers with public IP
resource "aws_lb" "lbext" {
  name                             = "lbext"
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true

  subnet_mapping {
    subnet_id     = aws_subnet.ext.id
    allocation_id = aws_eip.ext.id
  }
}

#Creates internal Load Balancers without Public IPs
resource "aws_lb" "lbapi" {
  name               = "lbapi"
  internal           = true
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id            = aws_subnet.api.id
    private_ipv4_address = "10.0.2.10"
  }
}

resource "aws_lb" "lbcache" {
  name               = "lbcache"
  internal           = true
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id            = aws_subnet.cache.id
    private_ipv4_address = "10.0.3.10"
  }
}

resource "aws_lb" "lbpay" {
  name               = "lbpay"
  internal           = true
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id            = aws_subnet.payments.id
    private_ipv4_address = "10.0.4.10"
  }
}

resource "aws_lb" "lbdata" {
  name               = "lbdata"
  internal           = true
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id            = aws_subnet.data.id
    private_ipv4_address = "10.0.5.10"
  }
}

#Create LB Target Groups
resource "aws_lb_target_group" "web" {
  name     = "lbtgweb"
  port     = tonumber(var.webport)
  protocol = "TCP"
  vpc_id   = aws_vpc.sentinel-demo-vpc.id
}

resource "aws_lb_target_group" "api" {
  name     = "lbtgapi"
  port     = tonumber(var.apiport)
  protocol = "TCP"
  vpc_id   = aws_vpc.sentinel-demo-vpc.id
}

resource "aws_lb_target_group" "cache" {
  name     = "lbtgcache"
  port     = tonumber(var.cacheport)
  protocol = "TCP"
  vpc_id   = aws_vpc.sentinel-demo-vpc.id
}

resource "aws_lb_target_group" "pay" {
  name     = "lbtgpay"
  port     = tonumber(var.payport)
  protocol = "TCP"
  vpc_id   = aws_vpc.sentinel-demo-vpc.id
}

resource "aws_lb_target_group" "data" {
  name     = "lbtgdata"
  port     = tonumber(var.dataport)
  protocol = "TCP"
  vpc_id   = aws_vpc.sentinel-demo-vpc.id
}

#Create LB Listeners
resource "aws_lb_listener" "lblistenerweb" {
  load_balancer_arn = aws_lb.lbext.arn
  port              = var.webport
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_listener" "lblistenerapi" {
  load_balancer_arn = aws_lb.lbapi.arn
  port              = var.apiport
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}

resource "aws_lb_listener" "lblistenercache" {
  load_balancer_arn = aws_lb.lbcache.arn
  port              = var.cacheport
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cache.arn
  }
}

resource "aws_lb_listener" "lblistenerpay" {
  load_balancer_arn = aws_lb.lbpay.arn
  port              = var.payport
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pay.arn
  }
}

resource "aws_lb_listener" "lblistenerdata" {
  load_balancer_arn = aws_lb.lbdata.arn
  port              = var.dataport
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.data.arn
  }
}

#Associates instances with target group
resource "aws_lb_target_group_attachment" "web" {
  count            = var.webapp
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web[count.index].id
  port             = tonumber(var.webport)
}

resource "aws_lb_target_group_attachment" "api" {
  count            = var.apiapp
  target_group_arn = aws_lb_target_group.api.arn
  target_id        = aws_instance.api[count.index].id
  port             = tonumber(var.apiport)
}

resource "aws_lb_target_group_attachment" "cache" {
  count            = var.cacheapp
  target_group_arn = aws_lb_target_group.cache.arn
  target_id        = aws_instance.cache[count.index].id
  port             = tonumber(var.cacheport)
}

resource "aws_lb_target_group_attachment" "pay" {
  count            = var.payapp
  target_group_arn = aws_lb_target_group.pay.arn
  target_id        = aws_instance.payments[count.index].id
  port             = tonumber(var.payport)
}

resource "aws_lb_target_group_attachment" "data" {
  count            = var.dataapp
  target_group_arn = aws_lb_target_group.data.arn
  target_id        = aws_instance.data[count.index].id
  port             = tonumber(var.dataport)
}