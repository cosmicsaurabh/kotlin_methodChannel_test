import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatteryInfo extends StatefulWidget {
  @override
  _BatteryPageState createState() => _BatteryPageState();
}

class _BatteryPageState extends State<BatteryInfo> {
  static const platform = MethodChannel('samples.flutter.dev/battery');

  String _batteryLevel = 'Unknown battery level.';
  String _batteryStatus = 'Unknown battery status.';
  String _batteryHealth = 'Unknown battery health.';
  String _isCharging = 'Unknown charging status.';

  Future<void> _getBatteryLevel() async {
    String nextText = _batteryLevel;
    try {
      final int? result = await platform.invokeMethod<int>('getBatteryLevel');
      nextText = 'Battery level: ${result ?? -1}%';
    } on PlatformException catch (e) {
      nextText = "Platform error: ${e.message}";
    } on MissingPluginException catch (_) {
      nextText =
          "Not implemented: native code not found for 'getBatteryLevel'.";
    } catch (e) {
      nextText = "Unexpected error: $e";
    } finally {
      if (mounted) {
        setState(() {
          _batteryLevel = nextText;
        });
      }
    }
  }

  Future<void> _getBatteryStatus() async {
    String batteryStatus = 'Unknown battery status.';
    try {
      final int? result = await platform.invokeMethod<int>('getBatteryStatus');
      batteryStatus = 'Battery status: ${result ?? -1}';
    } on PlatformException catch (e) {
      batteryStatus = "Platform error: ${e.message}";
    } on MissingPluginException catch (_) {
      batteryStatus =
          "Not implemented: native code not found for 'getBatteryStatus'.";
    } catch (e) {
      batteryStatus = "Unexpected error: $e";
    } finally {
      if (mounted) {
        setState(() {
          _batteryStatus = batteryStatus;
        });
      }
    }
  }

  Future<void> _getBatteryHealth() async {
    String batteryHealth = 'Unknown battery health.';
    try {
      final int? result = await platform.invokeMethod<int>('getBatteryHealth');
      batteryHealth = 'Battery health: ${result ?? -1}';
    } on PlatformException catch (e) {
      batteryHealth = "Platform error: ${e.message}";
    } on MissingPluginException catch (_) {
      batteryHealth =
          "Not implemented: native code not found for 'getBatteryHealth'.";
    } catch (e) {
      batteryHealth = "Unexpected error: $e";
    } finally {
      if (mounted) {
        setState(() {
          _batteryHealth = batteryHealth;
        });
      }
    }
  }

  Future<void> _getIsCharging() async {
    String isCharging = 'Unknown charging status.';
    try {
      final bool? result = await platform.invokeMethod<bool>('isCharging');
      isCharging = 'Charging status: ${result ?? false}';
    } on PlatformException catch (e) {
      isCharging = "Platform error: ${e.message}";
    } on MissingPluginException catch (_) {
      isCharging = "Not implemented: native code not found for 'isCharging'.";
    } catch (e) {
      isCharging = "Unexpected error: $e";
    } finally {
      if (mounted) {
        setState(() {
          _isCharging = isCharging;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Battery Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          children: [
            GridTile(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              child: Text(
                                _batteryLevel,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _getBatteryLevel,
                          child: Text("🔋 level"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GridTile(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              child: Text(
                                _batteryStatus,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _getBatteryStatus,
                          child: Text("🔋 status"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GridTile(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              child: Text(
                                _batteryHealth,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _getBatteryHealth,
                          child: Text("🔋 health"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GridTile(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              child: Text(
                                _isCharging,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _getIsCharging,
                          child: Text("🔋 charging"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: resetAll,
        child: Icon(Icons.restore),
      ),
    );
  }

  void resetAll() {
    setState(() {
      _batteryLevel = 'Unknown battery level.';
      _batteryStatus = 'Unknown battery status.';
      _batteryHealth = 'Unknown battery health.';
      _isCharging = 'Unknown charging status.';
    });
  }
}
