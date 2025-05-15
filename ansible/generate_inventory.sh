#!/bin/bash

# ansible/generate_inventory.sh

set -euo pipefail

# Получаем вывод Terraform в JSON-формате
IPS_JSON=$(cd ../terraform && terraform output -json server_public_ips)

# Удаляем [ ] и кавычки, превращаем JSON-массив в список IP через пробел
IPS=($(echo "$IPS_JSON" | sed 's/\[//; s/\]//' | tr -d '"' | tr ',' ' '))

# Создаём inventory.ini
cat > inventory.ini <<EOF
[webservers]
EOF

for i in "${!IPS[@]}"; do
  echo "server-$((${i} + 1)) ansible_host=${IPS[$i]} ansible_user=michel" >> inventory.ini
done