import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'resizer.dart';

import 'login.dart';
import 'main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _authorized = true; //authorized
  final _loginPageKey = GlobalKey<LoginPageState>();
  final _homePageKey = GlobalKey<HomePageState>();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(key: _homePageKey, top: 844, logout: _logout),
      LoginPage(key: _loginPageKey, authorize: authorize),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_authorized) {
        animationAuthorize();
      }
    });
  }

  void _logout() {
    _homePageKey.currentState?.moveToY(-844);
    _loginPageKey.currentState?.moveToY(0);
    _homePageKey.currentState?.clear();
    setState(() {
      _authorized = false;
    });
  }

  void authorize(String email, String password) {
    FocusScope.of(context).unfocus();
    bool authorized = checkAuthorize(email, password);
    if (authorized) {
      animationAuthorize();
      setState(() {
        _authorized = true;
      });
      _loginPageKey.currentState?.clear();
    }
  }

  void animationAuthorize() {
    _homePageKey.currentState?.moveToY(0);
    _loginPageKey.currentState?.moveToY(-844);
  }

  bool checkAuthorize(String email, String password) {
    // ignore: avoid_print
    print(email);
    // ignore: avoid_print
    print(password);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390.w,
      height: 844.h,
      decoration: BoxDecoration(color: Colors.white),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          initScale(context);
          final mq = MediaQuery.of(context);
          return MediaQuery(
            data: mq.copyWith(
              textScaler: const TextScaler.linear(1.0),
              boldText: false,
              alwaysUse24HourFormat: true,
              accessibleNavigation: false,
              highContrast: false,
              invertColors: false,
            ),
            child: child!,
          );
        },
        title: 'PKI_UL Frontend',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('ru'),
        supportedLocales: const [Locale('ru'), Locale('en')],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(95, 255, 255, 255),
          ),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            backgroundColor: Colors.white,
          ),
        ),
        home: Stack(children: _pages),
      ),
    );
  }
}
