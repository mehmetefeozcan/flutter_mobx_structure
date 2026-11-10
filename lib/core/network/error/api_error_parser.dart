import 'package:flutter_mobx_structure/core/l10n/app_localizations.dart';
import 'package:flutter_mobx_structure/core/network/result.dart';

/// API hata metinlerini (backend anahtarları) kullanıcıya gösterilecek
/// l10n metinlerine çevirir.
///
/// Öncelik: bağlantı/zaman aşımı tipi → bilinen backend anahtarı → hata tipi.
abstract final class ApiErrorParser {
  static String parse(ApiException? error, AppLocalizations l10n) {
    if (error == null) return l10n.errorUnknown;

    switch (error.type) {
      case ApiErrorType.network:
        return l10n.errorNetwork;
      case ApiErrorType.timeout:
        return l10n.errorTimeout;
      default:
        break;
    }

    final byKey = _byKey(error.message, l10n);
    if (byKey != null) return byKey;

    return _byType(error.type, l10n);
  }

  /// Backend'in döndüğü bilinen mesaj anahtarları (örnek). Kendi backend
  /// sözleşmene göre genişlet; feature'a özel anahtarlar (ör. auth) kendi
  /// feature'larında ele alınmalı.
  static String? _byKey(String key, AppLocalizations l10n) {
    switch (key) {
      case 'server_error':
      case 'invalid_response':
        return l10n.errorServer;

      default:
        return null;
    }
  }

  static String _byType(ApiErrorType type, AppLocalizations l10n) {
    return switch (type) {
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
}

/// `error.localized(context.l10n)` kullanımı için.
extension ApiExceptionLocalizedExtension on ApiException? {
  String localized(AppLocalizations l10n) => ApiErrorParser.parse(this, l10n);
}
