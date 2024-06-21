import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StrategiesSelectionState extends StatefulWidget {
  final Function? onChanged;
  final List<String> strategiesListSelected;

  const StrategiesSelectionState(
      {super.key, this.onChanged, required this.strategiesListSelected});

  @override
  State<StrategiesSelectionState> createState() =>
      _StrategiesSelectionStateState();
}

class _StrategiesSelectionStateState extends State<StrategiesSelectionState> {
  List<String> _strategiesList = [];
  List<String> _selected = [];

  @override
  void initState() {
    super.initState();
    initSelcted();
    initStrategy();
  }

  void initSelcted() {
    if (widget.strategiesListSelected.isNotEmpty) {
      setState(() {
        _selected = widget.strategiesListSelected;
      });
    }
  }

  Future<void> initStrategy() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> strategies = prefs.getStringList('strategies') ?? [];
    if (strategies.isEmpty) {
      List<String> simpleStrategies = [
        'Breakout',
        'Pullback',
        'Reversal',
        'Momentum',
        'Position Trading',
        'Trend Following',
        'Counter Trend',
      ];
      setState(() {
        _strategiesList = simpleStrategies;
      });
      prefs.setStringList('strategies', simpleStrategies);
    } else {
      setState(() {
        _strategiesList = strategies;
      });
    }
  }

  void onClickStrategies(String data) {
    setState(() {
      if (_selected.contains(data)) {
        _selected.remove(data);
      } else {
        _selected.add(data);
      }
    });
    widget.onChanged!(_selected);
  }

  bool checkSelected(String data) {
    // ignore: collection_methods_unrelated_type
    return _selected.contains(data);
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
                    _selected.isNotEmpty
                        ? '${_selected.length} Strategies Selected'
                        : 'Select Strategies',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          //list of strategies
          Expanded(
            child: ListView.builder(
              itemCount: _strategiesList.length + 1,
              itemBuilder: (_, i) {
                if (i == _strategiesList.length) {
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
                        child: Text('Manage Strategies',
                            style: TextStyle(color: Colors.black)),
                      ),
                      onTap: () {
                        //add new strategy
                      },
                    ),
                  );
                }
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 207, 207, 207)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(_strategiesList[i],
                        style: const TextStyle(color: Colors.white)),
                    trailing: checkSelected(_strategiesList[i])
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                    onTap: () {
                      onClickStrategies(_strategiesList[i]);
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
