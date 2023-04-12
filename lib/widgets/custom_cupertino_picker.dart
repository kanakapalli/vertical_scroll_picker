// COPY OF CUPERTINO PICKER WITH NEW SCROLL PHYSICS

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

const double _kDefaultDiameterRatio = 1.07;
const double _kDefaultPerspective = 0.003;
const double _kSqueeze = 1.45;

const double _kOverAndUnderCenterOpacity = 0.447;

class CustomCupertinoPicker extends StatefulWidget {
  CustomCupertinoPicker({
    Key? key,
    this.diameterRatio = _kDefaultDiameterRatio,
    this.backgroundColor,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    this.scrollController,
    this.squeeze = _kSqueeze,
    required this.itemExtent,
    required this.onSelectedItemChanged,
    required List<Widget> children,
    this.selectionOverlay =
        const CustomCupertinoPickerDefaultSelectionOverlay(),
    bool looping = false,
    this.axis = Axis.vertical,
  })  : assert(diameterRatio > 0.0,
            RenderListWheelViewport.diameterRatioZeroMessage),
        assert(magnification > 0),
        assert(itemExtent > 0),
        assert(squeeze > 0),
        childDelegate = looping
            ? ListWheelChildLoopingListDelegate(
                children: children
                    .map((e) => RotatedBox(
                          quarterTurns: axis == Axis.horizontal ? 1 : 0,
                          child: e,
                        ))
                    .toList())
            : ListWheelChildListDelegate(
                children: children
                    .map((e) => RotatedBox(
                          quarterTurns: axis == Axis.horizontal ? 1 : 0,
                          child: e,
                        ))
                    .toList()),
        super(key: key);

  CustomCupertinoPicker.builder({
    Key? key,
    this.diameterRatio = _kDefaultDiameterRatio,
    this.backgroundColor,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    this.scrollController,
    this.squeeze = _kSqueeze,
    required this.itemExtent,
    required this.onSelectedItemChanged,
    required NullableIndexedWidgetBuilder itemBuilder,
    int? childCount,
    this.selectionOverlay =
        const CustomCupertinoPickerDefaultSelectionOverlay(),
    this.axis = Axis.vertical,
  })  : assert(diameterRatio > 0.0,
            RenderListWheelViewport.diameterRatioZeroMessage),
        assert(magnification > 0),
        assert(itemExtent > 0),
        assert(squeeze > 0),
        childDelegate = ListWheelChildBuilderDelegate(
            builder: itemBuilder, childCount: childCount),
        super(key: key);

  final double diameterRatio;

  final Color? backgroundColor;

  final double offAxisFraction;

  final bool useMagnifier;

  final double magnification;

  final FixedExtentScrollController? scrollController;

  final double itemExtent;

  final double squeeze;

  final ValueChanged<int>? onSelectedItemChanged;

  final ListWheelChildDelegate childDelegate;

  final Widget? selectionOverlay;

  final Axis axis;

  @override
  State<StatefulWidget> createState() => _CustomCupertinoPickerState();
}

class _CustomCupertinoPickerState extends State<CustomCupertinoPicker> {
  int? _lastHapticIndex;
  FixedExtentScrollController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController == null) {
      _controller = FixedExtentScrollController();
    }
  }

  @override
  void didUpdateWidget(CustomCupertinoPicker oldWidget) {
    if (widget.scrollController != null && oldWidget.scrollController == null) {
      _controller = null;
    } else if (widget.scrollController == null &&
        oldWidget.scrollController != null) {
      assert(_controller == null);
      _controller = FixedExtentScrollController();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _handleSelectedItemChanged(int index) {
    // Only the haptic engine hardware on iOS devices would produce the
    // intended effects.
    final bool hasSuitableHapticHardware;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        hasSuitableHapticHardware = true;
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        hasSuitableHapticHardware = false;
        break;
    }
    if (hasSuitableHapticHardware && index != _lastHapticIndex) {
      _lastHapticIndex = index;
      HapticFeedback.selectionClick();
    }

    widget.onSelectedItemChanged?.call(index);
  }

  /// Draws the selectionOverlay.
  Widget _buildSelectionOverlay(Widget selectionOverlay) {
    final double height = widget.itemExtent * widget.magnification;

    return IgnorePointer(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(
            height: height,
          ),
          child: selectionOverlay,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color? resolvedBackgroundColor =
        CupertinoDynamicColor.maybeResolve(widget.backgroundColor, context);

    assert(RenderListWheelViewport.defaultPerspective == _kDefaultPerspective);
    final Widget result = DefaultTextStyle(
      style: CupertinoTheme.of(context).textTheme.pickerTextStyle,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: _CupertinoPickerSemantics(
              scrollController: widget.scrollController ?? _controller!,
              child: RotatedBox(
                quarterTurns: widget.axis == Axis.horizontal ? 3 : 0,
                child: ListWheelScrollView.useDelegate(
                  controller: widget.scrollController ?? _controller,
                  physics: const FixedExtentScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  diameterRatio: widget.diameterRatio,
                  offAxisFraction: widget.offAxisFraction,
                  useMagnifier: widget.useMagnifier,
                  magnification: widget.magnification,
                  overAndUnderCenterOpacity: _kOverAndUnderCenterOpacity,
                  itemExtent: widget.itemExtent,
                  squeeze: widget.squeeze,
                  onSelectedItemChanged: _handleSelectedItemChanged,
                  childDelegate: widget.childDelegate,
                ),
              ),
            ),
          ),
          if (widget.selectionOverlay != null)
            _buildSelectionOverlay(widget.selectionOverlay!),
        ],
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(color: resolvedBackgroundColor),
      child: result,
    );
  }
}

class CustomCupertinoPickerDefaultSelectionOverlay extends StatelessWidget {
  const CustomCupertinoPickerDefaultSelectionOverlay({
    Key? key,
    this.background = CupertinoColors.tertiarySystemFill,
    this.capLeftEdge = true,
    this.capRightEdge = true,
  }) : super(key: key);

  final bool capLeftEdge;

  final bool capRightEdge;

  final Color background;

  static const double _defaultSelectionOverlayHorizontalMargin = 9;

  static const double _defaultSelectionOverlayRadius = 8;

  @override
  Widget build(BuildContext context) {
    const Radius radius = Radius.circular(_defaultSelectionOverlayRadius);

    return Container(
      margin: EdgeInsets.only(
        left: capLeftEdge ? _defaultSelectionOverlayHorizontalMargin : 0,
        right: capRightEdge ? _defaultSelectionOverlayHorizontalMargin : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: capLeftEdge ? radius : Radius.zero,
          right: capRightEdge ? radius : Radius.zero,
        ),
        color: CupertinoDynamicColor.resolve(background, context),
      ),
    );
  }
}

class _CupertinoPickerSemantics extends SingleChildRenderObjectWidget {
  const _CupertinoPickerSemantics({
    Key? key,
    Widget? child,
    required this.scrollController,
  }) : super(key: key, child: child);

  final FixedExtentScrollController scrollController;

  @override
  RenderObject createRenderObject(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    return _RenderCupertinoPickerSemantics(
        scrollController, Directionality.of(context));
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant _RenderCupertinoPickerSemantics renderObject) {
    assert(debugCheckHasDirectionality(context));
    renderObject
      ..textDirection = Directionality.of(context)
      ..controller = scrollController;
  }
}

class _RenderCupertinoPickerSemantics extends RenderProxyBox {
  _RenderCupertinoPickerSemantics(
      FixedExtentScrollController controller, this._textDirection) {
    _updateController(null, controller);
  }

  FixedExtentScrollController get controller => _controller;
  late FixedExtentScrollController _controller;
  set controller(FixedExtentScrollController value) =>
      _updateController(_controller, value);

  void _updateController(FixedExtentScrollController? oldValue,
      FixedExtentScrollController value) {
    if (value == oldValue) return;
    if (oldValue != null) {
      oldValue.removeListener(_handleScrollUpdate);
    } else {
      _currentIndex = value.initialItem;
    }
    value.addListener(_handleScrollUpdate);
    _controller = value;
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (textDirection == value) return;
    _textDirection = value;
    markNeedsSemanticsUpdate();
  }

  int _currentIndex = 0;

  void _handleIncrease() {
    controller.jumpToItem(_currentIndex + 1);
  }

  void _handleDecrease() {
    if (_currentIndex == 0) return;
    controller.jumpToItem(_currentIndex - 1);
  }

  void _handleScrollUpdate() {
    if (controller.selectedItem == _currentIndex) return;
    _currentIndex = controller.selectedItem;
    // markNeedsSemanticsUpdate();
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.isSemanticBoundary = true;
    config.textDirection = textDirection;
  }

  @override
  void assembleSemanticsNode(SemanticsNode node, SemanticsConfiguration config,
      Iterable<SemanticsNode> children) {
    if (children.isEmpty) {
      return super.assembleSemanticsNode(node, config, children);
    }
    final SemanticsNode scrollable = children.first;
    final Map<int, SemanticsNode> indexedChildren = <int, SemanticsNode>{};
    scrollable.visitChildren((SemanticsNode child) {
      assert(child.indexInParent != null);
      indexedChildren[child.indexInParent!] = child;
      return true;
    });
    if (indexedChildren[_currentIndex] == null) {
      return node.updateWith(config: config);
    }
    config.value = indexedChildren[_currentIndex]!.label;
    final SemanticsNode? previousChild = indexedChildren[_currentIndex - 1];
    final SemanticsNode? nextChild = indexedChildren[_currentIndex + 1];
    if (nextChild != null) {
      config.increasedValue = nextChild.label;
      config.onIncrease = _handleIncrease;
    }
    if (previousChild != null) {
      config.decreasedValue = previousChild.label;
      config.onDecrease = _handleDecrease;
    }
    node.updateWith(config: config);
  }
}
