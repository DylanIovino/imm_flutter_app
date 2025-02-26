import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:imm_app/src/data/repositories/firestore_repository.dart';
import 'package:imm_app/src/data/services/user_data_service.dart';
import 'package:imm_app/src/data/services/blood_pressure_record_data_service.dart';
import 'package:imm_app/src/auth/authentication_service.dart';

// import provider
import 'package:provider/provider.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  MultiProvider(
    providers: [
          Provider<FirebaseAuth>(
            create: (_) => FirebaseAuth.instance,
          ),
          Provider<AuthenticationService>(
            create: (context) => AuthenticationService(
              Provider.of<FirebaseAuth>(context, listen: false),
            ),
          ),
          Provider<FirebaseFirestore>(
            create: (_) => FirebaseFirestore.instance,
          ),
          Provider<FirestoreRepository>(
            create: (context) => FirestoreRepository(
              Provider.of<FirebaseFirestore>(context, listen: false),
            ),
          ),
          ChangeNotifierProvider<UserDataService>(
            create: (context) => UserDataService(
              Provider.of<FirestoreRepository>(context, listen: false),
            ),
          ),
          ChangeNotifierProvider<BloodPressureRecordDataService>(
            create: (context) => BloodPressureRecordDataService(
              Provider.of<FirestoreRepository>(context, listen: false),
            ),
          ),
    ],
  )

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController));
}
