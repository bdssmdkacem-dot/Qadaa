import 'package:flutter/material.dart';
import 'qadaa_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

const forest = Color(0xFF145B49);
const green = Color(0xFF16866B);
const cream = Color(0xFFFFFCF4);
const gold = Color(0xFFD3A64B);
const ink = Color(0xFF173E34);

const translations = <String, Map<String, String>>{
  'ar': {
    'welcome':'مرحبًا بك في قضاء','intro':'رفيقك لتنظيم قضاء الصلوات الفائتة','choose':'اختر لغة التطبيق','continue':'المتابعة','home':'الرئيسية','plan':'الخطة اليومية','stats':'الإحصائيات','encouragement':'التشجيع','settings':'الإعدادات','missed':'الصلوات الفائتة','estimate':'تقدير الفوائت','completed':'تم قضاؤها','remaining':'المتبقي','total':'الإجمالي التقديري','progress':'نسبة الإنجاز','years':'سنوات الفوائت','save':'حفظ التقدير','daily':'الهدف اليومي','prayers':'صلوات','savePlan':'حفظ الخطة','log':'تسجيل صلاة تم قضاؤها','motivation':'خطوة ثابتة كل يوم خير من الانقطاع.','verse':'﴿ وَأَقِمِ الصَّلَاةَ لِذِكْرِي ﴾','verseRef':'طه: 14','subtitle':'ابدأ بخطوة صغيرة، واستمر بثبات','language':'اللغة','note':'هذا تقدير للتنظيم الشخصي، وليس فتوى شرعية.','edit':'تعديل','notifications':'التنبيهات','welcomeBack':'السلام عليكم','fajr':'الفجر','dhuhr':'الظهر','asr':'العصر','maghrib':'المغرب','isha':'العشاء','recentRecords':'آخر الصلوات المسجلة','fiveDaily':'الصلوات الخمس اليومية','target':'الهدف','days':'أيام','noData':'ابدأ بإدخال تقديرك للسنوات التي فاتتك فيها الصلاة.'
  },
  'es': {
    'welcome':'Te damos la bienvenida a Qadaa','intro':'Tu compañero para organizar las oraciones pendientes','choose':'Elige el idioma','continue':'Continuar','home':'Inicio','plan':'Plan diario','stats':'Estadísticas','encouragement':'Motivación','settings':'Ajustes','missed':'Oraciones pendientes','estimate':'Calcular pendientes','completed':'Realizadas','remaining':'Pendientes','total':'Total estimado','progress':'Progreso','years':'Años estimados','save':'Guardar estimación','daily':'Objetivo diario','prayers':'oraciones','savePlan':'Guardar plan','log':'Registrar una oración realizada','motivation':'Un paso constante cada día es mejor que rendirse.','verse':'«Establece la oración para recordarme»','verseRef':'Ta-Ha 20:14','subtitle':'Empieza poco a poco y continúa con constancia','language':'Idioma','note':'Es una estimación organizativa, no una opinión religiosa.','edit':'Editar','notifications':'Notificaciones','welcomeBack':'Bienvenido','fajr':'Fajr','dhuhr':'Dhuhr','asr':'Asr','maghrib':'Maghrib','isha':'Isha','recentRecords':'Registros recientes','fiveDaily':'Las cinco oraciones diarias','target':'Objetivo','days':'días','noData':'Introduce una estimación de los años de oraciones pendientes.'
  },
  'en': {
    'welcome':'Welcome to Qadaa','intro':'Your companion for organizing missed prayers','choose':'Choose your language','continue':'Continue','home':'Home','plan':'Daily plan','stats':'Statistics','encouragement':'Encouragement','settings':'Settings','missed':'Missed prayers','estimate':'Estimate missed prayers','completed':'Completed','remaining':'Remaining','total':'Estimated total','progress':'Progress','years':'Estimated years','save':'Save estimate','daily':'Daily target','prayers':'prayers','savePlan':'Save plan','log':'Log a completed prayer','motivation':'A steady step each day is better than stopping.','verse':'“Establish prayer for My remembrance”','verseRef':'Ta-Ha 20:14','subtitle':'Start small and keep moving forward','language':'Language','note':'An organizational estimate, not a religious ruling.','edit':'Edit','notifications':'Notifications','welcomeBack':'Welcome','fajr':'Fajr','dhuhr':'Dhuhr','asr':'Asr','maghrib':'Maghrib','isha':'Isha','recentRecords':'Recent prayer records','fiveDaily':'The five daily prayers','target':'Target','days':'days','noData':'Enter an estimate of the years of missed prayers.'
  },
  'fr': {
    'welcome':'Bienvenue sur Qadaa','intro':'Votre compagnon pour organiser les prières à rattraper','choose':'Choisissez la langue','continue':'Continuer','home':'Accueil','plan':'Plan quotidien','stats':'Statistiques','encouragement':'Encouragement','settings':'Paramètres','missed':'Prières à rattraper','estimate':'Estimer les prières','completed':'Effectuées','remaining':'Restantes','total':'Total estimé','progress':'Progression','years':'Années estimées','save':'Enregistrer','daily':'Objectif quotidien','prayers':'prières','savePlan':'Valider le plan','log':'Enregistrer une prière effectuée','motivation':'Un petit pas chaque jour vaut mieux que l’abandon.','verse':'« Accomplis la prière pour te souvenir de Moi »','verseRef':'Taha : 14','subtitle':'Commencez doucement, avancez avec constance','language':'Langue','note':'Estimation d’organisation, pas un avis religieux.','edit':'Modifier','notifications':'Notifications','welcomeBack':'Bienvenue','fajr':'Fajr','dhuhr':'Dhouhr','asr':'Asr','maghrib':'Maghrib','isha':'Icha','recentRecords':'Prières récemment enregistrées','fiveDaily':'Les cinq prières quotidiennes','target':'Objectif','days':'jours','noData':'Saisissez une estimation des années de prières à rattraper.'
  },
  'de': {
    'welcome':'Willkommen bei Qadaa','intro':'Dein Begleiter zum Nachholen versäumter Gebete','choose':'Sprache auswählen','continue':'Weiter','home':'Startseite','plan':'Tagesplan','stats':'Statistik','encouragement':'Motivation','settings':'Einstellungen','missed':'Versäumte Gebete','estimate':'Gebete schätzen','completed':'Nachgeholt','remaining':'Offen','total':'Geschätzte Gesamtzahl','progress':'Fortschritt','years':'Geschätzte Jahre','save':'Schätzung speichern','daily':'Tagesziel','prayers':'Gebete','savePlan':'Plan speichern','log':'Nachgeholtes Gebet erfassen','motivation':'Ein beständiger Schritt jeden Tag ist besser als aufzugeben.','verse':'„Verrichte das Gebet zu Meinem Gedenken“','verseRef':'Ta-Ha 20:14','subtitle':'Fange klein an und bleibe beständig','language':'Sprache','note':'Eine organisatorische Schätzung, keine religiöse Rechtsauskunft.','edit':'Bearbeiten','notifications':'Benachrichtigungen','welcomeBack':'Willkommen','fajr':'Fadschr','dhuhr':'Dhuhr','asr':'Asr','maghrib':'Maghrib','isha':'Ischa','recentRecords':'Zuletzt erfasste Gebete','fiveDaily':'Die fünf täglichen Gebete','target':'Ziel','days':'Tage','noData':'Gib eine Schätzung der Jahre mit versäumten Gebeten ein.'
  }
};

String tr(String language, String key) =>
    translations[language]?[key] ?? translations['en']![key] ?? key;

const languages = <(String, String, String)>[
  ('ar', 'العربية', 'ع'),
  ('es', 'Español', 'ES'),
  ('en', 'English', 'EN'),
  ('fr', 'Français', 'FR'),
  ('de', 'Deutsch', 'DE'),
];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QadaaApp());
}

class QadaaApp extends StatefulWidget {
  const QadaaApp({super.key});
  @override
  State<QadaaApp> createState() => _QadaaAppState();
}

class _QadaaAppState extends State<QadaaApp> {
  String? language;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      language = prefs.getString('qadaa.language');
      loading = false;
    });
  }

  Future<void> _setLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('qadaa.language', value);
    if (mounted) setState(() => language = value);
  }

  @override
  Widget build(BuildContext context) {
    final lang = language ?? 'ar';
    return MaterialApp(
      title: 'Qadaa | قضاء',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: forest, surface: cream),
      ),
      home: loading
          ? const Scaffold(
              backgroundColor: forest,
              body: Center(child: CircularProgressIndicator(color: gold)),
            )
          : language == null
              ? LanguagePage(onChoose: _setLanguage)
              : Directionality(
                  textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
                  child: HomePage(language: lang, onLanguageChange: _setLanguage),
                ),
    );
  }
}

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key, required this.onChoose});
  final Future<void> Function(String) onChoose;
  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String selected = 'ar';
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    String t(String key) => tr(selected, key);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const CustomPaint(painter: SceneryPainter()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        color: forest,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: gold, width: 2),
                      ),
                      child: const Icon(Icons.mosque_rounded, color: Color(0xFFFFE8A8), size: 60),
                    ),
                    const SizedBox(height: 22),
                    Text(t('welcome'), textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 29, fontWeight: FontWeight.w900, color: forest)),
                    const SizedBox(height: 10),
                    Text(t('intro'), textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15, height: 1.7, color: ink)),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: cream,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: gold),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(t('choose'), textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: forest)),
                          const SizedBox(height: 14),
                          for (final item in languages)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: InkWell(
                                onTap: () => setState(() => selected = item.$1),
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  padding: const EdgeInsets.all(13),
                                  decoration: BoxDecoration(
                                    color: selected == item.$1 ? const Color(0xFFE2EEE4) : Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: selected == item.$1 ? green : const Color(0xFFE6E2D7)),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: forest,
                                        child: Text(item.$3, style: const TextStyle(color: gold, fontWeight: FontWeight.bold)),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(child: Text(item.$2, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: ink))),
                                      Icon(selected == item.$1 ? Icons.radio_button_checked : Icons.radio_button_off, color: green),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),
                          FilledButton(
                            onPressed: saving ? null : () async {
                              setState(() => saving = true);
                              await widget.onChoose(selected);
                            },
                            style: FilledButton.styleFrom(backgroundColor: forest, padding: const EdgeInsets.all(16)),
                            child: saving
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : Text(t('continue'), style: const TextStyle(fontWeight: FontWeight.w800)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.language, required this.onLanguageChange});
  final String language;
  final Future<void> Function(String) onLanguageChange;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;
  int years = 0;
  int legacyCompleted = 0;
  List<PrayerRecord> records = [];
  int get completed => (legacyCompleted + records.length).clamp(0, total).toInt();
  int dailyTarget = 5;
  bool loading = true;

  String get lang => widget.language;
  String t(String key) => tr(lang, key);
  int get total => years * 365 * 5;
  int get remaining => (total - completed).clamp(0, total);
  int get progress => total == 0 ? 0 : (completed * 100 / total).round().clamp(0, 100).toInt();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final snapshot = await QadaaPrayerStore.load();
    if (!mounted) return;
    setState(() {
      years = prefs.getInt('qadaa.years') ?? 0;
      legacyCompleted = snapshot.legacyCompleted;
      records = snapshot.records;
      dailyTarget = prefs.getInt('qadaa.dailyTarget') ?? 5;
      loading = false;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('qadaa.years', years);
    await prefs.setInt('qadaa.dailyTarget', dailyTarget);
    await QadaaPrayerStore.save(QadaaPrayerStoreSnapshot(
      legacyCompleted: legacyCompleted,
      records: records,
    ));
  }

  Future<void> _editEstimate() async {
    int draft = years;
    final result = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: cream,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, update) => Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(ctx).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(t('estimate'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: forest)),
              const SizedBox(height: 16),
              Text('${t('years')}: $draft', style: const TextStyle(fontWeight: FontWeight.bold, color: ink)),
              Slider(value: draft.toDouble(), min: 0, max: 80, divisions: 80, activeColor: green,
                  label: '$draft', onChanged: (value) => update(() => draft = value.round())),
              Text('${draft * 365 * 5} ${t('prayers')}', style: const TextStyle(color: forest, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              Text(t('note'), style: const TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(height: 14),
              FilledButton(onPressed: () => Navigator.pop(ctx, draft),
                  style: FilledButton.styleFrom(backgroundColor: forest), child: Text(t('save'))),
            ],
          ),
        ),
      ),
    );
    if (result == null) return;
    setState(() => years = result);
    await _saveData();
  }

  Future<void> _editPlan() async {
    int draft = dailyTarget;
    final result = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: cream,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, update) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(t('plan'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: forest)),
            const SizedBox(height: 16),
            Text('${t('daily')}: $draft ${t('prayers')}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Slider(value: draft.toDouble(), min: 1, max: 20, divisions: 19, activeColor: green,
                onChanged: (value) => update(() => draft = value.round())),
            Text('${(remaining / draft / 365).toStringAsFixed(1)} ${t('years')}',
                style: const TextStyle(color: forest, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            FilledButton(onPressed: () => Navigator.pop(ctx, draft),
                style: FilledButton.styleFrom(backgroundColor: forest), child: Text(t('savePlan'))),
          ]),
        ),
      ),
    );
    if (result == null) return;
    setState(() => dailyTarget = result);
    await _saveData();
  }

  Future<void> _changeLanguage() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: cream,
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          for (final item in languages)
            ListTile(title: Text(item.$2), onTap: () => Navigator.pop(ctx, item.$1),
                trailing: item.$1 == lang ? const Icon(Icons.check_circle, color: green) : null),
        ]),
      ),
    );
    if (result != null && result != lang) await widget.onLanguageChange(result);
  }

  Future<void> _logPrayer() async {
    if (remaining <= 0) return;
    final prayer = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(t('log'), style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w900, color: forest,
              )),
              const SizedBox(height: 12),
              for (final id in const ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'])
                ListTile(
                  leading: const Icon(Icons.check_circle_outline, color: green),
                  title: Text(t(id)),
                  onTap: () => Navigator.pop(ctx, id),
                ),
            ],
          ),
        ),
      ),
    );
    if (prayer == null) return;
    final record = PrayerRecord(prayer: prayer, completedAt: DateTime.now().toUtc());
    setState(() => records = [record, ...records]);
    await _saveData();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _home(),
      _simple(t('plan'), Icons.calendar_month_rounded, t('daily'), '$dailyTarget ${t('prayers')}', t('subtitle'), _editPlan),
      _simple(t('stats'), Icons.bar_chart_rounded, t('progress'), '$progress%',
          '${t('completed')}: $completed\n${t('remaining')}: $remaining', _editEstimate),
      _simple(t('encouragement'), Icons.volunteer_activism_rounded, t('motivation'), t('verse'), t('verseRef'), () => setState(() => tab = 0)),
      _simple(t('settings'), Icons.settings_rounded, t('language'), languages.firstWhere((e) => e.$1 == lang).$2, t('intro'), _changeLanguage),
    ];

    return Scaffold(
      body: SafeArea(child: loading ? const Center(child: CircularProgressIndicator(color: green))
          : IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: NavigationBar(
        height: 74,
        backgroundColor: const Color(0xFFFFFEFA),
        indicatorColor: const Color(0xFFDCEDE4),
        selectedIndex: tab,
        onDestinationSelected: (index) => setState(() => tab = index),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home_rounded), label: t('home')),
          NavigationDestination(icon: const Icon(Icons.calendar_month_outlined), label: t('plan')),
          NavigationDestination(icon: const Icon(Icons.bar_chart_rounded), label: t('stats')),
          NavigationDestination(icon: const Icon(Icons.volunteer_activism_outlined), label: t('encouragement')),
          NavigationDestination(icon: const Icon(Icons.settings_outlined), label: t('settings')),
        ],
      ),
    );
  }

  Widget _home() => CustomScrollView(slivers: [
    SliverToBoxAdapter(
      child: SizedBox(
        height: 230,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
          child: Stack(fit: StackFit.expand, children: [
            const CustomPaint(painter: SceneryPainter()),
            Positioned(top: 8, left: 12, right: 12, child: Row(children: [
              IconButton(onPressed: () => setState(() => tab = 4), icon: const Icon(Icons.settings_outlined, color: forest)),
              const Spacer(),
              IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('notifications')))),
                  icon: const Icon(Icons.notifications_none_rounded, color: forest)),
            ])),
            Positioned(left: 18, right: 18, bottom: 22, child: Row(children: [
              Container(width: 66, height: 66, decoration: BoxDecoration(color: forest, borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: gold, width: 2)),
                  child: const Icon(Icons.mosque_rounded, color: Color(0xFFFFE8A8), size: 42)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('قضاء | Qadaa', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: forest)),
                Text(t('subtitle'), style: const TextStyle(color: ink, fontSize: 12)),
              ])),
            ])),
          ]),
        ),
      ),
    ),
    SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(delegate: SliverChildListDelegate([
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFEAF0E0), borderRadius: BorderRadius.circular(20)),
          child: Row(children: [
            const Icon(Icons.auto_awesome_rounded, color: green, size: 28),
            const SizedBox(width: 10),
            Expanded(child: Text(t('verse'), style: const TextStyle(fontWeight: FontWeight.w800, color: forest))),
            Text(t('verseRef'), style: const TextStyle(fontSize: 11, color: ink)),
          ])),
        const SizedBox(height: 14),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE9E5D9))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t('missed'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: forest)),
            const SizedBox(height: 14),
            Row(children: [
              SizedBox(width: 84, height: 84, child: Stack(alignment: Alignment.center, children: [
                SizedBox.expand(child: CircularProgressIndicator(value: progress / 100, strokeWidth: 8, color: green,
                    backgroundColor: const Color(0xFFE9E9DF))),
                Text('$progress%', style: const TextStyle(fontWeight: FontWeight.w900, color: forest, fontSize: 20)),
              ])),
              const SizedBox(width: 12),
              Expanded(child: Column(children: [
                _metric(t('total'), _format(total)),
                _metric(t('completed'), _format(completed)),
                _metric(t('remaining'), _format(remaining)),
              ])),
            ]),
            if (years == 0) Padding(padding: const EdgeInsets.only(top: 8), child: Text(t('noData'), style: const TextStyle(color: ink, fontSize: 12))),
            const SizedBox(height: 8),
            Text('${t('years')}: $years', style: const TextStyle(color: ink, fontSize: 12)),
          ])),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _action(t('estimate'), Icons.calculate_rounded, const Color(0xFFFAF0DC), gold, _editEstimate)),
          const SizedBox(width: 10),
          Expanded(child: _action(t('plan'), Icons.event_available_rounded, const Color(0xFFDDF1E7), green, _editPlan)),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _action(t('stats'), Icons.insights_rounded, const Color(0xFFECE7FA), const Color(0xFF7057C9), () => setState(() => tab = 2))),
          const SizedBox(width: 10),
          Expanded(child: _action(t('encouragement'), Icons.volunteer_activism_rounded, const Color(0xFFE1F1F8), const Color(0xFF258DB1), () => setState(() => tab = 3))),
        ]),
        const SizedBox(height: 14),
        Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [forest, Color(0xFF247D63)]), borderRadius: BorderRadius.circular(22)),
          child: Row(children: [
            const Icon(Icons.spa_rounded, color: Color(0xFFE5C77B), size: 34),
            const SizedBox(width: 12),
            Expanded(child: Text(t('motivation'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
          ])),
        const SizedBox(height: 12),
        OutlinedButton.icon(onPressed: _logPrayer, icon: const Icon(Icons.check_circle_outline), label: Text(t('log')),
            style: OutlinedButton.styleFrom(foregroundColor: forest, padding: const EdgeInsets.all(14))),
        if (records.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(t('recentRecords'), style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w900, color: forest,
          )),
          const SizedBox(height: 6),
          for (final record in records.take(3))
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: const Icon(Icons.check_circle, color: green),
              title: Text(t(record.prayer)),
              subtitle: Text(record.completedAt.toLocal().toString().substring(0, 16)),
              dense: true,
            ),
        ],
        const SizedBox(height: 8),
        Text(t('note'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Colors.black54)),
      ])),
    ),
  ]);

  String _format(int number) => number.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  Widget _metric(String label, String value) => Container(
    width: double.infinity, margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(color: const Color(0xFFFAFAF4), borderRadius: BorderRadius.circular(12)),
    child: Row(children: [
      Expanded(child: Text(label, style: const TextStyle(fontSize: 11, color: ink))),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w900, color: forest)),
    ]),
  );

  Widget _action(String label, IconData icon, Color background, Color accent, VoidCallback action) => Material(
    color: background, borderRadius: BorderRadius.circular(20),
    child: InkWell(onTap: action, borderRadius: BorderRadius.circular(20), child: Container(
      constraints: const BoxConstraints(minHeight: 112), padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(backgroundColor: accent, child: Icon(icon, color: Colors.white)),
        const SizedBox(height: 12),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w900, color: ink)),
        Align(alignment: AlignmentDirectional.centerEnd, child: Icon(Icons.arrow_forward_rounded, color: accent)),
      ]),
    )),
  );

  Widget _simple(String title, IconData icon, String heading, String value, String body, VoidCallback action) => Center(
    child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CircleAvatar(radius: 44, backgroundColor: const Color(0xFFE4EFE5), child: Icon(icon, color: forest, size: 44)),
      const SizedBox(height: 20),
      Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: forest)),
      const SizedBox(height: 16),
      Text(heading, textAlign: TextAlign.center, style: const TextStyle(color: ink)),
      const SizedBox(height: 8),
      Text(value, textAlign: TextAlign.center, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: green)),
      const SizedBox(height: 10),
      Text(body, textAlign: TextAlign.center, style: const TextStyle(height: 1.6, color: ink)),
      const SizedBox(height: 22),
      FilledButton(onPressed: action, style: FilledButton.styleFrom(backgroundColor: forest), child: Text(t('edit'))),
    ])),
  );
}

class SceneryPainter extends CustomPainter {
  const SceneryPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..shader = const LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [Color(0xFFF5D9A8), Color(0xFFFFF5DC), Color(0xFFD9E5D1)],
    ).createShader(rect));
    canvas.drawCircle(Offset(size.width * .52, size.height * .34), size.height * .11,
        Paint()..color = const Color(0xFFFFF2BE));

    void hill(List<Offset> points, Color color) {
      final path = Path()..moveTo(0, size.height);
      for (final point in points) {
        path.lineTo(point.dx * size.width, point.dy * size.height);
      }
      path.lineTo(size.width, size.height);
      path.close();
      canvas.drawPath(path, Paint()..color = color);
    }

    hill([const Offset(0,.60), const Offset(.12,.48), const Offset(.23,.56), const Offset(.39,.37),
      const Offset(.53,.55), const Offset(.67,.42), const Offset(.83,.59), const Offset(1,.46)], const Color(0xFFD8D7B9));
    hill([const Offset(0,.72), const Offset(.16,.57), const Offset(.29,.67), const Offset(.47,.50),
      const Offset(.63,.67), const Offset(.79,.54), const Offset(1,.68)], const Color(0xFF9CB7A0));
    hill([const Offset(0,.84), const Offset(.15,.68), const Offset(.31,.78), const Offset(.49,.65),
      const Offset(.68,.79), const Offset(.85,.65), const Offset(1,.76)], const Color(0xFF5B8B73));

    final mosque = Paint()..color = const Color(0xFF245C4A);
    final x = size.width * .18;
    final y = size.height * .64;
    canvas.drawRect(Rect.fromLTWH(x, y + 20, 76, 48), mosque);
    canvas.drawArc(Rect.fromCenter(center: Offset(x + 38, y + 20), width: 45, height: 49),
        3.14159, 3.14159, true, mosque);
    canvas.drawRect(Rect.fromLTWH(x - 15, y - 20, 11, 88), mosque);
    canvas.drawRect(Rect.fromLTWH(x - 18, y - 24, 17, 6), mosque);
    canvas.drawCircle(Offset(x - 9.5, y - 28), 3, Paint()..color = gold);
    canvas.drawRect(Rect.fromLTWH(x + 14, y + 43, 13, 25), Paint()..color = const Color(0xFFF5E8C9));
    canvas.drawRect(Rect.fromLTWH(x + 47, y + 43, 13, 25), Paint()..color = const Color(0xFFF5E8C9));
  }

  @override
  bool shouldRepaint(covariant SceneryPainter oldDelegate) => false;
}
