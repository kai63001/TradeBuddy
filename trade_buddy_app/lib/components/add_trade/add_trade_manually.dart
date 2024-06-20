import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showAddTradeManually(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: const Color(0xff222222),
    context: context,
    useSafeArea: true,
    barrierColor: Colors.transparent,
    enableDrag: false,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return const AddTrandingManuallyPage();
    },
  );
}

class AddTrandingManuallyPage extends StatefulWidget {
  const AddTrandingManuallyPage({
    super.key,
  });

  @override
  State<AddTrandingManuallyPage> createState() =>
      _AddTrandingManuallyPageState();
}

class _AddTrandingManuallyPageState extends State<AddTrandingManuallyPage> {
  DateFormat formattedDate = DateFormat('dd-MMMM-yyyy');
  DateFormat formatTime = DateFormat('kk:mm');

  DateTime now = DateTime.now();

  Map<String, dynamic> trade = {
    'symbol': '',
    'date': DateTime.now(),
    'tradeSide': 'LONG',
    'entryPrice': null,
    'exitPrice': null,
    'lotSize': null,
    'feeCommission': null,
    'strategies': [],
    'feelingsMistakes': [],
    'notes': '',
  };

  void onChangeStrategies(List<String> strategies) {
    setState(() {
      trade['strategies'] = strategies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Add a New Trade Entry',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 10),
            //input symbol with label
            TextField(
              controller: TextEditingController(text: trade['symbol']),
              decoration: const InputDecoration(
                  hintText: 'AAPL',
                  labelText: 'Symbol',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 207, 207, 207)),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 201, 201, 201)),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  )),
              onChanged: (value) => {
                setState(() {
                  trade['symbol'] = value;
                })
              },
            ),
            const SizedBox(height: 20),
            //selection date and time with label
            GestureDetector(
              onTap: () => {
                picker.DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    onChanged: (date) {}, onConfirm: (date) {
                  setState(() {
                    trade['date'] = date;
                  });
                },
                    currentTime: DateTime.now(),
                    locale: picker.LocaleType.en,
                    theme: const picker.DatePickerTheme(
                      backgroundColor: Color(0xff222222),
                      itemStyle: TextStyle(color: Colors.white),
                      doneStyle: TextStyle(color: Colors.white),
                      cancelStyle: TextStyle(color: Colors.white),
                    ))
              },
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 207, 207, 207)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Center(
                          child: Text(
                            formattedDate.format(trade['date']),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 207, 207, 207)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Center(
                        child: Text(
                          formatTime.format(trade['date']),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            //trade side long and short
            longOrShort(trade['tradeSide'], onChanged: (value) {
              setState(() {
                trade['tradeSide'] = value;
              });
            }),
            //Row entry price and exit price
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                        text: trade['entryPrice'] == null
                            ? ''
                            : trade['entryPrice'].toString()),
                    onChanged: (value) => {
                      setState(() {
                        trade['entryPrice'] = double.parse(value);
                      })
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        hintText: '\$120.1',
                        labelText: 'Entry Price',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 207, 207, 207)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 201, 201, 201)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        )),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                        text: trade['exitPrice'] == null
                            ? ''
                            : trade['exitPrice'].toString()),
                    onChanged: (value) => {
                      setState(() {
                        trade['exitPrice'] = double.parse(value);
                      })
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        hintText: '\$123.1',
                        labelText: 'Exit Price',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 207, 207, 207)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 201, 201, 201)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        )),
                  ),
                ),
              ],
            ),
            //Row Lot Size and Fee and commission
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                        text: trade['lotSize'] == null
                            ? ''
                            : trade['lotSize'].toString()),
                    onChanged: (value) => {
                      setState(() {
                        trade['lotSize'] = int.parse(value);
                      })
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        hintText: '1',
                        labelText: 'Lot Size',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 207, 207, 207)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 201, 201, 201)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        )),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                        text: trade['feeCommission'] == null
                            ? ''
                            : trade['feeCommission'].toString()),
                    onChanged: (value) => {
                      setState(() {
                        trade['feeCommission'] = double.parse(value);
                      })
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        hintText: '\$0.1',
                        labelText: 'Fee & Commission',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 207, 207, 207)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 201, 201, 201)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        )),
                  ),
                ),
              ],
            ),
            //Selection Statigies
            const SizedBox(height: 20),
            startegiesSelection(onChangeStrategies, trade['strategies']),
            //Selection of Feelings mistake (optional)
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(255, 207, 207, 207)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Feelings & Mistakes (Optional)',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.white),
                  ],
                ),
              ),
            ),
            //Notes
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(255, 207, 207, 207)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                      //hint long text about trade notes
                      hintText: 'What did you learn from this trade?',
                      border: InputBorder.none),
                ),
              ),
            ),
            //Button Save Trade
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                  child: Row(
                    children: [
                      Icon(Icons.save, color: Colors.black),
                      SizedBox(width: 30),
                      Text(
                        'Save Trade',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector startegiesSelection(
      Function onChanged, List<String> strategies) {
    return GestureDetector(
      onTap: () => {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return StrategiesSelectionState(
                onChanged: onChanged,
                strategiesListSelected:
                    trade['strategies'].isEmpty ? [] : trade['strategies'],
              );
            }),
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 207, 207, 207)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  strategies.isEmpty
                      ? 'Select Strategies'
                      : '${strategies.length} Strategies Selected',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

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
      for (int i = 1; i <= 10; i++) {
        setState(() {
          _strategiesList.add(i.toString());
        });
        prefs.setStringList('strategies', _strategiesList);
      }
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
                    _selected.length > 0
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
              itemCount: _strategiesList.length,
              itemBuilder: (_, i) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 207, 207, 207)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text('Strategy ${_strategiesList[i]}',
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

Row longOrShort(String type, {Function? onChanged}) {
  return Row(
    children: [
      Expanded(
        child: GestureDetector(
          onTap: () => onChanged!('LONG'),
          child: Container(
            decoration: BoxDecoration(
              color:
                  type == 'LONG' ? const Color(0xff00D6BF) : Colors.transparent,
              border: Border.all(color: const Color(0xff00D6BF)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Center(
                child: Text(
                  'LONG',
                  style: TextStyle(
                      color: type == 'LONG'
                          ? Colors.white
                          : const Color(0xff00D6BF),
                      fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: GestureDetector(
          onTap: () => onChanged!('SHORT'),
          child: Container(
            width: 100,
            decoration: BoxDecoration(
              color: type == 'SHORT'
                  ? const Color(0xffFF0E37)
                  : Colors.transparent,
              border: Border.all(color: const Color(0xffFF0E37)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Center(
                child: Text(
                  'SHORT',
                  style: TextStyle(
                      color: type == 'SHORT'
                          ? Colors.white
                          : const Color(0xffFF0E37),
                      fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
