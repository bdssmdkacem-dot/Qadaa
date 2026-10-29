import 'package:flutter_test/flutter_test.dart';
import 'package:qadaa/main.dart';

void main() {
  testWidgets('Qadaa app opens with Arabic home screen', (tester) async {
    await tester.pumpWidget(const QadaaApp());
    await tester.pumpAndSettle();
    expect(find.text('قضاء'), findsOneWidget);
    expect(find.text('الصلوات الفائتة'), findsOneWidget);
    expect(find.text('خطة القضاء اليومية'), findsOneWidget);
  });
}
