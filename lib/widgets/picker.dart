import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vertical_scroll_picker/widgets/custom_cupertino_picker.dart';

class VerticalPickerWidget extends StatefulWidget {
  final FixedExtentScrollController controller;

  final void Function(int val) onScroll;

  final void Function(AnimationStatus)? onCompleteAnimation;

  final int minIntegralValue;
  final int maxIntegralValue;

  const VerticalPickerWidget({
    Key? key,
    required this.controller,
    required this.onScroll,
    this.minIntegralValue = 0,
    this.maxIntegralValue = 100,
    this.onCompleteAnimation,
  }) : super(key: key);

  @override
  State<VerticalPickerWidget> createState() => _VerticalPickerWidgetState();
}

class _VerticalPickerWidgetState extends State<VerticalPickerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // ignore: unused_field
  late Animation<double> _opacity;
  late Animation<double> _width;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _controller.addStatusListener(widget.onCompleteAnimation ?? (_) {});

    _opacity = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.5,
          curve: Curves.ease,
        ),
      ),
    )..addListener(() => setState(() {}));

    _width = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.5,
          1.0,
          curve: Curves.ease,
        ),
      ),
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(VerticalPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final sideWidth = constraints.maxWidth * 0.10330579;
      final pickerMaxWidth = (constraints.maxWidth - (sideWidth * 2));
      final pickerWidthLeft = pickerMaxWidth * _width.value;

      return SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Positioned(
          left: sideWidth,
          child: SizedBox(
            width: pickerWidthLeft,
            height: constraints.maxHeight,
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Positioned(
                  top: 0,
                  width: pickerMaxWidth,
                  height: constraints.maxHeight,
                  child: ShaderMask(
                    shaderCallback: (rect) => shaderCallBack(rect),
                    child: CustomCupertinoPicker(
                      looping: false,
                      useMagnifier: false,
                      itemExtent: 80,
                      diameterRatio: 1.3,
                      selectionOverlay: Container(
                        color: Colors.transparent,
                      ),
                      scrollController: widget.controller,
                      squeeze: 1,
                      onSelectedItemChanged: (index) {
                        HapticFeedback.lightImpact();
                        widget.onScroll(index);
                      },
                      children: [
                        for (var i = widget.minIntegralValue;
                            i < widget.maxIntegralValue;
                            i++)
                          Text(
                            '$i',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 64,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Nunito',
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

Shader shaderCallBack(Rect rect) => LinearGradient(
      stops: const [0.0, 0.15, 0.3, 0.7, 0.85, 1.0],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.white.withOpacity(0.0),
        Colors.white.withOpacity(0.0),
        Colors.white,
        Colors.white,
        Colors.white.withOpacity(0.0),
        Colors.white.withOpacity(0.0),
      ],
    ).createShader(rect);
