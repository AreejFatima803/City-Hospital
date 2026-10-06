import 'package:flutter/material.dart';
import 'api.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

const kRed = Color(0xFFC62828);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Api.load();
  runApp(const CityHospitalApp());
}

class CityHospitalApp extends StatelessWidget {
  const CityHospitalApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'City Hospital',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: kRed, primary: kRed),
          scaffoldBackgroundColor: const Color(0xFFFFF5F5),
          appBarTheme: const AppBarTheme(backgroundColor: kRed, foregroundColor: Colors.white, centerTitle: true),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kRed, foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true, fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        home: Api.token != null ? const HomeScreen() : const LoginScreen(),
      );
}
