import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/multa_provider.dart';
import 'screens/home_screen.dart';
import 'screens/acerca_de_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MultaProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Multas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: HomeScreen(),
      routes: {
        '/acerca-de': (context) => AcercaDeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}