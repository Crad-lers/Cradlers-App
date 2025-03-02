import 'package:flutter/material.dart';
import 'dart:math';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  final double bodyTemperature = 36.4; // Dummy data
  final double oxygenLevel = 80; // Dummy data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo and Title
            Row(
              children: [
                Image.asset('assets/logo-wo-bg.png', height: 40), // Logo
                SizedBox(width: 10),
                Text(
                  "Cradlers",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Page Title
            Text(
              "Health",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Body Temperature
            Text(
              "Body temperature",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            Center(
              child: CustomCircularIndicator(
                value: (bodyTemperature - 32) / 8, // Normalized between 32-40°C
                color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.thermostat, color: Colors.green, size: 24),
                    SizedBox(height: 5),
                    Text(
                      "${bodyTemperature}°C",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),

            // Oxygen Level
            Text(
              "Oxygen level",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            Center(
              child: CustomCircularIndicator(
                value: oxygenLevel / 100, // Normalize between 0-100%
                color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "O₂",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "${oxygenLevel} %",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Circular Progress Indicator Without External Packages
class CustomCircularIndicator extends StatelessWidget {
  final double value;
  final Color color;
  final Widget child;

  const CustomCircularIndicator({
    super.key,
    required this.value,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Circle
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
          ),
          // Progress Arc
          SizedBox(
            width: 180,
            height: 180,
            child: CustomPaint(
              painter: ArcPainter(value, color),
            ),
          ),
          // Center Content (Text & Icon)
          child,
        ],
      ),
    );
  }
}

// Arc Painter for Custom Circular Progress Indicator
class ArcPainter extends CustomPainter {
  final double progress;
  final Color color;

  ArcPainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint trackPaint = Paint()
      ..color = color
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double startAngle = -pi / 2;
    final double sweepAngle = 2 * pi * progress;

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawArc(rect, startAngle, sweepAngle, false, trackPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
