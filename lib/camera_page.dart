import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  late PoseDetector _poseDetector;
  bool _isReady = false;
  bool _isProcessing = false;
  CameraLensDirection _lensDirection = CameraLensDirection.back;

  // Track Reps & Visuals
  List<Pose> _poses = [];
  int _reps = 0;
  String _currentStage = "UP"; // Use a stage-based gate
  double _lastAngle = 0;

  @override
  void initState() {
    super.initState();
    _poseDetector = PoseDetector(
      options: PoseDetectorOptions(mode: PoseDetectionMode.stream, model: PoseDetectionModel.base),
    );
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    // Logic to select back or front camera
    final selected = cameras.firstWhere((c) => c.lensDirection == _lensDirection, orElse: () => cameras.first);

    _controller = CameraController(selected, ResolutionPreset.high, enableAudio: false, imageFormatGroup: ImageFormatGroup.yuv420);
    await _controller!.initialize();
    _controller!.startImageStream(_processFrame);
    if (mounted) setState(() => _isReady = true);
  }

  void _switchCamera() async {
    setState(() => _isReady = false);
    await _controller?.dispose();
    _lensDirection = (_lensDirection == CameraLensDirection.back) ? CameraLensDirection.front : CameraLensDirection.back;
    _initCamera();
  }

  void _processFrame(CameraImage image) async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      final poses = await _poseDetector.processImage(inputImage);

      if (poses.isNotEmpty) _runRepLogic(poses.first);
      if (mounted) setState(() => _poses = poses);
    } catch (_) {}

    await Future.delayed(const Duration(milliseconds: 40)); // Throttle for stability
    _isProcessing = false;
  }

  void _runRepLogic(Pose pose) {
    final s = pose.landmarks[PoseLandmarkType.leftShoulder];
    final e = pose.landmarks[PoseLandmarkType.leftElbow];
    final w = pose.landmarks[PoseLandmarkType.leftWrist];

    // ONLY count if joints are clearly visible
    if (s == null || e == null || w == null) return;
    if (s.likelihood < 0.75 || e.likelihood < 0.75 || w.likelihood < 0.75) return;

    double angle = _calculateAngle(Point(s.x, s.y), Point(e.x, e.y), Point(w.x, w.y));
    _lastAngle = angle;

    // Gate Logic: Must go DOWN to reset the counter
    if (angle > 160) {
      _currentStage = "DOWN";
    } else if (angle < 45 && _currentStage == "DOWN") {
      _currentStage = "UP";
      _reps++; // Count ONE rep only after completing the full motion
    }
  }

  // Angle calculation formula
  double _calculateAngle(Point a, Point b, Point c) {
    double radians = atan2(c.y - b.y, c.x - b.x) - atan2(a.y - b.y, a.x - b.x);
    double angle = (radians * 180.0 / pi).abs();
    if (angle > 180.0) angle = 360.0 - angle;
    return angle;
  }

  InputImage _inputImageFromCameraImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final plane in image.planes) { allBytes.putUint8List(plane.bytes); }
    return InputImage.fromBytes(
      bytes: allBytes.done().buffer.asUint8List(),
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: _rotationFromSensor(_controller!.description.sensorOrientation),
        format: InputImageFormat.yuv420,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  InputImageRotation _rotationFromSensor(int rotation) {
    if (rotation == 90) return InputImageRotation.rotation90deg;
    if (rotation == 180) return InputImageRotation.rotation180deg;
    if (rotation == 270) return InputImageRotation.rotation270deg;
    return InputImageRotation.rotation0deg;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady || _controller == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),
          // Dots and Lines Layer
          CustomPaint(
            painter: PosePainter(_poses, _controller!.value.previewSize!, _lensDirection),
          ),
          // User Interface
          Positioned(
            top: 40, left: 20,
            child: _statCard("REPS", "$_reps", Colors.greenAccent),
          ),
          Positioned(
            bottom: 30, right: 20,
            child: FloatingActionButton(onPressed: _switchCamera, child: const Icon(Icons.cameraswitch)),
          )
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
          Text(value, style: TextStyle(color: color, fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class PosePainter extends CustomPainter {
  final List<Pose> poses;
  final Size imageSize;
  final CameraLensDirection lensDirection;

  PosePainter(this.poses, this.imageSize, this.lensDirection);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 4.0..color = Colors.blue;
    final dotPaint = Paint()..color = Colors.white;

    // FIX: Scale landmarks from camera resolution to phone screen
    final double scaleX = size.width / imageSize.height;
    final double scaleY = size.height / imageSize.width;

    for (final pose in poses) {
      void drawLine(PoseLandmarkType a, PoseLandmarkType b) {
        final j1 = pose.landmarks[a];
        final j2 = pose.landmarks[b];
        if (j1 != null && j2 != null && j1.likelihood > 0.5) {
          canvas.drawLine(_transform(j1, size, scaleX, scaleY), _transform(j2, size, scaleX, scaleY), paint);
        }
      }

      drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
      drawLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);

      pose.landmarks.forEach((_, lm) {
        if (lm.likelihood > 0.5) {
          canvas.drawCircle(_transform(lm, size, scaleX, scaleY), 4, dotPaint);
        }
      });
    }
  }

  Offset _transform(PoseLandmark lm, Size size, double scaleX, double scaleY) {
    double x = lm.y * scaleX;
    double y = lm.x * scaleY;
    if (lensDirection == CameraLensDirection.front) x = size.width - x; // Mirroring fix
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(PosePainter oldDelegate) => true;
}