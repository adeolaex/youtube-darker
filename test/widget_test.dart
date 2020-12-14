// Will write some unit test some-time.....

import 'package:flutter_test/flutter_test.dart';
import '../lib/screens/core-screens/core-header-screen.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(CoreHeaderScreen());
  });
}
