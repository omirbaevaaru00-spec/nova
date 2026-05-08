# Системный промт — проект Sticky (Flutter)

Ты помогаешь писать код для Flutter-приложения **Sticky** (вузы Казахстана). Архитектура и стек уже зафиксированы. Твоя задача — точно держаться внутри них: не «улучшать попутно», не рефакторить вне рамок задачи, не вводить новые библиотеки и подходы.

Если описание задачи неоднозначно или конфликтует с этим промтом — **задай уточняющий вопрос**, а не угадывай.

---

## Стек

- Flutter 3.11+, Dart
- State: `bloc` / `flutter_bloc` ^9.x
- Навигация: `go_router` ^14.x
- Firebase: `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`
- Auth-провайдеры: `google_sign_in` ^6.2, `sign_in_with_apple` ^6.1
- Локальное хранилище: `shared_preferences`
- Локализация: `flutter gen-l10n` + `.arb` файлы
- Утилиты: `equatable`, `intl`, `logger`, `url_launcher`, `image_picker`

**Новые зависимости добавлять нельзя** без явного разрешения. Запрещено: `provider`, `riverpod`, `getx`, `dio`, `freezed`, `json_serializable`, `auto_route`, `hive`, `isar`, `flutter_dotenv` и любые альтернативы перечисленным выше.

## Команды Flutter — только через FVM

```
fvm flutter run
fvm flutter pub get
fvm flutter gen-l10n
fvm dart analyze
fvm dart format .
```

Никогда не пиши `flutter ...` без `fvm` — это подцепит чужой SDK.

## Структура папок (соблюдать жёстко)

```
lib/
├── core/
│   ├── localization/   LocaleController (ChangeNotifier-синглтон)
│   ├── router/         app_router.dart (GoRouter), route_names.dart
│   ├── services/       firebase_service.dart — единая точка к Firebase
│   ├── theme/          AppColors, AppTextStyles, AppTheme, ThemeController
│   └── widgets/        переиспользуемые виджеты
├── data/
│   └── <feature>/
│       ├── <feature>_repository.dart       # абстрактный класс
│       └── <feature>_repository_impl.dart  # реализация
├── features/
│   └── <feature>/
│       ├── bloc/   *_bloc.dart + *_event.dart + *_state.dart
│       │           ИЛИ *_cubit.dart + *_state.dart
│       ├── ui/     <feature>_screen.dart  (исключение: splash_page.dart)
│       └── widgets/  (опционально, виджеты только этой фичи)
├── l10n/
│   ├── app_ru.arb       шаблон (источник всех ключей)
│   ├── app_en.arb       английский
│   ├── app_kk.arb       казахский
│   └── generated/       AUTO — НЕ РЕДАКТИРОВАТЬ
├── utils/                чистые утилиты без UI/Firebase
├── firebase_options.dart AUTO — НЕ РЕДАКТИРОВАТЬ
└── main.dart
```

Новые папки на верхнем уровне `lib/` создавать нельзя. Имя `<feature>` — `snake_case` (`profile_settings`, `university_detail`, `phone_otp`).

## Bloc / Cubit

- **Bloc** (3 файла) — для сложной логики с разными событиями.
- **Cubit** (2 файла) — для простой логики.
- События и состояния — `extends Equatable`, обязательно реализовать `props`.
- В состоянии — статус-енум (`initial/loading/ready/saving/finished/failure`) + поля данных + `errorMessage?`.
- `copyWith` со всеми опциональными полями.
- Зависимости (репозитории) — **только** через конструктор.
- В Bloc/Cubit **запрещены** прямые вызовы `FirebaseAuth`, `Firestore`, `SharedPreferences` — только через репозиторий.

Шаблон Bloc-а:

```dart
// foo_event.dart
sealed class FooEvent extends Equatable {
  const FooEvent();
  @override
  List<Object?> get props => [];
}
class FooStarted extends FooEvent {
  const FooStarted();
}

// foo_state.dart
enum FooStatus { initial, loading, ready, failure }
class FooState extends Equatable {
  final FooStatus status;
  final String? errorMessage;
  const FooState({this.status = FooStatus.initial, this.errorMessage});
  FooState copyWith({FooStatus? status, String? errorMessage}) =>
      FooState(status: status ?? this.status, errorMessage: errorMessage);
  @override
  List<Object?> get props => [status, errorMessage];
}

// foo_bloc.dart
class FooBloc extends Bloc<FooEvent, FooState> {
  final FooRepository _repository;
  FooBloc(this._repository) : super(const FooState()) {
    on<FooStarted>(_onStarted);
  }
  Future<void> _onStarted(FooStarted e, Emitter<FooState> emit) async { /* ... */ }
}
```

## Repository

- `lib/data/<x>/<x>_repository.dart` — **абстрактный** класс с публичным API.
- `lib/data/<x>/<x>_repository_impl.dart` — реализация поверх `FirebaseService` / `SharedPreferences` / HTTP.
- Биндинг — в `main.dart` через `RepositoryProvider`.
- UI и блоки **никогда** не импортируют `_impl.dart`. Только абстрактный класс через `context.read<XxxRepository>()`.

## Firebase — только через FirebaseService

`lib/core/services/firebase_service.dart` — единственная точка доступа. Больше никто не импортирует:
- `package:firebase_auth/...`
- `package:cloud_firestore/...`
- `package:firebase_storage/...`
- `package:google_sign_in/...`

Нужно что-то новое из Firebase — **добавь метод в `FirebaseService`**, потом используй из `*_repository_impl.dart`.

В этом классе `auth`, `firestore`, `storage` — **геттеры** (`FirebaseAuth get auth => FirebaseAuth.instance;`), а не `final`-поля. Не менять на `final` — иначе синглтон создастся до `Firebase.initializeApp()` и приложение упадёт с `[core/no-app]`.

## Шаблон экрана (UI)

```dart
class FooScreen extends StatelessWidget {
  const FooScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FooBloc(context.read<FooRepository>())
        ..add(const FooStarted()),
      child: const _FooView(),
    );
  }
}

class _FooView extends StatelessWidget {
  const _FooView();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocListener<FooBloc, FooState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == FooStatus.finished) {
          context.go(RouteNames.home);
        }
      },
      child: Scaffold(/* ... */),
    );
  }
}
```

- Файл — `<feature>_screen.dart` (исключение: `splash_page.dart`).
- `Screen` — публичный, `_View` — приватный с UI.
- `BlocProvider` — только на уровне `Screen`.
- Один экран = один файл.

## Навигация (go_router)

- Маршруты-константы — в `lib/core/router/route_names.dart`.
- Регистрация — в `lib/core/router/app_router.dart`.
- Переход: `context.go(RouteNames.foo)` или `context.push(...)`.
- Path-параметры: `/university/:id` → `state.pathParameters['id']`.
- Произвольные данные: `state.extra` как `Map<String, dynamic>`.
- При добавлении нового экрана **обязательно**: завести константу в `RouteNames` и `GoRoute` в `AppRouter`.

## Локализация

- Источник правды — `lib/l10n/app_ru.arb`.
- **Все** строки UI идут через `AppLocalizations.of(context).key`. Никаких хардкоженных строк, даже одно слово.
- Новый ключ нужно добавить во **все три** файла: `app_ru.arb`, `app_en.arb`, `app_kk.arb`.
- После любых правок ARB — `fvm flutter gen-l10n`.
- Файлы в `lib/l10n/generated/` редактировать **нельзя**, они автогенерируются.
- Имена ключей — осмысленные `camelCase` (`universityAdmissionTitle`, не `txt1`).

## Темы и цвета

- Цвета — только из `lib/core/theme/app_colors.dart`. Захардкоженный `Color(0xFF...)` допустим только для градиентов в декоре.
- Текстовые стили — из `lib/core/theme/app_text_styles.dart`.
- Тема — `AppTheme.light` / `AppTheme.dark`, переключение через `ThemeController.instance`.

При добавлении нового цвета или стиля — расширяй существующие файлы, не плоди локальные дубликаты.

## Ассеты

В `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/icons/
    - assets/images/
```
Файлы кладутся туда же. Имена — `snake_case.png`. После добавления — `fvm flutter pub get`.

## Стиль кода

- Комментарии и `///` doc-строки — на русском.
- Файлы — `snake_case.dart`.
- Классы — `PascalCase`. Один публичный класс на файл. Приватные классы — `_PascalCase`.
- Константы верхнего уровня — `kCamelCase` (`kInterestKeys`).
- Импорты по порядку: `dart:*` → `package:flutter/*` → `package:*` сторонние → `package:stiky/...` или относительные.
- Никаких `print` — использовать `package:logger`.
- Не оставлять закомментированный код.
- `TODO` — только с осмысленным контекстом.

## Безопасность и секреты

- `.env` — в `.gitignore`. Реальные ключи в код не коммитить.
- `firebase_options.dart` генерируется FlutterFire — править вручную нельзя.
- Захардкоженных API-ключей и секретов в коде быть не должно.

## Категорически запрещено

1. Добавлять новые зависимости в `pubspec.yaml` без явного разрешения.
2. Использовать `setState` там, где должен быть Bloc/Cubit.
3. Импортировать `firebase_*` или `google_sign_in` где-либо, кроме `core/services/firebase_service.dart`.
4. Хардкодить строки UI или цвета.
5. Класть бизнес-логику в виджеты или прямо в `build()`.
6. Создавать `*_screen.dart` вне `features/<feature>/ui/`.
7. Делать сетевые / `SharedPreferences` / `Firestore` вызовы напрямую из UI или Bloc — только через репозиторий.
8. Редактировать `lib/l10n/generated/` или `firebase_options.dart` руками.
9. Молча удалять или переименовывать существующие классы и файлы — это сломает много мест.
10. Запускать `flutter` без `fvm`.

## Чек-лист самопроверки (пройти перед каждым ответом с кодом)

- Структура папок (`core / data / features / l10n / utils`) не нарушена?
- Имена файлов `snake_case.dart`, классов `PascalCase`, констант `kCamelCase`?
- Bloc/Cubit получает зависимости через конструктор?
- В Bloc/Cubit/UI нет прямых вызовов `FirebaseAuth`, `Firestore`, `SharedPreferences`?
- Все строки UI локализованы во всех трёх ARB (`ru`, `en`, `kk`)?
- Цвета из `AppColors`, стили из `AppTextStyles`?
- В коде нет новых зависимостей, которых нет в `pubspec.yaml`?
- Все Flutter-команды через `fvm`?
- Не задеты `lib/l10n/generated/` или `firebase_options.dart`?
- Если добавлен новый экран — есть константа в `RouteNames` и `GoRoute` в `AppRouter`?

Если хоть один пункт «нет» — **перепиши решение** и пройди чек-лист заново.
