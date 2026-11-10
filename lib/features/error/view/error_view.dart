import 'package:flutter_mobx_structure/core/enums/app_error_enums.dart';
import 'package:flutter_mobx_structure/core/extensions/extensions.dart';
import 'package:flutter_mobx_structure/core/l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Sayfadan bağımsız (bağlantı yok, oturum düştü, bakım...) hataların tam ekran sayfası.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.type});

  final AppErrorEnums type;

  String _message(AppLocalizations l10n) => switch (type) {
    AppErrorEnums.noConnection => l10n.errorNetwork,
    AppErrorEnums.sessionExpired => l10n.errorUnauthorized,
    AppErrorEnums.forbidden => l10n.errorForbidden,
    AppErrorEnums.maintenance => l10n.errorServiceUnavailable,
    AppErrorEnums.notFound => l10n.errorNotFound,
    AppErrorEnums.wentWrong => l10n.errorUnknown,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_message(l10n), textAlign: TextAlign.center),
              if (type.isRetryable) ...[
                const SizedBox(height: 16),
                // TODO: sessionExpired için giriş sayfasına yönlendirme auth feature'ı ile eklenecek.
                FilledButton(
                  onPressed: () => context.go('/'),
                  child: Text(l10n.actionRetry),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
