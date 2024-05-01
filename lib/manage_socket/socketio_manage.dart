import 'package:abishek/manage_provider/provider_manage.dart';
import 'package:abishek/pages/create_join.dart';
import 'package:abishek/pages/main_page.dart';
// import 'package:abishek/pages/second_screen.dart';
// import 'package:abishek/pages/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

late BuildContext context1;
late BuildContext context2;
// late IO.Socket _soc;
AppProvider appPro = AppProvider();

class Socketmanager {
  bool connectNeed = false;
  String nickname = 'Abishek';
  int roomId = 1234;
  late IO.Socket _socket;
  late String ticID;
  String socketUID='';

  // static IO.Socket so;
  // final TextEditingController _messageController=TextEditingController();

  //  _sendData(){
  //   _socket.emit('message',{
  //     'message':'Hello'
  //   });
  // }

  _conectSocket() {
    // ignore: avoid_print
    _socket.onConnect((data) => print('Connect'));
    // ignore: avoid_print
    _socket.onConnectError((data) => print('not connect'));

    _socket.on('created', (data) {
      Map<String, dynamic> jsonData = data;
      String gameid = jsonData['gameID'];
      socketUID=jsonData['socketUID'];
      socUID=socketUID;
      Provider.of<AppProvider>(context1, listen: false).gameID = gameid;
      isPlayerready = true;
      // currPlayer='X';
      Provider.of<AppProvider>(context1, listen: false).isPlaying = true;
      myPlayerxo = 'X';
      isturn = true;
    });
    _socket.on('PlayerJoined', (data) {
      isPlayerready = false;
      appPro.playerJoined();
      changebuild();
    });

    _socket.on('exitBoth', (data) {
      // connectNeed=true;
      // _socket.close();
      Navigator.of(context1).popUntil((route) => route.isFirst);
      Provider.of<AppProvider>(context1, listen: false).xScore = 0;
      Provider.of<AppProvider>(context1, listen: false).oScore = 0;
      Provider.of<AppProvider>(context1, listen: false).clearMessages();
      isBtn = true;
      // onReturnToPage();
    });

    _socket.on('joinFound', (data) {
      Map<String, dynamic> jsonData = data;
      ticID = jsonData['ticID'];
      Provider.of<AppProvider>(context1, listen: false).gameID = ticID;

      var xPlayer = jsonData['xPlayer'];
      Provider.of<AppProvider>(context1, listen: false).xNickname = xPlayer;

      var oPlayer = jsonData['oPlayer'];
      Provider.of<AppProvider>(context1, listen: false).oNickname = oPlayer;

      Navigator.pushNamed(context1, '/third');
      Provider.of<AppProvider>(context1, listen: false).playerFound();
    });
    _socket.on('joinNotFound', (data) {
      Provider.of<AppProvider>(context1, listen: false).playerNot();
    });
    _socket.on('randomplayerJoined', (data) {
      Provider.of<AppProvider>(context1, listen: false).randomPlayLoad(false);
    });
    _socket.on('joinTic', (data) {
       Map<String, dynamic> jsonData = data;
      socketUID = jsonData['socketUID'];
      socUID=socketUID;
      Provider.of<AppProvider>(context1, listen: false).setCurrent('O');
      Provider.of<AppProvider>(context1, listen: false).isPlaying = false;
      myPlayerxo = 'O';
      isturn = false;
    });

    //  _socket.emit('winPlayer', {'win1':r,'win2':c});
    _socket.on('winPlaying', (data) {
      // Map<String, dynamic> jsonData = data;
      // int row = jsonData['win1'];
      Provider.of<AppProvider>(context1, listen: false).reBoard();
    });
    //changevarum
    _socket.on('receiveMessage',(data){
      Map<String, dynamic> jsonData = data;
      String recMess = jsonData['receiveMessage'];
      String recUID = jsonData['socketUID'];
      print('$recMess $recUID');
      Provider.of<AppProvider>(context1, listen: false).receiveMess(recMess,recUID);
      
    });
  }

  void changebuild() {
    Provider.of<AppProvider>(context1, listen: false).playerJoined();
  }

  void initalState() {
    // _socket = IO.io(
    //     'http://127.0.0.1:3000',
    //     IO.OptionBuilder().setTransports(['websocket']).setQuery(
    //         {'name': "Abishek"}).build());

 
    _socket = IO.io(
        'https://abishek.onrender.com/',
        IO.OptionBuilder().setTransports(['websocket']).setQuery(
            {'name': "Abishek"}).build());
    

//      _socket = IO.io('http://127.0.0.1:3000', <String, dynamic>{
//   'transports': ['websocket'],
//   'autoConnect': false,
// });
    _conectSocket();
    // print('inital state');
    // _soc=_socket;
    // _sendData();
  }

  void randomjoining(String name) {
    nickname = name;
    _socket.emit('joinRandom', {'nickname': name});
  }

  void setNickname(String str) {
    nickname = str;
  }

  void setListener(BuildContext con, List<List<String>> b) {
    // Provider.of<AppProvider>(con, listen: false).board=b;

    _socket.on('opponentClick', (data) {
      Map<String, dynamic> jsonData = data;
      int clickind = jsonData['clickIndex'];
      String playerTic = jsonData['player'];
      Provider.of<AppProvider>(context1, listen: false).winner = '';
      Provider.of<AppProvider>(context1, listen: false).isIncrease = true;
      if (myPlayerxo == playerTic) {
        Provider.of<AppProvider>(context1, listen: false)
            .changeMove(playerTic, clickind, false);
      } else {
        Provider.of<AppProvider>(context1, listen: false).oneTime = false;
        Provider.of<AppProvider>(context1, listen: false)
            .changeMove(playerTic, clickind, true);
      }
    });
  }

  void createGame(int id) {
    roomId = id;
    _socket.emit('createRoom', {
      'nickname': nickname,
      'gameID': id,
    });
    Provider.of<AppProvider>(context1, listen: false).setCurrent('X');
    Provider.of<AppProvider>(context1, listen: false).isPlaying = true;
  }

  void joinGame(int id) {
    roomId = id;
    _socket.emit('joinRoom', {
      'nickname': nickname,
      'roomid': id,
    });
  }

  void disConnect() {
    // _socket.disconnect(); // Disconnect the socket when the widget is disposed.
    // initalState();
    _socket.emit('removedb', {});
  }

  void ticExit() {
    _socket.emit('ticExit', {'Ticid': ticID});
    isBtn = true;
    // Provider.of<AppProvider>(context1, listen: false).message=Null;
    // Provider.of<AppProvider>(context1, listen: false)._message=[];
  }

  void clickindex(int clickedIndex, String room, BuildContext con) {
    isturn = false;
    Provider.of<AppProvider>(con, listen: false).isPlaying = false;
    Provider.of<AppProvider>(con, listen: false).oneTime = false;

    // Provider.of<AppProvider>(context1, listen: false).winner='';
    // Provider.of<AppProvider>(context1, listen: false).isIncrease=true;
    _socket.emit('clickIndex', {'clickIndex': clickedIndex, 'roomid': room});
  }

  void setContext(BuildContext con) {
    context2 = con;
  }

  void isWinPlay(int r, int c) {
    // print('win Emit');
    _socket.emit('winPlayer', {'win1': r, 'win2': c, 'ticID': ticID});
  }
  void sendMessage(String str){//changevarum
    _socket.emit('sendmessage', {'sendmessage': str, 'roomid': ticID});
  }
}

late Socketmanager sm;
Future<void> fetchData(Socketmanager s) async {
  sm = s;
}
