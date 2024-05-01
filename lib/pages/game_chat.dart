import 'package:abishek/pages/chat.dart';
import 'package:abishek/pages/second_screen.dart';
import 'package:flutter/material.dart';

class GameChat extends StatelessWidget {
  const GameChat({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'TTT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplitScreenChatApp(),
    );
  }
}

class SplitScreenChatApp extends StatelessWidget {
  const SplitScreenChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 6, // Adjust the flex ratio as needed
            child: TicTacToeGame(),
          ),
          Divider(height: 1.0),
          Flexible(
            flex: 3, // Adjust the flex ratio as needed
            child: ChatScreen(),
          ),
        ],
      ),
    );
  }
}