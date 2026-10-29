import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QadaaApp());
}

const forest = Color(0xFF145B49);
const green = Color(0xFF16866B);
const cream = Color(0xFFFFFCF4);
const gold = Color(0xFFD3A64B);
const ink = Color(0xFF173E34);

class QadaaApp extends StatelessWidget {
  const QadaaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'قضاء',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: forest, surface: cream),
        fontFamily: 'Roboto',
      ),
      home: const Directionality(textDirection: TextDirection.rtl, child: HomeShell()),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int tab = 0;
  int years = 5;
  int completed = 0;
  int dailyTarget = 5;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      years = prefs.getInt('years') ?? 5;
      completed = prefs.getInt('completed') ?? 0;
      dailyTarget = prefs.getInt('dailyTarget') ?? 5;
      loading = false;
    });
  }

  int get total => years * 365 * 5;
  int get remaining => (total - completed).clamp(0, total);
  int get progress => total == 0 ? 0 : (completed * 100 / total).round().clamp(0, 100);

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('years', years);
    await prefs.setInt('completed', completed);
    await prefs.setInt('dailyTarget', dailyTarget);
  }

  void _openCalculator() {
    int draftYears = years;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: cream,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => StatefulBuilder(builder: (context, setModalState) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('حساب الصلوات الفائتة', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: forest)),
          const SizedBox(height: 8),
          const Text('أدخل عدد السنوات التقديري، ويمكنك تعديل النتيجة لاحقًا.', style: TextStyle(color: ink, height: 1.6)),
          const SizedBox(height: 18),
          Row(children: [
            const Expanded(child: Text('سنوات الفوائت', style: TextStyle(fontWeight: FontWeight.w700))),
            IconButton(onPressed: draftYears > 0 ? () => setModalState(() => draftYears--) : null, icon: const Icon(Icons.remove_circle_outline)),
            Text('$draftYears', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            IconButton(onPressed: draftYears < 80 ? () => setModalState(() => draftYears++) : null, icon: const Icon(Icons.add_circle_outline)),
          ]),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFEAF2E8), borderRadius: BorderRadius.circular(16)),
            child: Text('تقدير مبدئي: ${draftYears * 365} يومًا · ${draftYears * 365 * 5} صلاة', style: const TextStyle(fontWeight: FontWeight.w700, color: forest)),
          ),
          const SizedBox(height: 18),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: forest, padding: const EdgeInsets.all(16)),
            onPressed: () async {
              setState(() { years = draftYears; completed = completed.clamp(0, draftYears * 365 * 5); });
              await _save();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('حفظ التقدير'),
          ),
          const SizedBox(height: 8),
          const Text('هذا حساب تقريبي للتنظيم وليس فتوى شرعية.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.black54)),
        ]),
      )),
    );
  }

  void _openPlan() {
    int draft = dailyTarget;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: cream,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => StatefulBuilder(builder: (context, setModalState) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('خطة القضاء اليومية', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: forest)),
          const SizedBox(height: 8),
          const Text('اختر وتيرة تناسب قدرتك مع المحافظة على الصلوات الحاضرة.', style: TextStyle(height: 1.6)),
          const SizedBox(height: 20),
          Text('الهدف اليومي: $draft صلوات فائتة', style: const TextStyle(fontWeight: FontWeight.w700)),
          Slider(value: draft.toDouble(), min: 1, max: 20, divisions: 19, label: '$draft', activeColor: green, onChanged: (v) => setModalState(() => draft = v.round())),
          Text('المدة التقريبية المتبقية: ${(remaining / draft / 365).toStringAsFixed(1)} سنة', style: const TextStyle(color: forest, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          FilledButton(style: FilledButton.styleFrom(backgroundColor: forest, padding: const EdgeInsets.all(16)), onPressed: () async {
            setState(() => dailyTarget = draft);
            await _save();
            if (context.mounted) Navigator.pop(context);
          }, child: const Text('اعتماد الخطة')),
        ]),
      )),
    );
  }

  Future<void> _markOne() async {
    if (remaining <= 0) return;
    setState(() => completed = (completed + 1).clamp(0, total));
    await _save();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _home(),
      _simplePage('خطة القضاء', Icons.calendar_month_rounded, 'هدفك اليومي', '$dailyTarget صلوات فائتة', 'اضغط لتعديل وتيرة القضاء.', _openPlan),
      _simplePage('الإحصائيات', Icons.bar_chart_rounded, 'إنجازك حتى الآن', '$progress%', 'أكملت $completed صلاة من أصل $total صلاة مقدّرة.', () => setState(() => tab = 0)),
      _simplePage('أدعيتني', Icons.volunteer_activism_rounded, 'ابدأ بخطوة صغيرة', 'اللهم أعنّي على ذكرك وشكرك وحسن عبادتك', 'اجعل الاستمرار أهم من السرعة.', () {}),
      _simplePage('الملف الشخصي', Icons.person_outline_rounded, 'إعداداتك محفوظة على الهاتف', 'بدون إنشاء حساب', 'يمكنك تعديل تقدير الفوائت والخطة في أي وقت.', _openCalculator),
    ];
    return Scaffold(
      body: SafeArea(child: loading ? const Center(child: CircularProgressIndicator(color: green)) : IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: NavigationBar(
        height: 76,
        backgroundColor: const Color(0xFFFFFEFA),
        indicatorColor: const Color(0xFFDCEDE4),
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: 'خطة القضاء'),
          NavigationDestination(icon: Icon(Icons.bar_chart_rounded), label: 'الإحصائيات'),
          NavigationDestination(icon: Icon(Icons.volunteer_activism_outlined), label: 'أدعيتني'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded), label: 'الملف الشخصي'),
        ],
      ),
    );
  }

  Widget _home() {
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(child: _hero()),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        sliver: SliverList(delegate: SliverChildListDelegate([
          _verseCard(),
          const SizedBox(height: 14),
          _progressCard(),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: _actionCard('خطة القضاء اليومية', 'اختر وتيرة تناسبك مع الحفاظ على الصلاة الحاضرة.', Icons.event_available_rounded, const Color(0xFFDDF1E7), green, _openPlan)),
            const SizedBox(width: 12),
            Expanded(child: _actionCard('حساب الفوائت', 'قدّر السنوات والأيام والصلوات التي فاتتك.', Icons.calculate_outlined, const Color(0xFFFAF0DC), gold, _openCalculator)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _actionCard('متابعة التقدم', 'تابع ما أنجزته وما تبقّى بوضوح.', Icons.bar_chart_rounded, const Color(0xFFECE7FA), const Color(0xFF7057C9), () => setState(() => tab = 2))),
            const SizedBox(width: 12),
            Expanded(child: _actionCard('رسائل التشجيع', 'تذكير لطيف بالثبات والاستمرار.', Icons.volunteer_activism_outlined, const Color(0xFFE1F1F8), const Color(0xFF258DB1), () => setState(() => tab = 3))),
          ]),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [forest, Color(0xFF247D63)]), borderRadius: BorderRadius.circular(22)),
            child: const Row(children: [
              Icon(Icons.spa_rounded, color: Color(0xFFE5C77B), size: 36),
              SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('لست متأخرًا.. أنت تبدأ الآن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                SizedBox(height: 6),
                Text('خطوة ثابتة كل يوم خير من الانقطاع.', style: TextStyle(color: Colors.white, height: 1.4)),
              ])),
            ]),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(onPressed: _markOne, icon: const Icon(Icons.check_circle_outline), label: const Text('تسجيل صلاة فائتة تم قضاؤها'), style: OutlinedButton.styleFrom(foregroundColor: forest, padding: const EdgeInsets.all(15), side: const BorderSide(color: green))),
          const SizedBox(height: 8),
          const Text('الحساب تقديري للتنظيم الشخصي، ولا يغني عن سؤال عالم موثوق في المسائل الشرعية.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 11, height: 1.5)),
        ])),
      ),
    ]);
  }

  Widget _hero() => Container(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
    decoration: const BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Color(0xFFF7E8C9), Color(0xFFFDF9EF), Color(0xFFD8E7D7)]),
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
    ),
    child: Column(children: [
      Row(children: [
        IconButton(onPressed: () => setState(() => tab = 4), icon: const Icon(Icons.settings_outlined, color: forest)),
        const Spacer(),
        IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('التنبيهات ستضاف في مرحلة لاحقة.'))), icon: const Icon(Icons.notifications_none_rounded, color: forest)),
      ]),
      Row(children: [
        Container(width: 82, height: 82, decoration: BoxDecoration(color: forest, borderRadius: BorderRadius.circular(26), border: Border.all(color: gold, width: 2)), child: const Icon(Icons.mosque_rounded, color: Color(0xFFFFE8A8), size: 50)),
        const SizedBox(width: 16),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('قضاء', style: TextStyle(fontSize: 42, height: 1.05, fontWeight: FontWeight.w900, color: forest)),
          SizedBox(height: 6),
          Text('خطوتك نحو إكمال ما فاتك من صلوات', style: TextStyle(fontSize: 13, color: ink, height: 1.4)),
        ])),
      ]),
      const SizedBox(height: 8),
    ]),
  );

  Widget _verseCard() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    decoration: BoxDecoration(color: const Color(0xFFEAF0E0), borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFFDDE6D2))),
    child: const Row(children: [
      Icon(Icons.eco_outlined, color: green, size: 28),
      SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('كل صلاة تقضيها اليوم', style: TextStyle(fontWeight: FontWeight.w800, color: forest)),
        SizedBox(height: 4),
        Text('تقربك من الله..', style: TextStyle(fontWeight: FontWeight.w700, color: forest)),
      ])),
      SizedBox(width: 8),
      Flexible(child: Text('﴿ وَأَقِمِ الصَّلَاةَ لِذِكْرِي ﴾\nطه: 14', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, height: 1.7, color: ink))),
    ]),
  );

  Widget _progressCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE9E5D9)), boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 12, offset: Offset(0, 3))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('الصلوات الفائتة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: forest)),
      const SizedBox(height: 14),
      Row(children: [
        SizedBox(width: 92, height: 92, child: Stack(alignment: Alignment.center, children: [
          SizedBox.expand(child: CircularProgressIndicator(value: progress / 100, strokeWidth: 9, backgroundColor: const Color(0xFFE9E9DF), color: green, strokeCap: StrokeCap.round)),
          Column(mainAxisSize: MainAxisSize.min, children: [Text('$progress%', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: forest)), const Text('من الخطة', style: TextStyle(fontSize: 11, color: ink))]),
        ])),
        const SizedBox(width: 12),
        Expanded(child: Column(children: [
          Row(children: [
            Expanded(child: _metric('الإجمالي', _fmt(total), Icons.mosque_outlined)),
            const SizedBox(width: 7),
            Expanded(child: _metric('تم قضاؤها', _fmt(completed), Icons.check_circle_outline)),
          ]),
          const SizedBox(height: 8),
          _metric('المتبقي', _fmt(remaining), Icons.schedule_rounded, wide: true),
        ])),
      ]),
      const SizedBox(height: 12),
      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF3F3EB), borderRadius: BorderRadius.circular(14)), child: Row(children: [
        const Icon(Icons.calendar_month_outlined, color: forest),
        const SizedBox(width: 10),
        Expanded(child: Text('التقدير الحالي: $years سنوات من الفوائت (قابل للتعديل)', style: const TextStyle(fontSize: 12, color: ink, height: 1.5))),
        IconButton(onPressed: _openCalculator, icon: const Icon(Icons.edit_outlined, color: forest)),
      ])),
    ]),
  );

  Widget _metric(String label, String value, IconData icon, {bool wide = false}) => Container(
    width: wide ? double.infinity : null,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    decoration: BoxDecoration(color: const Color(0xFFFAFAF4), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE8E9DF))),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 17, color: green),
      const SizedBox(width: 5),
      Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 10, color: ink), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: forest), maxLines: 1, overflow: TextOverflow.ellipsis),
      ])),
    ]),
  );

  Widget _actionCard(String title, String description, IconData icon, Color bg, Color accent, VoidCallback onTap) => Material(
    color: bg, borderRadius: BorderRadius.circular(22),
    child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(22), child: Container(
      constraints: const BoxConstraints(minHeight: 178),
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(color: accent, shape: BoxShape.circle), child: Icon(icon, color: Colors.white, size: 27)),
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: ink)),
        const SizedBox(height: 7),
        Text(description, style: const TextStyle(fontSize: 11, height: 1.55, color: ink)),
        const Spacer(),
        Align(alignment: Alignment.bottomLeft, child: Icon(Icons.arrow_back_rounded, color: accent)),
      ]),
    )),
  );

  Widget _simplePage(String title, IconData icon, String headline, String value, String body, VoidCallback action) => Center(
    child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 100, height: 100, decoration: const BoxDecoration(color: Color(0xFFE4EFE5), shape: BoxShape.circle), child: Icon(icon, color: forest, size: 52)),
      const SizedBox(height: 20),
      Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: forest)),
      const SizedBox(height: 20),
      Text(headline, style: const TextStyle(color: ink, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      Text(value, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: green)),
      const SizedBox(height: 10),
      Text(body, textAlign: TextAlign.center, style: const TextStyle(height: 1.7, color: ink)),
      const SizedBox(height: 24),
      FilledButton(onPressed: action, style: FilledButton.styleFrom(backgroundColor: forest, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)), child: const Text('تعديل / متابعة')),
    ])),
  );

  String _fmt(int n) => n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
}
