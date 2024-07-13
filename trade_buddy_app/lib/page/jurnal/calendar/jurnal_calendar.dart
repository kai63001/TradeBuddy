import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:trade_buddy_app/helper/calculate_trading.dart';
import 'package:trade_buddy_app/store/select_profile_store.dart';
import 'package:trade_buddy_app/store/trade_store.dart';

class JurnalCalendar extends StatefulWidget {
  final Function? updateSelection;
  const JurnalCalendar({super.key, required this.updateSelection});

  @override
  State<JurnalCalendar> createState() => _JurnalCalendarState();
}

class _JurnalCalendarState extends State<JurnalCalendar> {
  DateTime _selectedDay = DateTime.now();
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();
  final kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 10, DateTime.now().day);
  final kLastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 10, DateTime.now().day);

  @override
  void initState() {
    super.initState();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      widget.updateSelection!(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      calendarFormat: _calendarFormat,
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      onFormatChanged: (format) => _calendarFormat,
      onDaySelected: _onDaySelected,
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) => Container(
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: calculateRedDayOrGreenColor(
                day.toString(),
                context.watch<TradeStore>().state,
                context.watch<SelectProfileStore>().state),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            //space between day and price
            children: [
              const SizedBox(height: 4),
              Text(
                day.day.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                calculateProfitPerDay(
                    day.toString(),
                    context.watch<TradeStore>().state,
                    context.watch<SelectProfileStore>().state),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
        selectedBuilder: (context, day, focusedDay) => Container(
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 80, 80, 82),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              Text(
                day.day.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                calculateProfitPerDay(
                    day.toString(),
                    context.watch<TradeStore>().state,
                    context.watch<SelectProfileStore>().state),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
        todayBuilder: (context, day, _) {
          return Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: calculateRedDayOrGreenColor(
                    day.toString(),
                    context.watch<TradeStore>().state,
                    context.watch<SelectProfileStore>().state),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Text(
                    day.day.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    calculateProfitPerDay(
                        day.toString(),
                        context.watch<TradeStore>().state,
                        context.watch<SelectProfileStore>().state),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ));
        },
        dowBuilder: (context, day) {
          if (day.weekday == DateTime.sunday ||
              day.weekday == DateTime.saturday) {
            final text = DateFormat.E().format(day);

            return Center(
              child: Text(
                text,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
