import 'package:flutter/material.dart';

import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';

class RadialGaugeChart extends StatelessWidget {
  const RadialGaugeChart({required this.value, super.key});
  final double value;
  @override
  Widget build(BuildContext context) {
    const width = 10.0;
    return Tooltip(
      message: value.toString(),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        height: 150,
        width: 250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FittedBox(
            // clipBehavior: Clip.antiAlias,
            fit: BoxFit.fill,
            child: RadialGauge(
              // radiusFactor: 0.3,
              valueBar: [
                RadialValueBar(
                  gradient: const LinearGradient(colors: [
                    Colors.red,
                    Colors.orange,
                    Colors.amber,
                    Colors.yellow,
                    Colors.lime,
                    Colors.lightGreen,
                    Colors.green,
                  ]),
                  value: value,
                  valueBarThickness: width,
                ),
              ],
              needlePointer: [
                NeedlePointer(
                  value: value,
                  // tailColor: Colors.black,
                  tailColor: Theme.of(context).colorScheme.onSurface,
                  color: Colors.red,
                  needleHeight: 200,
                  needleWidth: 5,
                  tailRadius: 20,
                  needleStyle: NeedleStyle.gaugeNeedle,
                ),
              ],
              track: RadialTrack(
                steps: 20,
                hideTrack: false,
                trackStyle: TrackStyle(
                  // secondaryRulerPerInterval: 5,
                  showLabel: true,
                  labelStyle: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Michroma',
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  showPrimaryRulers: true,
                  showSecondaryRulers: true,
                  primaryRulersHeight: 20,
                  secondaryRulersHeight: 10,
                  primaryRulerColor: Theme.of(context).colorScheme.onSurface,
                  secondaryRulerColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                start: 0,
                thickness: width,
                end: 100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
