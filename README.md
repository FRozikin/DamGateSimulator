```markdown
# SCADA BENDUNGAN — Node-RED Flow (Dam Gate HMI) — Enhanced Controls

Perubahan utama versi ini:
- Panel kontrol digabung di satu ui_template (tata letak lebih rapi)
- Tombol non-active (disabled) ketika Controller bukan REMOTE (lrStatus != 2)
- Konfirmasi ESD dan Save Defaults
- RESET button tersedia (kirim command 1 ke 40002)
- Save Defaults menulis 3 register: 40021 (min), 40022 (max), 40023 (span)
- Animasi gate lebih halus dengan transition CSS

Dependencies (install sebelum import):
- node-red-contrib-modbus
  - install: cd %USERPROFILE%\\.node-red && npm i node-red-contrib-modbus
- @flowfuse/node-red-dashboard
  - install: cd %USERPROFILE%\\.node-red && npm i @flowfuse/node-red-dashboard
  - atau pasang lewat Palette Manager di Node-RED

Cara import:
1. Pastikan Node-RED berjalan dan dependencies terpasang.
2. Buka Node-RED editor.
3. Menu > Import > Clipboard, paste isi `flow.json` di atas, tekan Import.
4. Deploy.
5. Jika ModRSSim2 berjalan di host/port/unitid berbeda, edit node 'ModRSSim2 TCP' (modbus-client) lalu deploy ulang.

Catatan teknis:
- Polling Holding Registers 40001..40023 (address 0..22) tiap 1s.
- Command register 40002 (address 1); command codes: 1=Reset,2=Stop,3=Open,4=Close,5=ESD.
- Save Defaults writes single registers 40021/40022/40023 (addresses 20/21/22).
- UI template mengirim objek ke flow; node 'Handle control panel messages' melakukan validasi LR dan meneruskan ke node write yang sesuai.
- Notifikasi tampil sebagai toast di pojok dashboard.

Jika ingin penyesuaian tambahan:
- Buat role-based tombol (admin only), atau tambahkan konfirmasi multi-step untuk ESD.
- Tambah log/history ke file atau chart waktu nyata.
- Ubah gaya (warna/ikon) sesuai preferensi.

```
