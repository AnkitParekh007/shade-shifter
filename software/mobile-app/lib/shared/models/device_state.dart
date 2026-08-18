/// Connection lifecycle shared by every transport (simulator, fake, BLE).
enum ConnectionStatus {
  disconnected,
  scanning,
  connecting,
  negotiating,
  connected,
  reconnecting,
  error,
}

/// Live telemetry snapshot from the frame. Fields are nullable when the device
/// does not report them; the UI shows "Not supported"/"—" rather than zeros.
class DeviceTelemetry {
  const DeviceTelemetry({
    this.batteryPercent,
    this.charging = false,
    this.temperatureCelsius,
    this.rssi,
    this.firmwareVersion,
    this.lastSyncAt,
    this.thermalAlarm = false,
  });

  final int? batteryPercent;
  final bool charging;
  final double? temperatureCelsius;
  final int? rssi;
  final String? firmwareVersion;
  final DateTime? lastSyncAt;

  /// True once temperature crossed the firmware shutdown threshold; animated
  /// effects must be suspended by the app until cleared.
  final bool thermalAlarm;

  /// Rough remaining-use estimate; null when battery is unknown.
  Duration? get estimatedRemaining {
    final b = batteryPercent;
    if (b == null || charging) return null;
    // POC heuristic: ~6h at full charge under typical use.
    return Duration(minutes: (b / 100 * 360).round());
  }

  /// 0..4 signal bars from RSSI.
  int get signalBars {
    final r = rssi;
    if (r == null) return 0;
    if (r >= -55) return 4;
    if (r >= -67) return 3;
    if (r >= -78) return 2;
    if (r >= -90) return 1;
    return 0;
  }

  DeviceTelemetry copyWith({
    int? batteryPercent,
    bool? charging,
    double? temperatureCelsius,
    int? rssi,
    String? firmwareVersion,
    DateTime? lastSyncAt,
    bool? thermalAlarm,
  }) =>
      DeviceTelemetry(
        batteryPercent: batteryPercent ?? this.batteryPercent,
        charging: charging ?? this.charging,
        temperatureCelsius: temperatureCelsius ?? this.temperatureCelsius,
        rssi: rssi ?? this.rssi,
        firmwareVersion: firmwareVersion ?? this.firmwareVersion,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        thermalAlarm: thermalAlarm ?? this.thermalAlarm,
      );
}

/// Identity of a discoverable / paired frame, transport-agnostic.
class DeviceRef {
  const DeviceRef({
    required this.id,
    required this.name,
    required this.isSimulator,
    this.rssi,
  });

  /// Opaque transport id (BLE remote id or a simulator handle). Never shown raw.
  final String id;
  final String name;
  final bool isSimulator;
  final int? rssi;

  DeviceRef copyWith({String? name, int? rssi}) => DeviceRef(
        id: id,
        name: name ?? this.name,
        isSimulator: isSimulator,
        rssi: rssi ?? this.rssi,
      );

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'isSimulator': isSimulator,
      };

  factory DeviceRef.fromJson(Map<String, Object?> json) => DeviceRef(
        id: json['id'] as String,
        name: json['name'] as String,
        isSimulator: json['isSimulator'] as bool? ?? false,
      );

  @override
  bool operator ==(Object other) => other is DeviceRef && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
