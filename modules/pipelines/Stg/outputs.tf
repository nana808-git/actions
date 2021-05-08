output pipeline_id {
  value = aws_codepipeline.pipeline.id
}

output pipeline_arn {
  value = aws_codepipeline.pipeline.arn
}

output "codepipeline_events_sns_arn" {
  description = "ARN of CodePipeline's SNS Topic"
  value       = var.codepipeline_events_enabled ? join(",", aws_sns_topic.codepipeline_events.*.arn) : "not set"
}