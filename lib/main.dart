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
  int get completed => legacyCompleted + records.length;
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
    // Prayer history is factual data and must remain recordable even before
    // the user enters an estimated backlog total.
    final prayer = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: cream,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  visualDensity: VisualDensity.compact,
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
        height: 248,
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
                  child: const Padding(
                    padding: EdgeInsets.all(9),
                    child: CustomPaint(painter: QadaaMarkPainter()),
                  )),
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

  Widget _simple(String title, IconData icon, String heading, String value, String body, VoidCallback action) {
    final isStats = title == t('stats');
    final isPlan = title == t('plan');
    final isEncouragement = title == t('encouragement');
    final isSettings = title == t('settings');
    final accent = isStats
        ? const Color(0xFF6D5CC6)
        : isEncouragement
            ? const Color(0xFFB77A28)
            : forest;

    Widget infoTile(IconData leading, String label, String detail) => Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9E5D9)),
      ),
      child: Row(children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(color: const Color(0xFFEAF2E9), borderRadius: BorderRadius.circular(13)),
          child: Icon(leading, color: forest, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF68756C))),
          const SizedBox(height: 4),
          Text(detail, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: forest)),
        ])),
        const Icon(Icons.chevron_right_rounded, color: Color(0xFF9AA69B)),
      ]),
    );

    return Scaffold(
      backgroundColor: cream,
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: Container(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 26),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight, end: Alignment.bottomLeft,
              colors: [Color(0xFFE9F0E2), Color(0xFFFFF9E9), Color(0xFFF4E5C8)],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: SafeArea(bottom: false, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: forest, borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: gold, width: 1.5),
                    boxShadow: const [BoxShadow(color: Color(0x1F173E34), blurRadius: 12, offset: Offset(0, 5))],
                  ),
                  child: Icon(icon, color: const Color(0xFFFFE8A8), size: 27),
                ),
                const SizedBox(width: 13),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: const TextStyle(fontSize: 24, height: 1.2, fontWeight: FontWeight.w900, color: forest)),
                  const SizedBox(height: 4),
                  Text(t('subtitle'), style: const TextStyle(fontSize: 12, color: ink)),
                ])),
              ]),
              const SizedBox(height: 24),
              Text(heading, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: ink)),
              const SizedBox(height: 7),
              Text(value, style: TextStyle(fontSize: isStats ? 32 : 25, height: 1.25, fontWeight: FontWeight.w900, color: accent)),
              const SizedBox(height: 9),
              Text(body, style: const TextStyle(fontSize: 13, height: 1.6, color: ink)),
              if (isStats) ...[
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress / 100, minHeight: 9,
                    backgroundColor: const Color(0xFFD9E2D5), color: green,
                  ),
                ),
                const SizedBox(height: 7),
                Align(alignment: AlignmentDirectional.centerEnd,
                  child: Text(t('progress') + ': ' + progress.toString() + '%',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: forest))),
              ],
            ],
          )),
        )),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
          sliver: SliverList(delegate: SliverChildListDelegate([
            if (isPlan) ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [forest, Color(0xFF26745D)]),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(children: [
                  const Icon(Icons.flag_rounded, color: Color(0xFFFFE2A0), size: 30),
                  const SizedBox(width: 13),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(t('daily'), style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 5),
                    Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                  ])),
                  const Icon(Icons.edit_calendar_rounded, color: Color(0xFFFFE2A0), size: 26),
                ]),
              ),
              const SizedBox(height: 18),
              Text(t('fiveDaily'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: forest)),
              const SizedBox(height: 10),
              infoTile(Icons.wb_twilight_rounded, t('fajr'), t('daily') + ': ' + dailyTarget.toString()),
              const SizedBox(height: 9),
              infoTile(Icons.wb_sunny_outlined, t('dhuhr'), t('daily') + ': ' + dailyTarget.toString()),
              const SizedBox(height: 9),
              infoTile(Icons.wb_sunny_rounded, t('asr'), t('daily') + ': ' + dailyTarget.toString()),
              const SizedBox(height: 9),
              infoTile(Icons.nights_stay_outlined, t('maghrib'), t('daily') + ': ' + dailyTarget.toString()),
              const SizedBox(height: 9),
              infoTile(Icons.dark_mode_outlined, t('isha'), t('daily') + ': ' + dailyTarget.toString()),
              const SizedBox(height: 16),
            ] else if (isStats) ...[
              Row(children: [
                Expanded(child: _summaryMetric(t('completed'), _format(completed), Icons.check_circle_outline, const Color(0xFFE0F1E5))),
                const SizedBox(width: 10),
                Expanded(child: _summaryMetric(t('remaining'), _format(remaining), Icons.hourglass_bottom_rounded, const Color(0xFFFFEED4))),
              ]),
              const SizedBox(height: 12),
              _summaryMetric(t('total'), _format(total), Icons.format_list_numbered_rounded, const Color(0xFFE8E5F7)),
              const SizedBox(height: 16),
              infoTile(Icons.calendar_month_rounded, t('years'), years.toString()),
              const SizedBox(height: 9),
              infoTile(Icons.flag_outlined, t('daily'), dailyTarget.toString() + ' ' + t('prayers')),
              const SizedBox(height: 16),
            ] else if (isEncouragement) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1E4),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFD7E4D2)),
                ),
                child: Column(children: [
                  const Icon(Icons.auto_awesome_rounded, color: gold, size: 34),
                  const SizedBox(height: 14),
                  Text(t('verse'), textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, height: 1.8, fontWeight: FontWeight.w900, color: forest)),
                  const SizedBox(height: 8),
                  Text(t('verseRef'), style: const TextStyle(color: ink, fontWeight: FontWeight.w700)),
                ]),
              ),
              const SizedBox(height: 14),
              infoTile(Icons.spa_rounded, t('motivation'), t('subtitle')),
              const SizedBox(height: 16),
            ] else if (isSettings) ...[
              infoTile(Icons.translate_rounded, t('language'), value),
              const SizedBox(height: 9),
              infoTile(Icons.shield_outlined, t('note'), t('intro')),
              const SizedBox(height: 16),
            ] else ...[
              infoTile(icon, heading, value),
              const SizedBox(height: 16),
            ],
            SizedBox(
              width: double.infinity, height: 54,
              child: FilledButton.icon(
                onPressed: action,
                icon: Icon(isSettings ? Icons.translate_rounded : isPlan ? Icons.tune_rounded : isStats ? Icons.edit_note_rounded : Icons.arrow_forward_rounded),
                label: Text(isSettings ? t('edit') : isPlan ? t('edit') : isStats ? t('estimate') : isEncouragement ? t('home') : t('edit')),
                style: FilledButton.styleFrom(
                  backgroundColor: forest, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
                  textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
            ),
          ])),
        ),
      ]),
    );
  }

  Widget _summaryMetric(String label, String value, IconData icon, Color tint) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFE9E5D9))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 38, height: 38, decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: forest, size: 21)),
      const SizedBox(height: 12),
      Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF68756C))),
      const SizedBox(height: 5),
      Text(value, maxLines: 1, overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: forest)),
    ]),
  );
}

class QadaaMarkPainter extends CustomPainter {
  const QadaaMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final goldPaint = Paint()..color = const Color(0xFFFFE8A8)..style = PaintingStyle.stroke..strokeWidth = 2.2..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final fillPaint = Paint()..color = const Color(0xFFFFE8A8);
    final arch = Path()
      ..moveTo(size.width * .16, size.height * .86)
      ..lineTo(size.width * .16, size.height * .39)
      ..quadraticBezierTo(size.width * .5, -size.height * .08, size.width * .84, size.height * .39)
      ..lineTo(size.width * .84, size.height * .86);
    canvas.drawPath(arch, goldPaint);
    canvas.drawLine(Offset(size.width * .08, size.height * .87), Offset(size.width * .92, size.height * .87), goldPaint);
    final dome = Path()
      ..moveTo(size.width * .29, size.height * .57)
      ..quadraticBezierTo(size.width * .5, size.height * .28, size.width * .71, size.height * .57)
      ..lineTo(size.width * .71, size.height * .78)
      ..lineTo(size.width * .29, size.height * .78)
      ..close();
    canvas.drawPath(dome, fillPaint);
    canvas.drawRect(Rect.fromLTWH(size.width * .46, size.height * .62, size.width * .08, size.height * .16),
        Paint()..color = forest);
    canvas.drawLine(Offset(size.width * .5, size.height * .29), Offset(size.width * .5, size.height * .17), goldPaint);
    canvas.drawCircle(Offset(size.width * .5, size.height * .14), size.width * .045, fillPaint);
    canvas.drawArc(Rect.fromCircle(center: Offset(size.width * .55, size.height * .13), radius: size.width * .065),
        .7, 4.9, false, Paint()..color = forest..style = PaintingStyle.stroke..strokeWidth = 2.5);
  }

  @override
  bool shouldRepaint(covariant QadaaMarkPainter oldDelegate) => false;
}

class SceneryPainter extends CustomPainter {
  const SceneryPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..shader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF7D9A5), Color(0xFFFFF6DF), Color(0xFFDDE8D6), Color(0xFFB8D0B8)],
      stops: [0, .38, .72, 1],
    ).createShader(rect));

    final sunCenter = Offset(size.width * .72, size.height * .30);
    canvas.drawCircle(sunCenter, size.height * .19, Paint()
      ..shader = RadialGradient(colors: [
        const Color(0xFFFFF5C9).withValues(alpha: .88),
        const Color(0xFFFFF5C9).withValues(alpha: .28),
        const Color(0xFFFFF5C9).withValues(alpha: 0),
      ]).createShader(Rect.fromCircle(center: sunCenter, radius: size.height * .19)));
    canvas.drawCircle(sunCenter, size.height * .065, Paint()..color = const Color(0xFFFFF4C7));

    void ridge(List<Offset> points, Color color) {
      final path = Path()..moveTo(0, size.height);
      for (final point in points) {
        path.lineTo(point.dx * size.width, point.dy * size.height);
      }
      path.lineTo(size.width, size.height);
      path.close();
      canvas.drawPath(path, Paint()..color = color);
    }

    ridge([const Offset(0,.54), const Offset(.10,.42), const Offset(.19,.48),
      const Offset(.34,.27), const Offset(.45,.43), const Offset(.58,.34),
      const Offset(.72,.47), const Offset(.86,.32), const Offset(1,.43)], const Color(0xFFD9D8C2));
    ridge([const Offset(0,.67), const Offset(.14,.53), const Offset(.25,.62),
      const Offset(.40,.43), const Offset(.54,.59), const Offset(.70,.45),
      const Offset(.83,.62), const Offset(1,.49)], const Color(0xFFB4C8AC));
    ridge([const Offset(0,.79), const Offset(.13,.65), const Offset(.28,.73),
      const Offset(.42,.61), const Offset(.58,.76), const Offset(.75,.61),
      const Offset(.89,.74), const Offset(1,.65)], const Color(0xFF789F83));

    // Distant tree line gives the landscape depth without external image assets.
    final treePaint = Paint()..color = const Color(0xFF4C8065);
    for (int i = 0; i < 34; i++) {
      final x = size.width * (i / 34);
      final base = size.height * (.83 + ((i % 4) * .012));
      final h = size.height * (.045 + ((i * 7) % 5) * .009);
      canvas.drawCircle(Offset(x, base - h * .56), h * .55, treePaint);
      canvas.drawRect(Rect.fromLTWH(x - 1.4, base - h * .35, 2.8, h * .42),
          Paint()..color = const Color(0xFF386B54));
    }

    // Main mosque: layered prayer hall, dome, crescent, arches and minaret.
    final building = Paint()..color = const Color(0xFF205C49);
    final dark = Paint()..color = const Color(0xFF164938);
    final stone = Paint()..color = const Color(0xFFF6E8C8);
    final x = size.width * .19;
    final ground = size.height * .86;
    final hallW = size.width * .24;
    final hallH = size.height * .18;
    canvas.drawRect(Rect.fromLTWH(x, ground - hallH, hallW, hallH), building);
    canvas.drawRect(Rect.fromLTWH(x - 5, ground - hallH - 4, hallW + 10, 5), dark);

    final domeRect = Rect.fromCenter(
      center: Offset(x + hallW * .52, ground - hallH - size.height * .035),
      width: hallW * .58, height: size.height * .15,
    );
    canvas.drawArc(domeRect, 3.14159265, 3.14159265, true, dark);
    canvas.drawRect(Rect.fromLTWH(domeRect.left, domeRect.center.dy, domeRect.width, size.height * .035), dark);
    canvas.drawCircle(Offset(domeRect.center.dx, domeRect.top - 2), 2.5, Paint()..color = gold);

    // Minaret with balconies and pointed cap.
    final minX = x - size.width * .045;
    final minW = size.width * .034;
    final minTop = size.height * .38;
    canvas.drawRect(Rect.fromLTWH(minX, minTop, minW, ground - minTop), dark);
    canvas.drawRect(Rect.fromLTWH(minX - 4, minTop + size.height * .08, minW + 8, 3), Paint()..color = gold);
    canvas.drawRect(Rect.fromLTWH(minX - 4, minTop + size.height * .16, minW + 8, 3), Paint()..color = gold);
    final spire = Path()
      ..moveTo(minX - 3, minTop)
      ..lineTo(minX + minW / 2, minTop - size.height * .045)
      ..lineTo(minX + minW + 3, minTop)
      ..close();
    canvas.drawPath(spire, dark);
    canvas.drawLine(Offset(minX + minW / 2, minTop - size.height * .045),
        Offset(minX + minW / 2, minTop - size.height * .065), Paint()..color = gold..strokeWidth = 1.5);

    // Arched doors and windows.
    for (int i = 0; i < 3; i++) {
      final wx = x + hallW * (.17 + i * .31);
      final wy = ground - hallH * .70;
      final w = hallW * .16;
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(wx, wy, w, hallH * .70),
          Radius.circular(w / 2)), stone);
      canvas.drawRect(Rect.fromLTWH(wx, wy + w / 2, w, hallH * .70 - w / 2), stone);
    }

    // Small foreground trees.
    for (int i = 0; i < 8; i++) {
      final tx = size.width * (.04 + i * .045);
      final ty = size.height * (.91 - (i % 3) * .018);
      canvas.drawCircle(Offset(tx, ty), size.height * (.025 + (i % 2) * .008),
          Paint()..color = i.isEven ? const Color(0xFF2D6B52) : const Color(0xFF39795A));
    }

    // Birds as restrained silhouettes in the open sky.
    final birdPaint = Paint()..color = const Color(0xFF55745F)..style = PaintingStyle.stroke..strokeWidth = 1.35..strokeCap = StrokeCap.round;
    for (final p in const [
      Offset(.49,.22), Offset(.55,.18), Offset(.59,.24), Offset(.64,.16), Offset(.68,.22),
    ]) {
      final bx = p.dx * size.width;
      final by = p.dy * size.height;
      final path = Path()
        ..moveTo(bx - 5, by + 1)
        ..quadraticBezierTo(bx - 2, by - 3, bx, by)
        ..quadraticBezierTo(bx + 3, by - 3, bx + 6, by + 1);
      canvas.drawPath(path, birdPaint);
    }

    // Fine geometric corner ornament; subtle enough to keep text legible.
    final ornament = Paint()..color = const Color(0xFFB68C43).withValues(alpha: .25)..style = PaintingStyle.stroke..strokeWidth = 1;
    for (int i = 0; i < 6; i++) {
      final d = 13.0 + i * 12;
      final path = Path()
        ..moveTo(0, d)
        ..lineTo(d, 0)
        ..lineTo(d * 1.5, d * .5)
        ..lineTo(d * .5, d * 1.5)
        ..close();
      canvas.drawPath(path, ornament);
    }
  }

  @override
  bool shouldRepaint(covariant SceneryPainter oldDelegate) => false;
}
