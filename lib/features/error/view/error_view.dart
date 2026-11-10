import 'package:flutter_mobx_structure/core/extensions/extensions.dart';
import 'package:flutter_mobx_structure/core/network/global_error.dart';
import 'package:flutter_mobx_structure/core/theme/app_spacing.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Global hataların (oturum düştü, bakım) tam ekran sayfası.
///
/// Her durumda bir çıkış vardır: buton uygulamanın giriş noktasına (`/`) döner.
/// Giriş noktası oturumu kontrol eder; auth feature'ı eklenince oturumu olmayan
/// kullanıcıyı giriş sayfasına o yönlendirir. Feature'lar birbirini import
/// etmediği için yol burada sabit yazılır.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error});

  final GlobalError error;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (message, action) = switch (error) {
      GlobalError.sessionExpired => (
        l10n.errorUnauthorized,
        l10n.actionContinue,
      ),
      GlobalError.maintenance => (
        l10n.errorServiceUnavailable,
        l10n.actionRetry,
      ),
    };

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.s16),
              FilledButton(
                onPressed: () => context.go('/'),
                child: Text(action),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
