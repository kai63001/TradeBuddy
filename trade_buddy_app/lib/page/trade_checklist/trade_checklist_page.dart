import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trade_buddy_app/helper/calculate_trading.dart';
import 'package:trade_buddy_app/store/select_profile_store.dart';

class TradeCheckListModal extends StatefulWidget {
  const TradeCheckListModal({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TradeCheckListModalState createState() => _TradeCheckListModalState();
}

class _TradeCheckListModalState extends State<TradeCheckListModal> {
  // List of checklist items
  late List<String> checklistItems = [];

  // Map to track checkbox states
  late Map<String, bool> checklistState;

  // Controller for additional notes
  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initTradeCheckListToday();
  }

  Future<void> initTradeCheckListToday() async {
    String profileId = context.read<SelectProfileStore>().state;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      checklistItems = prefs.getStringList('tradeChecklist_$profileId')!;
      checklistState = {for (var item in checklistItems) item: false};
    });

    notesController.clear();
    checkHasBeenChecked();
  }

  Future<void> checkHasBeenChecked() async {
    String profileId = context.read<SelectProfileStore>().state;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String todaay = formattedDate.format(DateTime.now());

    // Check if checklist has been checked today or not by tradeCheckList_$profileId_$today
    if (prefs.getBool('tradeCheckList_${profileId}_$todaay') == true) {
      // If checked, get the notes and checklist state
      String notes =
          prefs.getString('tradeCheckListNotes_${profileId}_$todaay')!;
      List<String> checkedItems = prefs
          .getStringList('tradeCheckListCheckedItems_${profileId}_$todaay')!;

      // Set the notes and checklist state
      notesController.text = notes;
      setState(() {
        for (var item in checkedItems) {
          checklistState[item] = true;
        }
      });
    }
  }

  Future<void> saveTradeCheckListToday() async {
    String profileId = context.read<SelectProfileStore>().state;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String todaay = formattedDate.format(DateTime.now());

    // Save the notes and checklist state
    prefs.setString(
        'tradeCheckListNotes_${profileId}_$todaay', notesController.text);
    List<String> checkedItems = [];
    for (var item in checklistState.keys) {
      if (checklistState[item] == true) {
        checkedItems.add(item);
      }
    }
    prefs.setStringList(
        'tradeCheckListCheckedItems_${profileId}_$todaay', checkedItems);

    // Mark the checklist as checked
    prefs.setBool('tradeCheckList_${profileId}_$todaay', true);

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
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
                      saveTradeCheckListToday();
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
