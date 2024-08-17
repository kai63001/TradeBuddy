import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trade_buddy_app/helper/calculate_trading.dart';
import 'package:trade_buddy_app/store/select_profile_store.dart';
import 'package:trade_buddy_app/store/trade_store.dart';

class CardThisWeakMain extends StatefulWidget {
  const CardThisWeakMain({super.key});

  @override
  State<CardThisWeakMain> createState() => _CardThisWeakMainState();
}

class _CardThisWeakMainState extends State<CardThisWeakMain> {
  List<DateTime> weekDates = [];
  Map<String, List<Map<String, dynamic>>> state = {};

  @override
  void initState() {
    super.initState();
    getTradeData();
    weekDates = getWeekDates();
  }

  void getTradeData() {
    Map<String, List<Map<String, dynamic>>> newState =
        context.read<TradeStore>().state;
    setState(() {
      state = newState;
    });
  }

  // Adjusted method to start week on Sunday
  List<DateTime> getWeekDates() {
    DateTime now = DateTime.now();
    // Adjusted to start the week on Sunday
    DateTime sunday = now.subtract(Duration(days: now.weekday % 7));
    return List.generate(7, (index) => sunday.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              'This Week',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 15),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDates.map((date) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: calculateRedDayOrGreenColorBackground(
                        date.toString(),
                        state,
                        context.read<SelectProfileStore>().state),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 14),
                    child: Center(
                      child: Text(
                        DateFormat('d').format(date),
                        style: TextStyle(
                          color: calculateRedDayOrGreenColor(date.toString(),
                              state, context.read<SelectProfileStore>().state),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
