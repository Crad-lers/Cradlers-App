import 'package:flutter/material.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({Key? key}) : super(key: key);

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _deviceNameController = TextEditingController();
  final TextEditingController _deviceDescriptionController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _customLocationController = TextEditingController();

  String _connectionType = 'Bluetooth';
  List<String> _locations = ['Master Bedroom', 'Living Room', 'Kitchen', 'Bathroom'];
  String _currentLocation = 'Master Bedroom';
  bool _isLoading = false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      // Simulate a network request
      Future.delayed(Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        _clearForm();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Device successfully added!'),
          backgroundColor: Colors.green,
        ));
      });
    }
  }

  void _clearForm() {
    _deviceNameController.clear();
    _deviceDescriptionController.clear();
    _serialNumberController.clear();
    _customLocationController.clear();
  }

  void _addCustomLocation() {
    final text = _customLocationController.text;
    if (text.isNotEmpty && !_locations.contains(text)) {
      setState(() {
        _locations.add(text);
        _currentLocation = text;
      });
      _customLocationController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Device'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _deviceNameController,
                decoration: InputDecoration(
                  labelText: 'Device Name',
                  border: OutlineInputBorder(),
                  hintText: 'Enter the name of the device',
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a device name' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _deviceDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  hintText: 'Enter a description for the device',
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _serialNumberController,
                decoration: InputDecoration(
                  labelText: 'Serial Number',
                  border: OutlineInputBorder(),
                  hintText: 'Enter the serial number of the device',
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a serial number' : null,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _connectionType,
                onChanged: (String? newValue) {
                  setState(() => _connectionType = newValue!);
                },
                items: <String>['Bluetooth', 'WiFi']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Connection Type',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _currentLocation,
                onChanged: (String? newValue) {
                  setState(() => _currentLocation = newValue!);
                },
                items: _locations
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Device Location',
                  border: OutlineInputBorder(),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _customLocationController,
                      decoration: InputDecoration(
                        labelText: 'Add Custom Location',
                        hintText: 'e.g., Guest Room',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addCustomLocation,
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (_isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Add Device'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF39CCCC),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
