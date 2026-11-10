// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LanguageStore on _LanguageStore, Store {
  late final _$localeAtom = Atom(
    name: '_LanguageStore.locale',
    context: context,
  );

  @override
  Locale? get locale {
    _$localeAtom.reportRead();
    return super.locale;
  }

  @override
  set locale(Locale? value) {
    _$localeAtom.reportWrite(value, super.locale, () {
      super.locale = value;
    });
  }

  late final _$setLocaleAsyncAction = AsyncAction(
    '_LanguageStore.setLocale',
    context: context,
  );

  @override
  Future<void> setLocale(Locale? newLocale) {
    return _$setLocaleAsyncAction.run(() => super.setLocale(newLocale));
  }

  @override
  String toString() {
    return '''
locale: ${locale}
    ''';
  }
}
