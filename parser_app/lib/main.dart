import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'resizer.dart';

import 'login.dart';
import 'main_page.dart';
import 'auth.dart';

Future<bool> _bootstrapAuth() async {
  try {
    await Api.I.me(); // если токены валидны — не упадёт
    return true;
  } catch (_) {
    return false;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final authed = await _bootstrapAuth();
  runApp(MyApp(startLogin: authed));
}

class MyApp extends StatefulWidget {
  final bool startLogin;
  const MyApp({super.key, required this.startLogin});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _authorized = false; //authorized
  final _loginPageKey = GlobalKey<LoginPageState>();
  final _homePageKey = GlobalKey<HomePageState>();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _authorized = widget.startLogin;
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
    Api.I.logout();
    setState(() {
      _authorized = false;
    });
  }

  void authorize(String email, String password) async {
    FocusScope.of(context).unfocus();

    final authorized = await checkAuthorize(email, password);

    if (authorized) {
      animationAuthorize();
      setState(() {
        _authorized = true;
      });
      _loginPageKey.currentState?.clear();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Неверный логин/пароль')));
    }
  }

  void animationAuthorize() {
    _homePageKey.currentState?.getGoods();
    _homePageKey.currentState?.moveToY(0);
    _loginPageKey.currentState?.moveToY(-844);
  }

  Future<bool> checkAuthorize(String email, String password) async {
    try {
      await Api.I.login(email.trim(), password);
      await Api.I.me();
      return true;
    } catch (e) {
      return false;
    }
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
