# Ubuntu Server'a Kubernetes ve Docker Kurulum Rehberi

Bu rehber, Ubuntu Server üzerine Docker ve Kubernetes kurulumunu adım adım anlatmaktadır.

## 💻 SSH ile Uzaktan Kurulum (Önerilen)

MacOS terminalinden Ubuntu sunucuya bağlanarak kurulum:

### 1. SSH ile Bağlanma
```bash
ssh kullanici@sunucu-ip
# Örnek: ssh ubuntu@192.168.1.100
```

### 2. Kurulum Dosyasını Kopyalama
```bash
# MacOS terminalinden (yeni terminal penceresi)
scp setup.sh kullanici@sunucu-ip:~/
# Örnek: scp setup.sh ubuntu@192.168.1.100:~/
```

### 3. Kurulumu Çalıştırma
```bash
# SSH bağlantısı içinde
chmod +x setup.sh
./setup.sh
```

**Bu kadar!** Kurulum otomatik olarak tamamlanır.


## 📝 Güncelleme Notları

Bu README düzenli olarak güncellenmektedir. Son güncellemeler:

- ✅ K3s hızlı kurulum eklendi
- ✅ Karşılaştırma tablosu eklendi
- ✅ YAML örnekleri eklendi
- ✅ Performans iyileştirmeleri eklendi

**Not:** Bu rehber temel kurulum içindir. Production ortamlar için ek yapılandırma, monitoring (Prometheus, Grafana), logging (ELK Stack) ve güvenlik önlemleri gereklidir.

---

**Katkıda Bulunma:** Bu dokümana katkıda bulunmak için pull request gönderebilirsiniz.

**Lisans:** MIT License