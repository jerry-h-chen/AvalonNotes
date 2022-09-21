import 'dart:math';
import 'dart:ui';

List<Offset> setSixPlayerConfig(double boardWidth, double boardHeight, double playerCircleRadius) {
  double xStart = playerCircleRadius, xEnd = boardWidth - playerCircleRadius;
  double yStart = playerCircleRadius, yEnd = boardHeight - playerCircleRadius;

  if (yEnd - yStart > xEnd - xStart) {
    yEnd = yStart + (xEnd - xStart);
  } else {
    xEnd = xStart + (yEnd - yStart);
  }
  double xMid = (xEnd + xStart) / 2, yMid = (yEnd + yStart) / 2;
  double a = yMid - yStart;

  return [
    Offset(xMid, yStart),
    Offset(xMid - 0.86602540378 * a, yStart + 0.5 * a),
    Offset(xMid + 0.86602540378 * a, yStart + 0.5 * a),
    Offset(xMid - 0.86602540378 * a, yEnd - 0.5 * a),
    Offset(xMid + 0.86602540378 * a, yEnd - 0.5 * a),
    Offset(xMid, yEnd)
  ];
}

List<Offset> setSevenPlayerConfig(
    double boardWidth, double boardHeight, double playerCircleRadius) {
  double xStart = playerCircleRadius, xEnd = boardWidth - playerCircleRadius;
  double yStart = playerCircleRadius, yEnd = boardHeight - playerCircleRadius;

  if (yEnd - yStart > xEnd - xStart) {
    yEnd = yStart + (xEnd - xStart);
  } else {
    xEnd = xStart + (yEnd - yStart);
  }

  double xMid = (xEnd + xStart) / 2, yMid = (yEnd + yStart) / 2;

  double cRadius = yMid - yStart;
  double a = 0.86776747823 * cRadius;
  double iRadius = a / 0.96314923761;
  double height = cRadius + iRadius;

  double x0 = xMid - xStart - (0.9009688679 * a);

  double p2x = xStart + x0;
  double p3x = xEnd - x0;

  double p2y = yStart + 0.43388373911 * a;
  double p3y = yStart + 0.43388373911 * a;

  double p4y = sqrt(pow(a, 2) - pow(x0, 2)) + p2y;
  double p5y = sqrt(pow(a, 2) - pow(x0, 2)) + p3y;

  double p6x = xStart + sqrt(pow(a, 2) - pow(yStart + height - p4y, 2));
  double p7x = xEnd - sqrt(pow(a, 2) - pow(yStart + height - p5y, 2));
  return [
    Offset(xMid, yStart),
    Offset(p2x, p2y),
    Offset(p3x, p3y),
    Offset(xStart, p4y),
    Offset(xEnd, p5y),
    Offset(p6x, yStart + height),
    Offset(p7x, yStart + height),
  ];
}

List<Offset> setEightPlayerConfig(
    double boardWidth, double boardHeight, double playerCircleRadius) {
  double xStart = playerCircleRadius, xEnd = boardWidth - playerCircleRadius;
  double yStart = playerCircleRadius, yEnd = boardHeight - playerCircleRadius;

  if (yEnd - yStart > xEnd - xStart) {
    yEnd = yStart + (xEnd - xStart);
  } else {
    xEnd = xStart + (yEnd - yStart);
  }

  double xMid = (xEnd + xStart) / 2, yMid = (yEnd + yStart) / 2;
  double cRadius = yMid - yStart;
  double a = 0.76536686473 * cRadius;

  double p2x = xMid - a * 0.92387953251;
  double p2y = yStart + a * 0.38268343236;

  double p3x = xMid + a * 0.92387953251;
  double p3y = p2y;

  double p4x = xStart;
  double p4y = p2y + a * 0.92387953251;

  double p5x = xEnd;
  double p5y = p4y;

  double p6x = p2x;
  double p6y = yEnd - a * 0.38268343236;

  double p7x = p3x;
  double p7y = p6y;

  return [
    Offset(xMid, yStart),
    Offset(p2x, p2y),
    Offset(p3x, p3y),
    Offset(p4x, p4y),
    Offset(p5x, p5y),
    Offset(p6x, p6y),
    Offset(p7x, p7y),
    Offset(xMid, yEnd),
  ];
}

List<Offset> setNinePlayerConfig(double boardWidth, double boardHeight, double playerCircleRadius) {
  double xStart = playerCircleRadius, xEnd = boardWidth - playerCircleRadius;
  double yStart = playerCircleRadius, yEnd = boardHeight - playerCircleRadius;

  if (yEnd - yStart > xEnd - xStart) {
    yEnd = yStart + (xEnd - xStart);
  } else {
    xEnd = xStart + (yEnd - yStart);
  }

  double xMid = (xEnd + xStart) / 2, yMid = (yEnd + yStart) / 2;
  double cRadius = yMid - yStart;
  double a = 0.68404028665 * cRadius;
  double iRadius = a / 0.82842712474;
  double height = cRadius + iRadius;

  double p2x = xMid - a * 0.93969262078;
  double p2y = yStart + a * 0.34202014332;

  double p3x = xMid + a * 0.93969262078;
  double p3y = p2y;

  double p4x = xMid - a * 0.93969262078 - (0.5 * a);
  double p4y = p2y + a * 0.86602540378;

  double p5x = xMid + a * 0.93969262078 + (0.5 * a);
  double p5y = p4y;

  double p6x = p4x + a * 0.17364817766;
  double p6y = p4y + a * 0.98480775301;

  double p7x = p5x - a * 0.17364817766;
  double p7y = p6y;

  double p8x = p6x + a * 0.76604444311;
  double p8y = p6y + a * 0.64278760968;

  double p9x = p7x - a * 0.76604444311;
  double p9y = p8y;

  return [
    Offset(xMid, yStart),
    Offset(p2x, p2y),
    Offset(p3x, p3y),
    Offset(p4x, p4y),
    Offset(p5x, p5y),
    Offset(p6x, p6y),
    Offset(p7x, p7y),
    Offset(p8x, p8y),
    Offset(p9x, p9y),
  ];
}

List<Offset> setTenPlayerConfig(double boardWidth, double boardHeight, double playerCircleRadius) {
  double xStart = playerCircleRadius, xEnd = boardWidth - playerCircleRadius;
  double yStart = playerCircleRadius, yEnd = boardHeight - playerCircleRadius;

  if (yEnd - yStart > xEnd - xStart) {
    yEnd = yStart + (xEnd - xStart);
  } else {
    xEnd = xStart + (yEnd - yStart);
  }

  double xMid = (xEnd + xStart) / 2, yMid = (yEnd + yStart) / 2;
  double cRadius = yMid - yStart;
  double a = 0.61803398875 * cRadius;

  double p2x = xMid - a * 0.95105651629;
  double p2y = yStart + a * 0.30901699437;

  double p3x = xMid + a * 0.95105651629;
  double p3y = p2y;

  double p4x = p2x - a * 0.58778525229;
  double p4y = p2y + a * 0.80901699437;

  double p5x = p3x + a * 0.58778525229;
  double p5y = p4y;

  double p6x = p4x;
  double p6y = p4y + a;

  double p7x = p5x;
  double p7y = p5y + a;

  double p8x = p2x;
  double p8y = yEnd - a * 0.30901699437;

  double p9x = p3x;
  double p9y = p8y;

  return [
    Offset(xMid, yStart),
    Offset(p2x, p2y),
    Offset(p3x, p3y),
    Offset(p4x, p4y),
    Offset(p5x, p5y),
    Offset(p6x, p6y),
    Offset(p7x, p7y),
    Offset(p8x, p8y),
    Offset(p9x, p9y),
    Offset(xMid, yEnd),
  ];
}
