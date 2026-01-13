import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:special_needs_planner/data/app_state_store.dart';
import 'package:special_needs_planner/data/models/supplement_log.dart';
import 'package:special_needs_planner/data/models/supplement_plan.dart';
import 'package:special_needs_planner/features/supplements/supplement_wizard_screen.dart';
import 'package:special_needs_planner/ui/section_header.dart';

class SupplementsScreen extends StatelessWidget {
  const SupplementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final store = context.watch<AppStateStore>();
    final plans = store.state.supplementPlans;
    final logs = store.state.supplementLogs.reversed.toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Supplements', style: textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          'Keep doses consistent with gentle reminders.',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        SectionHeader(
          title: 'Today\'s plan',
          action: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SupplementWizardScreen(),
                ),
              );
            },
            child: const Text('Create plan'),
          ),
        ),
        const SizedBox(height: 12),
        if (plans.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No supplement plan yet. Create one to get started.',
                style: textTheme.bodyMedium,
              ),
            ),
          )
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_nextDoseLabel(plans.first), style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${plans.first.name} - ${plans.first.baseDose} ${plans.first.doseUnit}',
                    style: textTheme.bodyMedium,
                  ),
                  if (plans.first.notes != null && plans.first.notes!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        plans.first.notes!,
                        style: textTheme.bodySmall,
                      ),
                    ),
                  if (plans.first.rampUpSteps != null &&
                      plans.first.rampUpSteps!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Ramp-up: ${plans.first.rampUpSteps!.join(', ')}',
                        style: textTheme.bodySmall,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilledButton(
                        onPressed: () {
                          store.logSupplement(
                            SupplementLog(
                              id: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              planId: plans.first.id,
                              scheduledAt: DateTime.now(),
                              status: SupplementLogStatus.taken,
                              recordedAt: DateTime.now(),
                            ),
                          );
                        },
                        child: const Text('Mark taken'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {
                          store.logSupplement(
                            SupplementLog(
                              id: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              planId: plans.first.id,
                              scheduledAt: DateTime.now(),
                              status: SupplementLogStatus.rescheduled,
                              recordedAt: DateTime.now(),
                            ),
                          );
                        },
                        child: const Text('Reschedule'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 24),
        const SectionHeader(title: 'Schedule'),
        const SizedBox(height: 12),
        if (plans.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Add a plan to build a schedule.',
                style: textTheme.bodyMedium,
              ),
            ),
          )
        else
          Card(
            child: Column(
              children: plans
                  .expand((plan) => plan.scheduleTimes.map(
                        (time) => ListTile(
                          leading: const Icon(Icons.alarm_outlined),
                          title: Text(time),
                          subtitle: Text(
                            '${plan.name} - ${plan.baseDose} ${plan.doseUnit}',
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        const SizedBox(height: 24),
        const SectionHeader(title: 'History'),
        const SizedBox(height: 12),
        if (logs.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No history yet. Logs will appear here.',
                style: textTheme.bodyMedium,
              ),
            ),
          )
        else
          Card(
            child: Column(
              children: logs
                  .map(
                    (log) => Column(
                      children: [
                        ListTile(
                          leading: Icon(_statusIcon(log.status)),
                          title: Text(_statusLabel(log.status)),
                          subtitle: Text(
                            '${_planName(plans, log.planId)} · ${_formatLogTime(log.scheduledAt)}',
                          ),
                        ),
                        if (log != logs.last) const Divider(height: 1),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }

  String _nextDoseLabel(SupplementPlan plan) {
    if (plan.scheduleTimes.isEmpty) {
      return 'Next dose time not set';
    }
    return 'Next dose at ${plan.scheduleTimes.first}';
  }

  String _planName(List<SupplementPlan> plans, String planId) {
    final plan = plans.firstWhere(
      (item) => item.id == planId,
      orElse: () => const SupplementPlan(
        id: 'unknown',
        name: 'Supplement',
        doseUnit: '',
        baseDose: 0,
        frequencyPerDay: 0,
        scheduleTimes: [],
      ),
    );
    return plan.name;
  }

  String _formatLogTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _statusLabel(SupplementLogStatus status) {
    switch (status) {
      case SupplementLogStatus.taken:
        return 'Taken';
      case SupplementLogStatus.skipped:
        return 'Skipped';
      case SupplementLogStatus.rescheduled:
        return 'Rescheduled';
      case SupplementLogStatus.missed:
        return 'Missed';
    }
  }

  IconData _statusIcon(SupplementLogStatus status) {
    switch (status) {
      case SupplementLogStatus.taken:
        return Icons.check_circle_outline;
      case SupplementLogStatus.skipped:
        return Icons.cancel_outlined;
      case SupplementLogStatus.rescheduled:
        return Icons.schedule_outlined;
      case SupplementLogStatus.missed:
        return Icons.error_outline;
    }
  }
}
