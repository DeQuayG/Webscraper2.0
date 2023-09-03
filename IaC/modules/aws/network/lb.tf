resource "aws_lb" "eks_lb" {
  name               = "${var.project_name}-eks-lb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public1.id,
    aws_subnet.public2.id,
    aws_subnet.public3.id,
  ]

  security_groups = [aws_security_group.eks_lb_sg.id]
}

resource "aws_security_group" "eks_lb_sg" {
  name_prefix = "eks-lb-sg-"
  vpc_id      = aws_vpc.example.id


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.public_access_cidrs[0]]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.public_access_cidrs[0]]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.public_access_cidrs[0]]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = [var.public_access_cidrs[0]]
  }

  ingress {
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = [var.public_access_cidrs[0]]
  }

  ingress {
    from_port   = 9003
    to_port     = 9003
    protocol    = "tcp"
    cidr_blocks = [var.public_access_cidrs[0]]
  }

  ingress {
    from_port   = 9004
    to_port     = 9004
    protocol    = "tcp"
    cidr_blocks = [var.public_access_cidrs[0]]
  }

  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = [var.public_access_cidrs[0]]
  }

  ingress {
    from_port   = 9731
    to_port     = 9731
    protocol    = "tcp"
    cidr_blocks = [var.public_access_cidrs[0]]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.public_access_cidrs[0]]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = [var.public_access_cidrs[0]]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  target_groups = [
    {
      port     = 80
      protocol = "HTTP"
    },
    {
      port     = 9003
      protocol = "HTTP"
    },
    {
      port     = 9090
      protocol = "HTTP"
    },
    {
      port     = 3001
      protocol = "HTTP"
    },
    {
      port     = 3000
      protocol = "HTTP"
    },

    {
      port     = 8443
      protocol = "HTTP"
    }
  ]
}

resource "aws_lb_listener" "eks_lb_listeners" {
  count             = length(local.target_groups)
  load_balancer_arn = aws_lb.eks_lb.arn
  port              = local.target_groups[count.index].port
  protocol          = local.target_groups[count.index].protocol

  default_action {
    target_group_arn = aws_lb_target_group.eks_target_groups[count.index].arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "eks_target_groups" {
  count       = length(local.target_groups)
  name        = "${var.project_name}-eks-tg-${local.target_groups[count.index].port}"
  port        = local.target_groups[count.index].port
  protocol    = local.target_groups[count.index].protocol
  target_type = "instance"
  vpc_id      = aws_vpc.example.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/healthz"
    matcher             = "200-399"
  }

}

