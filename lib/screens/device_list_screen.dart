import 'package:flutter/material.dart';

import '../DashboardScreen.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cradlers'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.of(context).pop(); // This will take the user back to the previous screen
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
              },
              child: const Text('Gen 1 Cradlers cradle'),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Gen 1 Cradlers cradle 2'),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // This is where we navigate to the AddDeviceScreen
                Navigator.pushNamed(context, '/addDevice');
              },
              child: const Text('+ Add device'),
            ),
          ],
        ),
      ),
    );
  }
}
