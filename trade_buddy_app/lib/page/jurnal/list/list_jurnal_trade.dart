import 'package:flutter/material.dart';
import 'package:trade_buddy_app/components/add_trade/add_trade_manually.dart';
import 'package:trade_buddy_app/helper/calculate_trading.dart';
import 'package:trade_buddy_app/helper/trading_history.dart';

class ListJurnalTrade extends StatefulWidget {
  final List<Map<String, dynamic>> trades;
  const ListJurnalTrade({super.key, required this.trades});

  @override
  State<ListJurnalTrade> createState() => _ListJurnalTradeState();
}

class _ListJurnalTradeState extends State<ListJurnalTrade> {
  int tappedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.trades.length,
      itemBuilder: (context, index) {
        bool isWin = calculateTradeWinOrLoss(
            widget.trades[index]['tradeSide'].toString(),
            widget.trades[index]['entryPrice'],
            widget.trades[index]['exitPrice']);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: AnimatedScale(
            scale: tappedIndex == index ? 0.95 : 1, // Scale down when tapped
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: GestureDetector(
              onTapDown: (_) {
                setState(() {
                  tappedIndex = index; // Start the animation
                });
              },
              onTapUp: (_) {
                Future.delayed(const Duration(milliseconds: 200), () {
                  setState(() {
                    tappedIndex = -1; // Stop the animation after a delay
                  });
                });
                //* go to Edit Trade Page
                showModalBottomSheet(
                  backgroundColor: const Color(0xff222222),
                  context: context,
                  useSafeArea: true,
                  barrierColor: Colors.transparent,
                  enableDrag: false,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return AddTrandingManuallyPage(
                      tradeId: widget.trades[index]["id"],
                    );
                  },
                );
              },
              onTapCancel: () {
                setState(() {
                  tappedIndex =
                      -1; // Also stop the animation after a delay if the tap was canceled
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 42, 42, 44),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Row(
                    children: [
                      Text(widget.trades[index]['symbol']),
                      const SizedBox(width: 5),
                      SizedBox(
                          width: 60,
                          child:
                              tradeType(widget.trades[index]['tradeSide'], 12)),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Text(widget.trades[index]['entryPrice'].toString(),
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(width: 5),
                      const Icon(Icons.arrow_forward,
                          color: Colors.grey, size: 15),
                      const SizedBox(width: 5),
                      Text(widget.trades[index]['exitPrice'].toString(),
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  trailing: Text(
                    isWin
                        ? returnStringToMoneyFormat(
                            (widget.trades[index]['netProfit']?.abs() ?? 0)
                                .toString())
                        : '-${returnStringToMoneyFormat((widget.trades[index]['netProfit']?.abs() ?? 0).toString())}',
                    // '\$${widget.trades[index]['netProfit'].abs()}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isWin
                            ? const Color(0xff00D6BF)
                            : const Color(0xffFF0E37)),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
