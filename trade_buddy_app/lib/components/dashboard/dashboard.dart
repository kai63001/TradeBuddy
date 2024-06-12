import 'package:flutter/material.dart';
import 'package:trade_buddy_app/components/dashboard/card_overview_main.dart';
import 'package:trade_buddy_app/components/dashboard/card_today_main.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff222222),
          centerTitle: false,
          title: const Text(
            'Hey Buddy',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
          actions: [
            //button text
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xff2B2B2F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Row(
                  children: [
                    Text(
                      'TOPSTEP 50K',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          children: const [CardTodayMain(), CardOverview()],
        ));
  }
}
