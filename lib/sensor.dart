import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SensorInfo extends StatefulWidget {
  @override
  _SensorInfoState createState() => _SensorInfoState();
}

class _SensorInfoState extends State<SensorInfo> {
  static const _methodChannel = MethodChannel('samples.flutter.dev/sensor');
  static const _eventChannel = EventChannel('samples.flutter.dev/sensorStream');

  List<String> _sensorList = [];
  String _accelerometerData = 'Accelerometer: Waiting for data...';
  StreamSubscription? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    _getSensorList();
    _accelerometerSubscription = _eventChannel.receiveBroadcastStream().listen(
      (dynamic event) {
        if (mounted) {
          setState(() {
            if (event is Map) {
              _accelerometerData =
                  'Accelerometer: X=${event['x']?.toStringAsFixed(2)}, Y=${event['y']?.toStringAsFixed(2)}, Z=${event['z']?.toStringAsFixed(2)}';
            }
          });
        }
      },
      onError: (dynamic error) {
        if (mounted) {
          setState(() {
            _accelerometerData = 'Accelerometer error: ${error.message}';
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  Future<void> _getSensorList() async {
    List<String> sensorList = [];
    try {
      final List<dynamic>? result = await _methodChannel
          .invokeMethod<List<dynamic>>('getSensorList');
      sensorList = result?.map((e) => e.toString()).toList() ?? [];
    } on PlatformException catch (e) {
      sensorList = ["Platform error: ${e.message}"];
    } on MissingPluginException catch (_) {
      sensorList = [
        "Not implemented: native code not found for 'getSensorList'.",
      ];
    } catch (e) {
      sensorList = ["Unexpected error: $e"];
    } finally {
      if (mounted) {
        setState(() {
          _sensorList = sensorList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sensor Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Available Sensors:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _sensorList
                            .map(
                              (sensor) =>
                                  Text(sensor, style: TextStyle(fontSize: 16)),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        _accelerometerData,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
