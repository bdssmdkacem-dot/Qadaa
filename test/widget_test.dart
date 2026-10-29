import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qadaa/main.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> openHome(WidgetTester tester, {String language = 'ar'}) async {
    await tester.pumpWidget(const QadaaApp());
    await tester.pumpAndSettle();
    expect(find.text('اختر لغة التطبيق'), findsOneWidget);
    await tester.tap(find.text(language == 'ar' ? 'العربية' : language == 'fr' ? 'Français' : 'English'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(language == 'ar' ? 'المتابعة' : language == 'fr' ? 'Continuer' : 'Continue'));
    await tester.pumpAndSettle();
  }

  testWidgets('first launch asks for language then opens Arabic home', (tester) async {
    await openHome(tester);
    expect(find.text('قضاء | Qadaa'), findsOneWidget);
    expect(find.text('الصلوات الفائتة'), findsOneWidget);
    expect(find.text('اختر لغة التطبيق'), findsNothing);
  });

  testWidgets('French and English can be selected on first launch', (tester) async {
    await openHome(tester, language: 'fr');
    expect(find.text('Prières à rattraper'), findsOneWidget);
    expect(find.text('Accueil'), findsOneWidget);

    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const QadaaApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Missed prayers'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('language choice is saved and skips onboarding on relaunch', (tester) async {
    await openHome(tester, language: 'fr');
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const QadaaApp());
    await tester.pumpAndSettle();
    expect(find.text('Prières à rattraper'), findsOneWidget);
    expect(find.text('Choisissez la langue'), findsNothing);
  });

  testWidgets('bottom navigation opens statistics and returns home', (tester) async {
    await openHome(tester);
    await tester.tap(find.text('الإحصائيات'));
    await tester.pumpAndSettle();
    expect(find.text('الإحصائيات'), findsWidgets);
    expect(find.text('الإنجاز'), findsOneWidget);
    await tester.tap(find.text('الرئيسية').last);
    await tester.pumpAndSettle();
    expect(find.text('الصلوات الفائتة'), findsOneWidget);
  });

  testWidgets('home progress action saves completed prayer locally', (tester) async {
    await openHome(tester);
    await tester.tap(find.text('تسجيل صلاة تم قضاؤها'));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('completed'), 1);
  });
}
