import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:special_needs_planner/data/app_state_store.dart';
import 'package:special_needs_planner/data/models/supplement_plan.dart';
import 'package:special_needs_planner/data/models/therapy_protocol.dart';
import 'package:special_needs_planner/features/therapy/therapy_session_screen.dart';
import 'package:special_needs_planner/features/today/plan_editor_screen.dart';
import 'package:special_needs_planner/ui/section_header.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final store = context.watch<AppStateStore>();
    final plans = store.state.supplementPlans;
    final protocols = store.state.therapyProtocols;
    final preferredTime = store.state.preferredTherapyTime;

    final entries = _buildEntries(context, plans, protocols, preferredTime);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Today', style: textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          'Your combined supplement and therapy timeline.',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        SectionHeader(
          title: 'Upcoming',
          action: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PlanEditorScreen(),
                ),
              );
            },
            child: const Text('Edit plan'),
          ),
        ),
        const SizedBox(height: 12),
        if (entries.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No items scheduled yet. Add a plan to populate your day.',
                style: textTheme.bodyMedium,
              ),
            ),
          )
        else
          Card(
            child: Column(
              children: entries
                  .map(
                    (entry) => Column(
                      children: [
                        ListTile(
                          leading: Icon(entry.icon),
                          title: Text(entry.title),
                          subtitle: Text(entry.subtitle),
                          trailing: entry.actionLabel == null
                              ? null
                              : TextButton(
                                  onPressed: entry.onAction,
                                  child: Text(entry.actionLabel!),
                                ),
                          onTap: entry.onTap,
                        ),
                        if (entry != entries.last) const Divider(height: 1),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }

  List<_TimelineEntry> _buildEntries(
    BuildContext context,
    List<SupplementPlan> plans,
    List<TherapyProtocol> protocols,
    String preferredTherapyTime,
  ) {
    final now = DateTime.now();
    final entries = <_TimelineEntry>[];

    for (final plan in plans) {
      for (final time in plan.scheduleTimes) {
        final parsed = _parseTime(now, time);
        if (parsed == null) continue;
        entries.add(
          _TimelineEntry(
            time: parsed,
            title: _formatTime(parsed),
            subtitle: '${plan.name} - ${plan.baseDose} ${plan.doseUnit}',
            icon: Icons.medication_outlined,
          ),
        );
      }
    }

    if (protocols.isNotEmpty) {
      final protocol = protocols.first;
      final sessionTime = _nextSessionTime(now, preferredTherapyTime);
      void openSession() {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TherapySessionScreen(protocol: protocol),
          ),
        );
      }
      entries.add(
        _TimelineEntry(
          time: sessionTime,
          title: _formatTime(sessionTime),
          subtitle:
              '${protocol.title} - ${protocol.defaultDurationMinutes ?? 15} min',
          icon: Icons.self_improvement_outlined,
          actionLabel: 'Start',
          onAction: openSession,
          onTap: openSession,
        ),
      );
    }

    entries.sort((a, b) => a.time.compareTo(b.time));
    return entries;
  }

  DateTime? _parseTime(DateTime base, String time) {
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return DateTime(base.year, base.month, base.day, hour, minute);
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  DateTime _nextSessionTime(DateTime now, String time) {
    final parts = time.split(':');
    if (parts.length != 2) {
      return DateTime(now.year, now.month, now.day, 16, 0);
    }
    final hour = int.tryParse(parts[0]) ?? 16;
    final minute = int.tryParse(parts[1]) ?? 0;
    final scheduled = DateTime(now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      return scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}

class _TimelineEntry {
  _TimelineEntry({
    required this.time,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.actionLabel,
    this.onAction,
    this.onTap,
  });

  final DateTime time;
  final String title;
  final String subtitle;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onTap;
}
