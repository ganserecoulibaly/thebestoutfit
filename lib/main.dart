import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thebestoutfit/connexion/account.dart';
import 'package:thebestoutfit/connexion/login_page.dart';
import 'package:thebestoutfit/connexion/splash_screen.dart';

Future<void> main() async {
  await Supabase.initialize(
    // TODO: Replace credentials with your own
    url: 'https://vfiqdedvhxxczafkkpwm.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZmaXFkZWR2aHh4Y3phZmtrcHdtIiwicm9sZSI6ImFub24iLCJpYXQiOjE2Nzg3NDU1NzcsImV4cCI6MTk5NDMyMTU3N30.6VJsk-8n_wZBBeYZjfH3YuzhNKM6SCcCqNugwcLD48Y',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Best Outfit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            //foregroundColor: Colors.white,
            //backgroundColor: Colors.green,
          ),
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/account': (_) => const AccountPage(),
      },
    );
  }
}