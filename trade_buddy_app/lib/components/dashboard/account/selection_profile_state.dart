// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_buddy_app/page/create_profile/create_profile_page.dart';
import 'package:trade_buddy_app/store/profile_store.dart';
import 'package:trade_buddy_app/store/select_profile_store.dart';
import 'package:trade_buddy_app/store/trade_store.dart';

class SelectionProfileState extends StatefulWidget {
  const SelectionProfileState({
    super.key,
  });

  @override
  State<SelectionProfileState> createState() => _SelectionProfileStateState();
}

class _SelectionProfileStateState extends State<SelectionProfileState> {
  List<Map<String, dynamic>> profiles = [];

  @override
  void initState() {
    super.initState();
    getProfiles();
  }

  void getProfiles() {
    setState(() {
      profiles = context.read<ProfileStore>().state;
    });
  }

  Future<void> importantInitTradeData() async {
    await context.read<ProfileStore>().initProfileList();
    await context.read<SelectProfileStore>().initSelectedProfile();
    final profileStore = context.read<ProfileStore>();
    if (profileStore.state.isNotEmpty) {
      setState(() {
        profiles = profileStore.state;
      });
      final profileId = context.read<SelectProfileStore>().state;
      await context.read<TradeStore>().initTradeList(profileId);
    }

    Navigator.pop(context);
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
                const Text(
                  'Select Profile',
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
              itemCount: profiles.length + 1,
              itemBuilder: (_, i) {
                if (i == profiles.length) {
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 26, 26, 27),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ListTile(
                      title: const Text(
                        'Create New Profile',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        //navigate to create profile
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const CreateProfilePage();
                        }));
                      },
                    ),
                  );
                }
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff2B2B2F),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(
                      profiles[i]['name'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: context.read<SelectProfileStore>().state ==
                            profiles[i]['id'].toString()
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                    onTap: () {
                      //navigate to challenge
                      context
                          .read<SelectProfileStore>()
                          .selectProfile(profiles[i]['id'].toString());

                      importantInitTradeData();
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
