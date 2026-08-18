import 'appearance.dart';

/// A saved, re-applicable frame configuration. Stored locally for the POC.
class Look {
  const Look({
    required this.id,
    required this.name,
    required this.appearance,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceCapabilityVersion,
    this.favorite = false,
    this.builtIn = false,
  });

  final String id;
  final String name;

  /// Per-zone configuration (front / temples) plus each zone's effect.
  final FrameAppearance appearance;

  final DateTime createdAt;
  final DateTime updatedAt;

  /// Capability version of the hardware this look was authored against, so we
  /// can warn when applying it to a device with a different capability shape.
  final int deviceCapabilityVersion;

  final bool favorite;

  /// True for curated presets shipped with the app (not user-deletable).
  final bool builtIn;

  Look copyWith({
    String? name,
    FrameAppearance? appearance,
    DateTime? updatedAt,
    bool? favorite,
  }) =>
      Look(
        id: id,
        name: name ?? this.name,
        appearance: appearance ?? this.appearance,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deviceCapabilityVersion: deviceCapabilityVersion,
        favorite: favorite ?? this.favorite,
        builtIn: builtIn,
      );

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'appearance': appearance.toJson(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'deviceCapabilityVersion': deviceCapabilityVersion,
        'favorite': favorite,
        'builtIn': builtIn,
      };

  factory Look.fromJson(Map<String, Object?> json) => Look(
        id: json['id'] as String,
        name: json['name'] as String,
        appearance: FrameAppearance.fromJson(
            (json['appearance'] as Map).cast<String, Object?>()),
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        deviceCapabilityVersion:
            (json['deviceCapabilityVersion'] as num?)?.toInt() ?? 1,
        favorite: json['favorite'] as bool? ?? false,
        builtIn: json['builtIn'] as bool? ?? false,
      );

  @override
  bool operator ==(Object other) => other is Look && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
