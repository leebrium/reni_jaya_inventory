import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reni_jaya_inventory/shared/loading.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List? cameras;
  int? selectedCameraIdx;
  String? imagePath;

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = CameraController(cameraDescription, ResolutionPreset.low);

    // If the controller is updated then update the UI.
    _controller!.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (_controller!.value.hasError) {
        print('Camera error ${_controller!.value.errorDescription}');
      }
    });

    _initializeControllerFuture = _controller!.initialize();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras!.length > 0) {
        setState(() => selectedCameraIdx = 0);

        _initCameraController(cameras![selectedCameraIdx!]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(children: [
            Container(
                child: CameraPreview(_controller!)),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: FloatingActionButton(
                child: Icon(Icons.camera_alt),
                onPressed: () async {
                  try {
                    await _initializeControllerFuture;
                    await _controller!
                        .takePicture()
                        .then((file) => {Navigator.pop(context, file.path)});
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            )
          ]);
        } else {
          return Loading();
        }
      },
    );
  }
}
