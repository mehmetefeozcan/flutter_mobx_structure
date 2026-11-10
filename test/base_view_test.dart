import 'package:flutter_mobx_structure/core/base/base_store.dart';
import 'package:flutter_mobx_structure/core/base/base_view.dart';
import 'package:flutter_mobx_structure/core/network/result.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class _Store extends BaseStore {
  int created = 0;
}

class _Page extends StatefulWidget {
  const _Page({required this.store, required this.errors});

  final _Store store;
  final List<ApiException> errors;

  @override
  State<_Page> createState() => _PageState();
}

class _PageState extends State<_Page> with BaseViewMixin<_Page, _Store> {
  CancelToken? token;

  @override
  _Store createStore() {
    widget.store.created++;
    return widget.store;
  }

  @override
  Future<void> onInit() async {
    store.runResult<String>((t) {
      token = t;
      return t.whenCancel.then(
        (_) => const Failure(
          ApiException('cancelled', type: ApiErrorType.cancelled),
        ),
      );
    });
  }

  @override
  void onError(ApiException error) => widget.errors.add(error);

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

void main() {
  testWidgets('store bir kez oluşur, hata onError a gider, kapanınca iptal', (
    tester,
  ) async {
    final store = _Store();
    final errors = <ApiException>[];

    await tester.pumpWidget(_Page(store: store, errors: errors));
    final state = tester.state<_PageState>(find.byType(_Page));
    await tester.pump();
    expect(store.created, 1);

    await store.runResult<int>(
      (_) async => const Failure(ApiException('x', type: ApiErrorType.server)),
    );
    expect(errors.single.type, ApiErrorType.server);

    await tester.pumpWidget(const SizedBox.shrink());
    expect(state.token!.isCancelled, isTrue);
    expect(store.created, 1);
  });
}
