import 'package:intl/intl.dart';

// 日期方法扩展
extension DatetimeExtension on DateTime {
  // 日期格式化
  String format(String pattern) => DateFormat(pattern).format(this);
}

// duration方法扩展
extension DurationExtension on Duration {
  // 格式化
  String format(String format) {
    // 处理负数
    final isNegative = inMicroseconds < 0;
    final absDuration = abs();

    // 1. 提取格式字符串中的所有时间单位（d/h/m/s/f），并确定最左侧的单位
    final units = _extractUnits(format);
    final String? primaryUnit = units.isNotEmpty ? units.first : null;

    // 2. 计算各单位的数值（区分累加值/周期值）
    final values = _calculateValues(absDuration, primaryUnit);

    // 3. 替换格式字符串中的占位符
    String result = format;
    result = _replacePlaceholder(result, 'd', values['d']!);
    result = _replacePlaceholder(result, 'h', values['h']!);
    result = _replacePlaceholder(result, 'm', values['m']!);
    result = _replacePlaceholder(result, 's', values['s']!);
    result = _replacePlaceholder(result, 'f', values['f']!);

    // 添加负号
    return isNegative ? '-$result' : result;
  }

  // 提取格式字符串中的时间单位（去重，按出现顺序）
  List<String> _extractUnits(String format) {
    final unitRegex = RegExp(r'[dhmsf]');
    final matches = unitRegex.allMatches(format);
    final units = <String>[];
    for (final match in matches) {
      final unit = match.group(0)!;
      if (!units.contains(unit)) {
        units.add(unit);
      }
    }
    return units;
  }

  /// 根据最左侧单位，计算各单位的数值（累加值/周期值）
  Map<String, int> _calculateValues(Duration duration, String? primaryUnit) {
    final values = <String, int>{};
    // 基础周期值（所有单位默认取周期值）
    values['d'] = duration.inDays; // 天的周期值=总天数（无周期，本身就是累加）
    values['h'] = duration.inHours.remainder(24); // 小时周期值（0-23）
    values['m'] = duration.inMinutes.remainder(60); // 分钟周期值（0-59）
    values['s'] = duration.inSeconds.remainder(60); // 秒周期值（0-59）
    values['f'] = duration.inMilliseconds.remainder(1000); // 毫秒周期值（0-999）
    // 最左侧单位替换为累加值
    if (primaryUnit != null) {
      switch (primaryUnit) {
        case 'd':
          values['d'] = duration.inDays; // 天本身就是累加值，无需调整
          break;
        case 'h':
          values['h'] = duration.inHours; // 小时累加值（总小时数，不÷24）
          break;
        case 'm':
          values['m'] = duration.inMinutes; // 分钟累加值（总分钟数，不÷60）
          break;
        case 's':
          values['s'] = duration.inSeconds; // 秒累加值（总秒数，不÷60）
          break;
        case 'f':
          values['f'] = duration.inMilliseconds; // 毫秒累加值（总毫秒数，不÷1000）
          break;
      }
    }
    return values;
  }

  // 替换单个占位符（补零逻辑）
  String _replacePlaceholder(String format, String unit, int value) {
    final regex = RegExp('($unit)+');
    return format.replaceAllMapped(regex, (match) {
      final placeholder = match.group(0)!;
      final length = placeholder.length;
      return value.toString().padLeft(length, '0');
    });
  }

  // duration相减
  Duration subtract(Duration duration) {
    duration.isNotEmpty;
    if (duration.compareTo(this) >= 1) return const Duration();
    return Duration(microseconds: inMicroseconds - duration.inMicroseconds);
  }

  // duration相加
  Duration add(Duration duration) =>
      Duration(microseconds: inMicroseconds + duration.inMicroseconds);

  // duration乘法
  Duration multiply(num n) =>
      Duration(microseconds: (inMicroseconds * n).toInt());

  // duration除法
  double divide(Duration duration) {
    if (isEmpty || duration.isEmpty) return 0.0;
    return inMicroseconds / duration.inMicroseconds.toDouble();
  }

  // 比较差值
  Duration difference(Duration duration) =>
      Duration(microseconds: (inMicroseconds - duration.inMicroseconds).abs());

  // 小于
  bool lessThan(Duration duration) => compareTo(duration) < 0;

  // 小于0
  bool get lessThanZero => compareTo(Duration.zero) < 0;

  // 小于等于
  bool lessEqualThan(Duration duration) => compareTo(duration) <= 0;

  // 小于等于0
  bool get lessEqualThanZero => compareTo(Duration.zero) <= 0;

  // 大于
  bool greaterThan(Duration duration) => compareTo(duration) > 0;

  // 大于0
  bool get greaterThanZero => compareTo(Duration.zero) > 0;

  // 大于等于
  bool greaterEqualThan(Duration duration) => compareTo(duration) >= 0;

  // 大于等于0
  bool get greaterEqualThanZero => compareTo(Duration.zero) >= 0;

  // 等于
  bool equal(Duration duration) => compareTo(duration) == 0;

  // 等于0
  bool get equalZero => compareTo(Duration.zero) == 0;

  // 判断是否等于0
  bool get isEmpty => inMicroseconds == 0;

  // 判断是否非0
  bool get isNotEmpty => inMicroseconds != 0;
}

// 日期格式化模型
class DatePattern {
  // 完整日期/时间格式
  static const String fullDateTime = 'yyyy-MM-dd HH:mm:ss';

  // 简略日期/时间格式
  static const String dateTime = 'MM-dd HH:mm';

  // 完整日期格式
  static const String fullDate = 'yyyy-MM-dd';

  // 简略日期格式
  static const String date = 'MM-dd';

  // 完整时间格式
  static const String fullTime = 'HH:mm:ss';

  // 简略时间格式
  static const String time = 'HH:mm';

  // 日期签名格式
  static const String dateSign = 'yyyyMMddHHmmssSSS';

  // 无秒展示格式
  static const String fullDateTimeNoSecond = 'yyyy-MM-dd HH:mm';
}

// 时长格式化模型
class DurationPattern {
  // 完整格式
  static const String fullDateTime = 'dd:HH:mm:ss';

  // 完整时分秒格式
  static const String fullTime = 'HH:mm:ss';

  // 简略时分格式
  static const String hourMinute = 'HH:mm';

  // 简略分秒格式
  static const String minuteSecond = 'mm:ss';
}
