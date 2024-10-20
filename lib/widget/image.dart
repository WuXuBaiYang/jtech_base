import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/*
* 自定义图片
* @author wuxubaiyang
* @Time 2024/10/19 23:15
*/
class CustomImage extends StatefulWidget {
  // 图片代理
  final ImageProvider _image;

  // 宽度
  final double? width;

  // 高度
  final double? height;

  // 语义标签
  final String? semanticLabel;

  // 排除语义
  final bool excludeFromSemantics;

  // 颜色
  final Color? color;

  // 透明度
  final Animation<double>? opacity;

  // 颜色混合模式
  final BlendMode? colorBlendMode;

  // 适应模式
  final BoxFit fit;

  // 对齐方式
  final AlignmentGeometry alignment;

  // 重复模式
  final ImageRepeat repeat;

  // 中心切片
  final Rect? centerSlice;

  // 匹配文本方向
  final bool matchTextDirection;

  // 无缝回放
  final bool gaplessPlayback;

  // 是否抗锯齿
  final bool isAntiAlias;

  // 过滤质量
  final FilterQuality filterQuality;

  // 动画
  final Curve curve;

  // 动画时长
  final Duration animationDuration;

  // 边距
  final EdgeInsetsGeometry? margin;

  // 内边距
  final EdgeInsetsGeometry? padding;

  // 背景颜色
  final Color? backgroundColor;

  // 形状
  final BoxShape shape;

  // 边框半径
  final BorderRadius? borderRadius;

  // 帧构建
  final ImageFrameBuilder? frameBuilder;

  // 错误构建
  final ImageErrorWidgetBuilder? errorBuilder;

  // 加载构建
  final ImageLoadingBuilder? loadingBuilder;

  // 点击事件
  final GestureTapCallback? onTap;

  // 长按事件
  final GestureLongPressCallback? onLongPress;

  CustomImage({
    super.key,
    required ImageProvider image,
    Size? size,
    BoxFit? fit,
    double? width,
    double? height,
    BoxShape? shape,
    double? scaleByWidth, // 固定宽度等比缩放
    double? scaleByHeight, // 固定高度等比缩放
    this.color,
    this.onTap,
    this.margin,
    this.padding,
    this.opacity,
    this.centerSlice,
    this.onLongPress,
    this.borderRadius,
    this.frameBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.colorBlendMode,
    this.loadingBuilder,
    this.backgroundColor,
    this.isAntiAlias = false,
    this.curve = Curves.easeIn,
    this.gaplessPlayback = false,
    this.matchTextDirection = false,
    this.excludeFromSemantics = false,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.filterQuality = FilterQuality.medium,
    this.animationDuration = const Duration(milliseconds: 200),
  })  : _image = image,
        width = _computeScaleWidth(
            scaleByWidth, scaleByHeight, width, height, size),
        height = _computeScaleHeight(
            scaleByWidth, scaleByHeight, width, height, size),
        fit = _handleFit(fit, scaleByWidth, scaleByHeight),
        shape = _handleShape(shape, scaleByWidth, scaleByHeight);

  // 本地图片
  CustomImage.file(
    String path, {
    super.key,
    Size? size,
    BoxFit? fit,
    double? width,
    double? height,
    BoxShape? shape,
    double? scaleByWidth, // 固定宽度等比缩放
    double? scaleByHeight, // 固定高度等比缩放
    this.color,
    this.onTap,
    this.margin,
    this.padding,
    this.opacity,
    this.centerSlice,
    this.onLongPress,
    this.frameBuilder,
    this.errorBuilder,
    this.borderRadius,
    this.semanticLabel,
    double scale = 1.0,
    this.colorBlendMode,
    this.backgroundColor,
    this.isAntiAlias = false,
    this.curve = Curves.easeIn,
    this.gaplessPlayback = false,
    this.matchTextDirection = false,
    this.excludeFromSemantics = false,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.filterQuality = FilterQuality.medium,
    this.animationDuration = const Duration(milliseconds: 200),
  })  : _image = FileImage(File(path), scale: scale),
        loadingBuilder = null,
        width = _computeScaleWidth(
            scaleByWidth, scaleByHeight, width, height, size),
        height = _computeScaleHeight(
            scaleByWidth, scaleByHeight, width, height, size),
        fit = _handleFit(fit, scaleByWidth, scaleByHeight),
        shape = _handleShape(shape, scaleByWidth, scaleByHeight);

  // asset图片
  CustomImage.asset(
    String assetName, {
    super.key,
    Size? size,
    BoxFit? fit,
    double? width,
    double? height,
    BoxShape? shape,
    double? scaleByWidth, // 固定宽度等比缩放
    double? scaleByHeight, // 固定高度等比缩放
    this.color,
    this.onTap,
    this.margin,
    this.padding,
    this.opacity,
    String? package,
    this.centerSlice,
    this.onLongPress,
    this.frameBuilder,
    this.errorBuilder,
    this.borderRadius,
    this.semanticLabel,
    AssetBundle? bundle,
    this.colorBlendMode,
    this.backgroundColor,
    this.isAntiAlias = false,
    this.curve = Curves.easeIn,
    this.gaplessPlayback = false,
    this.matchTextDirection = false,
    this.excludeFromSemantics = false,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.filterQuality = FilterQuality.medium,
    this.animationDuration = const Duration(milliseconds: 200),
  })  : _image = AssetImage(assetName, bundle: bundle, package: package),
        loadingBuilder = null,
        width = _computeScaleWidth(
            scaleByWidth, scaleByHeight, width, height, size),
        height = _computeScaleHeight(
            scaleByWidth, scaleByHeight, width, height, size),
        fit = _handleFit(fit, scaleByWidth, scaleByHeight),
        shape = _handleShape(shape, scaleByWidth, scaleByHeight);

  // 内存图片
  CustomImage.memory(
    Uint8List bytes, {
    super.key,
    Size? size,
    BoxFit? fit,
    double? width,
    double? height,
    BoxShape? shape,
    double? scaleByWidth, // 固定宽度等比缩放
    double? scaleByHeight, // 固定高度等比缩放
    this.color,
    this.onTap,
    this.margin,
    this.padding,
    this.opacity,
    this.centerSlice,
    this.onLongPress,
    this.frameBuilder,
    this.errorBuilder,
    this.borderRadius,
    double scale = 1.0,
    this.semanticLabel,
    this.colorBlendMode,
    this.backgroundColor,
    this.isAntiAlias = false,
    this.curve = Curves.easeIn,
    this.gaplessPlayback = false,
    this.matchTextDirection = false,
    this.excludeFromSemantics = false,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.filterQuality = FilterQuality.medium,
    this.animationDuration = const Duration(milliseconds: 200),
  })  : _image = MemoryImage(bytes, scale: scale),
        loadingBuilder = null,
        width = _computeScaleWidth(
            scaleByWidth, scaleByHeight, width, height, size),
        height = _computeScaleHeight(
            scaleByWidth, scaleByHeight, width, height, size),
        fit = _handleFit(fit, scaleByWidth, scaleByHeight),
        shape = _handleShape(shape, scaleByWidth, scaleByHeight);

  // 网络图片
  CustomImage.network(
    String url, {
    super.key,
    Size? size,
    BoxFit? fit,
    double? width,
    double? height,
    BoxShape? shape,
    double? scaleByWidth, // 固定宽度等比缩放
    double? scaleByHeight, // 固定高度等比缩放
    this.color,
    this.onTap,
    this.margin,
    this.padding,
    this.opacity,
    int? maxWidth,
    int? maxHeight,
    String? cacheKey,
    this.centerSlice,
    this.onLongPress,
    this.frameBuilder,
    this.errorBuilder,
    this.borderRadius,
    double scale = 1.0,
    this.semanticLabel,
    this.colorBlendMode,
    this.loadingBuilder,
    this.backgroundColor,
    this.isAntiAlias = false,
    this.curve = Curves.easeIn,
    Map<String, String>? headers,
    this.gaplessPlayback = false,
    BaseCacheManager? cacheManager,
    this.matchTextDirection = false,
    this.excludeFromSemantics = false,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    void Function(Object)? errorListener,
    this.filterQuality = FilterQuality.medium,
    this.animationDuration = const Duration(milliseconds: 200),
  })  : _image = CachedNetworkImageProvider(
          url,
          scale: scale,
          headers: headers,
          cacheKey: cacheKey,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          cacheManager: cacheManager,
          errorListener: errorListener,
        ),
        width = _computeScaleWidth(
            scaleByWidth, scaleByHeight, width, height, size),
        height = _computeScaleHeight(
            scaleByWidth, scaleByHeight, width, height, size),
        fit = _handleFit(fit, scaleByWidth, scaleByHeight),
        shape = _handleShape(shape, scaleByWidth, scaleByHeight);

  @override
  State<CustomImage> createState() => _CustomImageState();
}

// 处理图片形状(当设置等比缩放时，强制为矩形)
BoxShape _handleShape(
    BoxShape? shape, double? scaleByWidth, double? scaleByHeight) {
  if (scaleByWidth != null || scaleByHeight != null) return BoxShape.rectangle;
  return shape ?? BoxShape.rectangle;
}

// 处理图片填充方式(当设置等比缩放时，强制为填充)
BoxFit _handleFit(BoxFit? fit, double? scaleByWidth, double? scaleByHeight) {
  if (fit != null) return fit;
  return (scaleByWidth != null || scaleByHeight != null)
      ? BoxFit.fill
      : BoxFit.cover;
}

// 计算等比缩放
(double?, double?) _computeScale(double? scaleByWidth, double? scaleByHeight,
    double? width, double? height, Size? size) {
  width = width ?? size?.width;
  height = height ?? size?.height;
  assert(scaleByWidth == null || scaleByHeight == null, '等比缩放宽高不能同时赋值');
  assert(
      (scaleByWidth ?? scaleByHeight) == null ||
          (width != null && height != null),
      '当设置等比缩放时，宽高不能为空');
  return (width, height);
}

// 计算等比缩放宽度
double? _computeScaleWidth(double? scaleByWidth, double? scaleByHeight,
    double? width, double? height, Size? size) {
  final (w, h) =
      _computeScale(scaleByWidth, scaleByHeight, width, height, size);
  if (scaleByWidth != null) return scaleByWidth;
  if (scaleByHeight != null) return (w! / h!) * scaleByHeight;
  return w;
}

// 计算等比缩放高度
double? _computeScaleHeight(double? scaleByWidth, double? scaleByHeight,
    double? width, double? height, Size? size) {
  final (w, h) =
      _computeScale(scaleByWidth, scaleByHeight, width, height, size);
  if (scaleByHeight != null) return scaleByHeight;
  if (scaleByWidth != null) return (h! / w!) * scaleByWidth;
  return h;
}

class _CustomImageState extends State<CustomImage>
    with SingleTickerProviderStateMixin {
  // 动画管理
  late final _controller =
      AnimationController(vsync: this, duration: widget.animationDuration);

  // 默认动画
  late final _animation = Tween(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(parent: _controller, curve: widget.curve));

  @override
  Widget build(BuildContext context) {
    final borderRadius =
        widget.shape == BoxShape.rectangle ? widget.borderRadius : null;
    final decoration = BoxDecoration(
      shape: widget.shape,
      borderRadius: borderRadius,
      color: widget.backgroundColor,
    );
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Container(
        margin: widget.margin,
        padding: widget.padding,
        decoration: decoration,
        clipBehavior: Clip.antiAlias,
        child: _buildImage(context),
      ),
    );
  }

  // 构建图片
  Widget _buildImage(BuildContext context) {
    return Image(
      fit: widget.fit,
      color: widget.color,
      width: widget.width,
      image: widget._image,
      height: widget.height,
      repeat: widget.repeat,
      alignment: widget.alignment,
      centerSlice: widget.centerSlice,
      isAntiAlias: widget.isAntiAlias,
      semanticLabel: widget.semanticLabel,
      filterQuality: widget.filterQuality,
      opacity: widget.opacity ?? _animation,
      colorBlendMode: widget.colorBlendMode,
      gaplessPlayback: widget.gaplessPlayback,
      matchTextDirection: widget.matchTextDirection,
      excludeFromSemantics: widget.excludeFromSemantics,
      frameBuilder: widget.frameBuilder ?? _buildFrameImage,
      errorBuilder: widget.errorBuilder ?? _buildErrorImage,
      loadingBuilder: widget.loadingBuilder ?? _buildLoadingImage,
    );
  }

  // 判断是否为网络图片
  bool get _isNetworkImage => widget._image is CachedNetworkImageProvider;

  // 构建帧图片
  Widget _buildFrameImage(BuildContext context, Widget child, int? frame,
      bool wasSynchronouslyLoaded) {
    if (frame != null) _playAnimation();
    return _clipImage(child);
  }

  // 裁剪图片
  Widget _clipImage(Widget child) {
    if (widget.shape == BoxShape.rectangle && widget.borderRadius != null) {
      return ClipRRect(borderRadius: widget.borderRadius!, child: child);
    }
    if (widget.shape == BoxShape.circle) return ClipOval(child: child);
    return child;
  }

  // 构建加载图片
  Widget _buildLoadingImage(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (!_isNetworkImage) return child;

    /// TODO 加载图片
    return child;
  }

  // 构建错误图片
  Widget _buildErrorImage(
      BuildContext context, Object error, StackTrace? stackTrace) {
    /// TODO 错误图片
    return SizedBox();
  }

  // 播放动画
  TickerFuture? _playAnimation() {
    if (widget.opacity != null) return null;
    if (_controller.isCompleted) return null;
    return _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
