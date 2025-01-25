import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider:
        ReCaptchaV3Provider('6LcX38EqAAAAABXPGVh_uEdzAsveN3Lokpeb9lcb'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );


  runApp(
    StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
                home: Scaffold(body: CircularProgressIndicator()));
          }
          return GetMaterialApp(
            title: "Presence App",
            initialRoute: snapshot.data == null ? Routes.LOGIN : Routes.HOME,
            getPages: AppPages.routes,
          );
        }),
  );
}
