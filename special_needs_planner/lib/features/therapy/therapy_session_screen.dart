import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:special_needs_planner/data/app_state_store.dart';
import 'package:special_needs_planner/data/models/therapy_protocol.dart';
import 'package:special_needs_planner/data/models/therapy_session.dart';

class TherapySessionScreen extends StatefulWidget {
  const TherapySessionScreen({super.key, required this.protocol});

  final TherapyProtocol protocol;

  @override
  State<TherapySessionScreen> createState() => _TherapySessionScreenState();
}

class _TherapySessionScreenState extends State<TherapySessionScreen> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;
  int _rating = 3;
  final Set<int> _completedSteps = {};
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _timer?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final duration = widget.protocol.defaultDurationMinutes ?? 15;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.protocol.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(widget.protocol.category, style: textTheme.bodyMedium),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Session timer', style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    _formatTimer(_elapsedSeconds),
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text('Recommended: $duration min', style: textTheme.bodyMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilledButton(
                        onPressed: _toggleTimer,
                        child: Text(_isRunning ? 'Pause' : 'Start'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: _resetTimer,
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Guided steps', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: List.generate(
                widget.protocol.steps.length,
                (index) => CheckboxListTile(
                  value: _completedSteps.contains(index),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _completedSteps.add(index);
                      } else {
                        _completedSteps.remove(index);
                      }
                    });
                  },
                  title: Text(widget.protocol.steps[index]),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Session rating', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Slider(
            min: 1,
            max: 5,
            divisions: 4,
            label: _rating.toString(),
            value: _rating.toDouble(),
            onChanged: (value) {
              setState(() => _rating = value.round());
            },
          ),
          const SizedBox(height: 16),
          Text('Notes', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Add observations or adjustments...',
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => _saveSession(context),
            child: const Text('Save session'),
          ),
        ],
      ),
    );
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsedSeconds += 1);
    });
    setState(() => _isRunning = true);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _elapsedSeconds = 0;
      _isRunning = false;
    });
  }

  void _saveSession(BuildContext context) {
    final store = context.read<AppStateStore>();
    final session = TherapySession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      protocolId: widget.protocol.id,
      startedAt: DateTime.now(),
      durationMinutes: (_elapsedSeconds / 60).ceil(),
      rating: _rating,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      completedChecklist: _completedSteps
          .map((index) => widget.protocol.steps[index])
          .toList(),
    );
    store.logTherapySession(session);
    Navigator.of(context).pop();
  }

  String _formatTimer(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remaining = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remaining';
  }
}
