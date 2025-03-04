import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraViewPage extends StatefulWidget {
  @override
  _CameraViewPageState createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(cameras![0], ResolutionPreset.high);
      await _controller!.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
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
          Image.asset('assets/logo.png', height: 40), // Add your logo here
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
              child: _isCameraInitialized
                  ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: CameraPreview(_controller!),
              )
                  : Center(child: CircularProgressIndicator()),
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
                    onPressed: () async {
                      if (_controller != null && _controller!.value.isInitialized) {
                        XFile file = await _controller!.takePicture();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Recording started')),
                        );
                      }
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
                    onPressed: () {},
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
