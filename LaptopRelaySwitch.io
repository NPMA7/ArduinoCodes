#include <WiFi.h>
#include <WebServer.h>

// Ganti dengan SSID dan password WiFi kamu
const char* ssid = "NAMA_WIFI_KAMU";
const char* password = "PASSWORD_WIFI_KAMU";

// Membuat server web di port 80
WebServer server(80);

// Pin GPIO untuk relay
const int relayPin = 25;

void setup() {
  Serial.begin(115200);
  
  // Setup pin relay sebagai OUTPUT
  pinMode(relayPin, OUTPUT);
  digitalWrite(relayPin, LOW); // relay off saat awal

  // Mulai koneksi WiFi
  WiFi.begin(ssid, password);
  Serial.print("Menghubungkan ke WiFi");

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nTerhubung!");
  Serial.print("Alamat IP: ");
  Serial.println(WiFi.localIP());

  // Halaman utama web
  server.on("/", HTTP_GET, []() {
    String html = "<html><body style='text-align:center; font-family:sans-serif;'>";
    html += "<h1>Kontrol Laptop</h1>";
    html += "<p>Klik tombol di bawah untuk menyalakan laptop</p>";
    html += "<a href=\"/power\"><button style='font-size:24px;padding:20px;'>Nyalakan Laptop</button></a>";
    html += "</body></html>";
    server.send(200, "text/html", html);
  });

  // Endpoint untuk menyalakan relay (menyalakan laptop)
  server.on("/power", HTTP_GET, []() {
    digitalWrite(relayPin, HIGH); // relay on
    delay(1000);                  // tahan 1 detik (seperti menekan tombol power)
    digitalWrite(relayPin, LOW);  // relay off
    server.send(200, "text/plain", "Laptop sedang dinyalakan.");
  });

  // Jalankan server
  server.begin();
  Serial.println("Server web ESP32 siap!");
}

void loop() {
  server.handleClient(); // Menangani request dari browser
}



