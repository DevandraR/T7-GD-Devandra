### Nama : Devandra Reswara Arkananta
### NPM  : 2206083552

# Implementasi Fitur Sprinting dan Crouching
Dalam tutorial ini, telah diimplementasikan latihan mandiri untuk mekanik sprinting dan crouching untuk meningkatkan pengalaman first-person shooter (FPS). Berikut adalah fitur-fitur yang telah ditambahkan:

## Sprinting (Berlari)
- input Handling: Pemain dapat berlari dengan menekan tombol Shift
- Kecepatan: Kecepatan berlari lebih cepat dari kecepatan berjalan yang normal (sprint_speed = 10.0 vs walk_speed = 5.0)
- Kontrol Kondisi: Pemain tidak dapat berlari jika ketika sedang jongkok (crouching)
- Implementasi: Perubahan kecepatan gerakan yang lancar menggunakan interpolasi linier (lerp)
## Crouching (Jongkok)
- Toggle System: Pemain dapat berganti antara posisi berdiri dan jongkok dengan menekan Ctrl
- Fisik Karakter:
    - Tinggi pemain berkurang ketika jongkok (crouch_height = 1.0 vs standing_height = 2.0)
    - CollisionShape dan mesh diubah sesuai dengan posisi jongkok
    - Posisi kamera disesuaikan agar lebih rendah
- Animasi Transisi: Menggunakan sistem Tween untuk transisi halus antara posisi berdiri dan jongkok
- Collision Detection: Sistem cek collision untuk mencegah pemain berdiri jika ada objek di atas (fungsi is_ceiling_above())
- Batasan Gerakan:
    - Kecepatan saat jongkok lebih lambat (crouch_speed = 3.0)
    - Pemain tidak dapat melompat ketika sedang jongkok
## Integrasi dengan Sistem Gerakan
- Sistem ini diintegrasikan dengan gerakan dasar first-person yang sudah ada
- Perpindahan antara ketiga mode gerakan (normal, sprint, crouch) bisa terjadi transisi dengan lancar
- Kecepatan gerakan menyesuaikan secara otomatis berdasarkan kondisi pemain saat ini
## Deteksi Ceiling
- Implementasi raycast untuk mendeteksi objek di atas pemain
- Mencegah pemain berdiri jika ada langit-langit/objek yang menghalangi di atas
- Meningkatkan realisme dan immersion dalam gameplay