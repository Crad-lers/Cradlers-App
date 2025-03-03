import 'package:flutter/material.dart';
import 'dart:math';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  final double bodyTemperature = 36.4; // Dummy data
  final double oxygenLevel = 20; // Dummy data

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo and Title
            Row(
              children: [
                Image.asset('assets/logo.png', height: 40), // Logo
                const SizedBox(width: 10),
                const Text(
                  "Cradlers",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Page Title
            const Text(
              "Health Overview",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _buildHealthCard(
              title: "Body Temperature",
              value: "$bodyTemperature°C",
              icon: Icons.thermostat,
              iconColor: Colors.green,
              progress: (bodyTemperature - 32) / 8,
              safeColor: Colors.green,
              dangerColor: Colors.red,
            ),
            const SizedBox(height: 20),

            _buildHealthCard(
              title: "Oxygen Level",
              value: "$oxygenLevel%",
              icon: Icons.bubble_chart,
              iconColor: Colors.red,
              progress: oxygenLevel / 100,
              safeColor: Colors.green,
              dangerColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required double progress,
    required Color safeColor,
    required Color dangerColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Center(
          child: AnimatedWaveIndicator(
            value: progress,
            safeColor: safeColor,
            dangerColor: dangerColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 28),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Animated Wave Progress Indicator
class AnimatedWaveIndicator extends StatefulWidget {
  final double value; // Value range: 0.0 - 1.0
  final Color safeColor;
  final Color dangerColor;
  final Widget child;

  const AnimatedWaveIndicator({
    super.key,
    required this.value,
    required this.safeColor,
    required this.dangerColor,
    required this.child,
  });

  @override
  State<AnimatedWaveIndicator> createState() => _AnimatedWaveIndicatorState();
}

class _AnimatedWaveIndicatorState extends State<AnimatedWaveIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width * 0.45;
    Color fillColor = widget.value >= 0.5 ? widget.safeColor : widget.dangerColor;

    return SizedBox(
      height: screenSize,
      width: screenSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Circle
          Container(
            width: screenSize,
            height: screenSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          // Animated Wave
          ClipOval(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(widget.value, _controller.value, fillColor),
                  child: child,
                );
              },
              child: SizedBox(width: screenSize, height: screenSize),
            ),
          ),
          // Center Content (Icon & Text)
          widget.child,
        ],
      ),
    );
  }
}

// Wave Painter for Animated Water Effect
class WavePainter extends CustomPainter {
  final double progress;
  final double animationValue;
  final Color color;

  WavePainter(this.progress, this.animationValue, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint wavePaint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final double waveHeight = 6 + 3 * sin(animationValue * 2 * pi);
    final double waterLevel = size.height * (1 - progress);

    final Path wavePath = Path();
    wavePath.moveTo(0, waterLevel);

    for (double x = 0; x <= size.width; x++) {
      double y = waterLevel + waveHeight * sin((x / size.width * 2 * pi) + (animationValue * 2 * pi));
      wavePath.lineTo(x, y);
    }

    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    canvas.drawPath(wavePath, wavePaint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}
