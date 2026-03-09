# DB-corse-project
# Курсовой проект — веб-приложение на Flask (работа с БД)

Краткое описание
-----------------
Это учебный Flask-проект для работы с заготовками, поставками и заказами.
Основные возможности:
- Аутентификация / регистрация пользователей (`app/auth`)
- Просмотр каталога заготовок и мониторинг (`app/data`)
- Корзина и оформление заказов (`app/cart`)
- Создание/хранение отчётов по продажам и поставкам (`app/analytics`)

Архитектура и паттерны
-----------------------
- Flask + блюпринты: точка входа `run.py`. Блюпринты регистрируются с префиксами (`/auth`, `/monitoring`, `/cart`, `/analytics`).
- Работа с БД через `psycopg2` и контекстный менеджер `app/db/context_manager.py` — он возвращает `cursor` и делает commit/rollback автоматически.
- SQL хранится в виде отдельных файлов в `app/*/sql/` и читаетcя через `app/db/sql_provider.py` (Jinja2-шаблоны для SQL-параметров).
- Формы: WTForms (`flask_wtf`) в `app/*/forms.py` (часть форм). Для простых POST-форм иногда используются plain HTML inputs.
- Пароли хэшируются `hashlib.sha256` (учебный вариант).

База данных
-----------
- Ожидается PostgreSQL. Параметры подключения через переменные окружения:
	- `POSTGRES_HOST`, `POSTGRES_PORT`, `POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD`.
- Создание схемы и наполнения данными: SQL-скрипты находятся в `app/db/db_data/`.
	- Важно: некоторые DDL используют `gen_random_uuid()` — включите расширение `pgcrypto` в базе: `CREATE EXTENSION IF NOT EXISTS pgcrypto;`.
- Скрипты для корзины/отчетов/триггеров лежат соответственно (`cart.sql`, `reports.sql`, `triggers.sql`).

Как запустить локально
----------------------
1. Создайте и активируйте виртуальное окружение:
```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```
2. Настройте переменные окружения (пример для macOS / Linux):
```bash
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5432
export POSTGRES_DB=your_db
export POSTGRES_USER=your_user
export POSTGRES_PASSWORD=your_pass
```
3. Подготовьте БД (создайте extension + выполните SQL-файлы из `app/db/db_data`):
```bash
# Подключитесь к БД и выполните файлы, пример через psql
psql "host=$POSTGRES_HOST port=$POSTGRES_PORT dbname=$POSTGRES_DB user=$POSTGRES_USER" -f app/db/db_data/tables.sql
psql "..." -f app/db/db_data/triggers.sql
psql "..." -f app/db/db_data/cart.sql
psql "..." -f app/db/db_data/reports.sql
psql "..." -f app/db/db_data/input_data.sql
psql "..." -f app/db/db_data/users_data.sql
```
4. Запустить приложение:
```bash
source venv/bin/activate
python run.py
```
Откройте http://127.0.0.1:5000

Ключевые файлы и директории
---------------------------
- `run.py` — точка входа, регистрация блюпринтов
- `app/auth` — логика авторизации, формы, SQL (`register.sql`, `authenticate.sql`)
- `app/data` — мониторинг и каталог, модели используют `SQLProvider`
- `app/cart` — корзина: шаблоны `app/templates/cart`, SQL в `app/cart/sql`, модель `app/cart/model.py`
- `app/analytics` — отчёты: модели, маршруты, SQL (`app/db/db_data/reports.sql` создает таблицы и функции)
- `app/db/context_manager.py` — подключение к БД и транзакции
- `app/db/sql_provider.py` — загрузка SQL-файлов как Jinja2-шаблонов

Примеры полезных команд
-----------------------
- Запуск dev-сервера: `python run.py`
- Выполнение SQL-файла: `psql "host=$POSTGRES_HOST port=$POSTGRES_PORT dbname=$POSTGRES_DB user=$POSTGRES_USER" -f path/to/file.sql`

Особенности и «gotchas» (важно для разработки)
---------------------------------------------
- Проект НЕ использует ORM — вместо этого все запросы через `psycopg2` и `cursor`. Обновления/вставки обычно делают `RETURNING id` и читают `db.fetchone()[0]`.
- `SQLProvider.get()` возвращает текст SQL (Jinja2) — при передаче параметров используйте `get(filename, **params)`.
- WTForms используется не везде: некоторые формы (например, карточки каталога) реализованы plain HTML, поэтому в обработчиках маршрутов иногда читают `request.form` напрямую.
- Декоратор доступа: `app/auth/access.py` — `login_required` и `permission_required(...)` — используйте строки формата `permission_role` (например, `reports_viewer`).
- Обратите внимание на триггеры в `triggers.sql`: они автоматически корректируют склад (`warehouse`) при создании заказов/поставок — тестируйте транзакции аккуратно.

Дальнейшие улучшения (опционально)
---------------------------------
- Добавить соль и более стойкий алгоритм хеширования паролей (bcrypt, argon2).
- Добавить миграции (Alembic) для управления схемой БД.
- Подробные тесты для маршрутов и моделей.

Контакты / поддержка
---------------------
Если нужно — могу помочь применить SQL в БД, настроить окружение или улучшить проверку прав и шаблоны.

---
Файл `app/db/db_data/reports.sql` содержит DDL-функции для генерации отчётов; используйте их для автоматического построения агрегированных отчётов.

# DB-corse-project