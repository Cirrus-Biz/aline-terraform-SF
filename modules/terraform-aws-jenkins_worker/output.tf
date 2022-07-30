# output "aws_instances" {
#   value = {
#     for k,v in aws_instance.jenkins_workers:
#         k => v
#   }
# }

// testing
output "aws_instances_ids" {
  value = {
    for ec2 in keys(aws_instance.jenkins_workers):
       ec2 => aws_instance.jenkins_workers[ec2].id
  }
}

# output "aws_instances_arns" {
#   value = {
#     for ec2 in keys(aws_instance.jenkins_workers):
#        ec2 => aws_instance.jenkins_workers[ec2].arn
#   }
# }
#
#
# output "aws_instances_ids_2" {
#     value = [ for ec2 in aws_instance.jenkins_workers : ec2.id ]
# }
#
# output "aws_instances_ids_3" {
#     value = {
#         for ec2 in aws_instance.jenkins_workers:
#             ec2.id => ec2.arn
#     }
# }

