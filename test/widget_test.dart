import 'package:flutter_test/flutter_test.dart';
import 'package:health_data_hub/app/app.dart';

void main() {
  testWidgets('App boots into Phenotype hub', (tester) async {
    await tester.pumpWidget(const HealthDataHubApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.text('Phenotype'), findsWidgets);
  });
}
