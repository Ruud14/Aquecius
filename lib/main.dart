import 'package:flutter/material.dart';
import 'package:showerthing/screens/account.dart';
import 'package:showerthing/screens/home.dart';
import 'package:showerthing/screens/login.dart';
import 'package:showerthing/screens/splash.dart';
import 'package:showerthing/services/supabase_general.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupaBaseService.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shower Thing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/account': (_) => const AccountScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}
