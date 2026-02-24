import 'dart:io';

import 'package:birdify/models/observation.dart';
import 'package:birdify/repos/observations_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ObservationsPage extends StatelessWidget {
  const ObservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 24,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.bookmarks_outlined, color: cs.primary, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'My Observations',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: -0.3,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder<List<Observation>>(
        valueListenable: ObservationsService.notifier,
        builder: (context, observations, _) {
          if (observations.isEmpty) {
            return _EmptyState(cs: cs);
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            itemCount: observations.length,
            itemBuilder: (context, i) =>
                _ObservationCard(obs: observations[i], cs: cs),
          );
        },
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primary.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.bookmarks_outlined,
                size: 52,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No observations yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Identify a bird on the Home tab and\ntap "Save Observation" to log it here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: cs.onSurface.withValues(alpha: 0.5),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Observation Card ──────────────────────────────────────────────────────────

class _ObservationCard extends StatelessWidget {
  const _ObservationCard({required this.obs, required this.cs});

  final Observation obs;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM d, yyyy').format(obs.date);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Dismissible(
        key: Key(obs.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => ObservationsService.remove(obs.id),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: cs.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.delete_outline_rounded, color: cs.error, size: 22),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: cs.onSurface.withValues(alpha: 0.07),
            ),
          ),
          child: Row(
            children: [
              // Image / placeholder
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: obs.imagePath != null
                    ? Image.file(
                        File(obs.imagePath!),
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _ImagePlaceholder(cs: cs),
                      )
                    : _ImagePlaceholder(cs: cs),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        obs.birdName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (obs.scientificName.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          obs.scientificName,
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: cs.onSurface.withValues(alpha: 0.4),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      _MetaRow(
                        icon: Icons.calendar_today_outlined,
                        text: dateStr,
                        cs: cs,
                      ),
                      if (obs.habitat.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        _MetaRow(
                          icon: Icons.forest_outlined,
                          text: obs.habitat,
                          cs: cs,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.text, required this.cs});

  final IconData icon;
  final String text;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: cs.onSurface.withValues(alpha: 0.35)),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: cs.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      color: cs.primary.withValues(alpha: 0.08),
      child: Icon(
        Icons.flutter_dash,
        size: 36,
        color: cs.primary.withValues(alpha: 0.4),
      ),
    );
  }
}
