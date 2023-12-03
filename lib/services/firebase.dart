import 'package:clarified_mobile/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future initFirebase() async {
  final a = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await a.setAutomaticDataCollectionEnabled(true);
  print(a.name);

  final setting = FirebaseFirestore.instance.settings;
  FirebaseFirestore.instance.settings = setting.copyWith(
    persistenceEnabled: true,
    ignoreUndefinedProperties: true,
  );

  // TODO: Setup Remote Config

  // TODO: Setup Remote Config
}
