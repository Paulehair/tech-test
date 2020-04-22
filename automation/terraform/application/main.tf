resource "aws_instance" "web" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  count         = var.instance_count

  key_name      = var.instance_key_name

  tags = {
    Name      = "${var.stage}-application"
    component = "application"
    stage     = var.stage
  }
}

resource "aws_elasticache_cluster" "example" {
  cluster_id           = "${var.stage}-redis"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
}

# Create load balancer
resource "aws_elb" "bar" {
  name               = "${var.stage}-elb"
  availability_zones = ["eu-west-3"]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/"
    interval            = 30
  }

  instances                   = aws_instance.web.*.id
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "foobar-terraform-elb"
  }
}