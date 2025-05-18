# ansible/Makefile
generate-inventory:
	./generate_inventory.sh
	@echo "✅ inventory.ini сгенерирован"

deploy: generate-inventory
	ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass

clean:
	@echo "🧹 Очистка контейнеров на серверах..."
	ansible all -i inventory.ini -m shell -a "docker stop redmine_app redmine_mysql || true"
	ansible all -i inventory.ini -m shell -a "docker rm redmine_app redmine_mysql || true"

status:
	ansible all -i inventory.ini -m shell -a "docker ps -a"

logs:
	ansible all -i inventory.ini -m shell -a "docker logs redmine_app"
	ansible all -i inventory.ini -m shell -a "docker logs redmine_mysql"
