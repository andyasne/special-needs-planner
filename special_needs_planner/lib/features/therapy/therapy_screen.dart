import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:special_needs_planner/data/app_state_store.dart';
import 'package:special_needs_planner/data/models/therapy_protocol.dart';
import 'package:special_needs_planner/features/therapy/therapy_session_screen.dart';
import 'package:special_needs_planner/ui/section_header.dart';

class TherapyScreen extends StatelessWidget {
  const TherapyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final store = context.watch<AppStateStore>();
    final protocols = store.state.therapyProtocols;
    final preferredTime = store.state.preferredTherapyTime;
    final sessions = store.state.therapySessions.reversed.toList();
    final recentSessions = sessions.take(3).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Guided therapy', style: textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          'Step-by-step sessions with timers and cues.',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Next session'),
        const SizedBox(height: 12),
        if (protocols.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No therapy plans yet. Add one to get started.',
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
                  Text(
                    _nextSessionLabel(preferredTime),
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _protocolSummary(protocols.first),
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      _openSession(context, protocols.first);
                    },
                    child: const Text('Start session'),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 24),
        const SectionHeader(title: 'Therapy library'),
        const SizedBox(height: 12),
        if (protocols.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Therapy protocols will appear here.',
                style: textTheme.bodyMedium,
              ),
            ),
          )
        else
          Card(
            child: Column(
              children: protocols
                  .map(
                    (protocol) => Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.record_voice_over_outlined),
                          title: Text(protocol.title),
                          subtitle: Text(protocol.category),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _openSession(context, protocol),
                        ),
                        if (protocol != protocols.last)
                          const Divider(height: 1),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        const SizedBox(height: 24),
        const SectionHeader(title: 'Recent notes'),
        const SizedBox(height: 12),
        if (recentSessions.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Notes will appear after completing sessions.',
                style: textTheme.bodyMedium,
              ),
            ),
          )
        else
          Card(
            child: Column(
              children: recentSessions
                  .map(
                    (session) => Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.notes_outlined),
                          title: Text(
                            _protocolTitle(protocols, session.protocolId),
                          ),
                          subtitle: Text(
                            '${_formatSessionTime(session.startedAt)} · Rating ${session.rating ?? '-'}',
                          ),
                        ),
                        if (session != recentSessions.last)
                          const Divider(height: 1),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }

  void _openSession(BuildContext context, TherapyProtocol protocol) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TherapySessionScreen(protocol: protocol),
      ),
    );
  }

  String _protocolSummary(TherapyProtocol protocol) {
    final minutes = protocol.defaultDurationMinutes ?? 15;
    return '${protocol.title} - $minutes min';
  }

  String _nextSessionLabel(String preferredTime) {
    final now = DateTime.now();
    final parts = preferredTime.split(':');
    final hour = parts.length == 2 ? int.tryParse(parts[0]) ?? 16 : 16;
    final minute = parts.length == 2 ? int.tryParse(parts[1]) ?? 0 : 0;
    final scheduled = DateTime(now.year, now.month, now.day, hour, minute);
    final isTomorrow = scheduled.isBefore(now);
    final labelTime = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    return isTomorrow ? 'Tomorrow at $labelTime' : 'Today at $labelTime';
  }

  String _protocolTitle(List<TherapyProtocol> protocols, String id) {
    final protocol = protocols.firstWhere(
      (item) => item.id == id,
      orElse: () => const TherapyProtocol(
        id: 'unknown',
        title: 'Therapy session',
        category: '',
        steps: [],
      ),
    );
    return protocol.title;
  }

  String _formatSessionTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
