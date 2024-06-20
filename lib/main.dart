import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/routing/app-routes.dart';
import 'horus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Horus(
    appRouter: AppRouter(),
  ));
}
