
## Getting started

VerticalPickerWidget is a animated picker , ease to use

## Example

![example for VerticalPickerWidget](https://user-images.githubusercontent.com/52455330/139071980-91302a8a-37b1-4196-803e-f91b1de2ee5b.gif)

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