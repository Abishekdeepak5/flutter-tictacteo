import 'package:abishek/manage_provider/provider_manage.dart';
import 'package:abishek/pages/create_join.dart';
import 'package:abishek/pages/game_chat.dart';
import 'package:abishek/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScaffold(),
        '/second': (context) => const CreateJoin(),
        '/third': (context) => const GameChat(),
      },
    );
  }
}
