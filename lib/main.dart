import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'avalon_board.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Avalon notes',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const AvalonPlayers());
  }
}

class AvalonPlayers extends StatefulWidget {
  const AvalonPlayers({super.key});

  @override
  State<AvalonPlayers> createState() => _AvalonPlayersState();
}

class _AvalonPlayersState extends State<AvalonPlayers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Avalon notes"),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints boxConstraints) {
          // TODO: move this into avalon_board
          // Value (214) is calculated from the menu space.
          final double canvasHeight = boxConstraints.maxHeight - 214;
          return Column(
            children: [
              AvalonBoard(boardWidth: boxConstraints.maxWidth, boardHeight: canvasHeight),
            ],
          );
        },
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
