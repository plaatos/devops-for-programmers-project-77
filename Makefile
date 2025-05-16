# Makefile

TERRAFORM_DIR = terraform
ANSIBLE_DIR = ansible

# === Основные команды ===

deploy: terraform-apply wait-for-ssh ansible-deploy
	@echo "✅ Инфраструктура и приложение успешно развернуты"

# === Terraform команды ===

terraform-init:
	cd $(TERRAFORM_DIR) && terraform init

terraform-apply: terraform-init
	cd $(TERRAFORM_DIR) && terraform apply -auto-approve

terraform-destroy:
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve || true

# === Подготовка к Ansible ===

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

generate-inventory:
	@cd $(TERRAFORM_DIR) && ../ansible/generate_inventory.sh
	@echo "✅ inventory.ini сгенерирован"

# === Ansible команды ===

ansible-deploy: generate-inventory
	cd $(ANSIBLE_DIR) && ansible-playbook -i inventory.ini playbook.yml --vault-password-file <(echo 'secret')
		
ansible-clean:
	@echo "🧹 Очистка контейнеров на серверах..."
	ansible all -i inventory.ini -m shell -a "docker stop redmine_app redmine_mysql || true" $(VAULT_PASS)
	ansible all -i inventory.ini -m shell -a "docker rm redmine_app redmine_mysql || true" $(VAULT_PASS)

status:
	cd $(ANSIBLE_DIR) && ansible all -i inventory.ini -m shell -a "docker ps -a"

logs:
	cd $(ANSIBLE_DIR) && ansible all -i inventory.ini -m shell -a "docker logs redmine_app"
	cd $(ANSIBLE_DIR) && ansible all -i inventory.ini -m shell -a "docker logs redmine_mysql"

# === Очистка ===

clean-artifacts:
	rm -f $(ANSIBLE_DIR)/inventory.ini

clean: terraform-destroy clean-artifacts
	@echo "✅ Инфраструктура и временные файлы удалены"
