import 'package:flutter/material.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({Key? key}) : super(key: key);

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  // Text controllers to capture input
  final TextEditingController _deviceNameController = TextEditingController();
  final TextEditingController _deviceDescriptionController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController(); // Controller for serial number
  String connectionType = 'Bluetooth'; // Default connection type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Device'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _deviceNameController,
              decoration: InputDecoration(
                labelText: 'Device Name',
                border: OutlineInputBorder(),
                hintText: 'Enter the name of the device',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _deviceDescriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                hintText: 'Enter a description for the device',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _serialNumberController,
              decoration: InputDecoration(
                labelText: 'Serial Number',
                border: OutlineInputBorder(),
                hintText: 'Enter the serial number of the device',
              ),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: connectionType,
              onChanged: (String? newValue) {
                setState(() {
                  connectionType = newValue!;
                });
              },
              items: <String>['Bluetooth', 'WiFi']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Make sure your device is connected to $connectionType before proceeding.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic to handle adding the device
                print('Device Added: ${_deviceNameController.text}, Serial: ${_serialNumberController.text} via $connectionType');
                // Clear the text fields
                _deviceNameController.clear();
                _deviceDescriptionController.clear();
                _serialNumberController.clear(); // Clear the serial number input
                // Optionally pop the screen
                Navigator.pop(context);
              },
              child: Text('Add Device'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF39CCCC), // Teal color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
