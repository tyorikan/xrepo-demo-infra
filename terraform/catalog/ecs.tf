# catalog-service on Amazon ECS (Fargate): task definition and the resources it references.

resource "aws_secretsmanager_secret" "catalog_db_password" {
  name = "catalog/${var.environment}/db-password"
}

resource "aws_route53_record" "catalog_db" {
  zone_id = var.internal_zone_id
  name    = "catalog-db.${var.environment}.your-org.internal"
  type    = "CNAME"
  ttl     = 300
  records = [var.catalog_db_endpoint]
}

resource "aws_ecs_task_definition" "catalog" {
  family                   = "catalog-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = var.execution_role_arn
  container_definitions = jsonencode([
    {
      name      = "catalog-service"
      image     = "123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/catalog-service:${var.image_tag}"
      essential = true
      portMappings = [
        { containerPort = 8080, protocol = "tcp" }
      ]
      environment = [
        { name = "CATALOG_CACHE_TTL", value = var.catalog_cache_ttl },
        { name = "LOG_LEVEL", value = "info" },
        { name = "CATALOG_DB_HOST", value = aws_route53_record.catalog_db.name }
      ]
      secrets = [
        { name = "CATALOG_DB_PASSWORD", valueFrom = aws_secretsmanager_secret.catalog_db_password.arn }
      ]
      healthCheck = {
        command  = ["CMD-SHELL", "curl -f http://localhost:8080/healthz || exit 1"]
        interval = 30
        timeout  = 5
        retries  = 3
      }
    }
  ])
}
