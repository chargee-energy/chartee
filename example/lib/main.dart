import 'package:chartee/chartee.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chartee example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: SizedBox(
              height: 200,
              child: Chart(
                bottomLabels: Labels(
                  getLabelText: (index, value) => value.toString(),
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                xIntervalsProvider: AllXIntervals.create,
                yIntervalsProvider: (bounds, items) =>
                    RoundedYIntervals(bounds: bounds, numberOfTicks: 3),
                layers: [
                  ChartGridLayer.horizontal(
                    (index, value) => GridLine(color: Colors.grey.shade300),
                  ),
                  const ChartLineLayer(
                    items: [
                      Point(x: 0, y: 100),
                      Point(x: 1, y: 150),
                      Point(x: 2, y: 50),
                    ],
                    positiveColor: Colors.green,
                    negativeColor: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
