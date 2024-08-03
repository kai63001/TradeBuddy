import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trade_buddy_app/components/add_trade/add_trade_manually.dart';
import 'package:trade_buddy_app/helper/calculate_trading.dart';
import 'package:trade_buddy_app/page/trade_checklist/trade_checklist_page.dart';
import 'package:trade_buddy_app/store/select_profile_store.dart';

class CustomNavBar extends StatefulWidget {
  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;

  const CustomNavBar({
    super.key,
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
  });

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  bool _isTodayCheckList = false;

  Future<void> checkIsToDayHasBeenChecked() async {
    String profileId = context.read<SelectProfileStore>().state;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String todaay = formattedDate.format(DateTime.now());


    // Check if checklist has been checked today or not by tradeCheckList_$profileId_$today
    if (prefs.getBool('tradeCheckList_${profileId}_$todaay') == true) {
      setState(() {
        _isTodayCheckList = true;
      });
    } else {
      setState(() {
        _isTodayCheckList = false;
      });
    }
  }

  Widget _buildItem(ItemConfig item, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: IconTheme(
            data: IconThemeData(
                size: item.iconSize,
                color: isSelected
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : const Color.fromARGB(255, 90, 90, 90)),
            child: isSelected ? item.icon : item.inactiveIcon,
          ),
        ),
      ],
    );
  }

  void showAddTradeType(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color(0xff2B2B2F),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 5),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Row(
                  //sspace between
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Add a New Trade Entry',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16)),

                    //icon close
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              if (!_isTodayCheckList)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 26, 26, 27), // background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // radius value
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      showModalTradeCheckList(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          Icon(Icons.checklist, color: Colors.white),
                          SizedBox(width: 30),
                          Text('Pre-Trade Checklist',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              if (!_isTodayCheckList)
                //divider
                const Divider(
                  color: Color.fromARGB(255, 70, 70, 70),
                  thickness: 1,
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 26, 26, 27), // background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // radius value
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    showAddTradeManually(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(width: 30),
                        Text('Enter Trade Manually',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 26, 26, 27), // background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // radius value
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        Icon(Icons.image, color: Colors.white),
                        SizedBox(width: 30),
                        Text('Upload Screenshot',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 26, 26, 27), // background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // radius value
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        Icon(Icons.upload_file, color: Colors.white),
                        SizedBox(width: 30),
                        Text('Import Trade Data',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedNavBar(
      decoration: NavBarDecoration(
        borderRadius: widget.navBarDecoration.borderRadius,
        boxShadow: widget.navBarDecoration.boxShadow,
        color: const Color(0xff222222),
      ),
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      opacity: 0.7,
      height: widget.navBarConfig.navBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.navBarConfig.items.map((item) {
          int index = widget.navBarConfig.items.indexOf(item);
          if (index == widget.navBarConfig.items.length ~/ 2) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  checkIsToDayHasBeenChecked();
                  showAddTradeType(context);
                },
                child: Container(
                  //icon plus
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.add, color: Colors.black, size: 30),
                  ),
                ),
              ),
            );
          }
          return Expanded(
            child: InkWell(
              onTap: () {
                widget.navBarConfig.onItemSelected(
                    index); // This is the most important part. Without this, nothing would happen if you tap on an item.
              },
              child: _buildItem(
                item,
                widget.navBarConfig.selectedIndex == index,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
