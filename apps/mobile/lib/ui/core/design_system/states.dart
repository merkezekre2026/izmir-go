import 'package:flutter/material.dart';
import 'package:izmir_go/app/theme/tokens.dart';
import 'package:izmir_go/core/time.dart';
import 'package:izmir_go/domain/models/fresh.dart';
import 'package:izmir_go/domain/models/transit.dart';
import 'package:izmir_go/ui/core/l10n.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Semantics(
      label: context.l10n.loading,
      child: MediaQuery.disableAnimationsOf(context)
          ? const Icon(Icons.hourglass_empty, size: 32)
          : const CircularProgressIndicator(),
    ),
  );
}

class MessageView extends StatelessWidget {
  const MessageView({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(IzSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(child: Icon(icon, size: 48, color: theme.colorScheme.outline)),
            const SizedBox(height: IzSpace.md),
            Text(title, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: IzSpace.sm),
              Text(message!, style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: IzSpace.lg),
              FilledButton.tonal(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView(this.error, {this.onRetry, super.key});
  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => MessageView(
    icon: Icons.error_outline,
    title: failureMessage(context.l10n, error),
    actionLabel: onRetry == null ? null : context.l10n.retry,
    onAction: onRetry,
  );
}

/// Shown above any data that came from the device cache.
class FreshnessBanner extends StatelessWidget {
  const FreshnessBanner(this.fresh, {super.key});
  final Fresh<Object?> fresh;

  @override
  Widget build(BuildContext context) {
    if (!fresh.isCached) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Semantics(
      liveRegion: true,
      child: Material(
        color: theme.colorScheme.tertiaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: IzSpace.gutter, vertical: IzSpace.sm),
          child: Row(
            children: [
              Icon(Icons.cloud_off, size: 18, color: theme.colorScheme.onTertiaryContainer),
              const SizedBox(width: IzSpace.sm),
              Expanded(
                child: Text(
                  context.l10n.offlineBanner(formatDateTime(fresh.fetchedAt)),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Server-provided caveats (excluded sources, missing holiday calendars, ...).
class NoticeList extends StatelessWidget {
  const NoticeList(this.notices, {this.include, super.key});
  final List<Notice> notices;

  /// Only show these codes (null = all).
  final Set<String>? include;

  @override
  Widget build(BuildContext context) {
    final seen = <String>{};
    final visible = [
      for (final n in notices)
        if ((include == null || include!.contains(n.code)) && seen.add(n.message)) n,
    ];
    if (visible.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: IzSpace.gutter, vertical: IzSpace.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final n in visible)
            Padding(
              padding: const EdgeInsets.only(bottom: IzSpace.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 16, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: IzSpace.sm),
                  Expanded(child: Text(n.message, style: theme.textTheme.bodySmall)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
