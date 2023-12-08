# # Create a route table 
# resource "aws_route_table" "rds_route_table" {
#   vpc_id = module.vpc.vpc_id

#   tags = {
#     Name = "${var.rds_cluster_name}-route-table"
#   }
# }

# # Associate Subnet A to the route table 
# resource "aws_route_table_association" "a" {
#   subnet_id      = aws_subnet.rds_subnet_a.id
#   route_table_id = aws_route_table.rds_route_table.id
# }

# # Associate Subnet B to the route table 
# resource "aws_route_table_association" "b" {
#   subnet_id      = aws_subnet.rds_subnet_b.id
#   route_table_id = aws_route_table.rds_route_table.id
# }
