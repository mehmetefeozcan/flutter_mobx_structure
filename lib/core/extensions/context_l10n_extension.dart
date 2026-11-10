import 'package:flutter_mobx_structure/core/l10n/app_localizations.dart';

import 'package:flutter/widgets.dart';

extension ContextL10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
