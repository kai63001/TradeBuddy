import 'package:flutter/material.dart';

Padding statusTrade(String status) {
  return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: status.toUpperCase() == 'WIN'
            ? const Color(0xff00D6BF)
            : const Color(0xffFF0E37),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(status.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w900)),
        ),
      ),
    ),
  );
}

Padding tradeType(String type) {
  return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: type.toUpperCase() == 'LONG'
                ? const Color(0xff00D6BF)
                : const Color(0xffFF0E37)),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(type,
            style: TextStyle(
                color: type.toUpperCase() == 'LONG'
                    ? const Color(0xff00D6BF)
                    : const Color(0xffFF0E37),
                fontWeight: FontWeight.w900)),
      ),
    ),
  );
}
