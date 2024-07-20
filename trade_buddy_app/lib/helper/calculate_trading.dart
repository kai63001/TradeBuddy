import 'package:flutter/material.dart';
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

  double profit = 0;
  for (int i = 0; i < trades.length; i++) {
    if (formattedDate.format(DateTime.parse(trades[i]['date'])) == dateFormat) {
      if (trades[i]['netProfit'] != null) {
        profit += trades[i]['netProfit'];
      }
    }
  }

  if (profit > 0) {
    return const Color(0xff00D6BF);
  } else if (profit < 0) {
    return const Color(0xffFF0E37);
  } else {
    return const Color(0xff2B2B2F);
  }
}

double calculateProfit({
  required String tradeSide,
  required String type,
  required double entryPrice,
  required double exitPrice,
  required double
      quantity, // Represents lot size for FOREX, contract size for FUTURE and OPTION, shares for STOCK
  dynamic trickSize = 1,
  dynamic trickValue = 1,
}) {
  double priceDifference = exitPrice - entryPrice;
  if (tradeSide == 'SHORT') {
    priceDifference = entryPrice - exitPrice;
  }

  double tickSize = double.parse(trickSize.toString());
  double tickValue = double.parse(trickValue.toString());

  // Adjust the profit calculation based on the type of trade
  double grossProfit = 0;
  switch (type) {
    case 'FOREX':
      // For FOREX, the profit calculation uses the lot size directly (assuming each lot represents 100,000 units)
      grossProfit = priceDifference * quantity * 100;
      break;
    case 'STOCK':
      // Stocks use the number of shares directly
      grossProfit = priceDifference * quantity;
      break;
    case 'OPTION':
      grossProfit = priceDifference * quantity * 100;
      break;
    case 'FUTURES':
      grossProfit = (priceDifference / tickSize) * tickValue * quantity;
      break;
    default:
      grossProfit = priceDifference * quantity;
      break;
  }

  // Assuming no other costs, net profit is equal to gross profit in this simplified example
  double netProfit = double.parse(grossProfit.toStringAsFixed(2));

  return netProfit;
}

/// Function to calculate the profit per day
String calculateProfitPerDay(String date,
    Map<String, List<Map<String, dynamic>>> state, String profileId) {
  String dateFormat = formattedDate.format(DateTime.parse(date));
  List<Map<String, dynamic>> trades = state[profileId] ?? [];
  double profit = 0;
  for (int i = 0; i < trades.length; i++) {
    if (formattedDate.format(DateTime.parse(trades[i]['date'])) == dateFormat) {
      if (trades[i]['netProfit'] != null) {
        profit += trades[i]['netProfit'];
      }
    }
  }
  String formattedProfit = '';
  if (profit >= 1000) {
    double formattedValue = profit / 1000;
    formattedProfit = '\$${formattedValue.abs().toStringAsFixed(1)}k';
  } else {
    formattedProfit = '\$${profit.abs().toStringAsFixed(0)}';
  }
  return formattedProfit;
}

bool calculateTradeWinOrLoss(
    String tradeSide, double entryPrice, double exitPrice) {
  if (tradeSide == 'LONG') {
    if (entryPrice < exitPrice) {
      return true;
    } else {
      return false;
    }
  } else {
    if (entryPrice > exitPrice) {
      return true;
    } else {
      return false;
    }
  }
}

//1000.00 -> 1,000.00
String returnStringToMoneyFormat(String value) {
  // Split the value into integer and decimal parts
  List<String> parts = value.split('.');
  String integerPart = parts[0];
  String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

  // Format the integer part with commas
  String formattedValue = '';
  int count = 0;
  for (int i = integerPart.length - 1; i >= 0; i--) {
    count++;
    formattedValue = integerPart[i] + formattedValue;
    if (count % 3 == 0 && i != 0) {
      // Ensure comma is not added at the start
      formattedValue = ',$formattedValue';
    }
  }

  // Combine the formatted integer part with the decimal part
  return '\$$formattedValue$decimalPart';
}

String calculateWinRateWithTrades(List<Map<String, dynamic>> trades) {
  if (trades.isEmpty) {
    return '0%';
  }
  int winCount = 0;
  int lossCount = 0;
  for (int i = 0; i < trades.length; i++) {
    if (trades[i]['netProfit'] == null) {
      continue;
    }

    if (double.parse(trades[i]['netProfit'].toString()) > 0) {
      winCount++;
    } else {
      lossCount++;
    }
  }
  double winRate = winCount / (winCount + lossCount);
  return '${(winRate * 100).toStringAsFixed(2)}%';
}
