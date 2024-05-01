import 'package:abishek/manage_socket/socketio_manage.dart';
import 'package:abishek/pages/chat.dart';
// import 'package:abishek/pages/second_screen.dart';
import 'package:flutter/material.dart';

String socUID = '';
String myPlayerxo = 'O';
String currPlayer = 'X';
bool isturn = false;

class AppProvider extends ChangeNotifier {
  late List<List<String>> board;
  Color mainColor = Colors.blue;
  String mainText = "Abishe";
  String nickname = 'Abishek';
  bool twoPlayerReady = false;
  bool noPlayer = false;
  bool isplayerFound = false;
  bool bothReady = false;
  bool isNavigate = true;
  bool isRandomReady = false;
  String currentPlay = 'O';
  String winner = '';
  String summa = '';
  String xNickname = '';
  String oNickname = '';
  int oppoIndex = 0;
  bool isPlaying = true;
  late String gameID = '';
  late BuildContext ticContext;
  late Socketmanager socketmanage;
  int xScore = 0;
  int oScore = 0;
  bool isIncrease = true;
  bool oneTime = false;
  bool isFinish = true;

  final List<ChatMessage> _message = <ChatMessage>[];

  List<ChatMessage> get message => _message;

  Object? get isPlay => twoPlayerReady;

  void changeThemeColor(Color color) {
    mainColor = color;
    notifyListeners();
  }

  void changeText(String str) {
    mainText = str;
    notifyListeners();
  }

  // void randomJoin(String nick) {
  //     nickname=nick;
  // }
  void setSM(Socketmanager s) {
    socketmanage = s;
    notifyListeners();
  }

  void playerJoined() {
    twoPlayerReady = false;
    notifyListeners();
    bothReady = true;
  }

  void playerCreated() {
    twoPlayerReady = true;
    notifyListeners();
  }

  void playerNot() {
    noPlayer = true;
    notifyListeners();
  }

  void playerFound() {
    isplayerFound = true;
    bothReady = true;
    notifyListeners();
  }

  void randomPlayLoad(bool isplay) {
    isRandomReady = isplay;
    notifyListeners();
  }

  void setCurrent(String xo) {
    currPlayer = xo;
    currentPlay = xo;
    notifyListeners();
  }

  void resetBoardPro() {
    board = List.generate(3, (_) => List<String>.filled(3, ''));
    // winner = '';
  }

  void checkWin(List<List<String>> board, String xo, int row, int col) {
    if (board[row][0] == board[row][1] && board[row][1] == board[row][2]) {
      winner = xo;
    } else if (board[0][col] == board[1][col] &&
        board[1][col] == board[2][col]) {
      winner = xo;
    } else if (row == col &&
        board[0][0] == board[1][1] &&
        board[1][1] == board[2][2]) {
      winner = xo;
    } else if (row + col == 2 &&
        board[0][2] == board[1][1] &&
        board[1][1] == board[2][0]) {
      winner = xo;
    }
    if (winner != '' && isIncrease) {
      print(xScore);
      if (xo == 'X') {
        xScore = xScore + 1;
        isIncrease = false;
      } else if (xo == 'O') {
        oScore = oScore + 1;
        isIncrease = false;
      }
      winner = '';
    }
  }

  void changeMove(String xo, int index, bool val) {
    if (!oneTime) {
      int row = index ~/ 3;
      int col = index % 3;
      currPlayer = xo;
      currentPlay = xo;
      oppoIndex = index;
      if (myPlayerxo != xo) {
        board[row][col] = xo;
      }
      isPlaying = val;
      if (winner == '') {
        if (board[row][0] == board[row][1] && board[row][1] == board[row][2]) {
          winner = xo;
        } else if (board[0][col] == board[1][col] &&
            board[1][col] == board[2][col]) {
          winner = xo;
        } else if (row == col &&
            board[0][0] == board[1][1] &&
            board[1][1] == board[2][2]) {
          winner = xo;
        } else if (row + col == 2 &&
            board[0][2] == board[1][1] &&
            board[1][1] == board[2][0]) {
          winner = xo;
        }
      }
      if (winner != '' && isIncrease) {
        sm.isWinPlay(row, col);
        for (var i = 0; i < 3; i++) {
          for (var j = 0; j < 3; j++) {
            board[i][j] = '';
          }
        }
        // ignore: avoid_print
        print(xScore);
        if (xo == 'X') {
          xScore = xScore + 1;
          isIncrease = false;
        } else if (xo == 'O') {
          oScore = oScore + 1;
          isIncrease = false;
        }
        winner = '';
        for (var i = 0; i < 3; i++) {
          for (var j = 0; j < 3; j++) {
            board[i][j] = '';
          }
        }
        isFinish = false;
      }
      if (!isFinish) {
        board[row][col] = '';
        isFinish = true;
      }

      // bool draw=true;
      var i = 0;
      var j = 0;
      for (i = 0; i < 3; i++) {
        for (j = 0; j < 3; j++) {
          if (board[i][j] == '') {
            break;
          }
        }
      }
      if (i == 3 && j == 3) {
        reBoard();
      }
      // ignore: avoid_print
      print('winner $winner');
      oneTime = true;
      notifyListeners();
    }
  }

  void reBoard() {
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        board[i][j] = '';
      }
    }
    notifyListeners();
  }

  void receiveMess(String msg, String uid) {
    if (uid == socUID) {
      ChatMessage message = ChatMessage(
        text: msg,
        isSender: true, 
      );
      _message.insert(0, message);
    } else {
      ChatMessage message = ChatMessage(
        text: msg,
        isSender: false, 
      );
      _message.insert(0, message);
    }
    notifyListeners();
  }
   void clearMessages() {
    _message.clear();
    notifyListeners();
  }
}
