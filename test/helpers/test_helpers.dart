import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:parental_control/app/landing_page.dart';
import 'package:parental_control/services/app_usage_local_service.dart';
import 'package:parental_control/services/auth.dart';
import 'package:parental_control/services/database.dart';
import 'package:parental_control/services/geo_locator_service.dart';
import 'package:parental_control/services/notification_service.dart';
import 'package:parental_control/sign_in/email_sign_in_bloc.dart';
import 'package:provider/provider.dart';

import 'test_helpers.mocks.dart';

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<AuthBase>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<Database>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<GeoLocatorService>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<User>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<NavigatorObserver>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<EmailSignInBloc>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<AppUsage>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<FireStoreDatabase>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<NotificationService>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
  ],
)
void registerServices() {}

class Helper {
  static Future<void> launch(Widget child, WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }

  static Future<void> pumpLandingPage(
    WidgetTester tester, {
    VoidCallback? onSignedIn,
    MockAuthBase? mockAuthBase,
    MockGeoLocatorService? mockGeoLocatorService,
  }) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuthBase ?? MockAuthBase(),
        child: Provider<GeoLocatorService>(
          create: (_) => mockGeoLocatorService ?? MockGeoLocatorService(),
          child: MaterialApp(
            home: Scaffold(
              body: LandingPage(),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
  }
}
