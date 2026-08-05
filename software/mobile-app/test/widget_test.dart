import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shade_shifter/src/core/models.dart';

void main() {
  test('intensity is clamped to the app safety range', () {
    expect(FrameAppearance.safeDefault.copyWith(intensity: 4).intensity, .65);
    expect(
        FrameAppearance.safeDefault.copyWith(intensity: double.nan).intensity,
        0);
  });
  test('thermal thresholds match the hardware blueprint', () {
    expect(const FrameDeviceStatus(temperatureCelsius: 37.9).safety,
        SafetyState.normal);
    expect(const FrameDeviceStatus(temperatureCelsius: 38).safety,
        SafetyState.warning);
    expect(const FrameDeviceStatus(temperatureCelsius: 40).safety,
        SafetyState.shutdown);
  });
  testWidgets('minimum touch target is represented by Material controls',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.power_settings_new)))));
    expect(tester.getSize(find.byType(IconButton)).shortestSide,
        greaterThanOrEqualTo(48));
  });
}
