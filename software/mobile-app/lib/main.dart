import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/device/application/frame_controller.dart';
import 'src/device/data/simulator_frame_transport.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = FrameController(transport: SimulatorFrameTransport());
  runApp(ShadeShifterApp(controller: controller));
}
