import 'package:flutter/material.dart';

class TradeCheckListModal extends StatefulWidget {
  const TradeCheckListModal({super.key});

  @override
  _TradeCheckListModalState createState() => _TradeCheckListModalState();
}

class _TradeCheckListModalState extends State<TradeCheckListModal> {
  // List of checklist items
  final List<String> checklistItems = [
    'Market analysis completed',
    'Risk management strategy defined',
    'Entry and exit points identified',
    'News and events checked',
    'Stop-loss and take-profit levels set',
    'Position size calculated'
  ];

  // Map to track checkbox states
  late Map<String, bool> checklistState;

  // Controller for additional notes
  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checklistState = {for (var item in checklistItems) item: false};
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff222222),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 5),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trade Checklist',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView(
              children: [
                for (var item in checklistItems)
                  CheckboxListTile(
                    title: Text(
                      item,
                      style: const TextStyle(color: Colors.white),
                    ),
                    value: checklistState[item],
                    onChanged: (bool? value) {
                      setState(() {
                        checklistState[item] = value!;
                      });
                    },
                    activeColor: const Color.fromARGB(255, 3, 181, 163),
                    checkColor: Colors.white,
                  ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Additional Notes',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: TextField(
                    controller: notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      fillColor: const Color(0xff333333),
                      filled: true,
                      hintText: 'Enter any additional notes here...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Save checklist logic here
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 3, 181, 163),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Save Checklist'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showModalTradeCheckList(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: const Color(0xff222222),
    context: context,
    useSafeArea: true,
    barrierColor: Colors.transparent,
    enableDrag: false,
    isScrollControlled: true,
    builder: (context) {
      return const TradeCheckListModal();
    },
  );
}
