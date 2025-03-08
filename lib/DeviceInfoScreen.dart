import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoScreen extends StatefulWidget {
  @override
  _DeviceInfoScreenState createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  String _deviceInfo = "Loading...";

  @override
  void initState() {
    super.initState();
    _initDeviceInfo();
  }

  Future<void> _initDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    setState(() {
      _deviceInfo = '''
Model: ${iosInfo.name}
System Name: ${iosInfo.systemName}
System Version: ${iosInfo.systemVersion}
Physical Device: ${iosInfo.isPhysicalDevice}
Utsname: ${iosInfo.utsname.version}
''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Device Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SelectableText(_deviceInfo),
      ),
    );
  }
}
