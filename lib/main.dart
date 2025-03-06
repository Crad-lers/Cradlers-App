import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash_screen.dart';
import 'thank_you_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'device_list_screen.dart';
import 'home_screen.dart';
import 'add_device_screen.dart';
import 'app_settings.dart';
import 'changepasswordscreen.dart';
import 'profile_screen.dart';
import 'language_screen.dart'; // Import LanguagesScreen

void main() {
  runApp(const CradlersApp());
}

class CradlersApp extends StatelessWidget {
  const CradlersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cradlers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/thankyou': (context) => const ThankYouScreen(),
        '/devices': (context) => const DeviceListScreen(),
        '/addDevice': (context) => const AddDeviceScreen(),
        '/settings': (context) => const AppSettingsScreen(),
        '/changePassword': (context) => ChangePasswordScreen(),
        '/language': (context) => LanguagesScreen(),
      },
      onGenerateRoute: (settings) {
        // Handling undefined routes:
        return MaterialPageRoute(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Page Not Found'),
            ),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
      },
    );
  }
}
