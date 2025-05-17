# terraform/Makefile
init:
	terraform init

apply: init
	terraform apply -auto-approve

destroy:
	terraform destroy -auto-approve || true

output:
	terraform output -json server_public_ips
