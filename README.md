
## Getting started

VerticalPickerWidget is a animated picker , ease to use

## Example

![example for VerticalPickerWidget](https://s10.gifyu.com/images/example0c0a2e7af5022f25.gif)

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