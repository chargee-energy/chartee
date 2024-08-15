## 1.0.10

- Added `ScrollableChart` widget to create charts that can scroll horizontally
- Added `isStatic` property to chart layers to determine if they should scroll or stay in place in a `ScrollableChart`
- **Breaking change**: Because grid layers are split up in separate vertical and horizontal layers `ChartGridLayer.all` returns a list of 2 layers now instead of a single layer
- **Breaking change**: Chart selections are no longer based on `ChartItem`, they work purely with `x` values now
- **Breaking change**: The property `sticky` of `ChartSelectionLayer` is renamed to `isSticky` to be consistent with the added `isStatic` property on all layers

## 1.0.9

- Make font size of labels adjustable through OS accessibility settings

## 1.0.8

- Include the actual value also in `RoundedYIntervals` when bounds min and max are the same

## 1.0.7

- Changed rounding in `RoundedYIntervals` when bounds min and max are the same

## 1.0.6

- Added default value to `RoundedYIntervals` when bounds are flexible

## 1.0.5

- Draw labels over other chart layers

## 1.0.4

- Added a layer type to support custom widgets in a chart

## 1.0.3

- Updated Github action

## 1.0.2

- Added basic example project

## 1.0.1

- Updated pubspec.yaml description
- Added code documentation

## 1.0.0

- Initial release with support for bar, line and area charts
