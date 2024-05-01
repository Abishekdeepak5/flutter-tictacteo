// import 'package:abishek/manage_provider/provider_manage.dart';
import 'package:abishek/manage_provider/provider_manage.dart';
import 'package:abishek/manage_socket/socketio_manage.dart';
import 'package:abishek/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State createState() => ChatScreenState();
}

// List<ChatMessage> _messages = <ChatMessage>[];

class ChatScreenState extends State<ChatScreen> {
  
  @override
  void initState(){
    super.initState();
    // Provider.of<AppProvider>(context,listen:false)._message=_messages;
  }
  Socketmanager sm = socketman;
  final TextEditingController _textController = TextEditingController();
  void _handleSubmitted(String text) {
    _textController.clear();
    // ChatMessage message = ChatMessage(
    //   text: text,
    //   isSender: true, // Change this to false for received messages
    // );
    sm.sendMessage(text);
    // setState(() {
    //   _messages.insert(0, message);
    // });
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: const IconThemeData(color: Colors.blue),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            child:
            Consumer<AppProvider>(
                builder: (context, themeProvider, child) =>
            ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: themeProvider.message.length,
              itemBuilder: (_, int index) => themeProvider.message[index],
            ),
            ),
          ),
          const Divider(height: 1.0),
          _buildTextComposer(),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isSender;

  ChatMessage({required this.text, required this.isSender});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print('!');
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // if (!isSender) const CircleAvatar(child: Text("A")), // Replace with user avatars
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: isSender ? Colors.blue : Colors.grey[300],
                borderRadius: isSender
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
              ),
              child: Text(
                text,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
