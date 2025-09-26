# Python Flask Todo App

Web app sederhana todolist menggunakan Flask dan SQLite.

## Setup

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Jalankan app:
   ```bash
   python app.py
   ```

3. Buka browser ke `http://localhost:5000`

## Features

- Tambah task baru
- Toggle completed/not completed
- Delete task
- Database SQLite otomatis dibuat

## Struktur

- `app.py`: Main Flask application
- `models.py`: Database models
- `templates/`: HTML templates
- `todos.db`: SQLite database (dibuat otomatis)

## Deployment dengan Gunicorn dan Nginx

Untuk production deployment, gunakan Gunicorn sebagai WSGI server dan Nginx sebagai reverse proxy.

### 1. Install Gunicorn
```bash
pip install gunicorn
```

### 2. Jalankan dengan Gunicorn
```bash
gunicorn --bind 127.0.0.1:8000 app:app
```

### 3. Install dan Konfigurasi Nginx
```bash
sudo apt update
sudo apt install nginx
```

### 4. Edit Nginx Config
```bash
sudo nano /etc/nginx/sites-available/default
```

Isi config:
```nginx
server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /static {
        alias /workspaces/explore-tech/1-python-web/static;
    }
}
```

### 5. Test dan Reload Nginx
```bash
sudo nginx -t
sudo service nginx reload
```

### 6. Akses App
Buka browser ke `http://localhost`

### 7. Jalankan sebagai Service (Opsional)
Buat systemd service untuk Gunicorn:
```bash
sudo nano /etc/systemd/system/todoapp.service
```

Isi:
```ini
[Unit]
Description=Todo App
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=/workspaces/explore-tech/1-python-web
ExecStart=/usr/local/bin/gunicorn --bind 127.0.0.1:8000 app:app
Restart=always

[Install]
WantedBy=multi-user.target
```

Enable dan start:
```bash
sudo systemctl enable todoapp
sudo systemctl start todoapp
```

## Konfigurasi DNS

Untuk mengakses app dengan domain name, ikuti langkah berikut:

### 1. Edit /etc/hosts (untuk Local DNS)
```bash
sudo nano /etc/hosts
```

Tambahkan baris:
```
127.0.0.1    todoapp.local
```

### 2. Update Nginx Config untuk Domain
```bash
sudo nano /etc/nginx/sites-available/default
```

Ubah `server_name`:
```nginx
server {
    listen 80;
    server_name todoapp.local;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /static {
        alias /workspaces/explore-tech/1-python-web/static;
    }
}
```

### 3. Reload Nginx
```bash
sudo nginx -t
sudo service nginx reload
```

### 4. Akses dengan Domain
Buka browser ke `http://todoapp.local`

### 5. DNS Server Eksternal (Opsional)
Untuk domain publik, gunakan layanan seperti:
- Cloudflare
- Route 53 (AWS)
- GoDaddy

Point A record ke IP server Anda.

### 6. SSL Certificate (HTTPS)
Install Let's Encrypt:
```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d todoapp.local
```

## Monitoring dengan Prometheus dan Grafana

Aplikasi ini sudah terintegrasi dengan Prometheus untuk monitoring metrics. Ikuti langkah berikut untuk setup monitoring stack.

### 1. Install Prometheus dan Grafana
```bash
# Install Prometheus
sudo apt update
sudo apt install -y prometheus

# Install Grafana
sudo apt install -y software-properties-common wget apt-transport-https
sudo wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key
echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt update
sudo apt install -y grafana
```

### 2. Konfigurasi Prometheus
Prometheus sudah dikonfigurasi untuk scrape metrics dari Flask app. Config file terletak di `monitoring/prometheus.yml`:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'flask-todo-app'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:5000']

  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
```

### 3. Jalankan Services
```bash
# Jalankan Flask app
python app.py

# Jalankan Prometheus (dalam terminal terpisah)
cd /workspaces/explore-tech/1-python-web
prometheus --config.file=monitoring/prometheus.yml --storage.tsdb.path=monitoring/data --web.listen-address=:9090

# Jalankan Grafana (dalam terminal terpisah)
sudo grafana-server --config=/etc/grafana/grafana.ini --homepath=/usr/share/grafana --configOverrides cfg:server.http_port=3002
```

### 4. Setup Grafana Dashboard
1. Buka browser ke `http://localhost:3002`
2. Login dengan default credentials:
   - Username: `admin`
   - Password: `admin`
3. Add Prometheus sebagai data source:
   - Configuration → Data Sources → Add data source
   - Pilih Prometheus
   - URL: `http://localhost:9090`
   - Save & Test

### 5. Buat Dashboard
1. Create Dashboard baru
2. Add panel untuk metrics Flask app:
   - Query: `flask_http_request_total` (total HTTP requests)
   - Query: `flask_http_request_duration_seconds` (request duration)
   - Query: `todo_items_total` (total todo items)

### 6. Metrics yang Tersedia
Flask app expose metrics berikut di endpoint `/metrics`:
- `flask_http_request_total`: Total HTTP requests
- `flask_http_request_duration_seconds`: Request duration histogram
- `todo_items_total`: Total todo items in database
- `todo_operations_total`: Total CRUD operations

### 7. Akses Monitoring
- Prometheus: `http://localhost:9090`
- Grafana: `http://localhost:3002`
- Flask Metrics: `http://localhost:5000/metrics`