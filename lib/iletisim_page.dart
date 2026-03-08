// ─── KURULUM ──────────────────────────────────────────────────────────────────
// pubspec.yaml dosyana şunu ekle:
//   dependencies:
//     http: ^1.2.0

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ─── RENKLER (main.dart'taki OC sınıfın aynısı) ───────────────────────────────
class OC {
  static const bg = Color(0xFF0A0A0A);
  static const bgCard = Color(0xFF111111);
  static const red = Color(0xFFE63329);
  static const white = Color(0xFFFFFFFF);
  static const grey = Color(0xFF888888);
  static const border = Color(0xFF222222);
}

// ─── API URL — kendi sunucun ile değiştir ─────────────────────────────────────
const String kApiBase = 'http://104.238.23.55:3005/api';

// ─── İLETİŞİM PAGE ────────────────────────────────────────────────────────────
class IletisimPage extends StatefulWidget {
  const IletisimPage({super.key});

  @override
  State<IletisimPage> createState() => _IletisimPageState();
}

class _IletisimPageState extends State<IletisimPage> {
  final _adCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _mesajCtrl = TextEditingController();

  bool _loading = false;
  bool _sent = false;
  String? _errorMsg;

  @override
  void dispose() {
    _adCtrl.dispose();
    _emailCtrl.dispose();
    _mesajCtrl.dispose();
    super.dispose();
  }

  // ─── FORM GÖNDER ────────────────────────────────────────────────────────────
  Future<void> _submit() async {
    final ad = _adCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final mesaj = _mesajCtrl.text.trim();

    // Client-side validasyon
    if (ad.isEmpty || email.isEmpty || mesaj.isEmpty) {
      setState(() => _errorMsg = 'Lütfen tüm alanları doldurun.');
      return;
    }
    if (!email.contains('@')) {
      setState(() => _errorMsg = 'Geçerli bir e-posta giriniz.');
      return;
    }

    setState(() {
      _loading = true;
      _errorMsg = null;
    });

    try {
      final response = await http
          .post(
            Uri.parse('$kApiBase/iletisim'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'ad_soyad': ad,
              'email': email,
              'mesaj': mesaj,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        setState(() => _sent = true);
      } else {
        setState(() =>
            _errorMsg = body['message'] ?? 'Bir hata oluştu. Tekrar deneyin.');
      }
    } catch (e) {
      setState(() => _errorMsg = 'Sunucuya ulaşılamadı. İnternet bağlantınızı kontrol edin.');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── BAŞLIK ──
            const _PageHeader(title: 'İLETİŞİM'),
            const SizedBox(height: 20),

            // ── BAŞARILI MESAJ ──
            if (_sent)
              _SuccessBanner()
            else ...[
              const Text(
                'Projenizi Konuşalım',
                style: TextStyle(
                    color: OC.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ücretsiz danışmanlık için hemen iletişime geçin.',
                style: TextStyle(color: OC.grey, fontSize: 14),
              ),
              const SizedBox(height: 28),

              // ── FORM ALANLARI ──
              _InputField(
                  controller: _adCtrl,
                  label: 'Adınız',
                  hint: 'Ad Soyad'),
              const SizedBox(height: 14),
              _InputField(
                  controller: _emailCtrl,
                  label: 'E-posta',
                  hint: 'ornek@mail.com',
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 14),
              _InputField(
                  controller: _mesajCtrl,
                  label: 'Mesajınız',
                  hint: 'Projenizi anlatın...',
                  maxLines: 5),
              const SizedBox(height: 16),

              // ── HATA MESAJI ──
              if (_errorMsg != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A0D0D),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: OC.red.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: OC.red, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(_errorMsg!,
                            style: const TextStyle(
                                color: OC.red, fontSize: 12)),
                      ),
                    ],
                  ),
                ),

              // ── GÖNDER BUTONU ──
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: _loading ? null : _submit,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: _loading
                          ? OC.red.withOpacity(0.6)
                          : OC.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: OC.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Gönder',
                              style: TextStyle(
                                  color: OC.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14),
                            ),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 30),

            // ── DİĞER İLETİŞİM ──
            const _SectionTitle(title: 'DİĞER İLETİŞİM'),
            const SizedBox(height: 16),
            ...[
              (Icons.language, 'Website', 'oxygens.ddns.net'),
              (Icons.email, 'E-posta', 'info@oxygensoft.com'),
              (Icons.phone, 'Telefon', '+90 555 000 00 00'),
            ].map((c) => _ContactTile(icon: c.$1, label: c.$2, value: c.$3)),
          ],
        ),
      ),
    );
  }
}

// ─── BAŞARI BANNER ────────────────────────────────────────────────────────────
class _SuccessBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00C48C)),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF00C48C), size: 48),
          const SizedBox(height: 16),
          const Text(
            'Mesajınız İletildi!',
            style: TextStyle(
                color: Color(0xFF00C48C),
                fontSize: 20,
                fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            'En kısa sürede sizinle iletişime geçeceğiz.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF00C48C), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ─── İLETİŞİM KARTI ───────────────────────────────────────────────────────────
class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ContactTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: OC.bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: OC.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: OC.red.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: OC.red, size: 18),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: OC.grey, fontSize: 11)),
              Text(value,
                  style: const TextStyle(
                      color: OC.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── ORTAK WİDGET'LAR ─────────────────────────────────────────────────────────
class _PageHeader extends StatelessWidget {
  final String title;
  const _PageHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 4,
            height: 22,
            color: OC.red,
            margin: const EdgeInsets.only(right: 10)),
        Text(title,
            style: const TextStyle(
                color: OC.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 2)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 3,
            height: 16,
            color: OC.red,
            margin: const EdgeInsets.only(right: 8)),
        Text(title,
            style: const TextStyle(
                color: OC.grey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 2)),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: OC.grey,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(color: OC.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF444444)),
            filled: true,
            fillColor: OC.bgCard,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: OC.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: OC.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: OC.red, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}
