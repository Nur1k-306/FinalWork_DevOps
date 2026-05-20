# Итоговая DevOps-работа: Smart Laundry System

## 1. Краткое описание

Smart Laundry System - веб-приложение для управления умной прачечной. В итоговую DevOps-упаковку входят frontend, API Gateway, backend-микросервисы и инфраструктурные зависимости. Приложение упаковано в Docker-контейнеры и запускается через отдельный `docker-compose.devops.yml`. Для backend и frontend используются multistage Dockerfile. Централизованное логирование реализовано через `Loki`, сбор логов из Docker-контейнеров выполняет `Promtail`, а просмотр логов доступен в `Grafana`. В репозитории лежат bash-скрипты для сборки, запуска и остановки стенда, а также скриншоты готового результата.

## 2. Что входит в итоговую упаковку

| Компонент | Назначение |
| --- | --- |
| frontend | Веб-интерфейс |
| api-gateway | Единая входная точка |
| backend services | Бизнес-логика микросервисов |
| PostgreSQL | Реляционные данные |
| MongoDB | Документные данные |
| Redis | Кэш |
| Kafka | Доменные события |
| MinIO | Object storage |
| Loki | Хранилище логов |
| Promtail | Сбор docker-логов |
| Grafana | Просмотр логов |

## 3. Структура репозитория

```text
FinalWork_DevOps/
|-- docker-compose.devops.yml
|-- Dockerfile.service.devops
|-- README_DEVOPS_FINAL.md
|-- frontend/
|   |-- .dockerignore
|   |-- Dockerfile.devops
|   `-- nginx.devops.conf
|-- infra/
|   |-- loki/
|   |   `-- loki-config.yml
|   |-- promtail/
|   |   `-- promtail-config.yml
|   `-- grafana/
|       `-- provisioning/
|           `-- datasources/
|               `-- loki-datasource.yml
|-- scripts/
|   `-- devops-final/
|       |-- build.sh
|       |-- deploy.sh
|       `-- down.sh
`-- docs/
    `-- devops-final/
        `-- screenshots/
```

## 4. Сборка образов

Требования: Docker, Docker Compose plugin и Bash. Для корректного сбора логов нужен Docker Engine или Docker Desktop в режиме Linux containers, потому что `Promtail` читает `json-file` Docker logs.

```bash
bash scripts/devops-final/build.sh -t v1
```

Если `-t` не указан, скрипт использует тег `latest`.

## 5. Развёртывание

```bash
bash scripts/devops-final/deploy.sh -t v1
```

Скрипт запускает compose-стенд с тегом `TAG=<tag>` и после запуска выполняет `docker compose -f docker-compose.devops.yml ps`.

## 6. Остановка

```bash
bash scripts/devops-final/down.sh
```

## 7. Доступ к сервисам

- Frontend: `http://localhost:5173`
- API Gateway: `http://localhost:8080`
- Grafana: `http://localhost:3000`
- Loki API: `http://localhost:3100`
- MinIO Console: `http://localhost:9001`

Grafana credentials:

- login: `admin`
- password: `admin`

## 8. Логирование

Схема логирования:

```text
Docker containers -> Promtail -> Loki -> Grafana
```

Все сервисы пишут в `stdout/stderr`. Docker хранит логи через `json-file`. `Promtail` читает container logs, добавляет labels контейнера и сервиса и отправляет записи в `Loki`. В `Grafana` datasource `Loki` подключается автоматически через provisioning.

Примеры запросов для Grafana Explore:

```logql
{service="api-gateway"}
{service="user-service"}
{service="device-service"}
{service=~".*service"}
{container=~".*api-gateway.*"}
```

## 9. Скриншоты

Папка со скриншотами: `docs/devops-final/screenshots/`

- `app.jpg` - frontend в браузере
- `docker-compose-ps.png.jpg` - список контейнеров после запуска
- `docker-images-v1.png.jpg` - собранные Docker-образы
- `grafana-loki-datasource.png.jpg` - datasource Loki в Grafana
- `grafana-api-gateway-logs.png.jpg` - логи API Gateway в Grafana
- `grafana-service-logs.png.jpg` - логи backend-сервисов в Grafana
- `loki-promtail-running.png.jpg` - контейнеры Loki / Promtail / Grafana

## 10. Результат

В репозитории собран отдельный DevOps-final слой для Smart Laundry System: multistage сборка образов, отдельный Docker Compose, централизованное логирование через Loki и Grafana, bash-скрипты запуска и готовые скриншоты для сдачи итоговой работы.
