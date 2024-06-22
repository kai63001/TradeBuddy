import 'package:flutter/material.dart';

class SelectionProfileState extends StatefulWidget {
  const SelectionProfileState({
    super.key,
  });

  @override
  State<SelectionProfileState> createState() => _SelectionProfileStateState();
}

class _SelectionProfileStateState extends State<SelectionProfileState> {
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
              itemCount: 3,
              itemBuilder: (_, i) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 207, 207, 207),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: const Center(
                      child: Text(
                        'FTMO 100K Challenge',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: () {
                      //navigate to challenge
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
