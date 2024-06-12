import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

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
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Material(
            type: MaterialType.transparency,
            child: FittedBox(
              child: Text(
                item.title ?? "",
                style: TextStyle(
                  color: isSelected
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : const Color.fromARGB(255, 90, 90, 90),
                  fontWeight: FontWeight.w600,
                  fontSize: 9,
                ),
              ),
            ),
          ),
        ),
      ],
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
              child: Container(
                //icon plus
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add),
                  color: const Color(0xff222222),
                  onPressed: () {},
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
