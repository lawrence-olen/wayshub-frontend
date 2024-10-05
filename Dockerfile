# Stage 1: Inisialisasi dan install dependensi
FROM node:14-alpine AS build
WORKDIR /app

# Salin file package.json dan install dependensi
COPY package*.json ./
RUN npm ci  # Gunakan npm ci untuk instalasi lebih cepat dan konsisten

# Salin semua file kedalam kontainer
COPY . .

# Jalankan build aplikasi
RUN npm run build

# Stage 2: Inisialisasi untuk menjalankan aplikasi
FROM node:14-alpine
WORKDIR /app

# Salin hasil build dari stage pertama
COPY --from=build /app ./

# Install PM2 secara global
RUN npm i pm2 -g

# Salin file konfigurasi PM2 ke direktori kerja
COPY ecosystem.config.js ./

# Menjalankan aplikasi menggunakan PM2
CMD [ "pm2-runtime", "ecosystem.config.js" ]
