# MoulsifyEdu

A Flutter learning app with flashcards.

## 🔊 Audio Narasi per Kartu (Tanpa TTS)

Aplikasi ini kini mendukung audio dari file asset (bukan TTS). Setiap kartu dapat memiliki 2 audio:

- Depan: audio untuk judul/intro kartu
- Belakang: audio untuk deskripsi di sisi belakang kartu

### 1) Letak file audio

Simpan file audio Anda (mp3/wav) di folder berikut:

```
assets/audio/
```

Pastikan `pubspec.yaml` sudah memuat path tersebut (sudah diset oleh project ini):

```
flutter:
	assets:
		- assets/audio/
```

### 2) Isi path audio di data kartu

Buka `lib/models/card_data.dart` dan isi properti berikut untuk setiap kartu:

- `audioFrontAsset`: path relatif untuk audio sisi depan (contoh: `audio/momentum_pengertian_front.mp3`)
- `audioBackAsset`: path relatif untuk audio sisi belakang (contoh: `audio/momentum_pengertian_back.mp3`)

Contoh:

```dart
BaseDatas(
	title: 'Pengertian Momentum',
	imageUrl: 'assets/resources/gambar-momentum.png',
	category: CardCategory.momentum,
	description: 'Momentum adalah ...',
	audioFrontAsset: 'audio/momentum_pengertian_front.mp3',
	audioBackAsset: 'audio/momentum_pengertian_back.mp3',
),
```

Catatan: Jika path audio tidak diisi atau file tidak ditemukan, aplikasi akan tetap berjalan tanpa memutar audio.

### 3) Kontrol suara

- Tombol speaker di kanan atas untuk mengaktifkan/menonaktifkan suara.
- Saat pindah ke kartu baru atau kembali ke sisi depan, aplikasi otomatis memutar `audioFrontAsset`.
- Saat kartu dibalik ke belakang, aplikasi memutar `audioBackAsset`.

### 4) Dependensi

Kami menggunakan paket `audioplayers` untuk memutar audio asset.
