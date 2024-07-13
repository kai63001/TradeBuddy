import 'package:flutter/material.dart';
import 'package:trade_buddy_app/helper/trading_history.dart';

class CardRecentTradesMain extends StatefulWidget {
  const CardRecentTradesMain({super.key});

  @override
  State<CardRecentTradesMain> createState() => _CardRecentTradesMainState();
}

class _CardRecentTradesMainState extends State<CardRecentTradesMain> {
  @override
  Widget build(BuildContext context) {
    const sizeboxTable = TableRow(children: [
      
      SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 10,
      ),
    ]);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text('Recent Trades',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15)),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const <int, TableColumnWidth>{
                  // 0: FixedColumnWidth(60),
                  0: FixedColumnWidth(70),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                  3: FixedColumnWidth(65),
                  4: FlexColumnWidth(),
                },
                children: <TableRow>[
                  const TableRow(
                    children: <Widget>[
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: Text('STATUS',
                      //       style: TextStyle(fontWeight: FontWeight.w900)),
                      // ),
                      Align(
                        alignment: Alignment.center,
                        child: Text('SYMBOL',
                            style: TextStyle(fontWeight: FontWeight.w900)),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text('ENTRY',
                            style: TextStyle(fontWeight: FontWeight.w900)),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text('EXIT',
                            style: TextStyle(fontWeight: FontWeight.w900)),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text('SIDE',
                            style: TextStyle(fontWeight: FontWeight.w900)),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text('RETURN',
                            style: TextStyle(fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                  sizeboxTable,
                  TableRow(
                    children: <Widget>[
                      // statusTrade('WIN'),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'NQ100',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                      const Text(
                        '\$4,200',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                        softWrap: false,
                      ),
                      const Text(
                        '\$4,210',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                        softWrap: false,
                      ),
                      tradeType('LONG'),
                      const Align(
                        alignment: Alignment.center,
                        child: Text('\$478',
                            style: TextStyle(
                                color: 'WIN' == 'WIN' ? Color(0xff00D6BF) : Color(0xffFF0E37),
                                fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                  sizeboxTable,
                  TableRow(
                    children: <Widget>[
                      // statusTrade('LOSE'),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'NQ100',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                      const Text(
                        '\$4,200',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                        softWrap: false,
                      ),
                      const Text(
                        '\$4,210',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                        softWrap: false,
                      ),
                      tradeType('SHORT'),
                     const Align(
                        alignment: Alignment.center,
                        child: Text('\$478',
                            style: TextStyle(
                                color: 'LOSE' == 'WIN' ? Color(0xff00D6BF) : Color(0xffFF0E37),
                                fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                  sizeboxTable,
                  TableRow(
                    children: <Widget>[
                      // statusTrade('WIN'),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'NQ100',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                      const Text(
                        '\$4,200',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                        softWrap: false,
                      ),
                      const Text(
                        '\$4,210',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                        softWrap: false,
                      ),
                      tradeType('SHORT'),
                      const Align(
                        alignment: Alignment.center,
                        child: Text('\$478',
                            style: TextStyle(
                                color: 'WIN' == 'WIN' ? Color(0xff00D6BF) : Color(0xffFF0E37),
                                fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
