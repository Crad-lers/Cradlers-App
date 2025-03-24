import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/thank_you_screen.dart';
import 'screens/device_list_screen.dart';
import 'screens/add_device_screen.dart';
import 'screens/app_settings.dart';
import 'screens/changepasswordscreen.dart';
import 'screens/profile_screen.dart';
import 'screens/language_screen.dart';
import 'screens/appearance_screen.dart';
import 'screens/DeviceInfoScreen.dart';
import 'screens/AppVersionScreen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully.");
  } catch (e) {
    print("Firebase initialization failed: $e");
    return; // If Firebase fails to initialize, do not proceed.
  }

  // Load theme preferences
  ThemeProvider themeProvider = ThemeProvider(ThemeData.light());
  try {
    await themeProvider.loadThemeFromPrefs();
    print("Theme loaded successfully.");
  } catch (e) {
    print("Failed to load theme: $e");
  }

  runApp(MyApp(themeProvider: themeProvider));
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const MyApp({Key? key, required this.themeProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) => themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return MaterialApp(
            title: 'Cradlers',
            theme: theme.themeData,
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/': (context) => SplashScreen(),
              '/login': (context) => SignInScreen(),
              '/signup': (context) => SignUpScreen(),
              '/home': (context) => HomeScreen(),
              '/thankyou': (context) => ThankYouScreen(),
              '/devices': (context) => DeviceListScreen(),
              '/addDevice': (context) => AddDeviceScreen(),
              '/settings': (context) => AppSettingsScreen(),
              '/changePassword': (context) => ChangePasswordScreen(),
              '/language': (context) => LanguagesScreen(),
              '/appearance': (context) => AppearanceScreen(),
              '/profile': (context) => ProfileScreen(),
              '/deviceInfo': (context) => DeviceInfoScreen(),
              '/appversion': (context) => AppVersionScreen(),
            },
          );
        },
      ),
    );
  }
}
