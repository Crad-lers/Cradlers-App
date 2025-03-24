import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  _HealthScreenState createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref('sensorData');

  double temperature = 36.4;
  double humidityLevel = 20;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    dbRef.onValue.listen((event) {
      final data = event.snapshot.value;

      if (data != null && data is Map<dynamic, dynamic>) {
        setState(() {
          temperature = double.tryParse(data['temperature'].toString()) ?? temperature;
          humidityLevel = double.tryParse(data['humidity'].toString()) ?? humidityLevel;
          hasError = false;
        });
      } else {
        setState(() {
          hasError = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine wave color (safe: green, danger: red)
    bool isTempSafe = temperature >= 20 && temperature <= 33;
    Color temperatureWaveColor = isTempSafe ? Colors.green : Colors.red;

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
        child: hasError
            ? const Center(
                child: Text(
                  "System error",
                  style: TextStyle(fontSize: 24, color: Colors.red),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/logo.png', height: 90),
                      const SizedBox(width: 10),
                      const Text(
                        "Cradlers",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Health Overview",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30), // Top padding before cards

                  // All cards with vertical spacing
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        _buildHealthCard(
                          title: "Temperature",
                          value: "${temperature.toStringAsFixed(1)}°C",
                          icon: Icons.thermostat,
                          iconColor: Colors.black,
                          textColor: Colors.black,
                          waveColor: temperatureWaveColor,
                          progress: (temperature - 9) / 31,
                        ),
                        const SizedBox(height: 40), // Spacing between cards
                        _buildHealthCard(
                          title: "Humidity Level",
                          value: "${humidityLevel.toStringAsFixed(1)}%",
                          icon: Icons.water_drop,
                          iconColor: Colors.blue,
                          textColor: Colors.black,
                          waveColor: Colors.blue,
                          progress: humidityLevel / 100,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30), // Bottom spacing after cards
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
    required Color textColor,
    required Color waveColor,
    required double progress,
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
            value: progress.clamp(0.0, 1.0),
            fillColor: waveColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 28),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedWaveIndicator extends StatefulWidget {
  final double value;
  final Color fillColor;
  final Widget child;

  const AnimatedWaveIndicator({
    super.key,
    required this.value,
    required this.fillColor,
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

    return SizedBox(
      height: screenSize,
      width: screenSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: screenSize,
            height: screenSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          ClipOval(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(widget.value, _controller.value, widget.fillColor),
                  child: child,
                );
              },
              child: SizedBox(width: screenSize, height: screenSize),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

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