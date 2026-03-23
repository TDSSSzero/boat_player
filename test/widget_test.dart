import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:boat_player/pages/welcome_page.dart';
import 'package:boat_player/utils/cookie_store.dart';

void main() {
  testWidgets('WelcomePage shows login when no cookie',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'privacy_notice_shown_v1': true,
    });
    await CookieStore().init();

    await tester.pumpWidget(
      MaterialApp(
        builder: FlutterSmartDialog.init(),
        navigatorObservers: [FlutterSmartDialog.observer],
        home: const WelcomePage(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Boat Player'), findsOneWidget);
    expect(find.text('请登录'), findsOneWidget);
  });
}
