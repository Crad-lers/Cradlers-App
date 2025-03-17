import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'screens/DeviceInfoScreen.dart';
import 'screens/AppVersionScreen.dart';

const firebaseWebOptions = FirebaseOptions(
  apiKey: "AIzaSyBvWkdSJk8kwkrs6nT0c9dTBt9_lDnTECg",
  authDomain: "cradlers-69c8b.firebaseapp.com",
  projectId: "cradlers-69c8b",
  storageBucket: "cradlers-69c8b.firebasestorage.app",
  messagingSenderId: "726880339466",
  appId: "1:726880339466:web:f0bdbfdd852e144d6bc1f3",
  measurementId: "G-4Y72VJRG77",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(options: firebaseWebOptions);
  } else {
    await Firebase.initializeApp(); // Uses google-services.json or .plist
  }

  ThemeProvider themeProvider = ThemeProvider(ThemeData.light());
  await themeProvider.loadThemeFromPrefs();

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
