import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trade_buddy_app/components/add_trade/components/feeling_mistake_selection.dart';
import 'package:trade_buddy_app/components/add_trade/components/strategies_selection_components.dart';
import 'package:trade_buddy_app/helper/calculate_trading.dart';
import 'package:trade_buddy_app/store/profile_store.dart';
import 'package:trade_buddy_app/store/select_profile_store.dart';
import 'package:trade_buddy_app/store/trade_store.dart';

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
    this.tradeId = '',
  });

  final String tradeId;

  @override
  State<AddTrandingManuallyPage> createState() =>
      _AddTrandingManuallyPageState();
}

class _AddTrandingManuallyPageState extends State<AddTrandingManuallyPage> {
  DateFormat formattedDate = DateFormat('dd-MMMM-yyyy');
  DateFormat formatTime = DateFormat('kk:mm');
  bool showAdvanced = false;
  String profileType = '';

  //Controller
  final Map<String, TextEditingController> _controllers = {};
  TextEditingController _getController(String key, String initialValue) {
    if (!_controllers.containsKey(key)) {
      _controllers[key] = TextEditingController(text: initialValue);
    }
    return _controllers[key]!;
  }

  DateTime now = DateTime.now();

  List<Map<String, dynamic>> futuresContracts = [
    {
      'name': 'S&P 500 E-Mini',
      'symbol': 'ES',
      'tickSize': 0.25,
      'tickValue': 12.5,
    },
    {
      'name': 'S&P 500 Micro E-Mini',
      'symbol': 'MES',
      'tickSize': 0.25,
      'tickValue': 1.25,
    },
    {
      'name': 'Nasdaq 100 E-Mini',
      'symbol': 'NQ',
      'tickSize': 0.25,
      'tickValue': 5.0,
    },
    {
      'name': 'Nasdaq 100 Micro E-Mini',
      'symbol': 'MNQ',
      'tickSize': 0.25,
      'tickValue': 0.5,
    },
    {
      'name': 'Dow Jones E-Mini',
      'symbol': 'YM',
      'tickSize': 1.0,
      'tickValue': 5.0,
    },
    {
      'name': 'Dow Jones Micro E-Mini',
      'symbol': 'MYM',
      'tickSize': 1.0,
      'tickValue': 0.5,
    },
    {
      'name': 'Russell 2000 E-Mini',
      'symbol': 'RTY',
      'tickSize': 0.1,
      'tickValue': 5.0,
    },
    {
      'name': 'Russell 2000 Micro E-Mini',
      'symbol': 'M2K',
      'tickSize': 0.1,
      'tickValue': 0.5,
    },
    {
      'name': 'Gold Futures',
      'symbol': 'GC',
      'tickSize': 0.1,
      'tickValue': 10,
    },
    {
      'name': 'Gold E-Mini',
      'symbol': 'QO',
      'tickSize': 0.25,
      'tickValue': 12.5,
    },
    {
      'name': 'Gold E-Micro',
      'symbol': 'MGC',
      'tickSize': 0.1,
      'tickValue': 1,
    }
  ];

  Map<String, dynamic> trade = {
    'symbol': '',
    'date': DateTime.now().toIso8601String(),
    'tradeSide': 'LONG',
    'entryPrice': null,
    'exitPrice': null,
    'lotSize': null,
    'feeCommission': null,
    'strategies': [],
    'feelingsMistakes': [],
    'endDateTime': null,
    'screenshot': [],
    'notes': '',
  };

  @override
  void initState() {
    super.initState();
    initTradeData();
    initFutureContractFromPref();
  }

  void initTradeData() {
    String profileId = context.read<SelectProfileStore>().state;
    List<Map<String, dynamic>> rawProfiles = context.read<ProfileStore>().state;

    String getProfileType = context
        .read<SelectProfileStore>()
        .getProfileType(profileId, rawProfiles);
    setState(() {
      profileType = getProfileType;
    });

    //check if trade id is not empty
    if (widget.tradeId.isNotEmpty) {
      //get trade by id
      final Map<String, dynamic> tradeData =
          context.read<TradeStore>().getTradeById(widget.tradeId, profileId);
      //set trade data to state
      //convert trade.startigies and trade.feelingsMistakes to list String
      List<String> strategies = [];
      List<String> feelingsMistakes = [];
      if (tradeData['strategies'] != null) {
        strategies = tradeData['strategies'].cast<String>();
      }
      if (tradeData['feelingsMistakes'] != null) {
        feelingsMistakes = tradeData['feelingsMistakes'].cast<String>();
      }

      setState(() {
        trade = tradeData;
        trade['strategies'] = strategies;
        trade['feelingsMistakes'] = feelingsMistakes;
      });
    }
  }

  void initFutureContractFromPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String futuresContractsString =
        prefs.getString('futuresContracts') ?? '';
    if (futuresContractsString.isNotEmpty) {
      //push futures contracts to list array
      setState(() {
        futuresContracts = [
          ...futuresContracts,
          ...jsonDecode(futuresContractsString)
        ];
        // set default symbol
      });
    }
    if (trade['symbol'].isEmpty) {
      setState(() {
        trade['symbol'] = futuresContracts[0]['symbol'];
      });
    }
  }

  @override
  void dispose() {
    // Dispose of all controllers
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void onChangeStrategies(List<String> strategies) {
    setState(() {
      trade['strategies'] = strategies;
    });
  }

  void onChangeFeelingsMistakes(List<String> feelingsMistakes) {
    setState(() {
      trade['feelingsMistakes'] = feelingsMistakes;
    });
  }

  bool checkConditionCanSave() {
    return trade['symbol'].isNotEmpty &&
        trade['entryPrice'] != null &&
        trade['exitPrice'] != null &&
        trade['lotSize'] != null;
  }

  String wordingForType(String type) {
    switch (type.toUpperCase()) {
      case 'FUTURES':
        return 'Contracts';
      case 'STOCK':
        return 'Shares';
      case 'FOREX':
        return 'Lots';
      case 'OPTION':
        return 'Contracts';
      default:
        return 'Lot Size';
    }
  }

  void saveTrade() {
    //add id to trade
    if (widget.tradeId.isNotEmpty) {
      trade['id'] = widget.tradeId;
    } else {
      trade['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    }
    trade['grossProfit'] = calculateProfit(
        tradeSide: trade['tradeSide'],
        type: profileType.toUpperCase(),
        trickSize: profileType.toUpperCase() == "FUTURES"
            ? futuresContracts.firstWhere(
                (element) => element['symbol'] == trade['symbol'])['tickSize']
            : 0,
        trickValue: profileType.toUpperCase() == "FUTURES"
            ? futuresContracts.firstWhere(
                (element) => element['symbol'] == trade['symbol'])['tickValue']
            : 0,
        entryPrice: trade['entryPrice'] ?? 0,
        exitPrice: trade['exitPrice'] ?? 0,
        quantity: trade['lotSize'] ?? 0);
    trade['netProfit'] = trade['grossProfit'] - (trade['feeCommission'] ?? 0);
    // convert jsonEncode
    final String tradeString = jsonEncode(trade);

    debugPrint(tradeString);
    // get profile id
    final String profileId = context.read<SelectProfileStore>().state;
    //* Update trade if tradeId is not empty
    if (widget.tradeId.isNotEmpty) {
      //update trade
      context.read<TradeStore>().updateTradeById(tradeString, profileId);
      // close modal
      Navigator.pop(context, 'update');
      return;
    }
    // save trade to local storage
    context.read<TradeStore>().addTrade(tradeString, profileId);

    // close modal
    Navigator.pop(context);
  }

  Future<void> deleteTrade() async {
    if (widget.tradeId.isEmpty) {
      return;
    }

    //alert confirm
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Delete Trade'),
          content: const Text('Are you sure you want to delete this trade?'),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                // get profile id
                final String profileId =
                    context.read<SelectProfileStore>().state;
                //delete trade
                context
                    .read<TradeStore>()
                    .deleteTrade(widget.tradeId, profileId);
                // close modal
                Navigator.pop(context, 'update');
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (result == 'update') {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, 'update');
    }
  }

  String nameFutureContract(String symbol) {
    if (symbol.isEmpty) {
      return 'Select Futures';
    }
    final Map<String, dynamic> futureContract =
        futuresContracts.firstWhere((element) => element['symbol'] == symbol);
    return futureContract['name'] + ' (' + symbol + ')';
  }

  @override
  Widget build(BuildContext context) {
    final symbolController = _getController('symbol', trade['symbol'] ?? '');
    final entryPriceController =
        _getController('entryPrice', trade['entryPrice']?.toString() ?? '');
    final exitPriceController =
        _getController('exitPrice', trade['exitPrice']?.toString() ?? '');
    final lotSizeController =
        _getController('lotSize', trade['lotSize']?.toString() ?? '');
    final feeCommissionController = _getController(
        'feeCommission', trade['feeCommission']?.toString() ?? '');
    final notesController = _getController('notes', trade['notes'] ?? '');
    return Scaffold(
      body: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      widget.tradeId.isNotEmpty
                          ? 'Edit Trade'
                          : 'Add a New Trade Entry',
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
              const SizedBox(height: 10),
              const Text('Symbol'),
              const SizedBox(height: 5),
              //input symbol with label
              if (profileType == 'futures')
                futureSelection(context)
              else
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff2B2B2F),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: symbolController,
                      decoration: const InputDecoration(
                        hintText: 'AAPL',
                        labelStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => {
                        setState(() {
                          trade['symbol'] = value;
                        })
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              const Text('Entry Date & Time'),
              const SizedBox(height: 5),
              //selection date and time with label
              GestureDetector(
                onTap: () => {
                  picker.DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      onChanged: (date) {}, onConfirm: (date) {
                    setState(() {
                      trade['date'] = date.toIso8601String();
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
                          color: const Color(0xff2B2B2F),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Center(
                            child: Text(
                              formattedDate.format(
                                  DateTime.parse(trade['date'].toString())),
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
                        color: const Color(0xff2B2B2F),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Center(
                          child: Text(
                            formatTime.format(
                                DateTime.parse(trade['date'].toString())),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Entry Price'),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff2B2B2F),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextField(
                              controller: entryPriceController,
                              onChanged: (value) => {
                                if (value.isNotEmpty)
                                  setState(() {
                                    trade['entryPrice'] = double.parse(value);
                                  })
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: false, decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]')),
                              ],
                              decoration: const InputDecoration(
                                hintText: '\$120.1',
                                labelStyle: TextStyle(color: Colors.white),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Exit Price'),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff2B2B2F),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextField(
                              controller: exitPriceController,
                              onChanged: (value) => {
                                if (value.isNotEmpty)
                                  setState(() {
                                    trade['exitPrice'] = double.parse(value);
                                  })
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: false, decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]')),
                              ],
                              decoration: const InputDecoration(
                                hintText: '\$123.1',
                                labelStyle: TextStyle(color: Colors.white),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //Row Lot Size and Fee and commission
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(wordingForType(profileType)),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff2B2B2F),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextField(
                              controller: lotSizeController,
                              onChanged: (value) => {
                                if (value.isNotEmpty)
                                  setState(() {
                                    trade['lotSize'] =
                                        double.parse(value.toString());
                                  })
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: false, decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]'))
                              ],
                              decoration: const InputDecoration(
                                hintText: '1',
                                labelStyle: TextStyle(color: Colors.white),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Fee & Commission'),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff2B2B2F),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextField(
                              controller: feeCommissionController,
                              onChanged: (value) => {
                                if (value.isNotEmpty)
                                  setState(() {
                                    trade['feeCommission'] =
                                        double.parse(value);
                                  })
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: false, decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]')),
                              ],
                              decoration: const InputDecoration(
                                hintText: '\$0.1',
                                labelStyle: TextStyle(color: Colors.white),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Gross Profit'),
                        // Text(calculateProfit(
                        //         tradeSide: trade['tradeSide'],
                        //         type: profileType.toUpperCase(),
                        //         trickSize: profileType.toUpperCase() == "FUTURES"
                        //             ? futuresContracts.firstWhere((element) =>
                        //                 element['symbol'] ==
                        //                 trade['symbol'])['tickSize']
                        //             : 0,
                        //         trickValue: profileType.toUpperCase() == "FUTURES"
                        //             ? futuresContracts.firstWhere((element) =>
                        //                 element['symbol'] ==
                        //                 trade['symbol'])['tickValue']
                        //             : 0,
                        //         entryPrice: trade['entryPrice'] ?? 0,
                        //         exitPrice: trade['exitPrice'] ?? 0,
                        //         quantity: trade['lotSize'] ?? 0)
                        //     .toString()),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 58, 56, 56),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: calculateProfit(
                                        tradeSide: trade['tradeSide'],
                                        type: profileType.toUpperCase(),
                                        trickSize: profileType.toUpperCase() ==
                                                "FUTURES"
                                            ? futuresContracts.firstWhere(
                                                (element) =>
                                                    element['symbol'] ==
                                                    trade['symbol'],
                                                orElse: () => {
                                                  'tickSize': 0
                                                }, // Provide a fallback map with a default 'tickSize'
                                              )['tickSize']
                                            : 0,
                                        trickValue: profileType.toUpperCase() ==
                                                "FUTURES"
                                            ? futuresContracts.firstWhere(
                                                (element) =>
                                                    element['symbol'] ==
                                                    trade['symbol'],
                                                orElse: () => {
                                                  'tickValue': 0
                                                }, // Provide a fallback map with a default 'tickValue'
                                              )['tickValue']
                                            : 0,
                                        entryPrice: trade['entryPrice'] ?? 0,
                                        exitPrice: trade['exitPrice'] ?? 0,
                                        quantity: trade['lotSize'] ?? 0)
                                    .toString(),
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: false, decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]'))
                              ],
                              decoration: const InputDecoration(
                                hintText: '200',
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 103, 103, 103)),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Net Profit'),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 58, 56, 56),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextField(
                              controller: TextEditingController(
                                text: (double.parse(calculateProfit(
                                                tradeSide: trade['tradeSide'],
                                                type: profileType.toUpperCase(),
                                                trickSize: profileType
                                                            .toUpperCase() ==
                                                        "FUTURES"
                                                    ? futuresContracts
                                                        .firstWhere(
                                                        (element) =>
                                                            element['symbol'] ==
                                                            trade['symbol'],
                                                        orElse: () => {
                                                          'tickSize': 0
                                                        }, // Provide a fallback map with a default 'tickSize'
                                                      )['tickSize']
                                                    : 0,
                                                trickValue: profileType
                                                            .toUpperCase() ==
                                                        "FUTURES"
                                                    ? futuresContracts
                                                        .firstWhere(
                                                        (element) =>
                                                            element['symbol'] ==
                                                            trade['symbol'],
                                                        orElse: () => {
                                                          'tickValue': 0
                                                        }, // Provide a fallback map with a default 'tickValue'
                                                      )['tickValue']
                                                    : 0,
                                                entryPrice:
                                                    trade['entryPrice'] ?? 0,
                                                exitPrice:
                                                    trade['exitPrice'] ?? 0,
                                                quantity: trade['lotSize'] ?? 0)
                                            .toString()) -
                                        (trade['feeCommission'] ?? 0))
                                    .toString(),
                              ),
                              readOnly: true,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: false, decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]')),
                              ],
                              decoration: const InputDecoration(
                                hintText: '\$0.1',
                                labelStyle: TextStyle(color: Colors.white),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //Selection Statigies
              const SizedBox(height: 20),
              startegiesSelection(
                  onChangeStrategies,
                  trade['strategies'].isEmpty
                      ? []
                      : trade['strategies'] as List<String>),
              //Selection of Feelings mistake (optional)
              const SizedBox(height: 20),
              feelingOrMisstakeSelection(
                  onChangeFeelingsMistakes,
                  trade['feelingsMistakes'].isEmpty
                      ? []
                      : trade['feelingsMistakes'] as List<String>),
              //Notes
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff2B2B2F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: TextField(
                    controller: notesController,
                    onChanged: (value) => {
                      if (value.isNotEmpty)
                        setState(() {
                          trade['notes'] = value;
                        })
                    },
                    maxLines: 5,
                    decoration: const InputDecoration(
                        //hint long text about trade notes
                        hintText:
                            'Summarize your learnings: Strategy effectiveness, unexpected outcomes, market impact, and potential improvements.',
                        border: InputBorder.none),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              //show advanced
              GestureDetector(
                onTap: () {
                  setState(() {
                    showAdvanced = !showAdvanced;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 28, 28, 32),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Show Advanced',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        Icon(
                          showAdvanced
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (showAdvanced)
                //selection date and time with label
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text('End Date & Time (Optional)'),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => {
                        picker.DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            onChanged: (date) {}, onConfirm: (date) {
                          setState(() {
                            trade['endDateTime'] = date;
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
                                color: const Color(0xff2B2B2F),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Center(
                                  child: Text(
                                    formattedDate
                                        .format(DateTime.parse(trade['date'])),
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
                              color: const Color(0xff2B2B2F),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Center(
                                child: Text(
                                  formatTime
                                      .format(DateTime.parse(trade['date'])),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              //Button Save Trade
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 26, 26, 27),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: checkConditionCanSave() ? saveTrade : null,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Center(
                    child: Row(
                      children: [
                        Icon(Icons.save, color: Colors.white),
                        SizedBox(width: 30),
                        Text(
                          'Save Trade',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (widget.tradeId.isNotEmpty)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    deleteTrade();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Center(
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          SizedBox(width: 30),
                          Text(
                            'Delete Trade',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector futureSelection(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                color: const Color(0xff222222),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Select Futures',
                            style: TextStyle(
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
                    //list of challenges
                    Expanded(
                      child: ListView.builder(
                        itemCount: futuresContracts.length,
                        itemBuilder: (_, i) {
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 26, 26, 27),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: ListTile(
                              title: Text(
                                futuresContracts[i]['name'],
                                style: const TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                setState(() {
                                  trade['symbol'] =
                                      futuresContracts[i]['symbol'];
                                });
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff2B2B2F),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Row(
            //space between symbol and icon
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(nameFutureContract(trade['symbol']),
                  style: const TextStyle(color: Colors.white, fontSize: 15)),
              const SizedBox(width: 10),

              //icon arrow down
              const Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector feelingOrMisstakeSelection(
      Function onChanged, List<String> feelingOrMisstake) {
    return GestureDetector(
      onTap: () => {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return FeelingMistakeSelectionState(
                onChanged: onChanged,
                feelingMistakeListSelected: trade['feelingsMistakes'].isEmpty
                    ? []
                    : trade['feelingsMistakes'],
              );
            }),
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 28, 28, 32),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  feelingOrMisstake.isEmpty
                      ? 'Feelings & Mistakes (Optional)'
                      : '${feelingOrMisstake.length} Feelings & Mistakes Selected',
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
          color: const Color.fromARGB(255, 28, 28, 32),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  strategies.isEmpty
                      ? 'Select Strategies (Optional)'
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
