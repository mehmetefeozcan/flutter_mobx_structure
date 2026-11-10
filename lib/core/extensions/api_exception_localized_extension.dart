import 'package:flutter_mobx_structure/core/l10n/app_localizations.dart';
import 'package:flutter_mobx_structure/core/network/result.dart';

/// Hatanın kullanıcıya gösterilecek metni: `error.localized(context.l10n)`.
///
/// Metin hata türünden üretilir; sunucunun `message` alanı gösterilmez.
/// Feature'a özel durumlar (ör. "e-posta kayıtlı") ilgili feature'da ele alınır.
extension ApiExceptionLocalizedExtension on ApiException? {
  String localized(AppLocalizations l10n) => switch (this?.type) {
    ApiErrorType.network => l10n.errorNetwork,
    ApiErrorType.timeout => l10n.errorTimeout,
    ApiErrorType.unauthorized => l10n.errorUnauthorized,
    ApiErrorType.forbidden => l10n.errorForbidden,
    ApiErrorType.notFound => l10n.errorNotFound,
    ApiErrorType.badRequest => l10n.errorBadRequest,
    ApiErrorType.tooManyRequests => l10n.errorRateLimited,
    ApiErrorType.server => l10n.errorServer,
    ApiErrorType.maintenance => l10n.errorServiceUnavailable,
    _ => l10n.errorUnknown,
  };
}
