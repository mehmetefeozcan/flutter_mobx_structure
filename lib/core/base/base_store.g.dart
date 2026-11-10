// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BaseStore on _BaseStore, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??= Computed<bool>(
    () => super.isLoading,
    name: '_BaseStore.isLoading',
  )).value;

  late final _$_activeRequestsAtom = Atom(
    name: '_BaseStore._activeRequests',
    context: context,
  );

  @override
  int get _activeRequests {
    _$_activeRequestsAtom.reportRead();
    return super._activeRequests;
  }

  @override
  set _activeRequests(int value) {
    _$_activeRequestsAtom.reportWrite(value, super._activeRequests, () {
      super._activeRequests = value;
    });
  }

  late final _$lastErrorAtom = Atom(
    name: '_BaseStore.lastError',
    context: context,
  );

  @override
  ApiException? get lastError {
    _$lastErrorAtom.reportRead();
    return super.lastError;
  }

  @override
  set lastError(ApiException? value) {
    _$lastErrorAtom.reportWrite(value, super.lastError, () {
      super.lastError = value;
    });
  }

  late final _$_BaseStoreActionController = ActionController(
    name: '_BaseStore',
    context: context,
  );

  @override
  void clearError() {
    final _$actionInfo = _$_BaseStoreActionController.startAction(
      name: '_BaseStore.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_BaseStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
lastError: ${lastError},
isLoading: ${isLoading}
    ''';
  }
}
