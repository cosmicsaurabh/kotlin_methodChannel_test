import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CoroutineInfo extends StatefulWidget {
  const CoroutineInfo({super.key});

  @override
  State<CoroutineInfo> createState() => _CoroutineInfoState();
}

class _CoroutineInfoState extends State<CoroutineInfo> {
  // Results
  String _resultMainThread = "No task run yet (MTB)";
  String _resultThreadBlocked = "No task run yet (Thread)";
  String _resultNonBlocking = "No task run yet (Non-blocking)";
  String _resultCompute = "No task run yet (Compute)";

  static const _channel = MethodChannel('samples.flutter.dev/compute');

  // Methods
  Future<void> _run(String method, Function(String) updateState) async {
    updateState("Running $method...");
    final result = await _channel.invokeMethod<String>(method);
    updateState(result ?? "No result");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kotlin Coroutines Demo")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTaskCard(
              title: "1️⃣ Main Thread Blocked (UI freezes ❌)",
              result: _resultMainThread,
              onRun: () => _run(
                "heavyTaskMainThreadBlocked",
                (r) => setState(() => _resultMainThread = r),
              ),
            ),
            _buildTaskCard(
              title: "2️⃣ Worker Thread Blocked (UI fine ⚠️)",
              result: _resultThreadBlocked,
              onRun: () => _run(
                "heavyTask",
                (r) => setState(() => _resultThreadBlocked = r),
              ),
            ),
            _buildTaskCard(
              title: "3️⃣ Non-blocking Suspend (Best ✅)",
              result: _resultNonBlocking,
              onRun: () => _run(
                "heavyTaskNonBlocking",
                (r) => setState(() => _resultNonBlocking = r),
              ),
            ),
            _buildTaskCard(
              title: "4️⃣ CPU-bound Compute (Fibonacci)",
              result: _resultCompute,
              onRun: () => _run(
                "computeTask",
                (r) => setState(() => _resultCompute = r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard({
    required String title,
    required String result,
    required VoidCallback onRun,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(result, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRun, child: const Text("Run Task")),
          ],
        ),
      ),
    );
  }
}
