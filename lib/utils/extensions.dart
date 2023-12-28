import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  String get formattedTime {
    String hour =
        this.hour.toString().length == 1 ? "0${this.hour}" : "${this.hour}";
    String min = minute.toString().length == 1 ? "0$minute" : "$minute";
    String suffix = this.hour < 12 ? "am" : "pm";
    return "$hour : $min  $suffix";
  }

  String getFormattedDate({bool? abbreviated = true}) {
    final months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    final monthsAbbrs = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    if (DateTime.now().day.compareTo(day) == 0) {
      return "Today";
    } else if (day.compareTo(DateTime.now().day) == -1) {
      return "Yesterday";
    } else {
      if (abbreviated!) {
        return ' ${monthsAbbrs[month]}, $year';
      } else {
        return '${months[month]}, $year';
      }
    }
  }
}

extension BuildContextExtensions on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;

  // navigation

  void push(Widget screen) {
    Navigator.push(this, MaterialPageRoute(builder: (context) {
      return screen;
    }));
  }

  void pop() {
    Navigator.pop(this);
  }
}

extension WidgetExtensions on Widget {
  Widget padX(double? size) => Padding(
        padding: EdgeInsets.symmetric(horizontal: size!),
        child: this,
      );

  Widget padY(double? size) => Padding(
        padding: EdgeInsets.symmetric(vertical: size!),
        child: this,
      );

  Widget padAll(double? size) => Padding(
        padding: EdgeInsets.all(size!),
        child: this,
      );
}
