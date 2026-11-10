// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'My App';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionContinue => 'Continue';

  @override
  String get errorNetwork => 'Could not connect to the internet.';

  @override
  String get errorTimeout => 'The server did not respond. Please try again.';

  @override
  String get errorServer =>
      'Something went wrong on our side. Please try again later.';

  @override
  String get errorUnknown => 'An unexpected error occurred.';

  @override
  String get errorBadRequest => 'Invalid request.';

  @override
  String get errorNotFound => 'The requested content could not be found.';

  @override
  String get errorUnauthorized =>
      'Your session has expired. Please sign in again.';

  @override
  String get errorForbidden => 'You are not allowed to perform this action.';

  @override
  String get errorRateLimited =>
      'Too many attempts. Please wait a while and try again.';

  @override
  String get errorServiceUnavailable =>
      'This action is unavailable right now. Please try again later.';
}
