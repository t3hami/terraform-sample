
resource "aws_cloudwatch_event_rule" "event_rule" {
  name                = "${var.name}-cloudwatch-event"
  description         = "Fires every ${var.rate} minutes"
  schedule_expression = "rate(${var.rate} minutes)"
}

resource "aws_cloudwatch_event_target" "target_event" {
  rule      = aws_cloudwatch_event_rule.event_rule.name
  target_id = "${var.name}-cloudwatch-event-id"
  arn = var.target_arn
}


//this is a temporary project to showcase terraform and AWS skills so not much resources are created

