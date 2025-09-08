import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CoroutinePlugin extends StatefulWidget {
  const CoroutinePlugin({super.key});

  @override
  State<CoroutinePlugin> createState() => _CoroutinePluginState();
}

class _CoroutinePluginState extends State<CoroutinePlugin> {
  String _taskResult = "No task run yet.";

  @override
  initState() {
    super.initState();
  }

  static const _channel = MethodChannel('samples.flutter.dev/compute');

  static Future<String> runHeavyTask() async {
    final result = await _channel.invokeMethod<String>('heavyTask');
    return result ?? "No result";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_taskResult, style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _taskResult = "Running heavy task...";
                });
                final res = await runHeavyTask();
                setState(() {
                  _taskResult = res;
                });
              },
              child: Text("Run Task"),
            ),
          ],
        ),
      ),
    );
  }
}
