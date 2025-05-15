# Makefile

TERRAFORM_DIR = terraform
ANSIBLE_DIR = ansible

deploy: terraform-apply wait-for-ssh ansible-deploy

terraform-init:
	cd $(TERRAFORM_DIR) && terraform init

terraform-apply: terraform-init
	cd $(TERRAFORM_DIR) && terraform apply -auto-approve

wait-for-ssh:
	@echo "⏳ Ожидаем доступность SSH на серверах..."
	@cd $(TERRAFORM_DIR) && \
		IPS_JSON=$$(terraform output -json server_public_ips); \
		if [ -z "$$IPS_JSON" ]; then \
			echo "❌ Не удалось получить IP-адреса"; \
			exit 1; \
		fi; \
	IPS=$$(echo "$$IPS_JSON" | sed 's/\[//; s/\]//' | tr -d '"' | tr ',' ' '); \
	echo "DEBUG: SERVERS = $$IPS"; \
	for ip in $$IPS; do \
		echo "🔌 Проверяем SSH на $$ip"; \
		until bash -c "exec 6<>/dev/tcp/$$ip/22" >/dev/null 2>&1; do \
			echo "💤 Жду SSH на $$ip..."; \
			sleep 5; \
		done; \
		echo "✅ SSH доступен на $$ip"; \
	done;
	@echo "✅ Все серверы доступны по SSH"

# Генерация inventory.ini через shell-скрипт
generate-inventory:
	cd $(ANSIBLE_DIR) && bash generate_inventory.sh

ansible-deploy: generate-inventory
	cd $(ANSIBLE_DIR) && ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass

clean: terraform-destroy clean-artifacts

terraform-destroy:
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve || true

clean-artifacts:
	rm -f $(ANSIBLE_DIR)/inventory.ini