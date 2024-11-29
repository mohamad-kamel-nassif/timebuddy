import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(TimeBuddyApp());
}

class TimeBuddyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TimerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer? timer;
  int remainingSeconds = 0;
  int initialTime = 0;
  bool isRunning = false;
  String buttonText = "Start";

  void toggleTimer() {
    if (isRunning) {
      stopTimer();
    } else {
      startTimer();
    }
  }

  void startTimer() {
    setState(() {
      buttonText = "Stop";
      isRunning = true;
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        stopTimer();
        _showCompletionDialog();
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      buttonText = "Start";
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Time\'s up!'),
          content: Text('Great job! Your session is complete.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  remainingSeconds = 0;
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void selectTime(int seconds) {
    stopTimer();
    setState(() {
      remainingSeconds = seconds;
      initialTime = seconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;
    return Scaffold(
      appBar: AppBar(title: Text('TimeBuddy')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$minutes:${seconds.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: remainingSeconds == 0 ? 0 : remainingSeconds / initialTime,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => selectTime(60),
                  child: Text('1 min'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => selectTime(300),
                  child: Text('5 min'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => selectTime(600),
                  child: Text('10 min'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => selectTime(1500),
                  child: Text(
                    '25 min',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: toggleTimer,
              child: Text(buttonText),
              style: ElevatedButton.styleFrom(
                backgroundColor: isRunning ? Colors.red : Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
