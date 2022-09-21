import 'package:flutter/material.dart';

/// An Avalon player, represented as a circle on the board.
class AvalonPlayer {
  int number;
  String name;
  Color color = Colors.lightBlueAccent;
  List<AvalonPlayer> accusations = [];

  AvalonPlayer(this.number, this.name);

  AvalonPlayer shallowCopy() {
    AvalonPlayer newPlayer = AvalonPlayer(number, name);
    newPlayer.color = color;
    newPlayer.accusations = accusations.toList();
    return newPlayer;
  }

  String get displayName => name.isNotEmpty ? name : "P$number";

  @override
  bool operator ==(Object other) {
    return other is AvalonPlayer && number == other.number;
  }

  @override
  int get hashCode => number;
}
