import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:special_needs_planner/data/app_state_store.dart';
import 'package:special_needs_planner/data/models/supplement_plan.dart';

class SupplementWizardScreen extends StatefulWidget {
  const SupplementWizardScreen({super.key});

  @override
  State<SupplementWizardScreen> createState() =>
      _SupplementWizardScreenState();
}

class _SupplementWizardScreenState extends State<SupplementWizardScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _doseController = TextEditingController();
  final _unitController = TextEditingController(text: 'mg');
  final _notesController = TextEditingController();
  final _rampUpController = TextEditingController();
  final List<TimeOfDay> _times = [];
  int _frequencyPerDay = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    _unitController.dispose();
    _notesController.dispose();
    _rampUpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New supplement plan'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _handleContinue,
        onStepCancel: _handleCancel,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                FilledButton(
                  onPressed: details.onStepContinue,
                  child: Text(_currentStep == 2 ? 'Save plan' : 'Continue'),
                ),
                const SizedBox(width: 12),
                if (_currentStep > 0)
                  OutlinedButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Basics'),
            isActive: _currentStep >= 0,
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Supplement name',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter a supplement name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _doseController,
                    decoration: const InputDecoration(
                      labelText: 'Base dose',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter a dose';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _unitController,
                    decoration: const InputDecoration(
                      labelText: 'Dose unit',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      hintText: 'With food, morning only, etc.',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('Schedule'),
            isActive: _currentStep >= 1,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Times per day'),
                    const Spacer(),
                    DropdownButton<int>(
                      value: _frequencyPerDay,
                      items: List.generate(
                        5,
                        (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text('${index + 1}'),
                        ),
                      ),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _frequencyPerDay = value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _times
                      .map(
                        (time) => Chip(
                          label: Text(time.format(context)),
                          onDeleted: () {
                            setState(() => _times.remove(time));
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _addTime,
                  icon: const Icon(Icons.add),
                  label: const Text('Add time'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _rampUpController,
                  decoration: const InputDecoration(
                    labelText: 'Ramp-up steps (optional)',
                    hintText: 'Example: 50, 100, 150',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Review'),
            isActive: _currentStep >= 2,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${_nameController.text.isEmpty ? '-' : _nameController.text}'),
                const SizedBox(height: 8),
                Text('Dose: ${_doseController.text.isEmpty ? '-' : _doseController.text} ${_unitController.text}'),
                const SizedBox(height: 8),
                Text('Times per day: $_frequencyPerDay'),
                const SizedBox(height: 8),
                Text('Schedule: ${_times.isEmpty ? 'Add times' : _times.map((t) => t.format(context)).join(', ')}'),
                const SizedBox(height: 8),
                Text('Ramp-up: ${_rampUpController.text.isEmpty ? 'None' : _rampUpController.text}'),
                const SizedBox(height: 8),
                Text('Notes: ${_notesController.text.isEmpty ? 'None' : _notesController.text}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleContinue() {
    if (_currentStep == 0 && !_formKey.currentState!.validate()) {
      return;
    }
    if (_currentStep == 2) {
      _savePlan();
      return;
    }
    setState(() => _currentStep += 1);
  }

  void _handleCancel() {
    if (_currentStep == 0) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _currentStep -= 1);
  }

  Future<void> _addTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked == null) return;
    setState(() => _times.add(picked));
  }

  void _savePlan() {
    final store = context.read<AppStateStore>();
    final rampUpSteps = _parseRampUpSteps(_rampUpController.text);
    final plan = SupplementPlan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      doseUnit: _unitController.text.trim(),
      baseDose: double.tryParse(_doseController.text) ?? 0,
      frequencyPerDay: _frequencyPerDay,
      scheduleTimes: _times.map(_formatTime).toList(),
      rampUpSteps: rampUpSteps.isEmpty ? null : rampUpSteps,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );
    store.addSupplementPlan(plan);
    Navigator.of(context).pop();
  }

  List<double> _parseRampUpSteps(String input) {
    final values = input.split(',');
    final steps = <double>[];
    for (final value in values) {
      final parsed = double.tryParse(value.trim());
      if (parsed != null) {
        steps.add(parsed);
      }
    }
    return steps;
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
