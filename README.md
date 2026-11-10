# Flutter MobX Vertical Slice - Temel Mimari Planı

## Context

`flutter_mobx_structure` şu an boş bir `flutter create` çıktısı (sadece `lib/main.dart`; Flutter 3.47, Dart ^3.13).
Yeni codebase'in genel kuralları belirleniyor. Bu plan, kullanıcının verdiği şartların ve netleşen kararların
iskeletidir. Detaylar kullanıcı tarafından sonradan netleştirilecek; bu plan onaylandıktan sonra sadece temel
altyapı kurulacak.

## Netleşen kararlar

| Konu              | Karar                                                                                                    |
| ----------------- | -------------------------------------------------------------------------------------------------------- |
| State management  | MobX (`mobx`, `flutter_mobx`, `mobx_codegen`)                                                            |
| Klasör yapısı     | Vertical slice                                                                                           |
| Router            | `go_router`                                                                                              |
| Network           | `dio`                                                                                                    |
| DI                | `get_it` + `injectable` (codegen)                                                                        |
| i18n              | Resmi `flutter gen_l10n` (ARB), flat key (`context.l10n.homeTitle`)                                      |
| Tema              | Multi theme, `ThemeExtension` token'ları, `ThemeStore`                                                   |
| Widget preview    | Flutter Widget Previewer (`@Preview`, `flutter widget-preview start`)                                    |
| Local storage     | `hive_ce` + `hive_ce_flutter` (shared_preferences yerine; orijinal `hive` 4 yıldır kararlı sürüm almadı) |
| Model             | `json_annotation` + `json_serializable`                                                                  |
| Feature içi yapı  | `view / store / service / model` (domain katmanı yok)                                                    |
| Context extension | Tek barrel dosyası ile import minimizasyonu                                                              |

## Klasör iskeleti

```
lib/
├── main.dart
├── app/
│   ├── app.dart                 # MaterialApp.router: tema + locale + router
│   ├── router/app_router.dart   # feature route'larını birleştirir
│   └── di/injector.dart         # @InjectableInit + configureDependencies()
├── core/
│   ├── network/                 # DioClient, interceptor'lar, Failure/Result
│   ├── theme/                   # AppTheme'ler, ThemeExtension token'ları, ThemeStore
│   ├── l10n/                    # arb/app_tr.arb, app_en.arb, LocaleStore
│   ├── storage/                 # Hive init + LocalStorage wrapper (box'lar: settings vb.)
│   └── extensions/
│       ├── extensions.dart      # TEK barrel (tüm context extension'ları)
│       ├── context_theme_x.dart # context.theme / context.colors / context.tokens
│       ├── context_l10n_x.dart  # context.l10n => AppLocalizations.of(context)
│       └── context_di_x.dart    # (opsiyonel) context.di<T>()
├── shared/
│   └── widgets/                 # kategori bazlı ortak widget'lar
│       ├── buttons/  app_button.dart + app_button.preview.dart
│       ├── inputs/   ...
│       └── feedback/ ...
└── features/
    └── <feature>/
        ├── view/    (page + widgets/)
        ├── store/   (MobX store + .g.dart)
        ├── service/ (dio çağrıları)
        ├── model/   (json_serializable modeller + .g.dart)
        └── <feature>_routes.dart   # feature kendi GoRoute'larını verir
```

## Kurallar

- Feature'lar birbirinin içine import yapmaz. Ortak ihtiyaç `core/` veya `shared/`'a taşınır.
- Feature'ın route'unu feature tanımlar, `app_router.dart` sadece birleştirir.
- Store'lar `@injectable` (sayfa ömürlü), app geneli (`ThemeStore`, `LocaleStore`) `@lazySingleton`.
- Service doğrudan `DioClient` kullanır (repository katmanı yok).
- Hive: `main()` içinde `Hive.initFlutter()` çağrılır, box'lar DI'dan önce açılır (`@preResolve` ile async kayıt).
  `ThemeStore` / `LocaleStore` seçimi `settings` box'ına yazar; feature'lar box'a doğrudan değil `LocalStorage`
  wrapper'ı üzerinden erişir. Basit değerler (tema, dil) için adapter gerekmez, modeller JSON/Map olarak saklanabilir.
- Context extension'lar import'u sıfırlamaz, teke indirir: `import 'package:flutter_mobx_structure/core/extensions/extensions.dart';`
- gen_l10n key'leri flat olduğundan feature prefix'i zorunlu: `homeTitle`, `authLoginButton`.
- Widget preview dosyaları `*.preview.dart` olarak widget'ın yanında durur; `group` parametresi widget kategorisini
  verir. Tema/locale/DI sarmalama için tek bir `PreviewWrapper` helper'ı yazılır (`@Preview(wrapper: ...)`).
  Not: Previewer API'si Flutter tarafından "stable değil" olarak işaretli, bu yüzden preview kodu uygulama
  koduna karışmaz.

## Uygulama adımları (onaydan sonra)

1. `pubspec.yaml`: bağımlılıkları ekle
   - dependencies: `mobx`, `flutter_mobx`, `go_router`, `dio`, `get_it`, `injectable`, `json_annotation`,
     `flutter_localizations` (sdk), `intl`, `hive_ce`, `hive_ce_flutter`
   - dev_dependencies: `build_runner`, `mobx_codegen`, `injectable_generator`, `json_serializable`,
     `hive_ce_generator` (sadece custom type adapter gerekirse)
   - `flutter: generate: true`, `l10n.yaml` oluştur (arb-dir: `lib/core/l10n/arb`)
2. `analysis_options.yaml`: generated dosyaları (`*.g.dart`, `*.config.dart`) analiz dışı bırak
3. `core/` altyapısı: `DioClient`, tema (light/dark + token extension), `ThemeStore`, `LocaleStore`, context extension'lar
4. `app/`: `injector.dart` (`@InjectableInit`), `app_router.dart`, `app.dart`, `main.dart` (DI init + runApp)
5. Örnek bir `features/home` (view + store + service + model) ile akışı uçtan uca göster
6. `shared/widgets/buttons/` altında örnek bir widget + `.preview.dart`
7. `dart run build_runner build` ve `flutter gen-l10n` çalıştır

## README taslağı (README.md'ye eklenecek)

```markdown
## dependencies

| Paket                   | Ne için                                          |
| ----------------------- | ------------------------------------------------ |
| `flutter_localizations` | gen_l10n ve Material widget çevirileri (SDK)     |
| `mobx`                  | State management çekirdeği                       |
| `flutter_mobx`          | `Observer` widget'ı                              |
| `go_router`             | Routing                                          |
| `dio`                   | Network                                          |
| `get_it`                | Service locator                                  |
| `injectable`            | get_it için annotation'lar                       |
| `json_annotation`       | Model annotation'ları                            |
| `intl`                  | Tarih/sayı formatı, gen_l10n bağımlılığı         |
| `hive_ce`               | Local storage                                    |
| `hive_ce_flutter`       | Hive Flutter entegrasyonu (`Hive.initFlutter()`) |

## dev_dependencies

| Paket                  | Ne için                                                           |
| ---------------------- | ----------------------------------------------------------------- |
| `flutter_lints`        | Lint kuralları                                                    |
| `build_runner`         | Kod üretimi. mobx_codegen ile uyumsuzluk var, güncellerken dikkat |
| `mobx_codegen`         | Store `.g.dart` üretimi                                           |
| `injectable_generator` | DI kayıt dosyası üretimi                                          |
| `json_serializable`    | Model `.g.dart` üretimi                                           |
```

## Doğrulama

- `flutter analyze` temiz
- `dart run build_runner build --delete-conflicting-outputs` hatasız
- `flutter run` ile örnek `home` sayfası açılır, tema ve dil değişimi `ThemeStore`/`LocaleStore` üzerinden çalışır
- `flutter widget-preview start` ile örnek widget preview'ı görünür
- `flutter test` (varsa örnek store testi) geçer
