import 'package:clarified_mobile/l10n/L10n.dart';
import 'package:clarified_mobile/services/app_pref.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart' show GoRouter;
import 'package:clarified_mobile/features/router.dart';
import 'package:clarified_mobile/services/firebase.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
 await FirebaseAppCheck.instance.activate();
 
  runApp(
    ProviderScope(
      child: ClarifiedApp(
        router: initRouter(),
      ),
    ),
  );
}

class ClarifiedApp extends StatefulWidget {
  final GoRouter router;

  const ClarifiedApp({super.key, required this.router});

  @override
  State<ClarifiedApp> createState() => _ClarifiedAppState();

  static void setLocal(BuildContext context, Locale newLocale){
    _ClarifiedAppState? state = context.findRootAncestorStateOfType<_ClarifiedAppState>();
    state?.setLocale(newLocale);
  }
}

class _ClarifiedAppState extends State<ClarifiedApp> {
  Locale? _locale;

  setLocale(Locale locale){
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    AppPref.getLanguageCode().then((value) {
      setLocale(value);
    });
    super.didChangeDependencies();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          surface: const Color(0xFFF9FAFB),
        ),
        useMaterial3: true,
      ),
      locale: _locale,
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      routerConfig: widget.router,
    );
  }
}
