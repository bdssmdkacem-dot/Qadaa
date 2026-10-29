import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qadaa/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Qadaa opens with Arabic home screen', (tester) async {
    await tester.pumpWidget(const QadaaApp());
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('قضاء'), findsOneWidget);
    expect(find.text('الصلوات الفائتة'), findsOneWidget);
  });

  testWidgets('bottom navigation opens statistics and returns home', (tester) async {
    await tester.pumpWidget(const QadaaApp());
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('الإحصائيات'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('إنجازك حتى الآن'), findsOneWidget);
    await tester.tap(find.text('الرئيسية'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('الصلوات الفائتة'), findsOneWidget);
  });
}
