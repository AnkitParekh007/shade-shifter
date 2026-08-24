import 'app_error.dart';

/// How an [AppError] is shown to a person: what happened, and what they can do
/// about it. Centralised so every surface tells the same story and no raw error
/// code or identifier ever reaches the UI (see UX-FLOWS.md "Handled error
/// states" and PRIVACY-NOTES.md).
class ErrorPresentation {
  const ErrorPresentation(
    this.message, {
    this.actionLabel,
    this.opensSettings = false,
  });

  /// A plain, non-blaming sentence describing the situation.
  final String message;

  /// Label for the recovery action, or `null` when there is nothing to retry.
  final String? actionLabel;

  /// True when the recovery action must send the user to OS settings rather
  /// than retrying in-app.
  final bool opensSettings;

  static ErrorPresentation of(AppError error) => switch (error.kind) {
        AppErrorKind.bluetoothDisabled => const ErrorPresentation(
            'Bluetooth is off. Turn it on to find your frame.',
            actionLabel: 'Try again',
          ),
        AppErrorKind.permissionDenied => const ErrorPresentation(
            'Shade Shifter needs Bluetooth access to find your frame.',
            actionLabel: 'Try again',
          ),
        AppErrorKind.permissionPermanentlyDenied => const ErrorPresentation(
            'Bluetooth access is blocked. You can enable it in Settings.',
            actionLabel: 'Open settings',
            opensSettings: true,
          ),
        AppErrorKind.locationServicesRequired => const ErrorPresentation(
            'This Android version needs location services on to scan for '
            'Bluetooth devices. Your location is never used or stored.',
            actionLabel: 'Try again',
          ),
        AppErrorKind.noDevicesFound => const ErrorPresentation(
            'No frames nearby. Make sure yours is powered on and close by.',
            actionLabel: 'Scan again',
          ),
        AppErrorKind.unsupportedFirmware => const ErrorPresentation(
            'That device is not a Shade Shifter frame, or its firmware is too '
            'old for this app.',
            actionLabel: 'Scan again',
          ),
        AppErrorKind.protocolMismatch => const ErrorPresentation(
            'This frame speaks a different protocol version. Update the app or '
            'the frame firmware.',
          ),
        AppErrorKind.connectionTimeout => const ErrorPresentation(
            'Could not reach the frame in time. Move closer and try again.',
            actionLabel: 'Try again',
          ),
        AppErrorKind.deviceBusyElsewhere => const ErrorPresentation(
            'The frame is connected to another device. Disconnect it there '
            'first.',
            actionLabel: 'Try again',
          ),
        AppErrorKind.unexpectedDisconnect => const ErrorPresentation(
            'The frame disconnected. It may be out of range or powered off.',
            actionLabel: 'Reconnect',
          ),
        AppErrorKind.commandTimeout => const ErrorPresentation(
            'The frame did not confirm that change. Nothing was applied.',
            actionLabel: 'Try again',
          ),
        AppErrorKind.commandRejected => const ErrorPresentation(
            'The frame refused that change to stay within its safe limits.',
          ),
        AppErrorKind.malformedPayload ||
        AppErrorKind.payloadTooLarge =>
          const ErrorPresentation(
            'That change could not be sent to the frame.',
          ),
        AppErrorKind.persistence => const ErrorPresentation(
            'Your settings could not be saved on this device.',
          ),
        AppErrorKind.unknown => const ErrorPresentation(
            'Something went wrong. Please try again.',
            actionLabel: 'Try again',
          ),
      };
}
