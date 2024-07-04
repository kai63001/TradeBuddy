import 'package:flutter/material.dart';
import 'package:trade_buddy_app/page/jurnal/calendar/jurnal_calendar.dart';

class TradeJurnalPage extends StatefulWidget {
  const TradeJurnalPage({super.key});

  @override
  State<TradeJurnalPage> createState() => _TradeJurnalPageState();
}

class _TradeJurnalPageState extends State<TradeJurnalPage> {
  DateTime _selectedDay = DateTime.now();

  void updateSelection(DateTime date) {
    setState(() {
      _selectedDay = date;
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
        ],
      ),
    );
  }
}
