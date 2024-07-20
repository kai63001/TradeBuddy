import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_buddy_app/helper/calculate_trading.dart';
import 'package:trade_buddy_app/store/select_profile_store.dart';
import 'package:trade_buddy_app/store/trade_store.dart';

class CardOverview extends StatefulWidget {
  const CardOverview({
    super.key,
  });

  @override
  State<CardOverview> createState() => _CardOverviewState();
}

class _CardOverviewState extends State<CardOverview> {
  @override
  void initState() {
    super.initState();
  }

  Text winrateCal() {
    String profileId = context.read<SelectProfileStore>().state;
    List<Map<String, dynamic>> trades =
        context.watch<TradeStore>().getTradeListByProfileId(profileId);

    String winRate = calculateWinRateWithTrades(trades);

    return Text(
      winRate,
      style: const TextStyle(
        color: Color(0xff00D6BF),
        fontWeight: FontWeight.w900,
        fontSize: 25,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text('Overview',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15)),
          ),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('WIN RATE',
                            style: TextStyle(
                                color: Color(0xff666666),
                                fontWeight: FontWeight.w900,
                                fontSize: 15)),
                        const SizedBox(height: 20),
                        Align(
                            alignment: Alignment.centerRight,
                            child: winrateCal()),
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('RISK REWARD',
                            style: TextStyle(
                                color: Color(0xff666666),
                                fontWeight: FontWeight.w900,
                                fontSize: 15)),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '1:2',
                            style: TextStyle(
                              color: Color(0xff00D6BF),
                              fontWeight: FontWeight.w900,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TOTAL TRADES',
                            style: TextStyle(
                                color: Color(0xff666666),
                                fontWeight: FontWeight.w900,
                                fontSize: 15)),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '153',
                            style: TextStyle(
                              color: Color(0xff00D6BF),
                              fontWeight: FontWeight.w900,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NET P/L',
                            style: TextStyle(
                                color: Color(0xff666666),
                                fontWeight: FontWeight.w900,
                                fontSize: 15)),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '\$3,751',
                            style: TextStyle(
                              color: Color(0xff00D6BF),
                              fontWeight: FontWeight.w900,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
