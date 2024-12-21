import 'dart:async';

import 'package:flutter/material.dart';
import 'package:giga/screen/crypto_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime targetDateTime;
  late Timer timer;
  Duration remainingTime = Duration();

  @override
  void initState() {
    _loadTargetDateTime();
    targetDateTime = DateTime.now()
        .add(Duration(days: 3, hours: 5, minutes: 5, seconds: 30));
    timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        setState(() {
          remainingTime = targetDateTime.difference(DateTime.now());
          if (remainingTime.isNegative) {
            timer.cancel();
          }
        });
      },
    );

    super.initState();
  }

  Future<void> _loadTargetDateTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? targetDateTimeString = prefs.getString('targetDateTime');
    if (targetDateTimeString != null) {
      targetDateTime = DateTime.parse(targetDateTimeString);
    } else {
      targetDateTime = DateTime.now()
          .add(Duration(days: 3, hours: 5, minutes: 5, seconds: 3));
      prefs.setString('targetDateTime', targetDateTime.toIso8601String());
    }
    setState(() {
      remainingTime = targetDateTime.difference(DateTime.now());
    });
  }

  // Future<void> _deleteData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isDone = await prefs.remove('targetDateTime');
  //   if (isDone) {
  //     print("Deleted");
  //   } else {
  //     print("Failed");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CryptoScreen(),
            ),
          );
        },
        child: Icon(
          Icons.accessibility_new,
          color: Colors.blue,
        ),
      ),
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "YOUR CHRISTMAS COUNTDOWN",
              style: TextStyle(
                fontSize: 23,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 5,
                  color: Colors.black,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "${remainingTime.inDays} : ${remainingTime.inHours % 24} : ${remainingTime.inMinutes % 60} : ${remainingTime.inSeconds % 60}",
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Days : Hours : Mins : Secs",
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
