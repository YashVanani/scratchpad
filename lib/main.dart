import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart' show GoRouter;
import 'package:clarified_mobile/features/router.dart';
import 'package:clarified_mobile/services/firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();

  runApp(
    ProviderScope(
      child: ClarifiedApp(
        router: initRouter(),
      ),
    ),
  );
}

class ClarifiedApp extends StatelessWidget {
  final GoRouter router;

  const ClarifiedApp({super.key, required this.router});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          surface: const Color(0xFFF9FAFB),
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
