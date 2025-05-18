# Makefile
deploy: terraform-apply wait-for-ssh ansible-deploy
	@echo "✅ Инфраструктура и приложение успешно развернуты"

# === Terraform команды ===
terraform-init: generate-terraform-vars
	make -C terraform init

terraform-apply: terraform-init
	make -C terraform apply

terraform-destroy:
	make -C terraform destroy

# === Подготовка к Ansible ===
wait-for-ssh:
	@echo "⏳ Ожидаем доступность SSH на серверах..."
	@cd terraform && \
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
	done; \
	echo "✅ Все серверы доступны по SSH"

# === Ansible команды ===
ansible-deploy:
	make -C ansible deploy

ansible-clean:
	make -C ansible clean

status:
	make -C ansible status

logs:
	make -C ansible logs

# === Очистка ===
clean-artifacts:
	rm -f ansible/inventory.ini

clean: terraform-destroy clean-artifacts
	@echo "✅ Инфраструктура и временные файлы удалены"
	
generate-terraform-vars:
	bash -c "ansible-playbook -i ansible/inventory.ini --ask-vault-pass -e \"template_file=../terraform/secrets.auto.tfvars.j2\" -e \"output_file=../terraform/secrets.auto.tfvars\" -e @ansible/group_vars/webservers/vault.yml scripts/render-template.yml"

