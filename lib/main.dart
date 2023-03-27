import 'package:apppps/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_live_51Mov4NKRDfZ6EQWeGHJz03MfhrW5iAV3vDglcWd8RQ8Hw1irhNpIZytGfxIkfwartDYlPMDpaLX0FiuCJxPHQTS100g7gO4TCE";  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}