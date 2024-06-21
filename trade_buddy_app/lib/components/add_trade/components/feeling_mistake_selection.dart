import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeelingMistakeSelectionState extends StatefulWidget {
  final Function? onChanged;
  final List<String> feelingMistakeListSelected;

  const FeelingMistakeSelectionState({
    super.key,
    this.onChanged,
    required this.feelingMistakeListSelected,
  });

  @override
  State<FeelingMistakeSelectionState> createState() =>
      _FeelingMistakeSelectionStateState();
}

class _FeelingMistakeSelectionStateState
    extends State<FeelingMistakeSelectionState> {
  List<String> _feelingMistakeList = [];
  List<String> _selectedFeelingsMistakes = [];

  @override
  void initState() {
    super.initState();
    initSelected();
    initFeelingMistake();
  }

  void initSelected() {
    if (widget.feelingMistakeListSelected.isNotEmpty) {
      setState(() {
        _selectedFeelingsMistakes = widget.feelingMistakeListSelected;
      });
    }
  }

  Future<void> initFeelingMistake() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> feelingsMistakes =
        prefs.getStringList('feelingsMistakes') ?? [];
    if (feelingsMistakes.isEmpty) {
      List<String> defaultFeelingsMistakes = [
        'Fear',
        'Greed',
        'Revenge',
        'Overconfidence',
        'Impatience',
        'Hesitation',
        'Indecision',
        'FOMO',
        'Revenge Trading',
        'Overtrading',
        'Undertrading',
        'Chasing',
        'Repeating Mistakes',
        'Not Following Plan',
        'Not Cutting Losses',
        'Not Letting Winners Run',
        'Not Taking Profits',
      ];
      setState(() {
        _feelingMistakeList = defaultFeelingsMistakes;
      });
      prefs.setStringList('feelingsMistakes', defaultFeelingsMistakes);
    } else {
      setState(() {
        _feelingMistakeList = feelingsMistakes;
      });
    }
  }

  void onClickFeelingMistake(String data) {
    setState(() {
      if (_selectedFeelingsMistakes.contains(data)) {
        _selectedFeelingsMistakes.remove(data);
      } else {
        _selectedFeelingsMistakes.add(data);
      }
    });
    widget.onChanged!(_selectedFeelingsMistakes);
  }

  bool checkSelected(String data) {
    return _selectedFeelingsMistakes.contains(data);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff222222),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedFeelingsMistakes.isNotEmpty
                      ? '${_selectedFeelingsMistakes.length} Selected'
                      : 'Select Feelings/Mistakes',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // List of feelings/mistakes
          Expanded(
            child: ListView.builder(
              itemCount: _feelingMistakeList.length + 1,
              itemBuilder: (_, i) {
                if (i == _feelingMistakeList.length) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ListTile(
                      title: const Center(
                        child: Text(
                          'Manage Feelings/Mistakes',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      onTap: () {
                        // Add new feeling/mistake
                      },
                    ),
                  );
                }
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 207, 207, 207),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(
                      _feelingMistakeList[i],
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: checkSelected(_feelingMistakeList[i])
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                    onTap: () {
                      onClickFeelingMistake(_feelingMistakeList[i]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
