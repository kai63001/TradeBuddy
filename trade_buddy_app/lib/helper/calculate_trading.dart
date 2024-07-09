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

double calculateProfit({
  required String tradeSide,
  required String type,
  required double entryPrice,
  required double exitPrice,
  required double quantity, // Represents lot size for FOREX, contract size for FUTURE and OPTION, shares for STOCK
  double? trickSize = 1,
  double? trickValue = 1,
}) {
  double priceDifference = exitPrice - entryPrice;
  if (tradeSide == 'SHORT') {
    priceDifference = entryPrice - exitPrice;
  }

  // Adjust the profit calculation based on the type of trade
  double grossProfit = 0;
  switch (type) {
    case 'FOREX':
      // For FOREX, the profit calculation uses the lot size directly (assuming each lot represents 100,000 units)
      grossProfit = priceDifference * quantity;
      break;
    case 'STOCK':
      // Stocks use the number of shares directly
      grossProfit = priceDifference * quantity;
      break;
    case 'OPTION':
      grossProfit = priceDifference * quantity * 100;
      break;
    case 'FUTURE':
      // For OPTIONS and FUTURES, the profit calculation uses the contract size directly
      if (trickSize == null || trickValue == null) {
        throw Exception('Contract size and value must be provided for FUTURE and OPTION trades');
      } 
      grossProfit = (priceDifference / trickSize) * trickValue * quantity;
      break;
    default:
      throw Exception('Trade type not supported');
  }

  // Assuming no other costs, net profit is equal to gross profit in this simplified example
  double netProfit = grossProfit;

  return netProfit;
}