import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/expense_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // ✅ Ensure Firebase is initialized

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseProvider()), // ✅ ExpenseProvider loads after Firebase
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Budget Tracker',
          theme: themeProvider.themeData, // ✅ Theme updates dynamically
          home: const HomeScreen(),
        );
      },
    );
  }
}
