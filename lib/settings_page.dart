import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: SettingsPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double bodyTemperature = 36; // Default value
  double oxygenLevel = 20; // Default value
  double cradleSwingSpeed = 3; // Default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Settings",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            // Body Temperature Slider
            _buildSlider(
              title: "Body temperature",
              min: 32,
              max: 40,
              value: bodyTemperature,
              unit: "°C",
              onChanged: (newValue) {
                setState(() {
                  bodyTemperature = newValue;
                });
              },
            ),

            // Oxygen Level Slider
            _buildSlider(
              title: "Humidity level",
              min: 20,
              max: 100,
              value: oxygenLevel,
              unit: "%",
              onChanged: (newValue) {
                setState(() {
                  oxygenLevel = newValue;
                });
              },
            ),

            // Speed of Cradle Swing (Discrete Slider)
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                "Speed of cradle swing",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Slider(
              value: cradleSwingSpeed,
              min: 1,
              max: 5,
              divisions: 4,
              activeColor: Colors.cyan,
              inactiveColor: Colors.grey[400],
              onChanged: (newValue) {
                setState(() {
                  cradleSwingSpeed = newValue;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                return Text("${index + 1}");
              }),
            ),

            SizedBox(height: 40),

            // Done Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save settings and go back
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Settings saved successfully!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  "Done",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String title,
    required double min,
    required double max,
    required double value,
    required String unit,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: Colors.cyan,
          inactiveColor: Colors.grey[400],
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${min.toInt()}$unit", style: TextStyle(fontSize: 14)),
            Text("${max.toInt()}$unit", style: TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
