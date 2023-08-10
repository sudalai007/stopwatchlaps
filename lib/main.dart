import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  int seconds = 0, minutes = 0, hours = 0;
  String digitSeconds = '00', digitMinutes = '00', digitHours = '00';
  Timer? timer;
  bool started = false;
  List<String> laps = [];

  void stop() {
    timer?.cancel();
    setState(() {
      started = false;
    });
  }

  void reset() {
    timer?.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;
      digitSeconds = '00';
      digitMinutes = '00';
      digitHours = '00';
      started = false;
      laps.clear();
    });
  }

  void addLap() {
    String lap = '$digitHours:$digitMinutes:$digitSeconds';
    setState(() {
      laps.insert(0, lap);
    });
  }

  void start() {
    started = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds = (seconds + 1) % 60;
        if (seconds == 0) {
          minutes = (minutes + 1) % 60;
          if (minutes == 0) {
            hours = (hours + 1) % 24;
          }
        }

        digitSeconds = (seconds >= 10) ? '$seconds' : '0$seconds';
        digitMinutes = (minutes >= 10) ? '$minutes' : '0$minutes';
        digitHours = (hours >= 10) ? '$hours' : '0$hours';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 124, 163, 183),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Stop Watch',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  '$digitHours:$digitMinutes:$digitSeconds',
                  style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListView.builder(
                      itemCount: laps.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lap ${laps.length - index}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                laps[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      shape: const StadiumBorder(
                        side: BorderSide(color: Colors.white, width: 2),
                      ),
                      onPressed: () {
                        setState(() {
                          (!started) ? start() : stop();
                        });
                      },
                      child: Text(
                        started ? 'Pause' : 'Start',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      addLap();
                    },
                    icon: Icon(Icons.flag),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: RawMaterialButton(
                      shape: const StadiumBorder(
                        side: BorderSide(color: Colors.white, width: 2),
                      ),
                      onPressed: () {
                        reset();
                      },
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
