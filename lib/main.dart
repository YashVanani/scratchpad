import 'package:clarified_mobile/l10n/L10n.dart';
import 'package:clarified_mobile/parents/features/community/screen/post_detail.dart';
import 'package:clarified_mobile/services/app_pref.dart';
import 'package:clarified_mobile/services/notification.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart' show GoRouter;
import 'package:clarified_mobile/features/router.dart';
import 'package:clarified_mobile/services/firebase.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
 await FirebaseAppCheck.instance.activate();
 AwesomeNotifications().initialize(
     null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic notifications',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
  );
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
  final NotificationService _notificationService = NotificationService();

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

  @override
  void initState() {
    super.initState();
    _notificationService.setupFirebase();
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
