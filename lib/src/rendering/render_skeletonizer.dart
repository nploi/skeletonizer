import 'package:flutter/rendering.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/painting/skeletonizer_painting_context.dart';

/// Builds a renderer object that overrides the painting operation
/// and provides a [SkeletonizerPaintingContext] to paint the skeleton effect
class RenderSkeletonizer extends RenderProxyBox with _RenderSkeletonBase<RenderBox> {
  /// Default constructor
  RenderSkeletonizer({
    required TextDirection textDirection,
    required double animationValue,
    required SkeletonizerConfigData config,
    required bool ignorePointers,
    required bool isZone,
    required bool enabled,
    RenderBox? child,
  })  : _animationValue = animationValue,
        _textDirection = textDirection,
        _config = config,
        _isZone = isZone,
        _ignorePointers = ignorePointers,
        _enabled = enabled,
        super(child);

  bool _enabled;

  @override
  bool get enabled => _enabled;

  set enabled(bool value) {
    if (_enabled != value) {
      _enabled = value;
      markNeedsPaint();
    }
  }

  TextDirection _textDirection;

  @override
  TextDirection get textDirection => _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection != value) {
      _textDirection = value;
      markNeedsPaint();
    }
  }

  SkeletonizerConfigData _config;

  @override
  SkeletonizerConfigData get config => _config;

  set config(SkeletonizerConfigData value) {
    if (_config != value) {
      _config = value;
      markNeedsPaint();
    }
  }

  bool _ignorePointers;

  set ignorePointers(bool value) {
    if (_ignorePointers != value) {
      _ignorePointers = value;
      markNeedsPaint();
    }
  }

  bool _isZone;

  set isZone(bool value) {
    if (_isZone != value) {
      _isZone = value;
      markNeedsPaint();
    }
  }

  @override
  bool get isZone => _isZone;

  double _animationValue = 0;

  @override
  double get animationValue => _animationValue;

  set animationValue(double value) {
    if (_animationValue != value) {
      _animationValue = value;
      markNeedsPaint();
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (enabled && _ignorePointers) return false;
    return super.hitTest(result, position: position);
  }
}

/// Builds a sliver renderer object that overrides the painting operation
/// and provides a [SkeletonizerPaintingContext] to paint the skeleton effect
class RenderSliverSkeletonizer extends RenderProxySliver with _RenderSkeletonBase<RenderSliver> {
  /// Default constructor
  RenderSliverSkeletonizer({
    required TextDirection textDirection,
    required double animationValue,
    required SkeletonizerConfigData config,
    required bool ignorePointers,
    required bool isZone,
    required bool enabled,
    RenderSliver? child,
  })  : _animationValue = animationValue,
        _textDirection = textDirection,
        _config = config,
        _isZone = isZone,
        _ignorePointers = ignorePointers,
        _enabled = enabled,
        super(child);

  bool _enabled;

  @override
  bool get enabled => _enabled;

  set enabled(bool value) {
    if (_enabled != value) {
      _enabled = value;
      markNeedsPaint();
    }
  }

  TextDirection _textDirection;

  @override
  TextDirection get textDirection => _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection != value) {
      _textDirection = value;
      markNeedsPaint();
    }
  }

  SkeletonizerConfigData _config;

  @override
  SkeletonizerConfigData get config => _config;

  set config(SkeletonizerConfigData value) {
    if (_config != value) {
      _config = value;
      markNeedsPaint();
    }
  }

  bool _ignorePointers;

  set ignorePointers(bool value) {
    if (_ignorePointers != value) {
      _ignorePointers = value;
    }
  }

  bool _isZone;

  set isZone(bool value) {
    if (_isZone != value) {
      _isZone = value;
      markNeedsPaint();
    }
  }

  @override
  bool get isZone => _isZone;

  double _animationValue = 0;

  @override
  double get animationValue => _animationValue;

  set animationValue(double value) {
    if (_animationValue != value) {
      _animationValue = value;
      markNeedsPaint();
    }
  }

  @override
  bool hitTest(
    SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    if (enabled && _ignorePointers) return false;
    return super.hitTest(
      result,
      mainAxisPosition: mainAxisPosition,
      crossAxisPosition: crossAxisPosition,
    );
  }
}

mixin _RenderSkeletonBase<R extends RenderObject> on RenderObjectWithChildMixin<R> {
  /// Whether skeletonizing is enabled
  bool get enabled;

  /// The text direction used to resolve Directional geometries
  TextDirection get textDirection;

  /// The resolved skeletonizer theme data
  SkeletonizerConfigData get config;

  /// The value to animate painting effects
  double get animationValue;

  /// if true, only [Bone] and [Skeletonizer] widgets will be shaded
  bool get isZone;

  @override
  bool get alwaysNeedsCompositing => true;

  SkeletonizerPaintingContext createSkeletonizerContext(
    ContainerLayer layer,
    Offset offset,
  ) {
    final estimatedBounds = paintBounds.shift(offset);
    final shaderPaint = config.effect.createPaint(
      animationValue,
      estimatedBounds,
      textDirection,
    );
    return SkeletonizerPaintingContext(
      layer: layer,
      animationValue: animationValue,
      estimatedBounds: estimatedBounds,
      shaderPaint: shaderPaint,
      config: config,
      isZone: isZone,
    );
  }

  @override
  OffsetLayer? get layer => super.layer as OffsetLayer?;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!enabled) {
      super.paint(context, offset);
      return;
    }
    layer ??= OffsetLayer();
    if (layer!.hasChildren) {
      layer!.removeAllChildren();
    }
    context.addLayer(layer!);
    final skeletonizerContext = createSkeletonizerContext(layer!, offset);
    super.paint(skeletonizerContext, offset);
    skeletonizerContext.stopRecordingIfNeeded();
  }
}
