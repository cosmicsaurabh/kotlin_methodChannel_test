import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NetworkInfo extends StatefulWidget {
  @override
  _NetworkInfoState createState() => _NetworkInfoState();
}

class _NetworkInfoState extends State<NetworkInfo> {
  static const platform = MethodChannel('samples.flutter.dev/network');

  String _networkType = 'Unknown network type.';
  String _connectivityStatus = 'Unknown connectivity status.';

  Future<void> _getNetworkType() async {
    String networkType = 'Unknown network type.';
    try {
      final String? result = await platform.invokeMethod<String>(
        'getNetworkType',
      );
      networkType = 'Network Type: ${result ?? 'Unknown'}';
    } on PlatformException catch (e) {
      networkType = "Platform error: ${e.message}";
    } on MissingPluginException catch (_) {
      networkType =
          "Not implemented: native code not found for 'getNetworkType'.";
    } catch (e) {
      networkType = "Unexpected error: $e";
    } finally {
      if (mounted) {
        setState(() {
          _networkType = networkType;
        });
      }
    }
  }

  Future<void> _getConnectivityStatus() async {
    String connectivityStatus = 'Unknown connectivity status.';
    try {
      final bool? result = await platform.invokeMethod<bool>(
        'getConnectivityStatus',
      );
      connectivityStatus = 'Connected: ${result ?? false}';
    } on PlatformException catch (e) {
      connectivityStatus = "Platform error: ${e.message}";
    } on MissingPluginException catch (_) {
      connectivityStatus =
          "Not implemented: native code not found for 'getConnectivityStatus'.";
    } catch (e) {
      connectivityStatus = "Unexpected error: $e";
    } finally {
      if (mounted) {
        setState(() {
          _connectivityStatus = connectivityStatus;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Network Example")),
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
                                _networkType,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _getNetworkType,
                          child: Text("📡 Type"),
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
                                _connectivityStatus,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _getConnectivityStatus,
                          child: Text("📡 Status"),
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
      _networkType = 'Unknown network type.';
      _connectivityStatus = 'Unknown connectivity status.';
    });
  }
}
