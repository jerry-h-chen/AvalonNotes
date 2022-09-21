import 'package:arrow_path/arrow_path.dart';
import 'package:avalon_notes/avalon_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'math.dart';

class AvalonPainter extends CustomPainter {
  final double radius;
  final Map<AvalonPlayer, Offset> playerToPlayerLocation;

  final AvalonPlayer? activePlayer;
  final Offset? currentDraggingLocation;

  AvalonPainter({
    required this.radius,
    required this.playerToPlayerLocation,
    required this.activePlayer,
    required this.currentDraggingLocation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint();
    linePaint.style = PaintingStyle.stroke;
    linePaint.strokeWidth = 3;

    // Draw connections for accusation arrows
    for (AvalonPlayer player in playerToPlayerLocation.keys) {
      for (AvalonPlayer accusedPlayer in player.accusations) {
        Offset playerLocation = playerToPlayerLocation[player]!;
        Offset accusedPlayerLocation = playerToPlayerLocation[accusedPlayer]!;
        Offset edgeOfAccusedPlayerLocation =
            getLineCircleIntersection(playerLocation, accusedPlayerLocation, radius);
        Path path = Path();
        path.moveTo(playerLocation.dx, playerLocation.dy);
        path.lineTo(edgeOfAccusedPlayerLocation.dx, edgeOfAccusedPlayerLocation.dy);
        canvas.drawPath(ArrowPath.make(path: path), linePaint);
      }
    }

    // Draw players
    for (AvalonPlayer player in playerToPlayerLocation.keys) {
      _drawPlayer(player, canvas);
    }

    // User is dragging the arrow
    if (activePlayer != null && currentDraggingLocation != null) {
      Offset activePlayerLocation = playerToPlayerLocation[activePlayer]!;
      Path path = Path();
      path.moveTo(activePlayerLocation.dx, activePlayerLocation.dy);
      path.lineTo(currentDraggingLocation!.dx, currentDraggingLocation!.dy);
      canvas.drawPath(ArrowPath.make(path: path), linePaint);

      // Redraw active player arrow to draw over arrow
      _drawPlayer(activePlayer!, canvas);
    }
  }

  @override
  bool shouldRepaint(AvalonPainter oldDelegate) {
    Map<int, AvalonPlayer> playerNumberToPlayer =
        playerToPlayerLocation.map((player, value) => MapEntry(player.number, player));
    for (AvalonPlayer oldPlayer in oldDelegate.playerToPlayerLocation.keys) {
      AvalonPlayer? currentPlayer = playerNumberToPlayer[oldPlayer.number];
      // Check if colors are different
      if (currentPlayer?.color != oldPlayer.color) {
        return true;
      }
      if (!listEquals(currentPlayer?.accusations, oldPlayer.accusations)) {
        return true;
      }
      if (currentPlayer?.name != oldPlayer.name) {
        return true;
      }
    }

    bool stoppedOrStartedDragging = activePlayer != oldDelegate.activePlayer;
    bool activeDragPositionChanged =
        activePlayer != null && (currentDraggingLocation != oldDelegate.currentDraggingLocation);
    return stoppedOrStartedDragging || activeDragPositionChanged;
  }

  void _drawPlayer(AvalonPlayer player, Canvas canvas) {
    Paint playerPaint = _getPaintForPlayer(player);
    Paint playerBorderPaint = _getPaintForPlayerBorder(player);

    Offset playerLocation = playerToPlayerLocation[player]!;
    canvas.drawCircle(playerLocation, radius, playerPaint);
    canvas.drawCircle(playerLocation, radius, playerBorderPaint);

    _drawPlayerName(player, canvas);
  }

  void _drawPlayerName(AvalonPlayer player, Canvas canvas) {
    Offset playerLocation = playerToPlayerLocation[player]!;
    TextSpan playerName = TextSpan(
        text: player.displayName, style: const TextStyle(color: Colors.white, fontSize: 20));
    TextPainter playerNamePainter = TextPainter(text: playerName, textDirection: TextDirection.ltr);
    playerNamePainter.layout();
    double widthOffset = playerNamePainter.size.width / 2;
    double heightOffset = playerNamePainter.size.height / 2;
    playerNamePainter.paint(canvas, playerLocation - Offset(widthOffset, heightOffset));
  }

  Paint _getPaintForPlayer(AvalonPlayer player) {
    Paint paint = Paint();
    paint.strokeWidth = 3;
    paint.style = PaintingStyle.fill;
    paint.color = player.color;
    return paint;
  }

  Paint _getPaintForPlayerBorder(AvalonPlayer player) {
    Paint paint = Paint();
    paint.strokeWidth = 3;
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.black87;
    return paint;
  }
}
