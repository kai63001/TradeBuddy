import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_buddy_app/components/dashboard/dashboard.dart';
import 'package:trade_buddy_app/main.dart';
import 'package:trade_buddy_app/store/profile_store.dart';
import 'package:trade_buddy_app/store/select_profile_store.dart';

class CreateProfileGoalsPage extends StatefulWidget {
  const CreateProfileGoalsPage(
      {super.key,
      required this.nameProfile,
      required this.type,
      this.first = false});
  final String nameProfile;
  final String type;
  final bool first;

  @override
  State<CreateProfileGoalsPage> createState() => _CreateProfileGoalsPageState();
}

class _CreateProfileGoalsPageState extends State<CreateProfileGoalsPage> {
  int dailyGoal = 0;
  int weeklyGoal = 0;
  int monthlyGoal = 0;
  int yearlyGoal = 0;

  bool checkCondition() {
    return dailyGoal > 0 && weeklyGoal > 0 && monthlyGoal > 0;
  }

  void createProfile() {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    // save profile to database
    context.read<ProfileStore>().addProfile(
          jsonEncode({
            'id': id,
            'name': widget.nameProfile,
            'type': widget.type,
            'dailyGoal': dailyGoal,
            'weeklyGoal': weeklyGoal,
            'monthlyGoal': monthlyGoal,
            'yearlyGoal': yearlyGoal,
          }),
        );
    //set selected profile
    context.read<SelectProfileStore>().selectProfile(id);

    if (widget.first) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
          (route) => false);
      return;
    }
    //Navigator with remove until
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 20),
          //input selection type container show bottom sheet
          const Center(
            child: Text('Set up your Goals',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 24)),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text('Daily Goal',
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
                      dailyGoal = int.parse(value);
                    })
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                      hintText: '200',
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
            child: Text('Weekly Goal',
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
                      weeklyGoal = int.parse(value);
                    })
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                      hintText: '1000',
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
            child: Text('Monthly Goal',
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
                      monthlyGoal = int.parse(value);
                    })
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                      hintText: '5000',
                      fillColor: Color(0xff2B2B2F),
                      labelStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none),
                ),
              ),
            ),
          ),
          // const SizedBox(height: 15),
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 25.0),
          //   child: Text('Yearly Goal',
          //       style: TextStyle(
          //           color: Colors.white,
          //           fontWeight: FontWeight.w600,
          //           fontSize: 15)),
          // ),
          // const SizedBox(height: 5),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: const Color(0xff2B2B2F),
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
          //       child: TextField(
          //         onChanged: (value) => {
          //           setState(() {
          //             yearlyGoal = int.parse(value);
          //           })
          //         },
          //         keyboardType: TextInputType.number,
          //         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          //         decoration: const InputDecoration(
          //             hintText: '10000',
          //             fillColor: Color(0xff2B2B2F),
          //             labelStyle: TextStyle(color: Colors.white),
          //             border: InputBorder.none),
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
                'Your goals will be used to track your progress and help you stay on track. You can always change them later.',
                style: TextStyle(
                    color: Color.fromARGB(255, 168, 168, 168),
                    fontWeight: FontWeight.w600,
                    fontSize: 12)),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: checkCondition() ? createProfile : null,
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
                    'Create Profile',
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
