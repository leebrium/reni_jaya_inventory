import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FancyBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: Container(color: Colors.white)),
        Positioned(
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue,
            ),
            child: Stack(
              children: <Widget>[
                onBottom(AnimatedWave(
                  height: 150,
                  speed: 0.9,
                )),
                onBottom(AnimatedWave(
                  height: 90,
                  speed: 0.8,
                  offset: pi,
                )),
                onBottom(AnimatedWave(
                  height: 170,
                  speed: 1.1,
                  offset: pi / 2,
                )),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );
}

class AnimatedWave extends StatelessWidget {
  final double height;
  final double speed;
  final double offset;

  const AnimatedWave({required this.height, required this.speed, this.offset = 0.0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: height,
        width: constraints.biggest.width,
        child: LoopAnimation<double>(
            duration: Duration(seconds: 80),
            tween: Tween(begin: 50, end: 200),
            builder: (context, child, value) {
              return CustomPaint(
                foregroundPainter: CurvePainter(value + offset),
              );
            }),
      );
    });
  }
}

class CurvePainter extends CustomPainter {
  final double value;

  CurvePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.blueAccent.withAlpha(60);
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
