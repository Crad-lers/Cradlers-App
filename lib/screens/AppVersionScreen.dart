import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AppVersionScreen extends StatefulWidget {
  @override
  _AppVersionScreenState createState() => _AppVersionScreenState();
}

class _AppVersionScreenState extends State<AppVersionScreen> {
  String _appVersion = "Unknown";

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = "${info.appName} Version: ${info.version}+${info.buildNumber}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Version'),
      ),
      body: Center(
        child: Text(
          _appVersion,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
