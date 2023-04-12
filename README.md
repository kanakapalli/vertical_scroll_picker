
## Getting started

VerticalPickerWidget is a animated picker , ease to use

## Example

example of using ResponsiveBuilder

```dart
VerticalPickerWidget(
                controller: FixedExtentScrollController(initialItem: 66),
                onScroll: (value) {
                  print(" current value $value");
                })
```

<!-- ## Additional information

check the device type based on screen size.

```dart
    // mobile
    MultiScreenBuilder.isMobile(context);

    // tablet
    MultiScreenBuilder.isTablet(context);

    // desktop
    MultiScreenBuilder.isDesktop(context);

``` -->