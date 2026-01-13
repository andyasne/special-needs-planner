import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:special_needs_planner/data/app_state_store.dart';
import 'package:special_needs_planner/data/models/supplement_plan.dart';
import 'package:special_needs_planner/ui/section_header.dart';

class PlanEditorScreen extends StatelessWidget {
  const PlanEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final store = context.watch<AppStateStore>();
    final plans = store.state.supplementPlans;
    final preferredTime = store.state.preferredTherapyTime;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan editor'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Plan settings', style: textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Manage supplement schedules and therapy time.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          const SectionHeader(title: 'Supplements'),
          const SizedBox(height: 12),
          if (plans.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Create a supplement plan to edit schedules.',
                  style: textTheme.bodyMedium,
                ),
              ),
            )
          else
            ...plans.map((plan) => _SupplementScheduleCard(plan: plan)),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Therapy time'),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.schedule_outlined),
              title: Text('Preferred time'),
              subtitle: Text(preferredTime),
              trailing: TextButton(
                onPressed: () => _pickTherapyTime(context),
                child: const Text('Edit'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTherapyTime(BuildContext context) async {
    final store = context.read<AppStateStore>();
    final current = _parseTime(store.state.preferredTherapyTime) ??
        const TimeOfDay(hour: 16, minute: 0);
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
    );
    if (picked == null) return;
    final formatted = _formatTime(picked);
    store.updatePreferredTherapyTime(formatted);
  }

  TimeOfDay? _parseTime(String value) {
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _SupplementScheduleCard extends StatelessWidget {
  const _SupplementScheduleCard({required this.plan});

  final SupplementPlan plan;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final store = context.read<AppStateStore>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(plan.name, style: textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                '${plan.baseDose} ${plan.doseUnit} · ${plan.frequencyPerDay}x per day',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: plan.scheduleTimes
                    .map(
                      (time) => Chip(
                        label: Text(time),
                        onDeleted: () {
                          final updatedTimes = [...plan.scheduleTimes]
                            ..remove(time);
                          store.updateSupplementPlan(
                            plan.copyWith(scheduleTimes: updatedTimes),
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 8, minute: 0),
                  );
                  if (picked == null) return;
                  final formatted = _formatTime(picked);
                  if (plan.scheduleTimes.contains(formatted)) return;
                  final updatedTimes = [...plan.scheduleTimes, formatted]..sort();
                  store.updateSupplementPlan(
                    plan.copyWith(scheduleTimes: updatedTimes),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add time'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
