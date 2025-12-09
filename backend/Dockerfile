FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_DEFAULT_TIMEOUT=100
ENV PIP_NO_CACHE_DIR=off

WORKDIR /app

# --- Dependencies for psycopg2 ---
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gcc \
        python3-dev \
        libpq-dev \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# --- Install Python deps with increased timeout + fast mirror ---
COPY requirements.txt /app/

RUN pip install --default-timeout=100 -r requirements.txt -i https://pypi.org/simple

# If всё ещё будет медленно, можно использовать АлиЮн:
# RUN pip install --default-timeout=100 -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/

COPY . /app/

EXPOSE 8000

CMD ["sh", "-c", "python manage.py migrate && python manage.py collectstatic --noinput && gunicorn project.wsgi:application --bind 0.0.0.0:8000 --workers 3"]
