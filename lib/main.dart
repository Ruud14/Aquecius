import 'package:Aquecius/screens/leaderboard.dart';
import 'package:Aquecius/screens/statistics.dart';
import 'package:Aquecius/screens/summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Aquecius/screens/account.dart';
import 'package:Aquecius/screens/home.dart';
import 'package:Aquecius/screens/login.dart';
import 'package:Aquecius/screens/splash.dart';
import 'package:Aquecius/services/supabase_general.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupaBaseService.setup();
  // Change system buttons background color.
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(systemNavigationBarColor: Color(0xFFB5CDC2)));
  // Force portrait mode.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Shower Thing',
          theme: ThemeData(
            fontFamily: 'Lato',
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            }),
            colorScheme: const ColorScheme(
              background: Color(0xFFB5CDC2),
              brightness: Brightness.light,
              error: Colors.red,
              onBackground: Color(0xFFB5CDC2),
              onError: Colors.red,
              onPrimary: Color(0xFF3A84B6),
              onSecondary: Color(0xFF475080),
              onSurface: Color(0xFFB5CDC2),
              primary: Color(0xFF3A84B6),
              secondary: Color(0xFF475080),
              surface: Color(0xFFB5CDC2),
            ),
          ),
          initialRoute: '/',
          routes: <String, WidgetBuilder>{
            '/': (_) => const SplashScreen(),
            '/login': (_) => const LoginScreen(),
            '/account': (_) => const AccountScreen(),
            '/home': (_) => const HomeScreen(),
            '/summary': (_) => const SummaryScreen(),
            '/statistics': (_) => const StatisticsScreen(),
            '/leaderboard': (_) => const LeaderBoardScreen(),
          },
        );
      },
    );
  }
}
