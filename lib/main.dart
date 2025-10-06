import 'package:financial_app/core/injection_container.dart' as di;
import 'package:financial_app/presentation/screens/home_screen.dart';
import 'package:financial_app/presentation/screens/login_screen.dart';
import 'package:financial_app/presentation/screens/register_screen.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  di.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AuthViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<AccountViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<TransactionViewModel>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(devicePixelRatio: 1.0, textScaler: TextScaler.linear(1.0)),
      child: MaterialApp(
        title: 'Financial App',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF2C2C54)),
          useMaterial3: true,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2C2C54), foregroundColor: Colors.white),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2C2C54), foregroundColor: Colors.white),
          ),
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR')],
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
