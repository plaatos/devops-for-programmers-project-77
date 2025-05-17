# devops-for-programmers-project-77

[![Actions Status](https://github.com/plaatos/devops-for-programmers-project-77/actions/workflows/hexlet-check.yml/badge.svg )](https://github.com/plaatos/devops-for-programmers-project-77/actions )

## Доступ к приложению
🔗 [Перейти к Redmine](https://test-step.ru )  
![Upmon Status](https://www.upmon.com/badge/63aaee31-2b07-4e54-91a2-5fcaef/IxKr_bO0-2.svg )  [Мониторинг через Upmon](https://upmon.net/29cfdebb-3552-4726-9d9a-5996b04ee273 )  

---

## Описание проекта

Этот проект реализует DevOps-инфраструктуру для развертывания приложения Redmine с использованием Terraform и Ansible. Инфраструктура разворачивается в Yandex Cloud и состоит из:

- 2 ВМ с Docker
- Балансировщика нагрузки (Yandex Application Load Balancer)
- DNS-записи для домена `test-step.ru`
- Поддержки HTTPS с сертификатом
- Мониторинга через Datadog
- Проверки доступности через Upmon

---

## Требования к окружению

- Установленный [Terraform](https://www.terraform.io/ )
- Установленный [Ansible](https://docs.ansible.com/ )
- Установленный [Make](https://www.gnu.org/software/make/ )
- Учетная запись в [Yandex Cloud](https://cloud.yandex.ru/ )
- Зарегистрированный домен (в данном случае — `test-step.ru`)
- API ключ Datadog

---

## Как развернуть проект

### Подготовка

1. Клонируйте репозиторий:
```bash
git clone https://github.com/plaatos/devops-for-programmers-project-77.git 
cd devops-for-programmers-project-77
```

2. Убедитесь, что переменные в файле `terraform/secrets.auto.tfvars` корректны:
   - `yc_token` — токен Yandex Cloud
   - `ssh_keys` — SSH-ключ для доступа к ВМ
   - `datadog_api_key` — API-ключ Datadog

> 🔐 Все чувствительные данные зашифрованы или хранятся вне репозитория.

---

### Создание инфраструктуры (Terraform)

Убедитесь, что вы авторизованы в Yandex Cloud.

```bash
make terraform-init
make terraform-apply
```

Эти команды создадут:
- Виртуальные машины
- Виртуальную сеть и подсеть
- Балансировщик нагрузки
- DNS-записи
- Целевую группу

---

### Деплой приложения (Ansible)

```bash
make ansible-deploy
```

Будет выполнен playbook, который:
- Установит Docker на серверы
- Развернет Redmine и MySQL в контейнерах
- Настроит `.env` файл для Redmine

> 🔐 Для работы с секретами используется `vault.yml`.

#### Доступные Makefile-команды:

| Команда                | Описание                             |
|------------------------|--------------------------------------|
| `make deploy`          | Полный цикл: инфраструктура + Ansible |
| `make terraform-init`  | Инициализация Terraform               |
| `make terraform-apply` | Применение конфигурации Terraform     |
| `make wait-for-ssh`    | Ожидание доступности SSH на серверах  |
| `make generate-inventory` | Генерация inventory.ini            |
| `make ansible-deploy`  | Выполнить Ansible-плейбук             |
| `make ansible-clean`   | Очистка контейнеров на серверах       |
| `make terraform-destroy` | Удалить всю инфраструктуру          |
| `make clean-artifacts` | Удалить временные файлы               |
| `make status`          | Показать статус контейнеров           |
| `make logs`            | Посмотреть логи контейнеров           |


---

### Мониторинг

На серверы устанавливается агент Datadog. Конфигурация находится в плейбуке `playbook.yml`. Также можно запускать отдельно:

```bash
make ansible-deploy
```

#### Настройки мониторинга:
- Проверка доступности Redmine по URL: `http://localhost:3000`
- Отправка метрик в Datadog
- Алерты на недоступность

---

### Проверка доступности сервиса

Сервис добавлен в [Upmon](https://upmon.net/29cfdebb-3552-4726-9d9a-5996b04ee273 ) для проверки из разных точек мира.

---

## Используемые технологии

- **IaC**: Terraform
- **Конфигурационное управление**: Ansible
- **Облачный провайдер**: Yandex Cloud
- **Мониторинг**: Datadog
- **Наблюдаемость**: Upmon
- **Контейнеризация**: Docker
- **CI/CD**: GitHub Actions

---
