import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:trade_buddy_app/components/add_trade/add_trade_manually.dart';

class CustomNavBar extends StatelessWidget {
  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;

  const CustomNavBar({
    super.key,
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
  });

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
        // Padding(
        //   padding: const EdgeInsets.only(top: 15.0),
        //   child: Material(
        //     type: MaterialType.transparency,
        //     child: FittedBox(
        //       child: Text(
        //         item.title ?? "",
        //         style: TextStyle(
        //           color: isSelected
        //               ? const Color.fromARGB(255, 255, 255, 255)
        //               : const Color.fromARGB(255, 90, 90, 90),
        //           fontWeight: FontWeight.w600,
        //           fontSize: 9,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
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
          height: 320,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
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
              const SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 26, 26, 27), // background color
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
                    backgroundColor: const Color.fromARGB(255, 26, 26, 27), // background color
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
                    backgroundColor: const Color.fromARGB(255, 26, 26, 27), // background color
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
        borderRadius: navBarDecoration.borderRadius,
        boxShadow: navBarDecoration.boxShadow,
        color: const Color(0xff222222),
      ),
      filter: navBarConfig.selectedItem.filter,
      opacity: navBarConfig.selectedItem.opacity,
      height: navBarConfig.navBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: navBarConfig.items.map((item) {
          int index = navBarConfig.items.indexOf(item);
          if (index == navBarConfig.items.length ~/ 2) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
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
                navBarConfig.onItemSelected(
                    index); // This is the most important part. Without this, nothing would happen if you tap on an item.
              },
              child: _buildItem(
                item,
                navBarConfig.selectedIndex == index,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
