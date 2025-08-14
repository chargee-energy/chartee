import 'package:chartee/chartee.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ScrollableChartController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollableChartController(initialX: 3);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chartee example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                child: ScrollableChart(
                  controller: _controller,
                  contentWidth: 800,
                  contentInset: 32,
                  leftLabels: Labels(
                    getLabelText: (index, value) => value.toString(),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  bottomLabels: Labels(
                    getLabelText: (index, value) => value.toString(),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  xIntervalsProvider: AllXIntervals.create,
                  yIntervalsProvider: (bounds, items) =>
                      RoundedYIntervals(bounds: bounds, numberOfTicks: 3),
                  layers: [
                    ...ChartGridLayer.all(
                      horizontalLineBuilder: (index, value) =>
                          GridLine(color: Colors.grey.shade300),
                      verticalLineBuilder: (index, value) =>
                          GridLine(color: Colors.grey.shade300),
                    ),
                    const ChartBarLayer(
                      items: [
                        BarStack(
                          x: 0,
                          bars: [
                            Bar(
                              fromValue: 0,
                              toValue: 10,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        BarStack(
                          x: 1,
                          bars: [
                            Bar(
                              fromValue: 0,
                              toValue: 8,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        BarStack(
                          x: 2,
                          bars: [
                            Bar(
                              fromValue: 0,
                              toValue: 7,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        BarStack(
                          x: 3,
                          bars: [
                            Bar(
                              fromValue: 0,
                              toValue: 8,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        BarStack(
                          x: 4,
                          bars: [
                            Bar(
                              fromValue: 0,
                              toValue: 6,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        BarStack(
                          x: 5,
                          bars: [
                            Bar(
                              fromValue: 0,
                              toValue: 10,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        BarStack(
                          x: 6,
                          bars: [
                            Bar(
                              fromValue: 0,
                              toValue: 10,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        BarStack(
                          x: 7,
                          bars: [
                            Bar(
                              fromValue: 0,
                              toValue: 8,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        BarStack(
                          x: 8,
                          bars: [
                            Bar(
                              fromValue: 0,
                              toValue: 7,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        BarStack(
                          x: 9,
                          bars: [
                            Bar(
                              fromValue: 0,
                              toValue: 8,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        BarStack(
                          x: 10,
                          bars: [
                            Bar(
                              fromValue: 0,
                              toValue: 6,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        BarStack(
                          x: 11,
                          bars: [
                            Bar(
                              fromValue: 0,
                              toValue: 10,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ),
                    ChartSelectionLayer(
                      isSticky: true,
                      initialSelectedX: 4,
                      builder: (items) => SingleChildSelectionOverlay(
                        child: SelectionOverlayItem(
                          widget: Container(
                            width: 1,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    ChartSelectionLayer(
                      isStatic: true,
                      translation: -1.5,
                      builder: (items) => SingleChildSelectionOverlay(
                        child: SelectionOverlayItem(
                          fullWidth: true,
                          widget: Container(
                            height: 50,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 200,
                child: Chart(
                  leftLabels: Labels(
                    getLabelText: (index, value) => value.toString(),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  bottomLabels: Labels(
                    getLabelText: (index, value) => value.toString(),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  xIntervalsProvider: AllXIntervals.create,
                  yIntervalsProvider: (bounds, items) =>
                      RoundedYIntervals(bounds: bounds, numberOfTicks: 3),
                  layers: [
                    ...ChartGridLayer.all(
                      horizontalLineBuilder: (index, value) =>
                          GridLine(color: Colors.grey.shade300),
                      verticalLineBuilder: (index, value) =>
                          GridLine(color: Colors.grey.shade300),
                    ),
                    const ChartBarLayer(
                      items: [
                        BarStack(
                          x: 0,
                          bars: [
                            Bar(
                              fromValue: 0,
                              toValue: 10,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        BarStack(
                          x: 1,
                          bars: [
                            Bar(
                              fromValue: 0,
                              toValue: 8,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        BarStack(
                          x: 2,
                          bars: [
                            Bar(
                              fromValue: 0,
                              toValue: 7,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        BarStack(
                          x: 3,
                          bars: [
                            Bar(
                              fromValue: 0,
                              toValue: 8,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        BarStack(
                          x: 4,
                          bars: [
                            Bar(
                              fromValue: 0,
                              toValue: 6,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        BarStack(
                          x: 5,
                          bars: [
                            Bar(
                              fromValue: 0,
                              toValue: 10,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        BarStack(
                          x: 6,
                          bars: [
                            Bar(
                              fromValue: 0,
                              toValue: 10,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const ChartLineLayer(
                      items: [
                        Point(x: 0, y: 11),
                        Point(x: 0.5, y: 20),
                        Point(x: 1, y: 13),
                        Point(x: 2, y: 12),
                        Point(x: 3, y: 14),
                        Point(x: 4, y: 11),
                        Point(x: 5, y: 12),
                        Point(x: 6, y: 10),
                      ],
                      positiveColor: Colors.green,
                      negativeColor: Colors.orange,
                      smoothness: 1,
                    ),
                    ChartSelectionLayer(
                      isSticky: true,
                      initialSelectedX: 1,
                      builder: (items) => SingleChildSelectionOverlay(
                        child: SelectionOverlayItem(
                          widget: Container(
                            width: 1,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
