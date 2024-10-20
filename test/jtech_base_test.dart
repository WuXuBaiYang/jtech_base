import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test', () {
    a(1, null, null, null, Size(100, 200));
  });
}

void a(double? scaleByWidth, double? scaleByHeight, double? width,
    double? height, Size? size) {
  assert(scaleByWidth == null || scaleByHeight == null, '等比缩放宽高不能同时赋值');
  assert(
      (scaleByWidth ?? scaleByHeight) == null ||
          ((width ?? size?.width) != null &&
              (height ?? size?.height) != null),
      '当设置等比缩放时，宽高不能为空');
  print('-----------------------');
}
