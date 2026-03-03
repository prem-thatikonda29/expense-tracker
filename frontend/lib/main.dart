import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/dashboard_screen.dart';
import 'screens/transactions/add_transaction_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/transactions/transaction_history_screen.dart';
import 'screens/settings/settings_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _authService.tryAutoLogin(),
        builder: (ctx, authResultSnapshot) {
          if (authResultSnapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (authResultSnapshot.data == true) {
            return DashboardScreen();
          }
          return LoginScreen();
        },
      ),
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        SignupScreen.routeName: (ctx) => SignupScreen(),
        DashboardScreen.routeName: (ctx) => DashboardScreen(),
        AddTransactionScreen.routeName: (ctx) => AddTransactionScreen(),
        TransactionHistoryScreen.routeName: (ctx) => TransactionHistoryScreen(),
        SettingsScreen.routeName: (ctx) => SettingsScreen(),
        OnboardingScreen.routeName: (ctx) => OnboardingScreen(),
      },
    );
  }
}
