import 'package:flutter/material.dart';

void showAddTradeManually(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: const Color(0xff222222),
    context: context,
    useSafeArea: true,
    barrierColor: Colors.transparent,
    enableDrag: false,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Add a New Trade Entry',
                      style: TextStyle(
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
              //input symbol with label
              const TextField(
                decoration: InputDecoration(
                    hintText: 'AAPL',
                    labelText: 'Symbol',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 207, 207, 207)),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 201, 201, 201)),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    )),
              ),
              const SizedBox(height: 10),
              //input date and time
              const TextField(
                decoration: InputDecoration(
                    hintText: '06/10/2024 12:00 PM',
                    labelText: 'Date and Time',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 207, 207, 207)),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 201, 201, 201)),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    )),
              ),
            ],
          ),
        ),
      );
    },
  );
}
