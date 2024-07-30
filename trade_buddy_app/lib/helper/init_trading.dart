import 'package:shared_preferences/shared_preferences.dart';

Future<void> initTradeChecklist(String profileId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  //* Init Trade Checklist List
  final List<String> tradeChecklist = [
    'Market analysis completed',
    'Risk management strategy defined',
    'Entry and exit points identified',
    'News and events checked',
    'Stop-loss and take-profit levels set',
    'Position size calculated'
  ];

  //* Check if don't have any trade checklist in shared preferences
  if (prefs.getStringList('tradeChecklist_$profileId') == null) {
    prefs.setStringList('tradeChecklist_$profileId', tradeChecklist);
  }
}
