import 'package:abishek/manage_provider/provider_manage.dart';
import 'package:abishek/manage_socket/socketio_manage.dart';
import 'package:abishek/pages/create_join.dart';
// import 'package:abishek/pages/create_join.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

export 'main_page.dart';

late Socketmanager socketman;

class MainScaffold extends StatefulWidget {
  // const MainScaffold({super.key});
  const MainScaffold({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}
bool isBtn=true;
class _MyAppState extends State<MainScaffold> {
  late Socketmanager sm;
  bool isConnect = true;

  @override
  void initState() {
    sm = Socketmanager();
    socketman = sm;
    fetchData(sm);
    super.initState();
    context1 = context;
    sm.initalState();
  }
//  void onReturnToPage() {
// //  print('Function called when returning to the page');
// }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    fetchData(sm);
    socketman = sm;
    context1 = context;
    isConnect = sm.connectNeed;
    if (isConnect) {
      sm.initalState();
      isConnect = false;
      sm.connectNeed = false;
    }
    // sm.initalState();
    //   super.didChangeDependencies();
  }

  // final
  // const MainScaffold({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    // context1=context;
    void randomRoom() {
      context1 = context;
      String text = textEditingController.text
          .trim(); // Trim any leading/trailing whitespace
      if (text.isNotEmpty && isBtn) {
        isBtn=false;
        context1 = context;
        sm.randomjoining(text);
        Provider.of<AppProvider>(context, listen: false).randomPlayLoad(true);
      }
    }

    // ignore: non_constant_identifier_names
    void NavigateCreate() {
      context1 = context;
      String text = textEditingController.text
          .trim(); // Trim any leading/trailing whitespace
      if (text.isNotEmpty) {
        sm.setNickname(text);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateJoin()),
        );
        //  Navigator.pushNamed(context, '/second');
      }
      // Provider.of<AppProvider>(context, listen: false).changeText(str);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Abishek'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.colorize),
        //     // onPressed: () => _showColorPicker(context),
        //     onPressed: () => {},
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextFormField(
              controller: textEditingController,
            ),

            Consumer<AppProvider>(
              builder: (context, appProvider, child) => Center(
                // isLoading: Provider.of<AppProvider>(context,listen:false).twoPlayerReady,('Waiting for opponent...')
                child: appProvider.isRandomReady == true
                    ? const CircularProgressIndicator()
                    : const Text(''),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                randomRoom();
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
                    "Random Join",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => NavigateCreate(),
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
                    "Create / Join Room",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),

            // ignore: avoid_print
            // ElevatedButton(
            //   onPressed: () {
            //     print(Provider.of<AppProvider>(context, listen: false).isPlay);
            //     // ignore: avoid_print
            //     print(Provider.of<AppProvider>(context, listen: false)
            //         .isRandomReady);
            //   },
            //   child: const Text('click'),
            // )
          ],
        ),
      ),
    );
  }
}
