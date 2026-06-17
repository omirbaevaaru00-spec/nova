// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'WELCOME';

  @override
  String get welcomeDescription =>
      'Удобный сервис для абитуриентов —\nсравнивай вузы, узнавай проходные\nбаллы, выбирай специальность\nи подавай документы в один клик.';

  @override
  String get welcomeSkip => 'Продолжить';

  @override
  String get continueText => 'Продолжить';

  @override
  String get chooseLanguage => 'Выберите язык';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageRussianSubtitle => 'Интерфейс на русском языке';

  @override
  String get languageKazakh => 'Қазақша';

  @override
  String get languageKazakhSubtitle => 'Интерфейс қазақ тілінде';

  @override
  String get localeShortRu => 'РУ';

  @override
  String get localeShortKk => 'ҚАЗ';

  @override
  String get quizTitle => 'Выбери, что тебе\nинтересно';

  @override
  String get quizSubtitle =>
      'Мы настроим ленту под твои цели, интересы\nи планы на будущее';

  @override
  String get quizSelected => 'Выбрано';

  @override
  String get quizSkip => 'Пропустить';

  @override
  String get quizNext => 'Далее';

  @override
  String get interestIT => 'IT и технологии';

  @override
  String get interestMedicine => 'Медицина';

  @override
  String get interestBusiness => 'Бизнес и экономика';

  @override
  String get interestGrants => 'Гранты';

  @override
  String get interestDesign => 'Дизайн и креатив';

  @override
  String get interestLaw => 'Юриспруденция';

  @override
  String get interestPedagogy => 'Педагогика';

  @override
  String get interestEngineering => 'Инженерия';

  @override
  String get interestBachelor => 'Бакалавриат';

  @override
  String get interestCollege => 'Колледж';

  @override
  String get interestMaster => 'Магистратура';

  @override
  String get navHome => 'Главная';

  @override
  String get navNotifications => 'Уведомления';

  @override
  String get navProfile => 'Профиль';

  @override
  String get screenNotifications => 'Уведомления';

  @override
  String get screenFavorites => 'Избранное';

  @override
  String get screenNews => 'Новости';

  @override
  String get screenSavedSearches => 'Сохранённые поиски';

  @override
  String get favoriteAuthRequired => 'Сохрани в избранное';

  @override
  String get favoriteAuthSubtitle =>
      'Чтобы сохранить университет в избранное,\nнужно зарегистрироваться';

  @override
  String get actionRegister => 'Зарегистрироваться';

  @override
  String get actionLater => 'Позже';

  @override
  String get universityTypeStateShort => 'Гос';

  @override
  String get universityTypePrivateShort => 'Частный';

  @override
  String get loginTitle => 'Снова вместе!';

  @override
  String get loginSubtitle => 'Мы скучали — классно, что ты снова с нами!';

  @override
  String get loginIdHint => 'Эл. почта';

  @override
  String get passwordHint => 'Пароль';

  @override
  String get loginForgotPassword => 'Забыли пароль?';

  @override
  String get loginAction => 'Войти';

  @override
  String get loginNoAccountPrefix => 'Нет аккаунта? ';

  @override
  String get loginPhoneSoon => 'Вход по телефону — скоро будет доступен';

  @override
  String get orDivider => 'ИЛИ';

  @override
  String get googleSignIn => 'Войти через Google';

  @override
  String get forgotTitle => 'Забыли пароль?';

  @override
  String get forgotSubtitle =>
      'Введи email — мы отправим\nссылку для сброса пароля';

  @override
  String get forgotSentTitle => 'Письмо отправлено!';

  @override
  String forgotSentSubtitle(String email) {
    return 'Мы отправили ссылку для сброса пароля на\n$email';
  }

  @override
  String get emailHint => 'Электронная почта';

  @override
  String get forgotSendAction => 'Отправить ссылку';

  @override
  String get forgotBackToLogin => 'Вернуться к входу';

  @override
  String get forgotCheckSpam => 'Не пришло письмо? Проверь папку «Спам»';

  @override
  String get errorGeneric => 'Что-то пошло не так. Попробуй ещё раз.';

  @override
  String get errorUserNotFound => 'Пользователь не найден';

  @override
  String get errorEmailNotFound => 'Пользователь с таким email не найден';

  @override
  String get errorWrongPassword => 'Неверный пароль';

  @override
  String get errorInvalidEmail => 'Неверный формат email';

  @override
  String get errorUserDisabled => 'Аккаунт заблокирован';

  @override
  String get errorTooManyRequests => 'Слишком много попыток. Подожди немного.';

  @override
  String get errorInvalidCredential => 'Неверный email или пароль';

  @override
  String get errorLogin => 'Ошибка входа. Попробуй ещё раз.';

  @override
  String get errorInvalidPhone =>
      'Неверный номер телефона. Проверь и попробуй снова.';

  @override
  String get errorQuotaExceeded => 'Превышен лимит SMS. Попробуй позже.';

  @override
  String get errorNetwork => 'Нет интернета. Проверь соединение.';

  @override
  String get registerTitle => 'Введите телефон или адрес\nэл.почты';

  @override
  String get registerModePhone => 'Телефон';

  @override
  String get registerModeEmail => 'Электронная почта';

  @override
  String get registerPhoneLabel => 'Номер телефона';

  @override
  String get registerPhoneCountryCode => 'KZ +7';

  @override
  String get registerPhoneHint => '7XX XXX XX XX';

  @override
  String get registerEmailLabel => 'Электронная почта';

  @override
  String get registerEmailHint => 'example@mail.com';

  @override
  String get registerPolicy =>
      'Ознакомьтесь с нашей Политикой Конфиденциальности';

  @override
  String get registerProceed => 'Далее';

  @override
  String get registerHasAccountPrefix => 'Уже есть аккаунт? ';

  @override
  String get registerLoginAction => 'Войти';

  @override
  String get googleContinue => 'Продолжить через Google';

  @override
  String get googleError => 'Ошибка входа через Google';

  @override
  String get phoneOtpTitle => 'Введите код';

  @override
  String phoneOtpSubtitle(String phone) {
    return 'Мы отправили SMS на номер\n$phone';
  }

  @override
  String get phoneOtpResend => 'Отправить код повторно';

  @override
  String phoneOtpResendIn(int seconds) {
    return 'Отправить повторно через $secondsс';
  }

  @override
  String get phoneOtpVerify => 'Подтвердить';

  @override
  String get phoneOtpInvalidCode => 'Неверный код. Проверь и попробуй ещё раз.';

  @override
  String get profileSetupTitle => 'Расскажи о себе';

  @override
  String get profileSetupSubtitle =>
      'Заполни профиль — это займёт\nменьше минуты';

  @override
  String get profileSetupNameLabel => 'Имя / Никнейм';

  @override
  String get profileSetupNameHint => 'Например: Арууке';

  @override
  String get profileSetupCityLabel => 'Город';

  @override
  String get profileSetupCityHint => 'Например: Алматы';

  @override
  String get profileSetupPasswordLabel => 'Придумай пароль';

  @override
  String get profileSetupPasswordHint => 'Минимум 6 символов';

  @override
  String get profileSetupContinue => 'Продолжить';

  @override
  String get errorEmailInUse =>
      'Этот email уже зарегистрирован. Войди через «Войти».';

  @override
  String get errorWeakPassword => 'Пароль слишком простой. Минимум 6 символов.';

  @override
  String get errorAuth => 'Ошибка авторизации. Попробуй снова.';

  @override
  String get profileFallbackName => 'Пользователь';

  @override
  String get profileFavoritesSection => 'избранные';

  @override
  String get profileFavoritesEmpty => 'Нет избранных университетов';

  @override
  String get profilePhotoTitle => 'Фото профиля';

  @override
  String get profilePhotoTake => 'Сделать фото';

  @override
  String get profilePhotoPick => 'Выбрать из галереи';

  @override
  String get actionCancel => 'Отмена';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileLogout => 'Выйти из аккаунта';

  @override
  String get profileGuestTitle => 'Войди в аккаунт';

  @override
  String get profileGuestSubtitle => 'Чтобы видеть избранное и историю поиска';

  @override
  String get profileScores => 'Мои баллы';

  @override
  String get profileFavorites => 'Избранное';

  @override
  String get profileSavedSearches => 'Сохранённые поиски';

  @override
  String get profileSettings => 'Настройки';

  @override
  String get profileEditScores => 'Изменить баллы';

  @override
  String get profileEditInterests => 'Изменить интересы';

  @override
  String get profileLanguage => 'Язык';

  @override
  String get profileTheme => 'Тёмная тема';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSaved => 'Сохранено';

  @override
  String get settingsSaveError => 'Не удалось сохранить';

  @override
  String get settingsEditProfile => 'Редактировать профиль';

  @override
  String get settingsEmpty => 'Не заполнено';

  @override
  String get settingsEditScores => 'Редактировать баллы';

  @override
  String get settingsQuiz => 'Пройти опрос по интересам';

  @override
  String get settingsInterestsEmpty => 'Не выбраны';

  @override
  String get settingsLanguageItem => 'Сменить язык';

  @override
  String get settingsThemeItem => 'Тёмная тема';

  @override
  String get settingsPhotoItem => 'Добавить фото';

  @override
  String get settingsPhotoSubtitle => 'Сделать фото или из галереи';

  @override
  String get settingsHelpItem => 'Нужна помощь';

  @override
  String get settingsHelpSubtitle => 'Центр помощи · FAQ и поддержка';

  @override
  String get settingsLogoutItem => 'Выйти из аккаунта';

  @override
  String get settingsLogoutConfirmTitle => 'Выйти из аккаунта?';

  @override
  String get settingsLogoutConfirmText => 'Вы уверены, что хотите выйти?';

  @override
  String get actionExit => 'Выйти';

  @override
  String get actionSave => 'Сохранить';

  @override
  String get actionOk => 'Ок';

  @override
  String get settingsAuthTitle => 'Требуется вход';

  @override
  String get settingsAuthText => 'Войдите в аккаунт чтобы сохранять баллы.';

  @override
  String get settingsPhotoUpdated => 'Фото обновлено';

  @override
  String get settingsPhotoError => 'Ошибка загрузки фото';

  @override
  String get dialogNamePlaceholder => 'Имя / ник';

  @override
  String get dialogCityPlaceholder => 'Город (напр. Алматы)';

  @override
  String get dialogGpaPlaceholder => 'GPA (напр. 3.8)';

  @override
  String get dialogIeltsPlaceholder => 'IELTS (напр. 7.0)';

  @override
  String get dialogEntPlaceholder => 'ЕНТ (напр. 120)';

  @override
  String get languageEnglish => 'English';

  @override
  String get searchTitle => 'Поиск';

  @override
  String get searchHint => 'Поиск по учреждениям...';

  @override
  String get searchHistoryTitle => 'История поиска';

  @override
  String get searchHistoryClear => 'Очистить';

  @override
  String get searchHistoryAuthRequired =>
      'Войди в аккаунт чтобы сохранять историю поиска';

  @override
  String get searchSavedFilterChip => 'Применить сохранённый фильтр';

  @override
  String get searchSaveFilter => 'Сохранить фильтр';

  @override
  String get searchDeleteSavedFilter => 'Удалить сохранённый';

  @override
  String get searchFilterSaved => 'Фильтр сохранён';

  @override
  String get searchFilterDeleted => 'Сохранённый фильтр удалён';

  @override
  String get searchSectionTypes => 'Тип';

  @override
  String get searchSectionLangs => 'Язык';

  @override
  String get searchSectionDirs => 'Направление';

  @override
  String get searchSectionFormats => 'Формат';

  @override
  String get searchSectionCosts => 'Стоимость';

  @override
  String get searchEmpty => 'Ничего не найдено';

  @override
  String get searchFilters => 'Фильтры';

  @override
  String get searchClear => 'Сбросить';

  @override
  String get searchApply => 'Применить';

  @override
  String get filterCity => 'Город';

  @override
  String get filterType => 'Тип';

  @override
  String get filterLanguage => 'Язык обучения';

  @override
  String get filterCost => 'Стоимость';

  @override
  String get filterDirection => 'Направление';

  @override
  String get universityCost => 'Стоимость';

  @override
  String get universityDuration => 'Срок обучения';

  @override
  String get universityLanguage => 'Язык обучения';

  @override
  String get universityFormat => 'Формат';

  @override
  String get universityWebsite => 'Сайт';

  @override
  String get universityInstagram => 'Instagram';

  @override
  String get universityDescription => 'Описание';

  @override
  String get universityDirections => 'Направления';

  @override
  String get universityRequirements => 'Требования';

  @override
  String universityMinEnt(int value) {
    return 'Мин. балл ЕНТ: $value';
  }

  @override
  String universityMinGpa(double value) {
    return 'Мин. GPA: $value';
  }

  @override
  String universityMinIelts(double value) {
    return 'Мин. IELTS: $value';
  }

  @override
  String get universityTabDescription => 'описание';

  @override
  String get universityTabPrograms => 'специальности';

  @override
  String get universityTabNews => 'новости';

  @override
  String get universityNewsEmpty => 'Новостей пока нет';

  @override
  String get universityAdmissionTitle => 'Условия поступления';

  @override
  String get universityTabReviews => 'Отзывы';

  @override
  String get reviewsAdd => 'Оставить отзыв';

  @override
  String get reviewsSubmit => 'Опубликовать';

  @override
  String get reviewsEmpty => 'Отзывов пока нет';

  @override
  String get reviewSpeciality => 'Специальность';

  @override
  String get reviewYear => 'Год поступления';

  @override
  String get reviewText => 'Напишите ваш отзыв...';

  @override
  String get professionDuration => 'Срок обучения';

  @override
  String get professionCost => 'Стоимость';

  @override
  String get professionLanguage => 'Язык';

  @override
  String get professionJobs => 'Кем можно работать';

  @override
  String get professionJobsExample => 'Разработчик, аналитик, архитектор ПО';

  @override
  String get actionClose => 'Закрыть';

  @override
  String get profileUnauthTitle => 'Войди, чтобы открыть профиль';

  @override
  String get profileUnauthSubtitle =>
      'Сохраняй избранные университеты, отслеживай баллы и получай персональные рекомендации.';

  @override
  String get profileUnauthCta => 'Зарегистрироваться';

  @override
  String get profileUnauthLogin => 'Уже есть аккаунт? Войти';

  @override
  String get notificationsEmpty => 'Нет новостей';

  @override
  String get notificationsEmptyHint =>
      'Добавь университеты в избранное — здесь будут появляться их новости.';

  @override
  String get reviewsViewAll => 'Все отзывы';

  @override
  String get reviewsEmptyHint =>
      'Будьте первым — нажмите + чтобы оставить отзыв.';

  @override
  String get notificationsAuthRequired => 'Войди, чтобы видеть новости';

  @override
  String get notificationsAuthSubtitle =>
      'Добавляй университеты в избранное — и здесь будут появляться их новости.';

  @override
  String get supportTitle => 'Поддержка';

  @override
  String get supportDescription => 'Здесь вы можете обратиться за помощью.';

  @override
  String get supportTelegramButton => 'Написать в Telegram';

  @override
  String get supportResponseTime => 'Обычно отвечаем в течение 2–4 часов';

  @override
  String get supportFaq1Question => 'Как найти подходящий вуз?';

  @override
  String get supportFaq1Answer => 'Используйте фильтры на экране поиска.';

  @override
  String get supportFaq2Question => 'Как добавить вуз в избранное?';

  @override
  String get supportFaq2Answer => 'Нажмите на иконку сердца. Нужен аккаунт.';

  @override
  String get supportFaq3Question => 'Как сменить язык?';

  @override
  String get supportFaq3Answer => 'Настройки → Язык.';

  @override
  String get settingsDeleteAccount => 'Удалить аккаунт';

  @override
  String get settingsDeleteAccountConfirmTitle => 'Удалить аккаунт?';

  @override
  String get settingsDeleteAccountConfirmBody =>
      'Все данные будут удалены навсегда.';

  @override
  String get settingsDeleteAccountCancel => 'Отмена';

  @override
  String get settingsDeleteAccountConfirm => 'Удалить';

  @override
  String get settingsDeleteAccountSuccess => 'Аккаунт удалён';

  @override
  String get registerSubtitle => 'Введите email для создания аккаунта';

  @override
  String get validationEmailRequired => 'Введите email';

  @override
  String get validationEmailInvalid => 'Некорректный формат email';

  @override
  String get reviewDeleteTitle => 'Удалить отзыв?';

  @override
  String get reviewDeleteBody => 'Это действие нельзя отменить.';

  @override
  String get reviewDeleteConfirm => 'Удалить';

  @override
  String get reviewThanksTitle => 'Спасибо за ваш отзыв!';

  @override
  String get reviewThanksSubtitle => 'Ваш отзыв поможет другим абитуриентам.';

  @override
  String get profileScoresEnt => 'ЕНТ';

  @override
  String get profileEntLabel => 'ЕНТ';
}
