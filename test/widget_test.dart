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
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('This week'), findsOneWidget);
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

  testWidgets('prayer history can be recorded before estimating missed prayers', (tester) async {
    SharedPreferences.setMockInitialValues({'qadaa.language': 'en'});
    await tester.pumpWidget(const QadaaApp());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Log a completed prayer'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Log a completed prayer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Isha'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('qadaa.prayerRecords'), contains('"prayer":"isha"'));
    expect(prefs.getInt('qadaa.completed'), 1);
  });

  testWidgets('prayer record survives closing and reopening the app', (tester) async {
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
    await tester.tap(find.text('Dhuhr'));
    await tester.pumpAndSettle();

    // Dispose the whole widget tree, then start a fresh app against the same
    // persisted SharedPreferences store to model a relaunch.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pumpWidget(const QadaaApp());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Recent prayer records'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Recent prayer records'), findsOneWidget);
    expect(find.text('Dhuhr'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('qadaa.prayerRecords'), contains('"prayer":"dhuhr"'));
    expect(prefs.getInt('qadaa.completed'), 1);

    // Verify the aggregate survives relaunch on the statistics screen. The
    // home-page metric is above the recent-record section and may be offscreen.
    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Statistics'),
    ));
    await tester.pumpAndSettle();
    final completedTile = find.byKey(const ValueKey('completed-summary'));
    expect(completedTile, findsOneWidget);
    expect(
      find.descendant(of: completedTile, matching: find.text('1')),
      findsOneWidget,
    );
  });


  testWidgets('plan and statistics use real prayer record data', (tester) async {
    final now = DateTime.now().toUtc();
    SharedPreferences.setMockInitialValues({
      'qadaa.language': 'en',
      'qadaa.years': 1,
      'qadaa.dailyTarget': 3,
      'qadaa.prayerRecords': '[{"prayer":"fajr","completedAt":"${now.toIso8601String()}"},{"prayer":"isha","completedAt":"${now.toIso8601String()}"}]',
    });
    await tester.pumpWidget(const QadaaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Daily plan'));
    await tester.pumpAndSettle();
    expect(find.text('Today’s progress: 2 / 3'), findsOneWidget);
    expect(find.text('3 prayers'), findsOneWidget);

    await tester.tap(find.text('Statistics'));
    await tester.pumpAndSettle();
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('This week'), findsOneWidget);
    expect(find.text('Fajr'), findsOneWidget);
    expect(find.text('Isha'), findsOneWidget);
    expect(find.text('2'), findsWidgets);
  });



  testWidgets('all localized screens fit a narrow Android viewport', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final item in [
      ('ar', 'الخطة اليومية', 'الإحصائيات', 'الإعدادات'),
      ('es', 'Plan diario', 'Estadísticas', 'Ajustes'),
      ('en', 'Daily plan', 'Statistics', 'Settings'),
      ('fr', 'Plan quotidien', 'Statistiques', 'Paramètres'),
      ('de', 'Tagesplan', 'Statistik', 'Einstellungen'),
    ]) {
      SharedPreferences.setMockInitialValues({'qadaa.language': item.$1});
      await tester.pumpWidget(const QadaaApp());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'home overflow for ${item.$1}');

      final navigationBar = find.byType(NavigationBar);
      expect(navigationBar, findsOneWidget);
      final navRect = tester.getRect(navigationBar);
      for (final index in [1, 2, 4]) {
        await tester.tapAt(Offset(
          navRect.left + navRect.width * (index + 0.5) / 5,
          navRect.center.dy,
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull,
            reason: 'layout overflow for ${item.$1} on navigation item $index');
      }
    }
  });


  testWidgets('all tabs remain usable at common widths with enlarged text', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.binding.platformDispatcher.clearTextScaleFactorTestValue);
    tester.view.devicePixelRatio = 1;
    tester.binding.platformDispatcher.textScaleFactorTestValue = 1.3;

    for (final width in [320.0, 360.0, 412.0]) {
      tester.view.physicalSize = Size(width, 800);
      SharedPreferences.setMockInitialValues({'qadaa.language': 'ar'});
      await tester.pumpWidget(const QadaaApp());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'home overflow at width $width');

      final nav = find.byType(NavigationBar);
      expect(nav, findsOneWidget);
      final rect = tester.getRect(nav);
      for (var index = 0; index < 5; index++) {
        await tester.tapAt(Offset(
          rect.left + rect.width * (index + 0.5) / 5,
          rect.center.dy,
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull,
            reason: 'tab $index overflow at width $width with text scale 1.3');
      }
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    }
  });

}
