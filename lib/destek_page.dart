// ─── KURULUM ──────────────────────────────────────────────────────────────────
// pubspec.yaml'da http: ^1.2.0 zaten ekli olmalı

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String kApiBase = 'http://104.238.23.55:3005/api';

// ─── RENKLER ──────────────────────────────────────────────────────────────────
class OC {
  static const bg = Color(0xFF0A0A0A);
  static const bgCard = Color(0xFF111111);
  static const bgCard2 = Color(0xFF161616);
  static const red = Color(0xFFE63329);
  static const white = Color(0xFFFFFFFF);
  static const grey = Color(0xFF888888);
  static const greyLight = Color(0xFFCCCCCC);
  static const border = Color(0xFF222222);
  static const green = Color(0xFF00C48C);
  static const orange = Color(0xFFFF9500);
}

// ─── DESTEK SAYFASI ───────────────────────────────────────────────────────────
class DestekPage extends StatefulWidget {
  const DestekPage({super.key});

  @override
  State<DestekPage> createState() => _DestekPageState();
}

class _DestekPageState extends State<DestekPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── BAŞLIK ──
          const _PageHeader(title: 'DESTEK'),
          // ── TAB BAR ──
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            decoration: BoxDecoration(
              color: OC.bgCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: OC.border),
            ),
            child: TabBar(
              controller: _tabCtrl,
              indicator: BoxDecoration(
                color: OC.red,
                borderRadius: BorderRadius.circular(8),
              ),
              labelColor: OC.white,
              unselectedLabelColor: OC.grey,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 12),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Yeni Talep'),
                Tab(text: 'Taleplerim'),
              ],
            ),
          ),
          // ── TAB VIEWS ──
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: const [
                _YeniTalepTab(),
                _TaleplerimTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── YENİ TALEP TAB ───────────────────────────────────────────────────────────
class _YeniTalepTab extends StatefulWidget {
  const _YeniTalepTab();

  @override
  State<_YeniTalepTab> createState() => _YeniTalepTabState();
}

class _YeniTalepTabState extends State<_YeniTalepTab> {
  final _adCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telefonCtrl = TextEditingController();
  final _mesajCtrl = TextEditingController();
  String? _secilenKonu;
  bool _loading = false;
  bool _sent = false;
  String? _error;

  final List<String> _konular = [
    'Teknik Destek',
    'Fiyat Teklifi',
    'Proje Hakkında',
    'Genel Soru',
    'Şikayet',
  ];

  final Map<String, IconData> _konuIkonlar = {
    'Teknik Destek': Icons.build,
    'Fiyat Teklifi': Icons.attach_money,
    'Proje Hakkında': Icons.folder,
    'Genel Soru': Icons.help_outline,
    'Şikayet': Icons.warning_amber,
  };

  @override
  void dispose() {
    _adCtrl.dispose();
    _emailCtrl.dispose();
    _telefonCtrl.dispose();
    _mesajCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_adCtrl.text.isEmpty || _emailCtrl.text.isEmpty ||
        _mesajCtrl.text.isEmpty || _secilenKonu == null) {
      setState(() => _error = 'Lütfen tüm zorunlu alanları doldurun.');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final res = await http.post(
        Uri.parse('$kApiBase/destek'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ad_soyad': _adCtrl.text.trim(),
          'email': _emailCtrl.text.trim(),
          'telefon': _telefonCtrl.text.trim(),
          'konu': _secilenKonu,
          'mesaj': _mesajCtrl.text.trim(),
        }),
      ).timeout(const Duration(seconds: 10));

      final body = jsonDecode(res.body);
      if (res.statusCode == 200 && body['success'] == true) {
        setState(() => _sent = true);
      } else {
        setState(() => _error = body['message'] ?? 'Bir hata oluştu.');
      }
    } catch (e) {
      setState(() => _error = 'Sunucuya ulaşılamadı.');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_sent) return _SuccessView(onReset: () => setState(() {
      _sent = false;
      _adCtrl.clear(); _emailCtrl.clear();
      _telefonCtrl.clear(); _mesajCtrl.clear();
      _secilenKonu = null;
    }));

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nasıl Yardımcı Olabiliriz?',
              style: TextStyle(color: OC.white, fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          const Text('Talebinizi gönderin, en kısa sürede dönüş yapalım.',
              style: TextStyle(color: OC.grey, fontSize: 13)),
          const SizedBox(height: 20),

          // ── KONU SEÇİMİ ──
          const _FieldLabel(text: 'Konu *'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _konular.map((k) {
              final selected = _secilenKonu == k;
              return GestureDetector(
                onTap: () => setState(() => _secilenKonu = k),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? OC.red.withOpacity(0.15) : OC.bgCard,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: selected ? OC.red : OC.border, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_konuIkonlar[k], color: selected ? OC.red : OC.grey, size: 14),
                      const SizedBox(width: 6),
                      Text(k,
                          style: TextStyle(
                              color: selected ? OC.red : OC.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // ── ALANLAR ──
          _InputField(controller: _adCtrl, label: 'Ad Soyad *', hint: 'Ad Soyad'),
          const SizedBox(height: 12),
          _InputField(controller: _emailCtrl, label: 'E-posta *', hint: 'ornek@mail.com',
              keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 12),
          _InputField(controller: _telefonCtrl, label: 'Telefon', hint: '+90 5XX XXX XX XX',
              keyboardType: TextInputType.phone),
          const SizedBox(height: 12),
          _InputField(controller: _mesajCtrl, label: 'Mesaj *',
              hint: 'Sorununuzu detaylı açıklayın...', maxLines: 5),
          const SizedBox(height: 16),

          // ── HATA ──
          if (_error != null)
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
                  const Icon(Icons.error_outline, color: OC.red, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_error!,
                      style: const TextStyle(color: OC.red, fontSize: 12))),
                ],
              ),
            ),

          // ── GÖNDER ──
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: _loading ? null : _submit,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _loading ? OC.red.withOpacity(0.6) : OC.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: _loading
                      ? const SizedBox(width: 20, height: 20,
                          child: CircularProgressIndicator(color: OC.white, strokeWidth: 2))
                      : const Text('Talep Gönder',
                          style: TextStyle(color: OC.white, fontWeight: FontWeight.w800, fontSize: 14)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── TALEPLERİM TAB ───────────────────────────────────────────────────────────
class _TaleplerimTab extends StatefulWidget {
  const _TaleplerimTab();

  @override
  State<_TaleplerimTab> createState() => _TaleplerimTabState();
}

class _TaleplerimTabState extends State<_TaleplerimTab> {
  final _emailCtrl = TextEditingController();
  List<dynamic> _talepler = [];
  bool _loading = false;
  bool _searched = false;
  String? _error;

  Future<void> _ara() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _error = 'Geçerli bir e-posta girin.');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final res = await http.get(
        Uri.parse('$kApiBase/destek/${Uri.encodeComponent(email)}'),
      ).timeout(const Duration(seconds: 10));
      final body = jsonDecode(res.body);
      setState(() {
        _talepler = body['data'] ?? [];
        _searched = true;
      });
    } catch (e) {
      setState(() => _error = 'Sunucuya ulaşılamadı.');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Taleplerinizi Takip Edin',
                  style: TextStyle(color: OC.white, fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              const Text('E-postanızla taleplerinizi sorgulayın.',
                  style: TextStyle(color: OC.grey, fontSize: 12)),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: OC.white, fontSize: 13),
                      onSubmitted: (_) => _ara(),
                      decoration: InputDecoration(
                        hintText: 'E-posta adresiniz',
                        hintStyle: const TextStyle(color: Color(0xFF444444)),
                        filled: true,
                        fillColor: OC.bgCard,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: OC.border)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: OC.border)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: OC.red, width: 1.5)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _loading ? null : _ara,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(color: OC.red, borderRadius: BorderRadius.circular(8)),
                      child: _loading
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: OC.white, strokeWidth: 2))
                          : const Icon(Icons.search, color: OC.white, size: 18),
                    ),
                  ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: OC.red, fontSize: 12)),
              ],
            ],
          ),
        ),

        if (_searched)
          Expanded(
            child: _talepler.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('📭', style: TextStyle(fontSize: 40)),
                        SizedBox(height: 10),
                        Text('Talep bulunamadı', style: TextStyle(color: OC.white, fontWeight: FontWeight.w700)),
                        SizedBox(height: 4),
                        Text('Bu e-posta ile açılmış talep yok.', style: TextStyle(color: OC.grey, fontSize: 12)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: _talepler.length,
                    itemBuilder: (ctx, i) => _TalepKarti(talep: _talepler[i]),
                  ),
          ),
      ],
    );
  }
}

// ─── TALEP KARTI ──────────────────────────────────────────────────────────────
class _TalepKarti extends StatelessWidget {
  final dynamic talep;
  const _TalepKarti({required this.talep});

  Color get _durumRenk {
    switch (talep['durum']) {
      case 'cevaplandi': return OC.green;
      case 'kapandi': return OC.grey;
      default: return OC.orange;
    }
  }

  String get _durumText {
    switch (talep['durum']) {
      case 'cevaplandi': return 'Cevaplandı';
      case 'kapandi': return 'Kapandı';
      default: return 'Bekliyor';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: OC.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OC.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HEADER ──
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: OC.red.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(talep['konu'] ?? '',
                      style: const TextStyle(color: OC.red, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _durumRenk.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(_durumText,
                      style: TextStyle(color: _durumRenk, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          // ── MESAJ ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: Text(talep['mesaj'] ?? '',
                style: const TextStyle(color: OC.greyLight, fontSize: 13, height: 1.5)),
          ),
          // ── CEVAP ──
          if (talep['cevap'] != null && talep['cevap'].toString().isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.all(14),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: OC.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: OC.green.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.reply, color: OC.green, size: 14),
                      const SizedBox(width: 6),
                      const Text('Oxygen Soft Yanıtı',
                          style: TextStyle(color: OC.green, fontSize: 11, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      if (talep['cevap_tarihi'] != null)
                        Text(_formatDate(talep['cevap_tarihi']),
                            style: const TextStyle(color: OC.grey, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(talep['cevap'],
                      style: const TextStyle(color: OC.greyLight, fontSize: 13, height: 1.5)),
                ],
              ),
            ),
          ] else
            const SizedBox(height: 14),
          // ── TARİH ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Text(_formatDate(talep['tarih'] ?? ''),
                style: const TextStyle(color: OC.grey, fontSize: 11)),
          ),
        ],
      ),
    );
  }

  String _formatDate(String str) {
    try {
      final d = DateTime.parse(str);
      return '${d.day.toString().padLeft(2,'0')}.${d.month.toString().padLeft(2,'0')}.${d.year} ${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}';
    } catch (_) { return str; }
  }
}

// ─── BAŞARI EKRANI ────────────────────────────────────────────────────────────
class _SuccessView extends StatelessWidget {
  final VoidCallback onReset;
  const _SuccessView({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: OC.green.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: OC.green, width: 2),
              ),
              child: const Icon(Icons.check, color: OC.green, size: 40),
            ),
            const SizedBox(height: 20),
            const Text('Talebiniz Alındı!',
                style: TextStyle(color: OC.white, fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text(
              'En kısa sürede ekibimiz size dönüş yapacak.\nTaleplerinizi "Taleplerim" sekmesinden takip edebilirsiniz.',
              textAlign: TextAlign.center,
              style: TextStyle(color: OC.grey, fontSize: 13, height: 1.6),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onReset,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: OC.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Yeni Talep Oluştur',
                    style: TextStyle(color: OC.white, fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ),
          ],
        ),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        children: [
          Container(width: 4, height: 22, color: OC.red, margin: const EdgeInsets.only(right: 10)),
          Text(title, style: const TextStyle(color: OC.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2)),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(color: OC.grey, fontSize: 12, fontWeight: FontWeight.w600));
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
        _FieldLabel(text: label),
        const SizedBox(height: 7),
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: OC.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: OC.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: OC.red, width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}