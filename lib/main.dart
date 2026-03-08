import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'iletisim_page.dart';
import 'destek_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A0A0A),
    ),
  );
  runApp(const OxygenSoftApp());
}

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
}

// ─── ANA UYGULAMA ─────────────────────────────────────────────────────────────
class OxygenSoftApp extends StatelessWidget {
  const OxygenSoftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oxygen Soft',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: OC.bg,
        colorScheme: const ColorScheme.dark(
          primary: OC.red,
          surface: OC.bgCard,
        ),
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}

// ─── ANA NAVİGASYON ───────────────────────────────────────────────────────────
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    HizmetlerPage(),
    ProjelerPage(),
    HakkimizdaPage(),
    IletisimPage(),
    DestekPage(),
  ];

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.home_outlined, label: 'Ana Sayfa'),
    _NavItem(icon: Icons.build_outlined, label: 'Hizmetler'),
    _NavItem(icon: Icons.folder_outlined, label: 'Projeler'),
    _NavItem(icon: Icons.info_outlined, label: 'Hakkımızda'),
    _NavItem(icon: Icons.mail_outlined, label: 'İletişim'),
    _NavItem(icon: Icons.headset_mic_outlined, label: 'Destek'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OC.bg,
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0D0D0D),
          border: Border(top: BorderSide(color: OC.border, width: 1)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (i) {
                final selected = _currentIndex == i;
                return GestureDetector(
                  onTap: () => setState(() => _currentIndex = i),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_navItems[i].icon,
                          color: selected ? OC.red : OC.grey, size: 22),
                      const SizedBox(height: 2),
                      Text(_navItems[i].label,
                          style: TextStyle(
                              color: selected ? OC.red : OC.grey,
                              fontSize: 9,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal)),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

// ─── HOME PAGE ────────────────────────────────────────────────────────────────
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildHero(),
            _buildStats(),
            _buildServicesPreview(),
            _buildProjectsPreview(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: OC.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text('O',
                  style: TextStyle(
                      color: OC.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20)),
            ),
          ),
          const SizedBox(width: 10),
          const Text('OXYGEN SOFT',
              style: TextStyle(
                  color: OC.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: OC.red,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('TEKLİF AL',
                style: TextStyle(
                    color: OC.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 30, height: 2, color: OC.red),
              const SizedBox(width: 10),
              const Text('YAZILIM & DİJİTAL ÇÖZÜMLER',
                  style: TextStyle(
                      color: OC.red,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2)),
            ],
          ),
          const SizedBox(height: 20),
          const Text('DİJİTAL',
              style: TextStyle(
                  color: OC.white,
                  fontSize: 58,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                  letterSpacing: -1)),
          Text('DÜNYADA',
              style: TextStyle(
                  color: OC.white.withOpacity(0.15),
                  fontSize: 58,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                  letterSpacing: -1)),
          const Text('GÜÇ OL',
              style: TextStyle(
                  color: OC.white,
                  fontSize: 58,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                  letterSpacing: -1)),
          const SizedBox(height: 24),
          const Text(
            'Web, mobil ve kurumsal yazılım alanında\nsektörün en iyisiyle çalışın.\nİşletmenizi geleceğe taşıyoruz.',
            style: TextStyle(color: OC.grey, fontSize: 14, height: 1.7),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _RedButton(label: 'Ücretsiz Danışmanlık', onTap: () {}),
              const SizedBox(width: 12),
              _OutlineButton(label: 'Projelerimiz →', onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: OC.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OC.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _StatItem(value: '50+', label: 'Proje'),
          _VDivider(),
          _StatItem(value: '30+', label: 'Müşteri'),
          _VDivider(),
          _StatItem(value: '5+', label: 'Yıl'),
          _VDivider(),
          _StatItem(value: '%100', label: 'Memnuniyet'),
        ],
      ),
    );
  }

  Widget _buildServicesPreview() {
    final services = [
      _ServiceData(icon: Icons.language, title: 'Web Geliştirme', desc: 'Modern ve hızlı web siteleri'),
      _ServiceData(icon: Icons.phone_android, title: 'Mobil Uygulama', desc: 'iOS & Android uygulamaları'),
      _ServiceData(icon: Icons.corporate_fare, title: 'Kurumsal Yazılım', desc: 'Özel iş çözümleri'),
      _ServiceData(icon: Icons.brush, title: 'UI/UX Tasarım', desc: 'Etkileyici arayüz tasarımı'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: _SectionTitle(title: 'HİZMETLER'),
        ),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: services.length,
            itemBuilder: (ctx, i) => _ServiceCard(data: services[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectsPreview() {
    final projects = [
      _ProjectData(title: 'E-Ticaret Platformu', tag: 'Web', color: OC.red),
      _ProjectData(title: 'Fintech Mobil App', tag: 'Mobil', color: Color(0xFF1A6BFF)),
      _ProjectData(title: 'CRM Sistemi', tag: 'Kurumsal', color: Color(0xFF00C48C)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: _SectionTitle(title: 'PROJELER'),
        ),
        ...projects.map((p) => _ProjectCard(data: p)),
      ],
    );
  }
}

// ─── HİZMETLER PAGE ───────────────────────────────────────────────────────────
class HizmetlerPage extends StatelessWidget {
  const HizmetlerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      _ServiceFull(icon: Icons.language, title: 'Web Geliştirme',
          desc: 'React, Vue, Next.js gibi modern frameworklerle hızlı, SEO uyumlu web siteleri.',
          features: ['React / Next.js', 'SEO Optimizasyonu', 'Responsive Tasarım', 'Yüksek Performans']),
      _ServiceFull(icon: Icons.phone_android, title: 'Mobil Uygulama',
          desc: 'Flutter ile iOS ve Android için native performanslı uygulamalar.',
          features: ['Flutter / Dart', 'iOS & Android', 'Push Bildirimler', 'Offline Destek']),
      _ServiceFull(icon: Icons.corporate_fare, title: 'Kurumsal Yazılım',
          desc: 'İşletmenize özel ERP, CRM ve yönetim sistemleri.',
          features: ['Özel ERP/CRM', 'API Entegrasyonu', 'Veri Analizi', 'Bulut Altyapı']),
      _ServiceFull(icon: Icons.brush, title: 'UI/UX Tasarım',
          desc: 'Kullanıcı odaklı, modern ve etkileyici arayüz tasarımları.',
          features: ['Figma Tasarım', 'Prototipleme', 'Kullanıcı Testi', 'Design System']),
      _ServiceFull(icon: Icons.security, title: 'Siber Güvenlik',
          desc: 'Sisteminizi tehditlere karşı koruyoruz. Pentest ve güvenlik denetimleri.',
          features: ['Pentest', 'Güvenlik Denetimi', 'SSL/TLS', 'GDPR Uyumu']),
      _ServiceFull(icon: Icons.cloud, title: 'Bulut Hizmetleri',
          desc: 'AWS, GCP ve Azure üzerinde ölçeklenebilir altyapı çözümleri.',
          features: ['AWS / GCP / Azure', 'Docker / K8s', 'CI/CD Pipeline', '7/24 Monitoring']),
    ];
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PageHeader(title: 'HİZMETLER'),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: services.length,
              itemBuilder: (ctx, i) => _ServiceFullCard(data: services[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── PROJELER PAGE ────────────────────────────────────────────────────────────
class ProjelerPage extends StatelessWidget {
  const ProjelerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = [
      _ProjectFull(title: 'E-Ticaret Platformu', tag: 'Web',
          desc: 'Büyük ölçekli e-ticaret sitesi. 100k+ ürün, ödeme entegrasyonu.',
          tech: ['Next.js', 'Node.js', 'PostgreSQL'], color: OC.red),
      _ProjectFull(title: 'Fintech Mobil App', tag: 'Mobil',
          desc: 'Para transferi ve yatırım takip uygulaması. 50k+ aktif kullanıcı.',
          tech: ['Flutter', 'Firebase', 'Stripe'], color: Color(0xFF1A6BFF)),
      _ProjectFull(title: 'Kurumsal CRM', tag: 'Kurumsal',
          desc: 'Müşteri ilişkileri yönetim sistemi. 200+ kullanıcı, tam entegrasyon.',
          tech: ['React', 'Django', 'MySQL'], color: Color(0xFF00C48C)),
      _ProjectFull(title: 'Hastane Yönetim Sistemi', tag: 'Sağlık',
          desc: 'Randevu, hasta takip ve raporlama sistemi.',
          tech: ['Vue.js', 'Laravel', 'Redis'], color: Color(0xFFFF9500)),
      _ProjectFull(title: 'Lojistik Takip', tag: 'Mobil',
          desc: 'Gerçek zamanlı araç ve kargo takip uygulaması.',
          tech: ['Flutter', 'Go', 'MongoDB'], color: Color(0xFFAF52DE)),
    ];
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PageHeader(title: 'PROJELER'),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: projects.length,
              itemBuilder: (ctx, i) => _ProjectFullCard(data: projects[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── HAKKIMIZDA PAGE ──────────────────────────────────────────────────────────
class HakkimizdaPage extends StatelessWidget {
  const HakkimizdaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final values = [
      ('🎯', 'Müşteri Odaklılık', 'Her projede müşteri memnuniyeti önceliğimizdir.'),
      ('⚡', 'Hız & Kalite', 'Zamanında teslim, sıfır hata politikası.'),
      ('🔒', 'Güvenilirlik', 'Verileriniz ve projeleriniz güvende.'),
      ('💡', 'İnovasyon', 'Sürekli öğrenme ve gelişim kültürü.'),
    ];
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _PageHeader(title: 'HAKKIMIZDA'),
            const SizedBox(height: 20),
            const Text('Yazılımın\nGücüyle\nFarklıyız.',
                style: TextStyle(
                    color: OC.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    height: 1.1)),
            const SizedBox(height: 20),
            const Text(
              'Oxygen Soft olarak, işletmelerin dijital dönüşüm süreçlerinde yanlarında olmaktan gurur duyuyoruz. Kuruluşumuzdan bu yana 50\'den fazla projeyi başarıyla tamamladık.',
              style: TextStyle(color: OC.grey, fontSize: 14, height: 1.7),
            ),
            const SizedBox(height: 30),
            const _SectionTitle(title: 'DEĞERLERİMİZ'),
            const SizedBox(height: 16),
            ...values.map((v) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: OC.bgCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: OC.border),
                  ),
                  child: Row(
                    children: [
                      Text(v.$1, style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(v.$2,
                                style: const TextStyle(
                                    color: OC.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)),
                            const SizedBox(height: 4),
                            Text(v.$3,
                                style: const TextStyle(
                                    color: OC.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
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
      ),
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

class _RedButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _RedButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
            color: OC.red, borderRadius: BorderRadius.circular(8)),
        child: Text(label,
            style: const TextStyle(
                color: OC.white,
                fontWeight: FontWeight.w800,
                fontSize: 13)),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: OC.border, width: 1.5),
        ),
        child: Text(label,
            style: const TextStyle(
                color: OC.white,
                fontWeight: FontWeight.w600,
                fontSize: 13)),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: OC.red, fontSize: 22, fontWeight: FontWeight.w900)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: OC.grey, fontSize: 11)),
      ],
    );
  }
}

class _VDivider extends StatelessWidget {
  const _VDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 30, color: OC.border);
  }
}

// ─── VERİ MODELLERİ ───────────────────────────────────────────────────────────

class _ServiceData {
  final IconData icon;
  final String title;
  final String desc;
  const _ServiceData({required this.icon, required this.title, required this.desc});
}

class _ServiceCard extends StatelessWidget {
  final _ServiceData data;
  const _ServiceCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: OC.bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: OC.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: OC.red.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(data.icon, color: OC.red, size: 20),
          ),
          const SizedBox(height: 10),
          Text(data.title,
              style: const TextStyle(
                  color: OC.white, fontWeight: FontWeight.w700, fontSize: 12)),
          const SizedBox(height: 4),
          Text(data.desc,
              style: const TextStyle(color: OC.grey, fontSize: 10),
              maxLines: 2),
        ],
      ),
    );
  }
}

class _ProjectData {
  final String title;
  final String tag;
  final Color color;
  const _ProjectData({required this.title, required this.tag, required this.color});
}

class _ProjectCard extends StatelessWidget {
  final _ProjectData data;
  const _ProjectCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OC.bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: OC.border),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
                color: data.color, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(data.title,
                style: const TextStyle(
                    color: OC.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(data.tag,
                style: TextStyle(
                    color: data.color,
                    fontSize: 10,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _ServiceFull {
  final IconData icon;
  final String title;
  final String desc;
  final List<String> features;
  const _ServiceFull(
      {required this.icon,
      required this.title,
      required this.desc,
      required this.features});
}

class _ServiceFullCard extends StatelessWidget {
  final _ServiceFull data;
  const _ServiceFullCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: OC.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OC.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: OC.red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(data.icon, color: OC.red, size: 22),
              ),
              const SizedBox(width: 14),
              Text(data.title,
                  style: const TextStyle(
                      color: OC.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Text(data.desc,
              style: const TextStyle(
                  color: OC.grey, fontSize: 13, height: 1.5)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: data.features
                .map((f) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: OC.bgCard2,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: OC.border),
                      ),
                      child: Text(f,
                          style: const TextStyle(
                              color: OC.greyLight, fontSize: 11)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ProjectFull {
  final String title;
  final String tag;
  final String desc;
  final List<String> tech;
  final Color color;
  const _ProjectFull(
      {required this.title,
      required this.tag,
      required this.desc,
      required this.tech,
      required this.color});
}

class _ProjectFullCard extends StatelessWidget {
  final _ProjectFull data;
  const _ProjectFullCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: OC.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OC.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(data.title,
                    style: const TextStyle(
                        color: OC.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(data.tag,
                    style: TextStyle(
                        color: data.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(data.desc,
              style: const TextStyle(
                  color: OC.grey, fontSize: 13, height: 1.5)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            children: [
              const Text('Teknoloji: ',
                  style: TextStyle(color: OC.grey, fontSize: 11)),
              ...data.tech.map((t) => Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: data.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(t,
                        style: TextStyle(
                            color: data.color,
                            fontSize: 10,
                            fontWeight: FontWeight.w600)),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  const _InputField(
      {required this.controller,
      required this.label,
      required this.hint,
      this.maxLines = 1});

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
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}
