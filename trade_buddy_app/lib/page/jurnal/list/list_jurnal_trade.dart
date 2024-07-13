import 'package:flutter/material.dart';

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
        return Padding(
          padding: const EdgeInsets.all(10),
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
                  title: Text(widget.trades[index]['symbol']),
                  subtitle: Text(widget.trades[index]['entryPrice'].toString()),
                  trailing: Text(widget.trades[index]['exitPrice'].toString()),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
