import 'package:flutter/material.dart';
import 'package:trade_buddy_app/page/jurnal/calendar/jurnal_calendar.dart';

class TradeJurnalPage extends StatefulWidget {
  const TradeJurnalPage({super.key});

  @override
  State<TradeJurnalPage> createState() => _TradeJurnalPageState();
}

class _TradeJurnalPageState extends State<TradeJurnalPage> {
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
        children: const [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: JurnalCalendar(),
          ),
        ],
      ),
    );
  }
}
