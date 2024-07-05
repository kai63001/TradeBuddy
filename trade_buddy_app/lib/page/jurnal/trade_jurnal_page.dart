import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trade_buddy_app/page/jurnal/calendar/jurnal_calendar.dart';
import 'package:trade_buddy_app/page/jurnal/list/list_jurnal_trade.dart';
import 'package:trade_buddy_app/store/select_profile_store.dart';
import 'package:trade_buddy_app/store/trade_store.dart';

class TradeJurnalPage extends StatefulWidget {
  const TradeJurnalPage({super.key});

  @override
  State<TradeJurnalPage> createState() => _TradeJurnalPageState();
}

class _TradeJurnalPageState extends State<TradeJurnalPage> {
  DateTime _selectedDay = DateTime.now();
  List<Map<String, dynamic>> trades = [];
  DateFormat formattedDate = DateFormat('yyyy-MM-dd');

  void updateSelection(DateTime date) {
    setState(() {
      _selectedDay = date;
    });
    getTradesBySelectedDate();
  }

  @override
  void initState() {
    super.initState();
    getTradesBySelectedDate();
  }

  Future<void> getTradesBySelectedDate() async {
    String profileId = context.read<SelectProfileStore>().state;
    //get trades by selected date
    List<Map<String, dynamic>> getTrade = await context.read<TradeStore>().getTradeList(profileId);
    setState(()  {
      trades = getTrade.where((element) => formattedDate.format(DateTime.parse(element['date'].toString())) == formattedDate.format(_selectedDay)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff222222),
        centerTitle: false,
        title: const Text(
          'Jurnal',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: JurnalCalendar(
              updateSelection: updateSelection,
            ),
          ),
          //divider
          const Divider(
            color: Color.fromARGB(255, 89, 87, 87),
            thickness: 2,
          ),
          //list of trades
          ListJurnalTrade(trades: trades)
        ],
      ),
    );
  }
}
