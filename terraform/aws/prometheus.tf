resource "aws_lb" "front_end" {
  name            = "${var.prefix}-front-end"
  subnets         = "${var.alb_subnet_ids}"
  security_groups = ["${aws_security_group.front_end.id}"]
}

resource "aws_lb_target_group" "prometheus" {
  name     = "${var.prefix}-prometheus"
  port     = 9090
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  health_check {
    path = "/"
    matcher = "401"
  }
}

resource "aws_lb_target_group" "alertmanager" {
  name     = "${var.prefix}-alertmanager"
  port     = 9093
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  health_check {
    path = "/"
    matcher = "401"
  }
}

resource "aws_lb_target_group" "grafana" {
  name     = "${var.prefix}-grafana"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  health_check {
    path = "/"
    matcher = "302"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.front_end.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${var.ssl_cert_arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.prometheus.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "prometheus" {
  listener_arn = "${aws_lb_listener.front_end.arn}"
  priority     = 50

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.prometheus.arn}"
  }

  condition {
    field  = "host-header"
    values = ["prometheus.${var.base_domain}"]
  }
}

resource "aws_lb_listener_rule" "grafana" {
  listener_arn = "${aws_lb_listener.front_end.arn}"
  priority     = 51

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.grafana.arn}"
  }

  condition {
    field  = "host-header"
    values = ["grafana.${var.base_domain}"]
  }
}

resource "aws_lb_listener_rule" "alertmanager" {
  listener_arn = "${aws_lb_listener.front_end.arn}"
  priority     = 52

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.alertmanager.arn}"
  }

  condition {
    field  = "host-header"
    values = ["alertmanager.${var.base_domain}"]
  }
}

resource "aws_security_group" "front_end" {
  name   = "${var.prefix}-front-end"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.front_end.id}"
}

resource "aws_security_group_rule" "https" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.front_end.id}"
}

resource "aws_route53_record" "prometheus" {
  zone_id = "${var.zone_id}"
  name    = "prometheus.${var.base_domain}"
  type    = "CNAME"
  ttl     = 300

  records = ["${aws_lb.front_end.dns_name}"]
}

resource "aws_route53_record" "alertmanager" {
  zone_id = "${var.zone_id}"
  name    = "alertmanager.${var.base_domain}"
  type    = "CNAME"
  ttl     = 300

  records = ["${aws_lb.front_end.dns_name}"]
}

resource "aws_route53_record" "grafana" {
  zone_id = "${var.zone_id}"
  name    = "grafana.${var.base_domain}"
  type    = "CNAME"
  ttl     = 300

  records = ["${aws_lb.front_end.dns_name}"]
}