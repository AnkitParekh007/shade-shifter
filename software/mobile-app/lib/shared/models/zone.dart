/// Physical, independently-addressable regions of a Rev-A Shade Shifter frame.
///
/// The device reports which of these it actually supports in its capability
/// response; the UI must map to that list rather than assuming all three.
enum ZoneId {
  front(0x01, 'Front'),
  leftTemple(0x02, 'Left temple'),
  rightTemple(0x03, 'Right temple');

  const ZoneId(this.wire, this.label);

  /// Byte identifier used on the BLE wire (see BLE-PROTOCOL.md, "Zone identifiers").
  final int wire;
  final String label;

  static ZoneId fromWire(int wire) =>
      values.firstWhere((z) => z.wire == wire, orElse: () => ZoneId.front);
}

/// What the user is currently editing in the studio. This is a *UI grouping* on
/// top of physical [ZoneId]s — e.g. "both temples" or "whole frame" fan a single
/// edit out to several zones. It is never sent to hardware directly.
enum SelectionTarget {
  wholeFrame('Whole frame'),
  front('Front'),
  leftTemple('Left temple'),
  rightTemple('Right temple'),
  bothTemples('Both temples');

  const SelectionTarget(this.label);
  final String label;

  /// The physical zones this selection writes to, constrained to those the
  /// device supports.
  List<ZoneId> resolve(List<ZoneId> supported) {
    List<ZoneId> raw;
    switch (this) {
      case SelectionTarget.wholeFrame:
        raw = ZoneId.values;
      case SelectionTarget.front:
        raw = const [ZoneId.front];
      case SelectionTarget.leftTemple:
        raw = const [ZoneId.leftTemple];
      case SelectionTarget.rightTemple:
        raw = const [ZoneId.rightTemple];
      case SelectionTarget.bothTemples:
        raw = const [ZoneId.leftTemple, ZoneId.rightTemple];
    }
    return raw.where(supported.contains).toList(growable: false);
  }
}
