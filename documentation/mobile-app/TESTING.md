# Testing

Run `flutter test` for unit/widget tests and `flutter analyze` for static checks. Protocol tests cover framing, little-endian values, CRC and corruption. Transport tests cover simulator connection, capabilities, commands, and disconnected writes. Model tests cover intensity clamps and thermal thresholds.

Manual release checks require one Android phone, one iPhone, and the ESP32 bench frame: permission denial/recovery, scan timeout, Rev A RGB writes, disconnect retention, off, background/foreground, large text, screen reader, dark mode, 30-minute thermal display, and 60-minute bench stability.
