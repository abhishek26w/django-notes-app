FROM python:3.9

WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN apt-get update && \
    apt-get install -y gcc default-libmysqlclient-dev curl && \
    pip install --no-cache-dir -r requirements.txt && \
    rm -rf /var/lib/apt/lists/*

# Copy project files
COPY . .

# Load env variables from file at build time (for gunicorn config, optional)
COPY .env /app/.env
ENV $(cat /app/.env | xargs)

# Expose the Django port
EXPOSE 8000

# Run migrations and start server
CMD ["sh", "-c", "python manage.py migrate && gunicorn notesapp.wsgi:application --bind 0.0.0.0:8000"]
