output "front_end_lb_name" {
  value = "${aws_lb.front_end.name}"
}

output "front_end_lb_dns_name" {
  value = "${aws_lb.front_end.dns_name}"
}

output "prometheus_target_group_name" {
  value = "${aws_lb_target_group.prometheus.name}"
}

output "alertmanager_target_group_name" {
  value = "${aws_lb_target_group.alertmanager.name}"
}

output "grafana_target_group_name" {
  value = "${aws_lb_target_group.grafana.name}"
}

output "prometheus_dns_name" {
  value = "${aws_route53_record.prometheus.name}"
}

output "alertmanager_dns_name" {
  value = "${aws_route53_record.alertmanager.name}"
}

output "grafana_dns_name" {
  value = "${aws_route53_record.grafana.name}"
}

output "front_end_security_group" {
  value = "${aws_security_group_rule.https.id}"
}