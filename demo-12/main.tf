resource "aws_iam_group" "administrator" {
  name = "developers"
}

resource "aws_iam_group_policy_attachment" "administrator_attach" {
  group      = aws_iam_group.administrator.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# creating user
resource "aws_iam_user" "Abhi" {
  name = "Abhi"
}

resource "aws_iam_user_group_membership" "name" {
  user = aws_iam_user.Abhi.name
  groups = [
    aws_iam_group.administrator.name
  ]
}
