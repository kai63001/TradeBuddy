import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TradeStore extends Cubit<List<Map<String, dynamic>>> {
  TradeStore() : super([]) {
    initTradeList();
  }

  Future<void> addTrade(String tradeData) async {
    final prefs = await SharedPreferences.getInstance();
    final trades = state;
    final newTrades = [...trades, jsonDecode(tradeData)];
    prefs.setStringList(
        'tradeList', newTrades.map((e) => jsonEncode(e)).toList());
    emit(newTrades.cast<Map<String, dynamic>>());
  }

  Future<void> initTradeList() async {
    final prefs = await SharedPreferences.getInstance();
    final rawTrades = prefs.getStringList('tradeList') ?? [];
    final trades = rawTrades.map((e) => jsonDecode(e)).toList();
    emit(trades.cast<Map<String, dynamic>>());
  }

  Future<void> deleteTrade(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final trades = state;
    final newTrades = trades.where((element) => element['id'] != id).toList();
    prefs.setStringList(
        'tradeList', newTrades.map((e) => jsonEncode(e)).toList());
    emit(newTrades.cast<Map<String, dynamic>>());
  }

  Future<void> updateDisplayNameWithId(String id, String displayName) async {
    final prefs = await SharedPreferences.getInstance();
    final trades = state;
    final newTrades = trades.map((e) {
      if (e['id'] == id) {
        e['displayName'] = displayName;
      }
      return e;
    }).toList();
    prefs.setStringList(
        'tradeList', newTrades.map((e) => jsonEncode(e)).toList());
    emit(newTrades.cast<Map<String, dynamic>>());
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('tradeList');
    emit([]);
  }
}
