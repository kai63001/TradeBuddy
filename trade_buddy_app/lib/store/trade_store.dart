import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TradeStore extends Cubit<Map<String, List<Map<String, dynamic>>>> {
  DateFormat formattedDate = DateFormat('yyyy-MM-dd');
  TradeStore() : super({});

  Future<void> addTrade(String tradeData, String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    final trades = state[profileId] ?? [];
    final newTrades = [...trades, jsonDecode(tradeData)];
    await prefs.setStringList(
        'tradeList_$profileId', newTrades.map((e) => jsonEncode(e)).toList());
    emit(
        {...state, profileId: newTrades.cast<Map<String, dynamic>>().toList()});
  }

  Future<void> updateTradeById(String tradeData, String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    final trades = state[profileId] ?? [];
    final tradeDataDecode = jsonDecode(tradeData);
    final newTrades = trades.map((e) {
      if (e['id'] == tradeDataDecode['id']) {
        e = tradeDataDecode;
      }
      return e;
    }).toList();
    prefs.setStringList(
        'tradeList_$profileId', newTrades.map((e) => jsonEncode(e)).toList());
    emit(
        {...state, profileId: newTrades.cast<Map<String, dynamic>>().toList()});
  }

  Future<void> initTradeList(String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    final rawTrades = prefs.getStringList('tradeList_$profileId') ?? [];
    final trades = rawTrades.map((e) => jsonDecode(e)).toList();
    emit({...state, profileId: trades.cast<Map<String, dynamic>>().toList()});
  }

  Map<String, dynamic> getTradeById(String id, String profileId) {
    final trades = state[profileId] ?? [];
    return trades.firstWhere((element) => element['id'] == id);
  }

  Future<List<Map<String, dynamic>>> getTradeList(String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    final rawTrades = prefs.getStringList('tradeList_$profileId') ?? [];
    final trades = rawTrades.map((e) => jsonDecode(e)).toList();
    return trades.cast<Map<String, dynamic>>().toList();
  }

  List<Map<String, dynamic>> getTradeListByProfileId(String profileId) {
    return state[profileId] ?? [];
  }

  List<Map<String, dynamic>> getTradeListByDate(
      String profileId, DateTime date) {
    final trades = state[profileId] ?? [];
    return trades
        .where((element) =>
            formattedDate.format(DateTime.parse(element['date'].toString())) ==
            formattedDate.format(date))
        .toList();
  }

  Future<void> deleteTrade(String id, String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    final trades = state[profileId] ?? [];
    final newTrades = trades.where((element) => element['id'] != id).toList();
    prefs.setStringList(
        'tradeList_$profileId', newTrades.map((e) => jsonEncode(e)).toList());
    emit(
        {...state, profileId: newTrades.cast<Map<String, dynamic>>().toList()});
  }

  Future<void> updateDisplayNameWithId(
      String tradeData, String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    final trades = state[profileId] ?? [];
    final tradeDataDecode = jsonDecode(tradeData);
    final newTrades = trades.map((e) {
      if (e['id'] == tradeDataDecode['id']) {
        e = tradeDataDecode;
      }
      return e;
    }).toList();
    prefs.setStringList(
        'tradeList', newTrades.map((e) => jsonEncode(e)).toList());
    emit(
        {...state, profileId: newTrades.cast<Map<String, dynamic>>().toList()});
  }
}
