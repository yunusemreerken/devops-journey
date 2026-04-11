
# 🚀 DevOps için REST API Öğrenme Yol Haritası
Bu repo, bir DevOps Mühendisinin sistem otomasyonu, araç entegrasyonu ve altyapı yönetimi için bilmesi gereken **REST API** temel kavramlarını ve uygulama örneklerini içerir.
## 🛠 Neden REST API Bilmeliyim?- **Infrastructure as Code (IaC):** Terraform/Ansible arka planda API kullanır.- **Araç Entegrasyonu:** Jenkins, GitHub Actions ve Jira arasında köprü kurmak.- **Cloud Management:** AWS, Azure ve GCP servislerini programatik yönetmek.
---## 📚 1. Temel Konu Başlıkları### 🔹 HTTP Metotları (Eylemler)
| Metot | Açıklama | DevOps Örneği |
| :--- | :--- | :--- |
| `GET` | Veri Çekme | Mevcut sunucu listesini al |
| `POST` | Yeni Kayıt Oluşturma | Yeni bir Deployment başlat |
| `PUT` | Kaynağı Güncelleme | Bir servisin imaj versiyonunu değiştir |
| `DELETE` | Kaynağı Silme | Kullanılmayan disk alanını temizle |
### 🔹 Durum Kodları (Status Codes)- **2xx (Success):** `200 OK`, `201 Created` (İşlem başarılı).
- **4xx (Client Error):** `401 Unauthorized` (Token hatalı), `404 Not Found`.
- **5xx (Server Error):** `500 Internal Server Error`, `503 Service Unavailable`.
### 🔹 Kimlik Doğrulama (Auth)- **API Key:** Basit anahtarlar.- **Bearer Token (JWT):** Modern standart (GitHub/Kubernetes API).- **Basic Auth:** Kullanıcı adı ve şifre.
---## 🛠 Kazanımlar ve Yetkinlikler
Bu roadmap'i tamamladığında aşağıdaki becerilere sahip olacaksın:1. **Programatik Yönetim:** Arayüz (UI) kullanmadan sistemleri yönetmek.
2. **Otomasyon:** `curl` ve `jq` kullanarak karmaşık Bash scriptleri yazmak.3. **Sorun Giderme:** API yanıtlarına bakarak sistem hatalarını saniyeler içinde teşhis etmek.4. **Entegrasyon:** Farklı DevOps araçlarını birbirine bağlamak.
---## 💻 İlk Uygulama (macOS/Linux)
Terminalinizde aşağıdaki komutu çalıştırarak ilk API isteğinizi atın:

```bash
# GitHub API üzerinden bir kullanıcı bilgisini çekme
curl -s https://github.com | jq '.'

------------------------------
## 🔗 Kaynaklar

* [MDN Web Docs - HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP)
* [Postman Learning Center](https://learning.postman.com/)
* [JSON Placeholder (Test API)](https://jsonplaceholder.typicode.com/)

------------------------------
⭐ Bu repo bir DevOps öğrenme yolculuğunun parçasıdır.


