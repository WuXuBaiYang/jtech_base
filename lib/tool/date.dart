import 'package:intl/intl.dart';

// 日期方法扩展
extension DatetimeExtension on DateTime {
  // 日期格式化
  String format(String pattern) => DateFormat(pattern).format(this);
}

// 时长格式化替换表
final Map<String, String Function(DateTime date, Duration dur)>
    _durationFormatRegMap = {
  'xxx': (date, _) => '${date.millisecond}'.padLeft(3, '0'),
  'dd': (_, dur) => '${dur.inDays}'.padLeft(2, '0'),
  'HH': (_, dur) => '${dur.inHours}'.padLeft(2, '0'),
  'mm': (date, _) => '${date.minute}'.padLeft(2, '0'),
  'ss': (date, _) => '${date.second}'.padLeft(2, '0'),
  'xx': (date, _) => '${date.millisecond}'.padLeft(2, '0'),
  'd': (_, dur) => '${dur.inDays}',
  'h': (_, dur) => '${dur.inHours}',
  'm': (date, _) => '${date.minute}',
  's': (date, _) => '${date.second}',
  'x': (date, _) => '${date.millisecond}',
};

// duration方法扩展
extension DurationExtension on Duration {
  // 时长格式化
  String format(String pattern) {
    DateTime date = DateTime(0).add(this);
    _durationFormatRegMap.forEach((key, fun) {
      if (pattern.contains(key)) {
        final value = fun(date, this);
        pattern = pattern.replaceAll(key, value);
      }
    });
    return pattern;
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

// 尝试解析duration
Duration? tryParseDuration(String durationString) {
  if (durationString.isEmpty) return null;
  final parts = durationString.split(':');
  int? hours = 0, minutes = 0, seconds = 0;
  if (parts.length == 3) {
    hours = int.tryParse(parts[0]);
    minutes = int.tryParse(parts[1]);
    seconds = int.tryParse(parts[2]);
    if (hours == null || minutes == null || seconds == null) return null;
  } else if (parts.length == 2) {
    minutes = int.tryParse(parts[0]);
    seconds = int.tryParse(parts[1]);
    if (minutes == null || seconds == null) return null;
  }
  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}
