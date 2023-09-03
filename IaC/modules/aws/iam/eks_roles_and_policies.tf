data "aws_caller_identity" "current" {}


data "aws_eks_cluster_auth" "current" {
  name = var.cluster_name
}


#### EBS CSI ########
data "aws_iam_policy_document" "ebs_csi_driver_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = ["${var.oidc_provider_arn}"] ## replace with oidc_arn
    }                                            #"arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}/identity/oidc/issuer" <-- this one
    #"https://oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}/identity/oidc/issuer"
    #"arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${var.aws_region}.amazonaws.com/id/${local.oidc_info.client_id}"
    actions = ["sts:AssumeRoleWithWebIdentity", "sts:AssumeRole"]
    # condition {
    #   test     = "StringLike"
    #   variable = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}/identity/oidc/issuer"#"oidc.eks.${var.aws_region}.amazonaws.com:sub"
    #   values   = ["oidc.us-east-1.eks.amazonaws.com/EXAMPLE-DEV:sub","system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    # }
    # condition {
    #   test     = "StringLike"
    #   variable = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}/identity/oidc/issuer"#"oidc.eks.${var.aws_region}.amazonaws.com:aud"
    #   values   = ["sts.amazonaws.com"]
    # }
  }
}

resource "aws_iam_role" "ebs_csi_driver_role" {
  name               = "${var.project_name}-${var.env}-EBS-CSI-Driver-Role"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_driver_assume_role.json
}


resource "kubernetes_service_account" "ebs_csi_driver_sa" {
  metadata {
    name      = "ebs-csi-driver-sa"
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.ebs_csi_driver_role.arn
    }
  }
}

resource "aws_iam_policy_attachment" "ebs_csi_driver_policy_attachment" {
  policy_arn = aws_iam_policy.ebs_csi_driver_policy.arn
  roles      = [aws_iam_role.ebs_csi_driver_role.name]
  name       = "ebs-csi-policy-attachment"
}



resource "aws_iam_policy" "ebs_csi_driver_policy" {
  name = "${var.project_name}-${var.env}-EBS-CSI-Driver-Policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "eks:UpdateAddon",
          "eks:DeleteAddon",
          "eks:DescribeAddonVersions",
          "eks:DescribeAddon",
          "eks:ListClusters",
          "eks:ListUpdates",
          "eks:DescribeCluster",
          "ec2:CreateVolume",
          "ec2:DeleteVolume",
          "ec2:DescribeVolumes",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:DescribeSnapshots",
          "ec2:DescribeVolumeAttribute",
          "ec2:ModifyVolume",
          "ec2:CreateTags",
          "ec2:*",
          "eks:*"
        ],
        "Resource" : "*"
      }
    ]
  })
}






### EKS Role and Policy Attachment ###
resource "aws_iam_role" "eks_role" {
  name = "${var.project_name}-${var.env}-EKS-ROLE"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "${var.oidc_provider_arn}", ##"arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.formatted_oidc_issuer}",
          "Service" : [
            "ec2.amazonaws.com",
            "eks.amazonaws.com",
            "elasticloadbalancing.amazonaws.com",
          ]
        },
        "Action" : ["sts:AssumeRoleWithWebIdentity", "sts:AssumeRole"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}






### S3 Athena access mentioned in Kubecost documentation ###
resource "aws_iam_policy" "s3_athena_policy" {
  name = "${var.project_name}-${var.env}-S3-Athena-Policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:Get*",
          "s3:List*"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "athena:StartQueryExecution",
          "athena:GetQueryExecution",
          "athena:GetQueryResults",
          "athena:GetQueryResultsStream",
          "athena:StopQueryExecution",
          "athena:GetWorkGroup",
          "athena:ListTagsForResource"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_athena_policy_attachment" {
  policy_arn = aws_iam_policy.s3_athena_policy.arn
  role       = aws_iam_role.eks_role.name
}





##### Karpenter Service Account ######

resource "kubernetes_namespace" "karpenter_namespace" {
  metadata {
    name = "karpenter"
  }
  depends_on = [
    var.cluster,
    var.vpc_id,
    var.oidc_provider_arn,
  ]
}

resource "aws_iam_policy" "karpenter_policy" {
  name = "${var.project_name}-${var.env}-Karpenter-Policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "ec2:*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:DescribeSnapshotAttribute",
          "ec2:DescribeSnapshots",
          "ec2:DescribeVolumeAttribute",
          "ec2:DescribeVolumeStatus",
          "ec2:DescribeVolumesModifications",
          "ec2:EnableVolumeIO",
          "ec2:GetEbsDefaultKmsKeyId",
          "ec2:GetEbsEncryptionByDefault",
          "ec2:GetEbsEncryptionByDefault",
          "ec2:ListSnapshots",
          "ec2:ModifySnapshotAttribute",
          "ec2:ModifyVolume",
          "ec2:CreateVolume",
          "ec2:ModifyVolumeAttribute",
          "ec2:ResetSnapshotAttribute",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:CreateTags",
          "ec2:*",
          "eks:*",
          "S3:ListObjects",
          "iam:PassRole",
          "pricing:GetProducts",
          "ssm:GetParameter",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:GetLifecyclePolicy",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:ListTagsForResource",
          "ecr:DescribeImageScanFindings",
          "ssm:DescribeAssociation",
          "ssm:GetDeployablePatchSnapshotForInstance",
          "ssm:GetDocument",
          "ssm:DescribeDocument",
          "ssm:GetManifest",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:ListAssociations",
          "ssm:ListInstanceAssociations",
          "ssm:PutInventory",
          "ssm:PutComplianceItems",
          "ssm:PutConfigurePackageResult",
          "ssm:UpdateAssociationStatus",
          "ssm:UpdateInstanceAssociationStatus",
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
        ],
        "Resource" : "*"
      }
    ]
  })
}



data "aws_iam_policy_document" "karpenter_assume_role" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = ["${var.oidc_provider_arn}"]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    # condition {
    #   test     = "StringEquals"
    #   variable = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}/identity/oidc/issuer"# The "condition" must be the url, the "federated identifiers" must be the arn
    #   values   = ["oidc.us-east-1.eks.amazonaws.com/EXAMPLE-DEV:sub", "system:serviceaccount:karpenter:karpenter-sa"]
  }
}
# statement {
#   effect = "Allow"
#   principals {
#     type        = "Service"
#     identifiers = ["eks.amazonaws.com", "ec2.amazonaws.com", "elasticloadbalancing.amazonaws.com"]
#   }
#   actions = ["sts:AssumeRole"]
# }
#}

resource "aws_iam_role" "karpenter_role" {
  name               = "${var.project_name}-${var.env}-Karpenter-Role"
  assume_role_policy = data.aws_iam_policy_document.karpenter_assume_role.json
}

resource "kubernetes_service_account" "karpenter_sa" {
  metadata {
    name      = "karpenter-sa"
    namespace = "karpenter"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.karpenter_role.arn
    }
  }
}

resource "aws_iam_role_policy_attachment" "karpenter_policy_attachment" {
  policy_arn = aws_iam_policy.karpenter_policy.arn
  role       = aws_iam_role.karpenter_role.name
}



#### Kubecost ######################


resource "kubernetes_namespace" "kubecost_namespace" {
  metadata {
    name = "kubecost"
  }
  depends_on = [
    var.cluster,
    var.vpc_id,
    var.oidc_provider_arn,
  ]
}
resource "aws_iam_policy" "kubecost_cost_analyzer_policy" {
  name = "${var.project_name}-${var.env}-Kubecost-Cost-Analyzer-Policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "ec2:*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:DescribeSnapshotAttribute",
          "ec2:DescribeSnapshots",
          "ec2:DescribeVolumeAttribute",
          "ec2:DescribeVolumeStatus",
          "ec2:DescribeVolumesModifications",
          "ec2:EnableVolumeIO",
          "ec2:GetEbsDefaultKmsKeyId",
          "ec2:GetEbsEncryptionByDefault",
          "ec2:GetEbsEncryptionByDefault",
          "ec2:ListSnapshots",
          "ec2:ModifySnapshotAttribute",
          "ec2:ModifyVolume",
          "ec2:CreateVolume",
          "ec2:ModifyVolumeAttribute",
          "ec2:ResetSnapshotAttribute",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:CreateTags",
          "ec2:*",
          "eks:*",
          "S3:ListObjects",
          "aps:*",
          "cloudwatch:*",
          "athena:*",
          "glue:*",
        ],
        "Resource" : "*"
      }
    ]
  })
}


data "aws_iam_policy_document" "kubecost_cost_analyzer_assume_role" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = ["${var.oidc_provider_arn}"]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    # condition {
    #   test     = "StringEquals"
    #   variable = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}/identity/oidc/issuer"
    #   values   = ["oidc.us-east-1.eks.amazonaws.com/EXAMPLE-DEV:sub", "system:serviceaccount:kubecost:kubecost-cost-analyzer"]
  }
}
# statement {
#   effect = "Allow"
#   principals {
#     type        = "Service"
#     identifiers = ["eks.amazonaws.com", "ec2.amazonaws.com", "elasticloadbalancing.amazonaws.com"]
#   }
#   actions = ["sts:AssumeRole"]
# }
#}

resource "aws_iam_role" "kubecost_cost_analyzer_role" {
  name               = "${var.project_name}-${var.env}-Kubecost-Cost-Analyzer-Role"
  assume_role_policy = data.aws_iam_policy_document.kubecost_cost_analyzer_assume_role.json
}

resource "kubernetes_service_account" "kubecost_cost_analyzer_sa" {
  metadata {
    name      = "kubecost-cost-analyzer"
    namespace = var.kubecost_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.kubecost_cost_analyzer_role.arn
    }
  }
}

resource "aws_iam_role_policy_attachment" "kubecost_cost_analyzer_policy_attachment" {
  policy_arn = aws_iam_policy.kubecost_cost_analyzer_policy.arn
  role       = aws_iam_role.kubecost_cost_analyzer_role.name
}


####### Load Balancer Controller ######

data "aws_iam_policy_document" "load_balancer_controller_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = ["${var.oidc_provider_arn}"] ## replace with oidc_arn
    }
    actions = ["sts:AssumeRoleWithWebIdentity", "sts:AssumeRole"]
    # condition {
    #   test     = "StringLike"
    #   variable = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}/identity/oidc/issuer"     #oidc.eks.${var.aws_region}.amazonaws.com:sub"
    #   values   = ["oidc.us-east-1.eks.amazonaws.com/EXAMPLE-DEV:sub","system:serviceaccount:kube-system:load-balancer-controller"]
    # }
    # condition {
    #   test     = "StringLike"
    #   variable = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}/identity/oidc/issuer"#"oidc.eks.${var.aws_region}.amazonaws.com:aud"
    #   values   = ["sts.amazonaws.com"]
    # }
  }
}

resource "aws_iam_role" "load_balancer_controller_role" {
  name               = "${var.project_name}-${var.env}-Load-Balancer-Controller-Role"
  assume_role_policy = data.aws_iam_policy_document.load_balancer_controller_assume_role.json
}


resource "kubernetes_service_account" "load_balancer_controller_sa" {
  metadata {
    name      = "load-balancer-controller-sa"
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.load_balancer_controller_role.arn
    }
  }
}

resource "aws_iam_policy" "load_balancer_controller_policy" {
  name = "${var.project_name}-${var.env}-Load-Balancer-Controller-Policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "acm:DescribeCertificate",
          "acm:ListCertificates",
          "acm:GetCertificate",
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeAddresses",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeInstances",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeTags",
          "ec2:GetCoipPoolUsage",
          "ec2:DescribeCoipPools",
          "ec2:*",
          "waf-regional:*",
          "wafv2:*",
          "shield:*",
          "elasticloadbalancing:*",
          "shield:GetSubscriptionState",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeListenerCertificates",
          "elasticloadbalancing:DescribeSSLPolicies",
          "elasticloadbalancing:DescribeRules",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetGroupAttributes",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:DescribeTags",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:CreateRule",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:DeleteRule",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:ModifyRule",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:ModifyTargetGroupAttributes",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:SetIpAddressType",
          "elasticloadbalancing:SetRulePriorities",
          "elasticloadbalancing:SetSecurityGroups",
          "elasticloadbalancing:SetSubnets",
          "elasticloadbalancing:SetWebACL",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateRule",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:AddTags",
          "wafv2:GetWebACLForResource",
          "waf-regional:GetWebACLForResource",
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "load_balancer_controller_role_policy_attachment" {
  policy_arn = aws_iam_policy.load_balancer_controller_policy.arn
  roles      = [aws_iam_role.load_balancer_controller_role.name]
  name       = "load-balancer-controller-role-policy-attachment"
}



##### Prometheus ###########

resource "kubernetes_namespace" "prometheus_namespace" {
  metadata {
    name = "prometheus"
  }
  depends_on = [
    var.cluster,
    var.vpc_id,
    var.oidc_provider_arn,
  ]
}

data "aws_iam_policy_document" "prometheus_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = ["${var.oidc_provider_arn}"] ## replace with oidc_arn
    }
    actions = ["sts:AssumeRoleWithWebIdentity", "sts:AssumeRole"]
    # condition {
    #   test     = "StringLike"
    #   variable = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}/identity/oidc/issuer"  #"oidc.eks.${var.aws_region}.amazonaws.com:sub"
    #   values   = ["oidc.us-east-1.eks.amazonaws.com/EXAMPLE-DEV:sub","system:serviceaccount:kube-system:prometheus"]
    # }
    # condition {
    #   test     = "StringLike"
    #   variable = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}/identity/oidc/issuer"#"oidc.eks.${var.aws_region}.amazonaws.com:aud"
    #   values   = ["sts.amazonaws.com"]
    # }
  }
}

resource "aws_iam_role" "prometheus_role" {
  name               = "${var.project_name}-${var.env}-Prometheus-Role"
  assume_role_policy = data.aws_iam_policy_document.prometheus_assume_role.json
}


resource "kubernetes_service_account" "prometheus_sa" {
  metadata {
    name      = "prometheus-sa"
    namespace = "prometheus"

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.prometheus_role.arn
    }
  }
  # depends_on = [
  # kubernetes_namespace.prometheus_namespace ]
}

resource "aws_iam_policy" "prometheus_policy" {
  name = "${var.project_name}-${var.env}-Prometheus-Policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "aps:*",
          "eks:*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "prometheus_role_policy_attachment" {
  policy_arn = aws_iam_policy.prometheus_policy.arn
  roles      = [aws_iam_role.prometheus_role.name]
  name       = "prometheus-role-policy-attachment"
}




