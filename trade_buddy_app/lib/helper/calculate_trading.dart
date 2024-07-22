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
    return const Color.fromARGB(255, 19, 170, 155);
  } else if (profit < 0) {
    return const Color(0xffFF0E37);
  } else {
    return const Color.fromARGB(255, 207, 207, 214);
  }
}

Color calculateRedDayOrGreenColorBackground(String date,
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
    return const Color(0xffE6F7F5);
  } else if (profit < 0) {
    return const Color(0xffFDE8E8);
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

String calculateProfitPerDay(String date,
    Map<String, List<Map<String, dynamic>>> state, String profileId) {
  DateFormat formattedDate = DateFormat(
      'yyyy-MM-dd'); // Ensure your date format matches the one used in the trades
  String dateFormat = formattedDate.format(DateTime.parse(date));
  List<Map<String, dynamic>> trades = state[profileId] ?? [];
  double profit = 0;
  for (Map<String, dynamic> trade in trades) {
    if (formattedDate.format(DateTime.parse(trade['date'])) == dateFormat) {
      profit += trade['netProfit'] ?? 0;
    }
  }
  return formatProfit(profit);
}

String formatProfit(double profit) {
  bool isNegative = profit < 0; // Check if the profit is negative
  double absoluteProfit =
      profit.abs(); // Work with the absolute value for formatting

  String formattedProfit;
  // Format and append 'M' for millions
  if (absoluteProfit >= 1000000) {
    formattedProfit =
        "\$${(absoluteProfit / 1000000).toStringAsFixed(absoluteProfit % 1000000 == 0 ? 0 : 3)}M";
  }
  // Format and append 'k' for thousands
  else if (absoluteProfit >= 1000) {
    formattedProfit =
        "\$${(absoluteProfit / 1000).toStringAsFixed(absoluteProfit % 1000 == 0 ? 0 : 1)}k";
  }
  // Return as is if less than a thousand
  else {
    formattedProfit =
        "\$${absoluteProfit.toStringAsFixed(absoluteProfit % 1 == 0 ? 0 : 2)}";
  }

  // Prepend the negative sign if the profit was negative
  return isNegative ? "-$formattedProfit" : formattedProfit;
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

// Calculate the risk-reward ratio for a trade like 1:2 or 1:3
String calculateRiskRewardRatioWithTrades(List<Map<String, dynamic>> trades) {
  if (trades.isEmpty) {
    return 'No Trades';
  }

  double totalRisk = 0;
  double totalReward = 0;

  // Calculate total risk and reward
  for (var trade in trades) {
    double netProfit =
        double.tryParse(trade['netProfit']?.toString() ?? '0') ?? 0;
    if (netProfit > 0) {
      totalReward += netProfit;
    } else {
      totalRisk += netProfit.abs();
    }
  }

  // Handling cases where totalRisk or totalReward is zero
  if (totalReward == 0) {
    return '1:1';
  }
  if (totalRisk == 0) {
    return '1:1';
  }

  // Calculating and formatting the risk-reward ratio
  double riskRewardRatio = totalReward / totalRisk;
  return '${riskRewardRatio.toStringAsFixed(0)}:1';
}

double calculateTotalNetProfit(List<Map<String, dynamic>> trades) {
  double totalNetProfit = 0;
  for (var trade in trades) {
    totalNetProfit +=
        double.tryParse(trade['netProfit']?.toString() ?? '0') ?? 0;
  }
  return totalNetProfit;
}

//convert $1,000.00 to $1k or $1,100.00 to $1.1k
String convertMoneyToK(String value) {
  // Remove commas and dollar signs, then convert to double
  double amount = double.parse(value.replaceAll(RegExp(r'[\$,]'), ''));

  // Format and append 'M' for millions
  if (amount >= 1000000) {
    // Calculate the number of decimals needed: up to 3 decimal places
    int decimalPlaces = 3;
    // For exact millions, reduce decimal to zero
    if (amount % 1000000 == 0) {
      decimalPlaces = 0;
    }
    return "\$${(amount / 1000000).toStringAsFixed(decimalPlaces)}M";
  }
  // Format and append 'k' for thousands
  else if (amount >= 1000) {
    // Calculate the number of decimals needed: one decimal place
    int decimalPlaces = 1;
    // For exact thousands, reduce decimal to zero
    if (amount % 1000 == 0) {
      decimalPlaces = 0;
    }
    return "\$${(amount / 1000).toStringAsFixed(decimalPlaces)}k";
  }
  // Return as is if less than a thousand
  else {
    return "\$$amount";
  }
}
