# 🚀 TensorFlow.js Interactive Demo with Nginx

Demo interaktif TensorFlow.js yang menjalankan model machine learning sederhana di browser menggunakan Nginx sebagai web server.

## 📋 Fitur

- ✅ **TensorFlow.js** - Machine learning di browser
- 🎯 **Linear Regression** - Model belajar pola `y ≈ 2x - 1`
- 🌐 **Nginx Server** - Web server production-ready
- 🔄 **Real-time Training** - Model dilatih langsung di browser
- 📱 **Responsive** - Bekerja di desktop dan mobile
- 🚀 **CORS Enabled** - Mendukung cross-origin requests

## 🏗️ Arsitektur

```
┌─────────────────┐
│   Nginx Server  │ ← Port 8080
│                 │
│ - index.html    │
│ - TensorFlow.js │
│ - Static files  │
└─────────────────┘
```

## 🚀 Quick Start

### Prerequisites

- Nginx (akan diinstall otomatis jika belum ada)
- Modern web browser dengan JavaScript enabled

### Menjalankan Demo

#### Option 1: Jalankan Semuanya (Recommended)
```bash
./run-all.sh
```
Script ini akan:
- Memulai Nginx server
- Membuka browser ke `http://localhost:8080`
- Menampilkan demo TensorFlow.js

#### Option 2: Jalankan Server Saja
```bash
./run-nginx.sh
```
Kemudian buka browser ke `http://localhost:8080`

#### Option 3: Buka Browser Saja
```bash
./open-browser.sh
```
Pastikan Nginx sudah berjalan di port 8080

## 🎮 Cara Menggunakan Demo

1. **Tunggu Training** - Model akan dilatih otomatis saat halaman dimuat
2. **Masukkan Angka** - Ketik angka x di input field
3. **Klik Prediksi** - Lihat hasil prediksi model
4. **Coba Berulang** - Test dengan angka berbeda

### Contoh:
- Input: `5` → Output: `y ≈ 9.00` (karena 2×5-1 = 9)
- Input: `10` → Output: `y ≈ 19.00` (karena 2×10-1 = 19)

## 📁 Struktur Project

```
5-tensorflowjs-html/
├── index.html           # Halaman utama dengan TensorFlow.js
├── nginx.conf           # Konfigurasi Nginx
├── run-nginx.sh         # Script menjalankan Nginx
├── open-browser.sh      # Script membuka browser
├── run-all.sh          # Script menjalankan semua
└── README.md           # Dokumentasi ini
```

## 🔧 Konfigurasi Nginx

Konfigurasi Nginx (`nginx.conf`) meliputi:

- **Port 8080** - Server listening port
- **CORS Headers** - Mendukung TensorFlow.js CDN
- **Gzip Compression** - Optimasi performa
- **Static File Serving** - Serve file HTML dan assets
- **Error Handling** - Proper error responses

## 🧠 TensorFlow.js Model

### Arsitektur Model:
```javascript
model = tf.sequential();
model.add(tf.layers.dense({units: 1, inputShape: [1]}));
```

### Training Data:
- **Input (x)**: [1, 2, 3, 4]
- **Output (y)**: [1, 3, 5, 7]
- **Pola**: `y = 2x - 1`

### Hyperparameters:
- **Optimizer**: Stochastic Gradient Descent (SGD)
- **Loss Function**: Mean Squared Error
- **Epochs**: 200

## 🐛 Troubleshooting

### Nginx tidak bisa start
- Pastikan port 8080 tidak digunakan aplikasi lain
- Cek apakah nginx terinstall: `nginx -v`
- Lihat log error: `sudo tail -f /var/log/nginx/error.log`

### Browser tidak bisa buka
- Pastikan Nginx sudah berjalan: `ps aux | grep nginx`
- Coba akses manual: `curl http://localhost:8080`
- Cek firewall atau proxy settings

### TensorFlow.js tidak loading
- Pastikan koneksi internet stabil (untuk CDN)
- Cek browser console untuk error JavaScript
- Pastikan browser mendukung WebGL

## 📊 Monitoring

### Cek Status Nginx:
```bash
# Cek proses nginx
ps aux | grep nginx

# Cek port listening
netstat -tlnp | grep 8080

# Lihat log akses
sudo tail -f /var/log/nginx/access.log
```

### Performance Tips:
- Model training berjalan di background saat halaman load
- Prediksi real-time tanpa server round-trip
- Gzip compression mengurangi ukuran transfer

## 🔄 Development

### Modifikasi Model:
Edit bagian JavaScript di `index.html`:

```javascript
// Ubah data training
const xs = tf.tensor2d([1, 2, 3, 4, 5], [5, 1]);
const ys = tf.tensor2d([1, 3, 5, 7, 9], [5, 1]);

// Ubah epochs
await model.fit(xs, ys, {epochs: 500});
```

### Custom Styling:
Edit CSS di bagian `<style>` dalam `index.html`

## 🤝 Contributing

1. Fork repository
2. Buat branch fitur baru
3. Commit perubahan
4. Push ke branch
5. Buat Pull Request

## 📄 License

Project ini open source dan tersedia di bawah lisensi MIT.

---

**Selamat belajar machine learning! 🤖✨**