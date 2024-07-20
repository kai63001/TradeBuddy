import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trade_buddy_app/helper/calculate_trading.dart';
import 'package:trade_buddy_app/store/select_profile_store.dart';
import 'package:trade_buddy_app/store/trade_store.dart';

class CardTodayMain extends StatefulWidget {
  const CardTodayMain({
    super.key,
  });

  @override
  State<CardTodayMain> createState() => _CardTodayMainState();
}

class _CardTodayMainState extends State<CardTodayMain> {
  DateFormat formatDateHHader = DateFormat('MMMM dd, yyyy');
  String stringDate = '';
  DateFormat formattedDate = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    getToday();
  }

  void getToday() {
    setState(() {
      stringDate = formatDateHHader.format(DateTime.now());
    });
  }

  Text getIncomeToday() {
    String profileId = context.read<SelectProfileStore>().state;
    List<Map<String, dynamic>> tradesListDate = context
        .watch<TradeStore>()
        .getTradeListByDate(profileId, DateTime.now());

    double totalIncome = 0;
    for (var trade in tradesListDate) {
      totalIncome += trade['netProfit'];
    }

    //check if totalIncome is negative
    final formattedTotalIncome =
        returnStringToMoneyFormat(totalIncome.abs().toStringAsFixed(2));
    final color =
        totalIncome < 0 ? const Color(0xffFF0E37) : const Color(0xff00D6BF);

    return Text(
      totalIncome < 0 ? '-$formattedTotalIncome' : formattedTotalIncome,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w900,
        fontSize: 25,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Today - $stringDate',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15)),
              const SizedBox(height: 10),
              getIncomeToday()
              // Text(getIncomeToday(),
              //     style: TextStyle(
              //         color: Color(0xff00D6BF),
              //         fontWeight: FontWeight.w900,
              //         fontSize: 25)),
            ],
          ),
        ),
      ),
    );
  }
}
