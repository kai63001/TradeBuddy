import 'dart:ui';

import 'package:intl/intl.dart';

DateFormat formattedDate = DateFormat('yyyy-MM-dd');

Color calculateColorCalendar(
    String date, List<String> redDay, List<String> greenDay) {
  String dateFormat = formattedDate.format(DateTime.parse(date));
  if (redDay.contains(dateFormat)) {
    return const Color(0xffFF0E37);
  } else if (greenDay.contains(dateFormat)) {
    return const Color(0xff00D6BF);
  } else {
    return const Color(0xff2B2B2F);
  }
}

Color calculateRedDayOrGreenColor(String date,
    Map<String, List<Map<String, dynamic>>> state, String profileId) {
  print('data');
  print(state);
  print(profileId);
  String dateFormat = formattedDate.format(DateTime.parse(date));
  //no status have only tradeSide long and short and entry and exit price
  List<Map<String, dynamic>> trades = state[profileId] ?? [];
  // and 1 day have multiple trade if have loosing trade more than winning trade then red
  // if have winning trade more than loosing trade then green
  int red = 0;
  int green = 0;
  for (int i = 0; i < trades.length; i++) {
    if (formattedDate.format(DateTime.parse(trades[i]['date'])) == dateFormat) {
      if (trades[i]['tradeSide'] == 'LONG') {
        if (trades[i]['entryPrice'] > trades[i]['exitPrice']) {
          red++;
        } else {
          green++;
        }
      } else {
        if (trades[i]['entryPrice'] < trades[i]['exitPrice']) {
          red++;
        } else {
          green++;
        }
      }
    }
  }

  if (red > green) {
    return const Color(0xffFF0E37);
  } else if (green > red) {
    return const Color(0xff00D6BF);
  } else if (green == red && (green != 0 || red != 0)) {
    return const Color.fromARGB(255, 31, 31, 31);
  }

  return const Color(0xff2B2B2F);
}
