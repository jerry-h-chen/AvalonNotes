import 'package:avalon_notes/avalon_player.dart';
import 'package:flutter/material.dart';
import 'package:quiver/collection.dart';

import 'avalon_painter.dart';
import 'math.dart';
import 'player_locations.dart';

const double radius = 30;

class AvalonBoard extends StatefulWidget {
  final double boardWidth;
  final double boardHeight;

  const AvalonBoard({super.key, required this.boardWidth, required this.boardHeight});

  @override
  State<AvalonBoard> createState() => _AvalonBoardState();
}

class _AvalonBoardState extends State<AvalonBoard> {
  final Map<Color, Color> colorCycleMap = {
    Colors.lightBlueAccent: Colors.purpleAccent,
    Colors.purpleAccent: Colors.red,
    Colors.red: Colors.lightGreen,
    Colors.lightGreen: Colors.lightBlueAccent,
  };

  final List<AvalonPlayer> players = [for (int i = 1; i < 7; i++) AvalonPlayer(i, "")];

  AvalonPlayer? activePlayer;
  Offset? currentDraggingLocation;
  BiMap<Offset, AvalonPlayer> playerLocationToPlayer = BiMap();

  @override
  Widget build(BuildContext context) {
    _assignPlayerLocations();
    List<Offset> playerLocations = playerLocationToPlayer.keys.toList();
    return Column(children: [
      Container(
        padding: EdgeInsets.only(top: 50, left: 10, right: 10),
        child: GestureDetector(
          onTapUp: (details) => setState(() => _handlePossiblePlayerTap(details)),
          onPanStart: (details) {
            final Offset currentLocation = details.localPosition;
            final Offset? tappedCircleCenter =
                getCircleCenterForCircleAtLocation(currentLocation, playerLocations, radius);
            activePlayer = playerLocationToPlayer[tappedCircleCenter];
          },
          onPanUpdate: (details) => setState(() {
            final Offset currentLocation = details.localPosition;
            currentDraggingLocation = currentLocation;
          }),
          onPanEnd: (details) => setState(() {
            AvalonPlayer? targetPlayer = _getPlayerAtLocation(currentDraggingLocation!, 3);
            if (activePlayer != null &&
                targetPlayer != null &&
                !activePlayer!.accusations.contains(targetPlayer)) {
              activePlayer!.accusations.add(targetPlayer);
            }
            activePlayer = null;
            currentDraggingLocation = null;
          }),
          onLongPressStart: (details) {
            final Offset currentLocation = details.localPosition;
            final Offset? tappedCircleCenter =
                getCircleCenterForCircleAtLocation(currentLocation, playerLocations, radius);
            if (tappedCircleCenter == null) {
              return;
            }
            _handlePlayerDialog(playerLocationToPlayer[tappedCircleCenter]!);
          },
          child: CustomPaint(
            // The shallow copies are a hacky way to create one-use copies of the players before
            // passing them to the painter. This allows us to correctly use shouldRepaint().
            painter: AvalonPainter(
              radius: radius,
              playerToPlayerLocation: playerLocationToPlayer.inverse
                  .map((player, location) => MapEntry(player.shallowCopy(), location)),
              activePlayer: activePlayer?.shallowCopy(),
              currentDraggingLocation: currentDraggingLocation,
            ),
            size: Size(widget.boardWidth - 20, widget.boardHeight),
          ),
        ),
      ),
      // Reset and add/remove player buttons
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              defaultButton(
                "Reset",
                onPressed: () {
                  setState(() {
                    _resetBoard();
                  });
                },
              ),
              defaultButton("Add Player", onPressed: _addPlayer),
              defaultButton("Remove Player", onPressed: _removePlayer),
            ],
          ),
        ),
      ])
    ]);
  }

  void _handlePossiblePlayerTap(TapUpDetails details) {
    List<Offset> centers = playerLocationToPlayer.keys.toList();
    final Offset tapLocation = details.localPosition;
    Offset? tappedCircleCenter = getCircleCenterForCircleAtLocation(tapLocation, centers, radius);
    if (tappedCircleCenter == null) {
      return;
    }
    Feedback.forTap(context);
    AvalonPlayer tappedPlayer = playerLocationToPlayer[tappedCircleCenter]!;
    tappedPlayer.color = colorCycleMap[tappedPlayer.color]!;
  }

  void _handlePlayerDialog(AvalonPlayer player) {
    Feedback.forLongPress(context);
    TextEditingController nameEditingController = TextEditingController(text: player.name);
    nameEditingController.addListener(() {
      setState(() {
        player.name = nameEditingController.text;
      });
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Widget nameEditor = TextField(
          controller: nameEditingController,
          decoration: const InputDecoration(icon: Icon(Icons.person), labelText: "Name"),
          maxLength: 2,
          textCapitalization: TextCapitalization.characters,
        );
        return SimpleDialog(
          clipBehavior: Clip.hardEdge,
          contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
          children: [
            nameEditor,
            ..._getAccusedPlayerWidgets(player.accusations),
          ],
        );
      },
    );
  }

  void _assignPlayerLocations() {
    playerLocationToPlayer = BiMap();
    late final List<Offset> playerLocations;
    switch (players.length) {
      case 6:
        playerLocations = setSixPlayerConfig(widget.boardWidth - 20, widget.boardHeight, radius);
        break;
      case 7:
        playerLocations = setSevenPlayerConfig(widget.boardWidth - 20, widget.boardHeight, radius);
        break;
      case 8:
        playerLocations = setEightPlayerConfig(widget.boardWidth - 20, widget.boardHeight, radius);
        break;
      case 9:
        playerLocations = setNinePlayerConfig(widget.boardWidth - 20, widget.boardHeight, radius);
        break;
      case 10:
        playerLocations = setTenPlayerConfig(widget.boardWidth - 20, widget.boardHeight, radius);
        break;
      default:
        playerLocations = setTenPlayerConfig(widget.boardWidth - 20, widget.boardHeight, radius);
        break;
    }
    for (int i = 0; i < playerLocations.length; i++) {
      Offset playerLocation = playerLocations[i];
      playerLocationToPlayer[playerLocation] = players[i];
    }
  }

  AvalonPlayer? _getPlayerAtLocation(Offset location, double slack) {
    List<Offset> playerLocations = playerLocationToPlayer.keys.toList();
    Offset? circleCenter =
        getCircleCenterForCircleAtLocation(location, playerLocations, radius, slack);
    return circleCenter == null ? null : playerLocationToPlayer[circleCenter];
  }

  List<Widget> _getAccusedPlayerWidgets(List<AvalonPlayer> accusations) {
    accusations.sort((p1, p2) => p1.displayName.compareTo(p2.displayName));
    return accusations.map(
      (accusation) {
        return Container(
          padding: const EdgeInsets.only(bottom: 1),
          child: Dismissible(
            key: ValueKey<int>(accusation.number),
            background: Container(
              color: Colors.grey,
            ),
            child: ListTile(
              title: Text(
                accusation.displayName,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              tileColor: accusation.color,
            ),
            onDismissed: (DismissDirection unused) {
              setState(() {
                accusations.remove(accusation);
              });
            },
          ),
        );
      },
    ).toList();
  }

  void _resetBoard() {
    activePlayer = null;
    currentDraggingLocation = null;
    for (AvalonPlayer player in players) {
      player.accusations.clear();
      player.color = Colors.lightBlueAccent;
      player.name = "";
    }
  }

  void _addPlayer() {
    if (players.length == 10) {
      return;
    }
    setState(() {
      players.add(AvalonPlayer(players.length + 1, ""));
    });
  }

  void _removePlayer() {
    if (players.length == 6) {
      return;
    }
    setState(() {
      AvalonPlayer removedPlayer = players.removeLast();
      for (AvalonPlayer player in players) {
        player.accusations.remove(removedPlayer);
      }
    });
  }
}

ElevatedButton defaultButton(String text, {required Function()? onPressed}) {
  return ElevatedButton(
    //style: ElevatedButton.styleFrom(fixedSize: const Size.fromWidth(150)),
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        height: 1.18,
      ),
    ),
  );
}
