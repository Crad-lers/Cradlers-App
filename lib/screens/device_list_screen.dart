import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'DashboardScreen.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF22C3C8);
    final Color textColor = Colors.black87;

    // ✅ Get current user's UID
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Devices'),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: uid.isEmpty
          ? const Center(child: Text('User not logged in'))
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔄 Real-time Device List from Firestore
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .collection('devices')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return const Center(child: Text('Something went wrong'));
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('No devices found'));
                        }

                        final devices = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: devices.length,
                          itemBuilder: (context, index) {
                            final data = devices[index].data() as Map<String, dynamic>;

                            final deviceName = data['deviceName'] ?? 'Unnamed Device';
                            final connection = data['connection'] ?? 'WiFi';
                            final location = data['location'] ?? 'Unknown';
                            final connectionStatus = '$connection • Connected';

                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                leading: Container(
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(Icons.devices_other, size: 30, color: primaryColor),
                                ),
                                title: Text(
                                  deviceName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                                subtitle: Text(
                                  '$connectionStatus • $location',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios, color: primaryColor, size: 18),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // ➕ Add Device Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text(
                        "Add New Device",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/addDevice');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
