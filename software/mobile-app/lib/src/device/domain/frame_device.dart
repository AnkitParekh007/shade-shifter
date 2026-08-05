enum FrameConnectionState { disconnected, scanning, connecting, connected }

class FrameDeviceStatus {
  const FrameDeviceStatus({
    required this.connection,
    required this.batteryPercent,
    required this.temperatureCelsius,
    required this.firmwareVersion,
    required this.simulator,
    this.lastAcknowledgedSequence = 0,
  });

  const FrameDeviceStatus.disconnected()
      : connection = FrameConnectionState.disconnected,
        batteryPercent = 0,
        temperatureCelsius = 0,
        firmwareVersion = 'Unknown',
        simulator = true,
        lastAcknowledgedSequence = 0;

  final FrameConnectionState connection;
  final int batteryPercent;
  final double temperatureCelsius;
  final String firmwareVersion;
  final bool simulator;
  final int lastAcknowledgedSequence;

  bool get thermalWarning => temperatureCelsius >= 38;
  bool get thermalShutdown => temperatureCelsius >= 40;
}
