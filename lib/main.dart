import 'package:flutter/material.dart';

import 'cal.dart';
// import 'package:flutter_ios_calculator/flutter_ios_calculator.dart';

void main() => runApp(const CalculatorTestApp());

class CalculatorTestApp extends StatelessWidget {
  const CalculatorTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "Calculator Test",
        debugShowCheckedModeBanner: false,
        home: Calculator());
  }
}
