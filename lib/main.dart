import 'package:flutter/material.dart';
import 'package:textbattery/battery.dart';
import 'package:textbattery/network.dart';
import 'package:textbattery/sensor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    BatteryInfo(),
    NetworkInfo(),
    SensorInfo(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.battery_charging_full),
              label: 'Battery',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.network_wifi),
              label: 'Network',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.sensors), label: 'Sensor'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
