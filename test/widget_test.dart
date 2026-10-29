import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qadaa/main.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> chooseLanguage(WidgetTester tester, String language, String button) async {
    await tester.pumpWidget(const QadaaApp());
    await tester.pumpAndSettle();
    final label = switch (language) {
      'ar' => 'العربية',
      'es' => 'Español',
      'en' => 'English',
      'fr' => 'Français',
      _ => 'Deutsch',
    };
    await tester.ensureVisible(find.text(label).first);
    await tester.tap(find.text(label).first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text(button));
    await tester.tap(find.text(button));
    await tester.pumpAndSettle();
  }

  testWidgets('first launch shows all five language options', (tester) async {
    await tester.pumpWidget(const QadaaApp());
    await tester.pumpAndSettle();
    expect(find.text('اختر لغة التطبيق'), findsOneWidget);
    expect(find.text('العربية'), findsOneWidget);
    expect(find.text('Español'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Français'), findsOneWidget);
    expect(find.text('Deutsch'), findsOneWidget);
  });

  testWidgets('Arabic selection opens localized home', (tester) async {
    await chooseLanguage(tester, 'ar', 'المتابعة');
    expect(find.text('الصلوات الفائتة'), findsOneWidget);
    expect(find.text('الرئيسية'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('qadaa.language'), 'ar');
  });

  testWidgets('Spanish, English, French and German home are translated', (tester) async {
    for (final item in [
      ('es', 'Continuar', 'Oraciones pendientes', 'Inicio'),
      ('en', 'Continue', 'Missed prayers', 'Home'),
      ('fr', 'Continuer', 'Prières à rattraper', 'Accueil'),
      ('de', 'Weiter', 'Versäumte Gebete', 'Startseite'),
    ]) {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(const SizedBox.shrink());
      await chooseLanguage(tester, item.$1, item.$2);
      expect(find.text(item.$3), findsOneWidget);
      expect(find.text(item.$4), findsOneWidget);
    }
  });

  testWidgets('saved language skips onboarding after app restart', (tester) async {
    SharedPreferences.setMockInitialValues({'qadaa.language': 'fr'});
    await tester.pumpWidget(const QadaaApp());
    await tester.pumpAndSettle();
    expect(find.text('Prières à rattraper'), findsOneWidget);
    expect(find.text('Choisissez la langue'), findsNothing);
  });

  testWidgets('navigation opens statistics and settings', (tester) async {
    SharedPreferences.setMockInitialValues({'qadaa.language': 'en'});
    await tester.pumpWidget(const QadaaApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Statistics'));
    await tester.pumpAndSettle();
    expect(find.text('Progress'), findsOneWidget);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Language'), findsOneWidget);
  });
  testWidgets('logging a qadaa prayer stores its type and timestamp', (tester) async {
    SharedPreferences.setMockInitialValues({
      'qadaa.language': 'en',
      'qadaa.years': 1,
    });
    await tester.pumpWidget(const QadaaApp());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Log a completed prayer'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Log a completed prayer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fajr'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    final records = prefs.getString('qadaa.prayerRecords');
    expect(records, isNotNull);
    expect(records, contains('"prayer":"fajr"'));
    expect(records, contains('completedAt'));
    expect(prefs.getInt('qadaa.completed'), 1);
  });

}
