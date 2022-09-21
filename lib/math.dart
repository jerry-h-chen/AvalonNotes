import 'dart:math';

import 'package:flutter/material.dart';

double _distanceSquared(Offset offset1, Offset offset2) {
  return pow(offset2.dx - offset1.dx, 2) + pow(offset2.dy - offset1.dy, 2).toDouble();
}

Offset? getCircleCenterForCircleAtLocation(Offset location, List<Offset> centers, double radius,
    [double slack = 2]) {
  double squaredCircleTapRadius = (radius + slack) * (radius * slack);
  for (Offset center in centers) {
    final double squaredDistanceToCircle = _distanceSquared(location, center);
    if (squaredDistanceToCircle <= squaredCircleTapRadius) {
      return center;
    }
  }
  return null;
}

Offset getLineCircleIntersection(Offset point, Offset circleCenter, double radius) {
  double dx = point.dx - circleCenter.dx, dy = point.dy - circleCenter.dy;
  double dr = sqrt(_distanceSquared(point, circleCenter));
  double discriminant = pow(radius, 2) * pow(dr, 2).toDouble();

  List<int> signs = dy < 0 ? [1, -1] : [-1, 1];
  int dySign = dy < 0 ? -1 : 1;
  List<List<double>> intersects = signs.map((sign) {
    double xCoordinate = circleCenter.dx + ((sign * dySign) * dx * sqrt(discriminant) / pow(dr, 2));
    double yCoordinate = circleCenter.dy + (sign * dy.abs() * sqrt(discriminant) / pow(dr, 2));
    return [xCoordinate, yCoordinate];
  }).toList();

  List<double> firstIntersect = intersects.first;
  double fractionAlongSegment = dx.abs() > dy.abs()
      ? (firstIntersect[0] - circleCenter.dx) / dx
      : (firstIntersect[1] - circleCenter.dy) / dy;
  List<double> chosenIntersect =
      fractionAlongSegment >= 0 && fractionAlongSegment <= 1 ? firstIntersect : intersects[1];
  return Offset(chosenIntersect[0], chosenIntersect[1]);
}
