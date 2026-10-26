# Load balancer target group and ECS service of catalog-service.

resource "aws_lb_target_group" "catalog" {
  name        = "catalog-${var.environment}"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/statusz"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_ecs_service" "catalog" {
  name            = "catalog-service"
  cluster         = var.cluster_arn
  task_definition = aws_ecs_task_definition.catalog.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.service_security_group_id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.catalog.arn
    container_name   = "catalog-service"
    container_port   = 8080
  }
}
