import 'package:abishek/manage_provider/provider_manage.dart';
import 'package:abishek/manage_socket/socketio_manage.dart';
import 'package:abishek/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tic-Tac-Toe',
      home: TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  // context2=context;
  const TicTacToeGame({super.key});
  Future<bool> onWillPop() async {
    // ignore: avoid_print
    print("Back button pressed on mobile");
    // Navigator.of(context).popUntil((route) => route.isFirst);
    sm.ticExit();
    return true;
  }

  @override
  // ignore: library_private_types_in_public_api
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

// ignore: library_private_types_in_public_api
_TicTacToeGameState tic = _TicTacToeGameState();

class _TicTacToeGameState extends State<TicTacToeGame> {
  final tabs=[   
    // Center(child: ,)
  ];
  late List<List<String>> board;
  String currentPlayer = '';
  // String winner = '';
  Socketmanager sm = socketman;
  late bool isPlayed;
  String playID = '';
  bool reload = false;

  @override
  void initState() {
    super.initState();
    try {
      currentPlayer = currPlayer;
      playID = Provider.of<AppProvider>(context, listen: false).gameID;
      if (playID != '') {
        if (currentPlayer == 'X') {
          isPlayed = true;
        } else {
          isPlayed = false;
        }
      } else {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
      resetBoard();
    } catch (e) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sm.setListener(context, board);
    try {
      currentPlayer = currPlayer;
      playID = Provider.of<AppProvider>(context, listen: false).gameID;
      if (playID != '') {
        if (currentPlayer == 'X') {
          isPlayed = true;
        } else {
          isPlayed = false;
        }
      } else {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeGameMove() {
    // ignore: avoid_print
    print('changeGameMove');
  }

  void resetBoard() {
    board = List.generate(3, (_) => List<String>.filled(3, ''));
    // winner = '';
  }

  void oppoMove(int row, int col) {
    if (myPlayerxo !=
            Provider.of<AppProvider>(context, listen: false).currentPlay &&
        !Provider.of<AppProvider>(context, listen: false).isPlaying) {
      setState(() {
        board[row][col] =
            Provider.of<AppProvider>(context, listen: false).currentPlay;
      });
    }
  }

  void makeMove(int row, int col) {
    try {
      if (board[row][col] == '') {
        setState(() {
          board[row][col] = myPlayerxo;
          // checkWinner(row, col);
          int index = row * 3 + col;
          sm.clickindex(index, playID, context);
          
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Widget buildTile(int row, int col) {
    Provider.of<AppProvider>(context).board = board;
    return GestureDetector(
      onTap: () {
        if (Provider.of<AppProvider>(context, listen: false).isPlaying) {
          makeMove(row, col);
        }
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: 
          Consumer<AppProvider>(
                                builder: (context, themeProvider, child) =>
          Text(
            board[row][col],
            style:TextStyle(
              fontSize: 48.0,
              fontWeight: FontWeight.bold, // Make the X/O symbols bold
              color:board[row][col]==myPlayerxo?Colors.blue:Colors.red,
             // Customize the color
            ),
          ),
          ),
        ),
      ),
    );
  }

  Widget buildBoard() {
    List<Row> rows = [];
    for (var i = 0; i < 3; i++) {
      List<Widget> tiles = [];
      for (var j = 0; j < 3; j++) {
        tiles.add(buildTile(i, j));
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: tiles,
      ));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rows,
    );
  }

  
  @override
  Widget build(BuildContext context) {
   
    sm.setListener(context, board);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic-Tac-Toe'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // ignore: avoid_print
            print("Back button pressed on mobile");
            setState(() {
              resetBoard();
            });
            Provider.of<AppProvider>(context,listen:false).xScore=0;
            Provider.of<AppProvider>(context,listen:false).oScore=0;
            // Navigator.pop(context);
            Navigator.of(context).popUntil((route) => route.isFirst);
            sm.ticExit();
            // This pops the current page and returns to the previous page.
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SafeArea(
                top: true,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                               const SizedBox(height: 2.0),
                              Consumer<AppProvider>(
                                builder: (context, themeProvider, child) =>
                                    Text(
                                  myPlayerxo == 'O'
                                      ? themeProvider.oNickname
                                      : themeProvider.xNickname,
                                ),
                              ),
                              Consumer<AppProvider>(
                                builder: (context, themeProvider, child) =>
                                    Text(
                                  myPlayerxo == 'O'
                                      ? themeProvider.oScore.toString()
                                      : themeProvider.xScore.toString(),
                                
                              ),
                              ),
                              const SizedBox(height: 2.0),
                              Consumer<AppProvider>(
                                builder: (context, themeProvider, child) =>
                              Container(
                                width: double.infinity,
                                height: 5,
                                color:isturn==true?Colors.blue:themeProvider.currentPlay != myPlayerxo ? Colors.blue:Colors.white,
                              
                              ),),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const SizedBox(height: 2.0),
                              Consumer<AppProvider>(
                                builder: (context, themeProvider, child) =>
                                    Text(
                                  myPlayerxo == 'O'
                                      ? themeProvider.xNickname
                                      : themeProvider.oNickname,
                                  
                                ),
                              ),
                              Consumer<AppProvider>(
                                builder: (context, themeProvider, child) =>
                                    Text(
                                  myPlayerxo == 'O'
                                      ? themeProvider.xScore.toString()
                                      : themeProvider.oScore.toString(),
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Consumer<AppProvider>(
                                builder: (context, themeProvider, child) =>                           
                              Container(
                                width: double.infinity,
                                height: 5,
                                color:isturn==true?Colors.white:themeProvider.currentPlay == myPlayerxo ? Colors.red:Colors.white,
                      
                              ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

const SizedBox(height: 5.0),
              buildBoard(),

   
            ],
          ),
        ),
      ),
    );
  }
}

void listenOppo(BuildContext context) {
  // sm.setListener(context,);
  // _soc.onConnect((data) => null);
// _soc.on('emait',()=>{});
  // sm._socket.onConnect((data) => null);
}

// class TabbedApp extends StatefulWidget {
//   const TabbedApp({super.key});

//   @override
//   _TabbedAppState createState() => _TabbedAppState();
// }

// class _TabbedAppState extends State<TabbedApp> {
//   int _selectedIndex = 0; // Current selected tab index
//   final List<Widget> _tabs = [
//   ];

//   void _onTabTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tabbed App'),
//       ),
//       body: _tabs[_selectedIndex], // Display the selected tab content
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Tab 1',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.business),
//             label: 'Tab 2',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.school),
//             label: 'Tab 3',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onTabTapped, // Called when a tab is tapped
//       ),
//     );
//   }
// }
