import 'package:flutter/material.dart';
import 'package:trade_buddy_app/page/create_profile/create_profile_goals_page.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  String nameProfile = '';
  String type = 'forex';

  List<String> types = ['Forex', 'Stock', 'Crypto', 'Futures', 'Options'];

  void navigateToCreateProfileGoalsPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CreateProfileGoalsPage(nameProfile: nameProfile, type: type)));
  }

  bool checkCondition() {
    return nameProfile.isNotEmpty && type.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //input selection type container show bottom sheet
          const Center(
            child: Text('Create Profile',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 24)),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text('Profile Name',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15)),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff2B2B2F),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  onChanged: (value) => {
                    setState(() {
                      nameProfile = value;
                    })
                  },
                  decoration: const InputDecoration(
                      hintText: 'Main Account',
                      fillColor: Color(0xff2B2B2F),
                      labelStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text('Select Profile Type',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15)),
          ),
          const SizedBox(height: 5),
          //input selection type container show bottom sheet
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xff2B2B2F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      //list selection
                      return Container(
                        color: const Color(0xff222222),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Select Type',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.white),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            //list of challenges
                            Expanded(
                              child: ListView.builder(
                                itemCount: types.length,
                                itemBuilder: (_, i) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xff2B2B2F),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: ListTile(
                                      title: Center(
                                        child: Text(
                                          types[i],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      //check if selected
                                      onTap: () {
                                        setState(() {
                                          type = types[i].toLowerCase();
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
                    });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    type.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                  const SizedBox(width: 5, height: 30),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          // right button
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed:
                    checkCondition() ? navigateToCreateProfileGoalsPage : null,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor:
                      const Color.fromARGB(255, 136, 136, 147),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 13),
                  child: Text(
                    'Next',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
