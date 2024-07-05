import 'package:flutter/material.dart';

class ListJurnalTrade extends StatelessWidget {
  final List<Map<String, dynamic>> trades;
  const ListJurnalTrade({super.key, required this.trades});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: trades.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(trades[index]['symbol']),
          subtitle: Text(trades[index]['entryPrice'].toString()),
          trailing: Text(trades[index]['exitPrice'].toString()),
        );
      },
    );
  }
}
