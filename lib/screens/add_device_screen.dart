import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final TextEditingController _locationController = TextEditingController();

  bool _isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          throw Exception("User not logged in");
        }

        final uid = user.uid;

        await _firestore
            .collection('users')
            .doc(uid)
            .collection('devices')
            .add({
          'deviceName': _deviceNameController.text,
          'deviceDescription': _deviceDescriptionController.text,
          'serialNumber': _serialNumberController.text,
          'location': _locationController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() => _isLoading = false);
        _clearForm();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Device successfully added!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context); // Return to device list or previous screen
      } catch (error) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add device: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _clearForm() {
    _deviceNameController.clear();
    _deviceDescriptionController.clear();
    _serialNumberController.clear();
    _locationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF39CCCC);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Device'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Device Name
              TextFormField(
                controller: _deviceNameController,
                decoration: const InputDecoration(
                  labelText: 'Device Name',
                  border: OutlineInputBorder(),
                  hintText: 'Enter the name of the device',
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a device name' : null,
              ),
              const SizedBox(height: 20),

              // Device Description
              TextFormField(
                controller: _deviceDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  hintText: 'Enter a description for the device',
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 20),

              // Serial Number
              TextFormField(
                controller: _serialNumberController,
                decoration: const InputDecoration(
                  labelText: 'Serial Number',
                  border: OutlineInputBorder(),
                  hintText: 'Enter the serial number of the device',
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a serial number' : null,
              ),
              const SizedBox(height: 20),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                  hintText: 'Enter the location of the cradle',
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a location' : null,
              ),
              const SizedBox(height: 20),

              // Submit Button or Loader
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      ),
                      child: const Text('Add Device'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
