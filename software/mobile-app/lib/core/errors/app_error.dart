import 'package:meta/meta.dart';

/// Coarse, user-facing category for a failure. UI maps these to friendly,
/// recoverable messages; logs use the [AppError.code] for diagnostics.
enum AppErrorKind {
  bluetoothDisabled,
  permissionDenied,
  permissionPermanentlyDenied,
  locationServicesRequired,
  noDevicesFound,
  unsupportedFirmware,
  protocolMismatch,
  connectionTimeout,
  deviceBusyElsewhere,
  unexpectedDisconnect,
  commandTimeout,
  commandRejected,
  malformedPayload,
  payloadTooLarge,
  persistence,
  unknown,
}

/// A structured, immutable error carried inside [Result]. Never contains raw
/// secrets or personal data — see PRIVACY-NOTES.md.
@immutable
class AppError implements Exception {
  const AppError(
    this.kind, {
    this.code,
    this.message,
    this.cause,
  });

  final AppErrorKind kind;

  /// Stable machine code for logs/diagnostics, e.g. `BLE_TIMEOUT`.
  final String? code;

  /// Developer-facing detail. Not shown verbatim to users.
  final String? message;

  /// Optional underlying cause (never logged raw if it may contain identifiers).
  final Object? cause;

  @override
  bool operator ==(Object other) =>
      other is AppError &&
      other.kind == kind &&
      other.code == code &&
      other.message == message;

  @override
  int get hashCode => Object.hash(kind, code, message);

  @override
  String toString() => 'AppError(${kind.name}${code == null ? '' : ', $code'})';
}
