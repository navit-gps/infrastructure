resource "aws_lambda_function" "fdroid" {
  filename         = "${path.module}/../lambda/fdroid.zip"
  source_code_hash = "${data.archive_file.fdroid.output_base64sha256}"
  function_name    = "fdroid-webhook"
  description      = "Run fdroid task from backup"
  role             = "${aws_iam_role.fdroid.arn}"
  handler          = "fdroid.handler"
  timeout          = "60"
  runtime          = "python3.6"

  depends_on = ["data.archive_file.fdroid"]
}

data "archive_file" "fdroid" {
  type        = "zip"
  source_file = "${path.module}/../lambda/fdroid.py"
  output_path = "${path.module}/../lambda/fdroid.zip"
}

resource "aws_iam_role" "fdroid" {
  name               = "fdroid_lambda"
  assume_role_policy = "${data.aws_iam_policy_document.fdroid.json}"
}

data "aws_iam_policy_document" "fdroid" {
  statement = {
    actions = ["sts:AssumeRole"]

    principals = {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "fdroid" {
  name        = "fdroid"
  policy      = "${data.aws_iam_policy_document.fdroid_policy.json}"
  description = "Policy attached to fdroid lambda"
}

data "aws_iam_policy_document" "fdroid_policy" {
  # Required permissions for Lambda to send logs to CW
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

resource "aws_iam_role_policy_attachment" "fdroid" {
  role       = "${aws_iam_role.fdroid.name}"
  policy_arn = "${aws_iam_policy.fdroid.arn}"
}
