/// Explicit lifecycle of a customization edit as it travels to the device.
/// Drives the "Apply" affordance and its status chip in the studio.
enum ApplyPhase {
  /// Local-only change, not yet queued for the device.
  previewing('Previewing'),

  /// Queued, debounced, awaiting the next allowed transmit slot.
  pendingTransmission('Pending'),

  /// Written to the device, awaiting acknowledgement.
  sending('Sending…'),

  /// Device acknowledged receipt of the command.
  acknowledged('Acknowledged'),

  /// Device confirmed the change is live on the frame.
  applied('Applied'),

  /// No acknowledgement within the timeout budget.
  timedOut('Timed out'),

  /// Device explicitly rejected (e.g. unsafe / unsupported).
  rejected('Rejected'),

  /// Local state was rolled back to the last confirmed appearance.
  reverted('Reverted');

  const ApplyPhase(this.label);
  final String label;

  bool get isTerminal =>
      this == applied ||
      this == timedOut ||
      this == rejected ||
      this == reverted;

  bool get isInFlight =>
      this == pendingTransmission || this == sending || this == acknowledged;
}
