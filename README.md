# Chartee

A chart library for Flutter

## Features

This package allows you to create the following charts:

- Bar chart
- Line chart
- Area chart

It's also possible to make combinations of these charts.

## Getting started

Install the package.

```
dependencies:
  chartee: <latest-version>
```

## Usage

This is a simple example of a simple bar chart. More examples will be available soon.

```dart
Chart(
  leftLabels: Labels(
    getLabelText: (index, value) => value.toString(),
    padding: const EdgeInsets.only(right: 16),
  ),
  layers: [
    ChartGridLayer.horizontal(
      (index, value) => GridLine(
        color: Colors.grey,
        dashArray: [5, 5],
        extendBehindLabels: true,
      ),
    ),
    const ChartBarLayer(
      items: [
        BarStack(
          x: 2,
          bars: [
            Bar(fromValue: 0, toValue: 100, color: Colors.red),
            Bar(fromValue: 0, toValue: -150, color: Colors.blue),
          ],
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        BarStack(
          x: 3,
          bars: [
            Bar(
              fromValue: 60,
              toValue: 100,
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            Bar(
              fromValue: 0,
              toValue: 50,
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ],
        ),
      ],
    ),
  ),
);
```

## Additional information

This package is maintained by [Chargee](https://chargee.energy). If you would like to contribute please open an issue or create a pull request on our [Github repository](https://github.com/chargee-energy/chartee).
