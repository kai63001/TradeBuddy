import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_buddy_app/components/dashboard/account/selection_profile_state.dart';
import 'package:trade_buddy_app/components/dashboard/card_overview_main.dart';
import 'package:trade_buddy_app/components/dashboard/card_this_weak_main.dart';
import 'package:trade_buddy_app/components/dashboard/card_today_main.dart';
import 'package:trade_buddy_app/store/profile_store.dart';
import 'package:trade_buddy_app/store/select_profile_store.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff222222),
          centerTitle: false,
          title: const Text(
            'Hey Buddy',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
          actions: [
            //button text
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xff2B2B2F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  selectProfile(context);
                },
                child: Row(
                  children: [
                    BlocBuilder<SelectProfileStore, String>(
                      builder: (BuildContext context, String state) {
                        List<Map<String, dynamic>> rawProfiles =
                            context.read<ProfileStore>().state;
                        return Text(
                          context
                              .read<SelectProfileStore>()
                              .getProfileName(state, rawProfiles),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        );
                      },
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          children: const [
            CardTodayMain(),
            CardOverview(),
            // CardRecentTradesMain(),
            CardThisWeakMain(),
          ],
        ));
  }

  Future<dynamic> selectProfile(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return const SelectionProfileState();
      },
    );
  }
}
