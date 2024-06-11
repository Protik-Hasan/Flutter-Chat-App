import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class ProfilePage extends StatefulWidget {
  final String name;
  final String email;

  ProfilePage({required this.name, required this.email});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  CameraController? _cameraController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Name: ${widget.name}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Email: ${widget.email}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await _requestPermissions(context);
              },
              icon: Icon(Icons.camera),
              label: Text('Upload Profile Picture'),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Implement logout logic and replace the current route with the login screen route
                Navigator.pushReplacementNamed(context, '/logout');
                // Remove all routes from the stack except the login screen
                Navigator.popUntil(context, ModalRoute.withName('/logout'));
              },
              icon: Icon(Icons.logout),
              label: Text('Logout'),
            ),
            _cameraController!= null
                ? CameraPreview(_cameraController!)
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<void> _requestPermissions(BuildContext context) async {
    await Permission.storage.request();
    await Permission.camera.request();

    if (await Permission.storage.isGranted && await Permission.camera.isGranted) {
      // Permission granted, you can now access the camera and storage
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        final camera = cameras.first;

        _cameraController = CameraController(camera, ResolutionPreset.high);

        try {
          await _cameraController!.initialize();
          setState(() {}); // Update the UI to display the camera preview
          print('Camera initialized');
        } catch (e) {
          print('Error initializing camera: $e');
        }

        final ImagePicker _picker = ImagePicker();
        final XFile? image = await _picker.pickImage(source: ImageSource.camera);
        if (image!= null) {
          // Implement your logic to upload the profile picture here
          print('Image picked: ${image.path}');
        } else {
          print('No image picked');
        }
      } else {
        print('No cameras available');
      }
    } else {
      _showPermissionDeniedDialog(context);
    }
  }

  Future<void> _showPermissionDeniedDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Denied'),
        content: Text('You denied the permission to access your storage and camera'),
        actions: [
          Icon(Icons.error),
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}