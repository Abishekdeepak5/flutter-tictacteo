import 'package:abishek/manage_provider/provider_manage.dart';
import 'package:abishek/manage_socket/socketio_manage.dart';
import 'package:abishek/pages/main_page.dart';
// import 'package:abishek/pages/second_screen.dart';
// import 'package:abishek/pages/second_screen.dart';
// import 'package:abishek/pages/second_screen.dart';
import 'package:flutter/material.dart';
// import 'package:loadingkit_flutter/loadingkit_flutter.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
// import 'package:abishek/main_page.dart';

bool isPlayerready = false;

class CreateJoin extends StatefulWidget {
  const CreateJoin({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyGame createState() => _MyGame();
}

class _MyGame extends State<CreateJoin> {
  late Socketmanager sm = socketman;
  @override
  void initState() {
    // sm = Socketmanager();
    // context1=context;
    super.initState();
  }

  bool isLoading = false;

  void startLoading() {
    setState(() {
      isLoading = true;
    });

    // Simulate a time-consuming operation
    // Future.delayed(const Duration(seconds: 3), () {
    //   setState(() {
    //     isLoading = false;
    //   });
    // });
  }

  // final TextEditingController _textEditingController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    context1 = context;

    final TextEditingController textController = TextEditingController();
    void createRoom() {
      String text =
          textController.text.trim(); // Trim any leading/trailing whitespace
      if (text.isNotEmpty) {
        context1 = context;

        sm.createGame(int.parse(text));
        // Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => const TicTacToeApp()),
        //       );
        // Provider.of<AppProvider>(context, listen: false).changeText(str);
        // print(text);
        // print("Create");
      }
    }

    void joinRoom() {
      String text =
          textController.text.trim(); // Trim any leading/trailing whitespace
      if (text.isNotEmpty) {
        context1 = context;

        sm.joinGame(int.parse(text));
        // Provider.of<AppProvider>(context, listen: false).changeText(str);
        // print(text);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AK'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // ignore: avoid_print
            // print('Back arrow pressed on the Second Page.');
            sm.disConnect();
            Navigator.pop(
                context); 
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: textController,
              keyboardType: TextInputType.number,
            ),

            Consumer<AppProvider>(
              builder: (context, appProvider, child) => Center(
               child: appProvider.twoPlayerReady == true
                    ? const CircularProgressIndicator()
                    : const Text(''),
              ),
            ),

            Consumer<AppProvider>(
              builder: (context, appProvider, child) => Center(
                child: appProvider.noPlayer == false
                    ? const Text('')
                    : appProvider.isplayerFound == true
                        ? const Text('')
                        : const Text('Room id not Found'),
              ),
            ),

            // Consumer<AppProvider>(
            //   builder: (context, appProvider, child){
            //     appProvider.bothReady==true?const Text(''):const Text('');
            //   }
            // ),

            //   Center(
            // child: isPlayerready
            //     ? const CircularProgressIndicator() // Show loader while loading
            //     : const Text(''),),

            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () {
                createRoom();
                // startLoading();
                Provider.of<AppProvider>(context, listen: false)
                    .playerCreated();
                // context1=context;
                //   Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const TicTacToeGame()),
                // );
              },
              // onPressed: () {
              // },
              child: Ink(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0)),
                child: Container(
                  constraints:
                      const BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                  alignment: Alignment.center,
                  child: const Text(
                    "Create",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),

            ElevatedButton(
              onPressed: () {
                joinRoom();
              },
              child: Ink(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0)),
                child: Container(
                  constraints:
                      const BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                  alignment: Alignment.center,
                  child: const Text(
                    "Join Room",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),

            // ignore: avoid_print
            
            // ElevatedButton(
            //   onPressed: () {
            //     print(Provider.of<AppProvider>(context, listen: false)
            //         .twoPlayerReady);
            //   },
            //   child: const Text('Click'),
            // ),



            // Consumer<AppProvider>(
            //   builder: (context, themeProvider, child) => Text(themeProvider.mainText),
            //   ),

            //   Consumer<AppProvider>(
            // builder: (context, dataProvider, _) {
            //   // Check if the value in the provider has changed
            //   if (dataProvider.twoPlayerReady) {
            //     // If it has changed, navigate to another page
            //     Future.delayed(Duration.zero, () {
            //       Navigator.of(context).push(
            //         MaterialPageRoute(
            //           builder: (context) =>TicTacToeApp(),
            //         ),
            //       );
            //     });

            //   }
            //   }
            //   )
          ],
        ),
      ),
    );
  }
}




// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Consumer<DataProvider>(
//         builder: (context, dataProvider, _) {
//           // Check if the value in the provider has changed
//           if (dataProvider.valueChanged) {
//             // If it has changed, navigate to another page
//             Future.delayed(Duration.zero, () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => SecondPage(),
//                 ),
//               );
//             });
//           }

//           return MyHomePage();
//         },
//       ),
//     );
//   }
// }
