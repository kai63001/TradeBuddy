import 'package:flutter/material.dart';

class CreateProfileGoalsPage extends StatefulWidget {
  const CreateProfileGoalsPage(
      {super.key, required this.nameProfile, required this.type});
  final String nameProfile;
  final String type;

  @override
  State<CreateProfileGoalsPage> createState() => _CreateProfileGoalsPageState();
}

class _CreateProfileGoalsPageState extends State<CreateProfileGoalsPage> {
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
            child: Text('Profile Goals',
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
                  onChanged: (value) => {},
                  decoration: const InputDecoration(
                      hintText: 'Main Account',
                      fillColor: Color(0xff2B2B2F),
                      labelStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
