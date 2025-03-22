import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class CameraViewPage extends StatefulWidget {
  @override
  _CameraViewPageState createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {
  late String _viewId;

  @override
  void initState() {
    super.initState();

    _viewId = 'mjpeg-view-${DateTime.now().millisecondsSinceEpoch}';

    // Register an HTML <img> tag to show the MJPEG stream
    ui.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      final image = ImageElement()
        ..src = 'http://192.168.8.108:5050/video' // <-- replace with your stream
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover';
      return image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Image.asset('assets/logo.png', height: 40),
          SizedBox(height: 10),
          Text(
            'Camera View',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Status: Connected',
            style: TextStyle(fontSize: 16, color: Colors.green),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: HtmlElementView(viewType: _viewId),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.red,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Record button pressed')),
                      );
                    },
                    child: Icon(Icons.circle, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text('Record', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
              SizedBox(width: 40),
              Column(
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.black,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Mic button pressed')),
                      );
                    },
                    child: Icon(Icons.mic, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text('Mic', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
