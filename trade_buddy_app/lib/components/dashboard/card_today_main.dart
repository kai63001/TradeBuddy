import 'package:flutter/material.dart';

class CardTodayMain extends StatelessWidget {
  const CardTodayMain({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Today - June 10, 2024',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15)),
              SizedBox(height: 10),
              Text('\$1,245',
                  style: TextStyle(
                      color: Color(0xff00D6BF),
                      fontWeight: FontWeight.w900,
                      fontSize: 25)),
            ],
          ),
        ),
      ),
    );
  }
}
