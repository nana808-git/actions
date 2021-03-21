module "pipeline" {
  source = "./modules/pipeline"
  #codepipeline_events_enabled    = true
  cluster_name                   = var.cluster_name
  environment                    = var.environment
  #env_name                       = var.env_name
  image                          = var.image
  codestar_connector_credentials = var.codestar_connector_credentials
  container_name                 = var.container_name
  app_repository_name            = var.app_repository_name
  repository_name                = var.repository_name
  git_repository                 = var.git_repository
  repository_url                 = module.ecs.repository_url
  app_service_name               = module.ecs.service_name
  vpc_id                         = var.vpc_id

  build_options                  = var.build_options
  build_args                     = var.build_args

  #subnet_ids                     = "module.vpc.aws_subnet.public*.id"
  #subnet_ids                     = "module.vpc.${var.network["publicAz1, publicAz1"]}"
  subnet_ids                     = var.public_subnets
}




