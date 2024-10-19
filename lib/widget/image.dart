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

  // 尺寸
  final Size? size;

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

  const CustomImage({
    super.key,
    required ImageProvider image,
    this.size,
    this.color,
    this.margin,
    this.padding,
    this.opacity,
    this.centerSlice,
    this.borderRadius,
    this.frameBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.colorBlendMode,
    this.loadingBuilder,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.isAntiAlias = false,
    this.curve = Curves.easeIn,
    this.gaplessPlayback = false,
    this.shape = BoxShape.rectangle,
    this.matchTextDirection = false,
    this.excludeFromSemantics = false,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.filterQuality = FilterQuality.medium,
    this.animationDuration = const Duration(milliseconds: 200),
  }) : _image = image;

  // 本地图片
  CustomImage.file(
    String path, {
    super.key,
    this.size,
    this.color,
    this.margin,
    this.padding,
    this.opacity,
    this.centerSlice,
    this.frameBuilder,
    this.errorBuilder,
    this.borderRadius,
    this.semanticLabel,
    double scale = 1.0,
    this.colorBlendMode,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.isAntiAlias = false,
    this.curve = Curves.easeIn,
    this.gaplessPlayback = false,
    this.shape = BoxShape.rectangle,
    this.matchTextDirection = false,
    this.excludeFromSemantics = false,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.filterQuality = FilterQuality.medium,
    this.animationDuration = const Duration(milliseconds: 200),
  })  : _image = FileImage(File(path), scale: scale),
        loadingBuilder = null;

  // asset图片
  CustomImage.asset(
    String assetName, {
    super.key,
    this.size,
    this.color,
    this.margin,
    this.padding,
    this.opacity,
    String? package,
    this.centerSlice,
    this.frameBuilder,
    this.errorBuilder,
    this.borderRadius,
    this.semanticLabel,
    AssetBundle? bundle,
    this.colorBlendMode,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.isAntiAlias = false,
    this.curve = Curves.easeIn,
    this.gaplessPlayback = false,
    this.shape = BoxShape.rectangle,
    this.matchTextDirection = false,
    this.excludeFromSemantics = false,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.filterQuality = FilterQuality.medium,
    this.animationDuration = const Duration(milliseconds: 200),
  })  : _image = AssetImage(assetName, bundle: bundle, package: package),
        loadingBuilder = null;

  // 内存图片
  CustomImage.memory(
    Uint8List bytes, {
    super.key,
    this.size,
    this.color,
    this.margin,
    this.padding,
    this.opacity,
    this.centerSlice,
    this.frameBuilder,
    this.errorBuilder,
    this.borderRadius,
    double scale = 1.0,
    this.semanticLabel,
    this.colorBlendMode,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.isAntiAlias = false,
    this.curve = Curves.easeIn,
    this.gaplessPlayback = false,
    this.shape = BoxShape.rectangle,
    this.matchTextDirection = false,
    this.excludeFromSemantics = false,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.filterQuality = FilterQuality.medium,
    this.animationDuration = const Duration(milliseconds: 200),
  })  : _image = MemoryImage(bytes, scale: scale),
        loadingBuilder = null;

  // 网络图片
  CustomImage.network(
    String url, {
    super.key,
    this.size,
    this.color,
    this.margin,
    this.padding,
    this.opacity,
    int? maxWidth,
    int? maxHeight,
    String? cacheKey,
    this.centerSlice,
    this.frameBuilder,
    this.errorBuilder,
    this.borderRadius,
    double scale = 1.0,
    this.semanticLabel,
    this.colorBlendMode,
    this.loadingBuilder,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.isAntiAlias = false,
    this.curve = Curves.easeIn,
    Map<String, String>? headers,
    this.gaplessPlayback = false,
    BaseCacheManager? cacheManager,
    this.shape = BoxShape.rectangle,
    this.matchTextDirection = false,
    this.excludeFromSemantics = false,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    void Function(Object)? errorListener,
    this.filterQuality = FilterQuality.medium,
    this.animationDuration = const Duration(milliseconds: 200),
  }) : _image = CachedNetworkImageProvider(
          url,
          scale: scale,
          headers: headers,
          cacheKey: cacheKey,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          cacheManager: cacheManager,
          errorListener: errorListener,
        );

  @override
  State<CustomImage> createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage> {
  // 记录图片代理
  ImageProvider? _cachedImage;

  @override
  Widget build(BuildContext context) {
    final borderRadius =
        widget.shape == BoxShape.rectangle ? widget.borderRadius : null;
    final decoration = BoxDecoration(
      shape: widget.shape,
      borderRadius: borderRadius,
      color: widget.backgroundColor,
    );
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      decoration: decoration,
      clipBehavior: Clip.antiAlias,
      child: _buildImage(context),
    );
  }

  // 构建图片
  Widget _buildImage(BuildContext context) {
    return Image(
      fit: widget.fit,
      color: widget.color,
      image: widget._image,
      repeat: widget.repeat,
      opacity: widget.opacity,
      width: widget.size?.width,
      height: widget.size?.height,
      alignment: widget.alignment,
      centerSlice: widget.centerSlice,
      isAntiAlias: widget.isAntiAlias,
      semanticLabel: widget.semanticLabel,
      filterQuality: widget.filterQuality,
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
    if (_cachedImage == widget._image) return _clipImage(child);
    if (wasSynchronouslyLoaded) _cachedImage = widget._image;
    return AnimatedOpacity(
      curve: Curves.easeIn,
      duration: Duration(seconds: 1),
      opacity: frame == null ? 0 : 1,
      child: _clipImage(child),
    );
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

    /// TODO 加载网络图片
    return child;
  }

  // 构建错误图片
  Widget _buildErrorImage(
      BuildContext context, Object error, StackTrace? stackTrace) {
    return SizedBox();
  }
}
