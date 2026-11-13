import 'package:flutter_test/flutter_test.dart';
import 'package:glowup_flutter/main.dart';

void main() {
  testWidgets('GlowUp app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GlowUpApp());
    expect(find.text('GlowUp'), findsOneWidget);
  });
}
