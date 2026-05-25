import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('kk'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'WELCOME'**
  String get appTitle;

  /// No description provided for @welcomeDescription.
  ///
  /// In ru, this message translates to:
  /// **'Удобный сервис для абитуриентов —\nсравнивай вузы, узнавай проходные\nбаллы, выбирай специальность\nи подавай документы в один клик.'**
  String get welcomeDescription;

  /// No description provided for @welcomeSkip.
  ///
  /// In ru, this message translates to:
  /// **'Пропустить'**
  String get welcomeSkip;

  /// No description provided for @continueText.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get continueText;

  /// No description provided for @chooseLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Выберите язык'**
  String get chooseLanguage;

  /// No description provided for @languageRussian.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @languageRussianSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Интерфейс на русском языке'**
  String get languageRussianSubtitle;

  /// No description provided for @languageKazakh.
  ///
  /// In ru, this message translates to:
  /// **'Қазақша'**
  String get languageKazakh;

  /// No description provided for @languageKazakhSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Интерфейс қазақ тілінде'**
  String get languageKazakhSubtitle;

  /// No description provided for @localeShortRu.
  ///
  /// In ru, this message translates to:
  /// **'РУ'**
  String get localeShortRu;

  /// No description provided for @localeShortKk.
  ///
  /// In ru, this message translates to:
  /// **'ҚАЗ'**
  String get localeShortKk;

  /// No description provided for @quizTitle.
  ///
  /// In ru, this message translates to:
  /// **'Выбери, что тебе\nинтересно'**
  String get quizTitle;

  /// No description provided for @quizSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Мы настроим ленту под твои цели, интересы\nи планы на будущее'**
  String get quizSubtitle;

  /// No description provided for @quizSelected.
  ///
  /// In ru, this message translates to:
  /// **'Выбрано'**
  String get quizSelected;

  /// No description provided for @quizSkip.
  ///
  /// In ru, this message translates to:
  /// **'Пропустить'**
  String get quizSkip;

  /// No description provided for @quizNext.
  ///
  /// In ru, this message translates to:
  /// **'Далее'**
  String get quizNext;

  /// No description provided for @interestIT.
  ///
  /// In ru, this message translates to:
  /// **'IT и технологии'**
  String get interestIT;

  /// No description provided for @interestMedicine.
  ///
  /// In ru, this message translates to:
  /// **'Медицина'**
  String get interestMedicine;

  /// No description provided for @interestBusiness.
  ///
  /// In ru, this message translates to:
  /// **'Бизнес и экономика'**
  String get interestBusiness;

  /// No description provided for @interestGrants.
  ///
  /// In ru, this message translates to:
  /// **'Гранты'**
  String get interestGrants;

  /// No description provided for @interestDesign.
  ///
  /// In ru, this message translates to:
  /// **'Дизайн и креатив'**
  String get interestDesign;

  /// No description provided for @interestLaw.
  ///
  /// In ru, this message translates to:
  /// **'Юриспруденция'**
  String get interestLaw;

  /// No description provided for @interestPedagogy.
  ///
  /// In ru, this message translates to:
  /// **'Педагогика'**
  String get interestPedagogy;

  /// No description provided for @interestEngineering.
  ///
  /// In ru, this message translates to:
  /// **'Инженерия'**
  String get interestEngineering;

  /// No description provided for @interestBachelor.
  ///
  /// In ru, this message translates to:
  /// **'Бакалавриат'**
  String get interestBachelor;

  /// No description provided for @interestCollege.
  ///
  /// In ru, this message translates to:
  /// **'Колледж'**
  String get interestCollege;

  /// No description provided for @interestMaster.
  ///
  /// In ru, this message translates to:
  /// **'Магистратура'**
  String get interestMaster;

  /// No description provided for @navHome.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get navHome;

  /// No description provided for @navNotifications.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get navNotifications;

  /// No description provided for @navProfile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get navProfile;

  /// No description provided for @screenNotifications.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get screenNotifications;

  /// No description provided for @screenFavorites.
  ///
  /// In ru, this message translates to:
  /// **'Избранное'**
  String get screenFavorites;

  /// No description provided for @screenNews.
  ///
  /// In ru, this message translates to:
  /// **'Новости'**
  String get screenNews;

  /// No description provided for @screenSavedSearches.
  ///
  /// In ru, this message translates to:
  /// **'Сохранённые поиски'**
  String get screenSavedSearches;

  /// No description provided for @favoriteAuthRequired.
  ///
  /// In ru, this message translates to:
  /// **'Сохрани в избранное'**
  String get favoriteAuthRequired;

  /// No description provided for @favoriteAuthSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Чтобы сохранить университет в избранное,\nнужно зарегистрироваться'**
  String get favoriteAuthSubtitle;

  /// No description provided for @actionRegister.
  ///
  /// In ru, this message translates to:
  /// **'Зарегистрироваться'**
  String get actionRegister;

  /// No description provided for @actionLater.
  ///
  /// In ru, this message translates to:
  /// **'Позже'**
  String get actionLater;

  /// No description provided for @universityTypeStateShort.
  ///
  /// In ru, this message translates to:
  /// **'Гос'**
  String get universityTypeStateShort;

  /// No description provided for @universityTypePrivateShort.
  ///
  /// In ru, this message translates to:
  /// **'Частный'**
  String get universityTypePrivateShort;

  /// No description provided for @loginTitle.
  ///
  /// In ru, this message translates to:
  /// **'Снова вместе!'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Мы скучали — классно, что ты снова с нами!'**
  String get loginSubtitle;

  /// No description provided for @loginIdHint.
  ///
  /// In ru, this message translates to:
  /// **'Эл. почта или номер'**
  String get loginIdHint;

  /// No description provided for @passwordHint.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get passwordHint;

  /// No description provided for @loginForgotPassword.
  ///
  /// In ru, this message translates to:
  /// **'Забыли пароль?'**
  String get loginForgotPassword;

  /// No description provided for @loginAction.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get loginAction;

  /// No description provided for @loginNoAccountPrefix.
  ///
  /// In ru, this message translates to:
  /// **'Нет аккаунта? '**
  String get loginNoAccountPrefix;

  /// No description provided for @loginPhoneSoon.
  ///
  /// In ru, this message translates to:
  /// **'Вход по телефону — скоро будет доступен'**
  String get loginPhoneSoon;

  /// No description provided for @orDivider.
  ///
  /// In ru, this message translates to:
  /// **'ИЛИ'**
  String get orDivider;

  /// No description provided for @googleSignIn.
  ///
  /// In ru, this message translates to:
  /// **'Войти через Google'**
  String get googleSignIn;

  /// No description provided for @forgotTitle.
  ///
  /// In ru, this message translates to:
  /// **'Забыли пароль?'**
  String get forgotTitle;

  /// No description provided for @forgotSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Введи email — мы отправим\nссылку для сброса пароля'**
  String get forgotSubtitle;

  /// No description provided for @forgotSentTitle.
  ///
  /// In ru, this message translates to:
  /// **'Письмо отправлено!'**
  String get forgotSentTitle;

  /// No description provided for @forgotSentSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Мы отправили ссылку для сброса пароля на\n{email}'**
  String forgotSentSubtitle(String email);

  /// No description provided for @emailHint.
  ///
  /// In ru, this message translates to:
  /// **'Электронная почта'**
  String get emailHint;

  /// No description provided for @forgotSendAction.
  ///
  /// In ru, this message translates to:
  /// **'Отправить ссылку'**
  String get forgotSendAction;

  /// No description provided for @forgotBackToLogin.
  ///
  /// In ru, this message translates to:
  /// **'Вернуться к входу'**
  String get forgotBackToLogin;

  /// No description provided for @forgotCheckSpam.
  ///
  /// In ru, this message translates to:
  /// **'Не пришло письмо? Проверь папку «Спам»'**
  String get forgotCheckSpam;

  /// No description provided for @errorGeneric.
  ///
  /// In ru, this message translates to:
  /// **'Что-то пошло не так. Попробуй ещё раз.'**
  String get errorGeneric;

  /// No description provided for @errorUserNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Пользователь не найден'**
  String get errorUserNotFound;

  /// No description provided for @errorEmailNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Пользователь с таким email не найден'**
  String get errorEmailNotFound;

  /// No description provided for @errorWrongPassword.
  ///
  /// In ru, this message translates to:
  /// **'Неверный пароль'**
  String get errorWrongPassword;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In ru, this message translates to:
  /// **'Неверный формат email'**
  String get errorInvalidEmail;

  /// No description provided for @errorUserDisabled.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт заблокирован'**
  String get errorUserDisabled;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In ru, this message translates to:
  /// **'Слишком много попыток. Подожди немного.'**
  String get errorTooManyRequests;

  /// No description provided for @errorInvalidCredential.
  ///
  /// In ru, this message translates to:
  /// **'Неверный email или пароль'**
  String get errorInvalidCredential;

  /// No description provided for @errorLogin.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка входа. Попробуй ещё раз.'**
  String get errorLogin;

  /// No description provided for @errorInvalidPhone.
  ///
  /// In ru, this message translates to:
  /// **'Неверный номер телефона. Проверь и попробуй снова.'**
  String get errorInvalidPhone;

  /// No description provided for @errorQuotaExceeded.
  ///
  /// In ru, this message translates to:
  /// **'Превышен лимит SMS. Попробуй позже.'**
  String get errorQuotaExceeded;

  /// No description provided for @errorNetwork.
  ///
  /// In ru, this message translates to:
  /// **'Нет интернета. Проверь соединение.'**
  String get errorNetwork;

  /// No description provided for @registerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Введите телефон или адрес\nэл.почты'**
  String get registerTitle;

  /// No description provided for @registerModePhone.
  ///
  /// In ru, this message translates to:
  /// **'Телефон'**
  String get registerModePhone;

  /// No description provided for @registerModeEmail.
  ///
  /// In ru, this message translates to:
  /// **'Электронная почта'**
  String get registerModeEmail;

  /// No description provided for @registerPhoneLabel.
  ///
  /// In ru, this message translates to:
  /// **'Номер телефона'**
  String get registerPhoneLabel;

  /// No description provided for @registerPhoneCountryCode.
  ///
  /// In ru, this message translates to:
  /// **'KZ +7'**
  String get registerPhoneCountryCode;

  /// No description provided for @registerPhoneHint.
  ///
  /// In ru, this message translates to:
  /// **'7XX XXX XX XX'**
  String get registerPhoneHint;

  /// No description provided for @registerEmailLabel.
  ///
  /// In ru, this message translates to:
  /// **'Электронная почта'**
  String get registerEmailLabel;

  /// No description provided for @registerEmailHint.
  ///
  /// In ru, this message translates to:
  /// **'example@mail.com'**
  String get registerEmailHint;

  /// No description provided for @registerPolicy.
  ///
  /// In ru, this message translates to:
  /// **'Ознакомьтесь с нашей Политикой Конфиденциальности'**
  String get registerPolicy;

  /// No description provided for @registerProceed.
  ///
  /// In ru, this message translates to:
  /// **'Далее'**
  String get registerProceed;

  /// No description provided for @registerHasAccountPrefix.
  ///
  /// In ru, this message translates to:
  /// **'Уже есть аккаунт? '**
  String get registerHasAccountPrefix;

  /// No description provided for @registerLoginAction.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get registerLoginAction;

  /// No description provided for @googleContinue.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить через Google'**
  String get googleContinue;

  /// No description provided for @googleError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка входа через Google'**
  String get googleError;

  /// No description provided for @phoneOtpTitle.
  ///
  /// In ru, this message translates to:
  /// **'Введите код'**
  String get phoneOtpTitle;

  /// No description provided for @phoneOtpSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Мы отправили SMS на номер\n{phone}'**
  String phoneOtpSubtitle(String phone);

  /// No description provided for @phoneOtpResend.
  ///
  /// In ru, this message translates to:
  /// **'Отправить код повторно'**
  String get phoneOtpResend;

  /// No description provided for @phoneOtpResendIn.
  ///
  /// In ru, this message translates to:
  /// **'Отправить повторно через {seconds}с'**
  String phoneOtpResendIn(int seconds);

  /// No description provided for @phoneOtpVerify.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердить'**
  String get phoneOtpVerify;

  /// No description provided for @phoneOtpInvalidCode.
  ///
  /// In ru, this message translates to:
  /// **'Неверный код. Проверь и попробуй ещё раз.'**
  String get phoneOtpInvalidCode;

  /// No description provided for @profileSetupTitle.
  ///
  /// In ru, this message translates to:
  /// **'Расскажи о себе'**
  String get profileSetupTitle;

  /// No description provided for @profileSetupSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Заполни профиль — это займёт\nменьше минуты'**
  String get profileSetupSubtitle;

  /// No description provided for @profileSetupNameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Имя / Никнейм'**
  String get profileSetupNameLabel;

  /// No description provided for @profileSetupNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Например: Арууке'**
  String get profileSetupNameHint;

  /// No description provided for @profileSetupCityLabel.
  ///
  /// In ru, this message translates to:
  /// **'Город'**
  String get profileSetupCityLabel;

  /// No description provided for @profileSetupCityHint.
  ///
  /// In ru, this message translates to:
  /// **'Например: Алматы'**
  String get profileSetupCityHint;

  /// No description provided for @profileSetupPasswordLabel.
  ///
  /// In ru, this message translates to:
  /// **'Придумай пароль'**
  String get profileSetupPasswordLabel;

  /// No description provided for @profileSetupPasswordHint.
  ///
  /// In ru, this message translates to:
  /// **'Минимум 6 символов'**
  String get profileSetupPasswordHint;

  /// No description provided for @profileSetupContinue.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get profileSetupContinue;

  /// No description provided for @errorEmailInUse.
  ///
  /// In ru, this message translates to:
  /// **'Этот email уже зарегистрирован. Войди через «Войти».'**
  String get errorEmailInUse;

  /// No description provided for @errorWeakPassword.
  ///
  /// In ru, this message translates to:
  /// **'Пароль слишком простой. Минимум 6 символов.'**
  String get errorWeakPassword;

  /// No description provided for @errorAuth.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка авторизации. Попробуй снова.'**
  String get errorAuth;

  /// No description provided for @profileFallbackName.
  ///
  /// In ru, this message translates to:
  /// **'Пользователь'**
  String get profileFallbackName;

  /// No description provided for @profileFavoritesSection.
  ///
  /// In ru, this message translates to:
  /// **'избранные'**
  String get profileFavoritesSection;

  /// No description provided for @profileFavoritesEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Нет избранных университетов'**
  String get profileFavoritesEmpty;

  /// No description provided for @profilePhotoTitle.
  ///
  /// In ru, this message translates to:
  /// **'Фото профиля'**
  String get profilePhotoTitle;

  /// No description provided for @profilePhotoTake.
  ///
  /// In ru, this message translates to:
  /// **'Сделать фото'**
  String get profilePhotoTake;

  /// No description provided for @profilePhotoPick.
  ///
  /// In ru, this message translates to:
  /// **'Выбрать из галереи'**
  String get profilePhotoPick;

  /// No description provided for @actionCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get actionCancel;

  /// No description provided for @profileTitle.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profileTitle;

  /// No description provided for @profileLogout.
  ///
  /// In ru, this message translates to:
  /// **'Выйти из аккаунта'**
  String get profileLogout;

  /// No description provided for @profileGuestTitle.
  ///
  /// In ru, this message translates to:
  /// **'Войди в аккаунт'**
  String get profileGuestTitle;

  /// No description provided for @profileGuestSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Чтобы видеть избранное и историю поиска'**
  String get profileGuestSubtitle;

  /// No description provided for @profileScores.
  ///
  /// In ru, this message translates to:
  /// **'Мои баллы'**
  String get profileScores;

  /// No description provided for @profileFavorites.
  ///
  /// In ru, this message translates to:
  /// **'Избранное'**
  String get profileFavorites;

  /// No description provided for @profileSavedSearches.
  ///
  /// In ru, this message translates to:
  /// **'Сохранённые поиски'**
  String get profileSavedSearches;

  /// No description provided for @profileSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get profileSettings;

  /// No description provided for @profileEditScores.
  ///
  /// In ru, this message translates to:
  /// **'Изменить баллы'**
  String get profileEditScores;

  /// No description provided for @profileEditInterests.
  ///
  /// In ru, this message translates to:
  /// **'Изменить интересы'**
  String get profileEditInterests;

  /// No description provided for @profileLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get profileLanguage;

  /// No description provided for @profileTheme.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная тема'**
  String get profileTheme;

  /// No description provided for @settingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTitle;

  /// No description provided for @settingsSaved.
  ///
  /// In ru, this message translates to:
  /// **'Сохранено'**
  String get settingsSaved;

  /// No description provided for @settingsSaveError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить'**
  String get settingsSaveError;

  /// No description provided for @settingsEditProfile.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать профиль'**
  String get settingsEditProfile;

  /// No description provided for @settingsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Не заполнено'**
  String get settingsEmpty;

  /// No description provided for @settingsEditScores.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать баллы'**
  String get settingsEditScores;

  /// No description provided for @settingsQuiz.
  ///
  /// In ru, this message translates to:
  /// **'Пройти опрос по интересам'**
  String get settingsQuiz;

  /// No description provided for @settingsInterestsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Не выбраны'**
  String get settingsInterestsEmpty;

  /// No description provided for @settingsLanguageItem.
  ///
  /// In ru, this message translates to:
  /// **'Сменить язык'**
  String get settingsLanguageItem;

  /// No description provided for @settingsThemeItem.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная тема'**
  String get settingsThemeItem;

  /// No description provided for @settingsPhotoItem.
  ///
  /// In ru, this message translates to:
  /// **'Добавить фото'**
  String get settingsPhotoItem;

  /// No description provided for @settingsPhotoSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Сделать фото или из галереи'**
  String get settingsPhotoSubtitle;

  /// No description provided for @settingsHelpItem.
  ///
  /// In ru, this message translates to:
  /// **'Нужна помощь'**
  String get settingsHelpItem;

  /// No description provided for @settingsHelpSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Центр помощи · FAQ и поддержка'**
  String get settingsHelpSubtitle;

  /// No description provided for @settingsLogoutItem.
  ///
  /// In ru, this message translates to:
  /// **'Выйти из аккаунта'**
  String get settingsLogoutItem;

  /// No description provided for @settingsLogoutConfirmTitle.
  ///
  /// In ru, this message translates to:
  /// **'Выйти из аккаунта?'**
  String get settingsLogoutConfirmTitle;

  /// No description provided for @settingsLogoutConfirmText.
  ///
  /// In ru, this message translates to:
  /// **'Вы уверены, что хотите выйти?'**
  String get settingsLogoutConfirmText;

  /// No description provided for @actionExit.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get actionExit;

  /// No description provided for @actionSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get actionSave;

  /// No description provided for @actionOk.
  ///
  /// In ru, this message translates to:
  /// **'Ок'**
  String get actionOk;

  /// No description provided for @settingsAuthTitle.
  ///
  /// In ru, this message translates to:
  /// **'Требуется вход'**
  String get settingsAuthTitle;

  /// No description provided for @settingsAuthText.
  ///
  /// In ru, this message translates to:
  /// **'Войдите в аккаунт чтобы сохранять баллы.'**
  String get settingsAuthText;

  /// No description provided for @settingsPhotoUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Фото обновлено'**
  String get settingsPhotoUpdated;

  /// No description provided for @settingsPhotoError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка загрузки фото'**
  String get settingsPhotoError;

  /// No description provided for @dialogNamePlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'Имя / ник'**
  String get dialogNamePlaceholder;

  /// No description provided for @dialogCityPlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'Город (напр. Алматы)'**
  String get dialogCityPlaceholder;

  /// No description provided for @dialogGpaPlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'GPA (напр. 3.8)'**
  String get dialogGpaPlaceholder;

  /// No description provided for @dialogIeltsPlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'IELTS (напр. 7.0)'**
  String get dialogIeltsPlaceholder;

  /// No description provided for @dialogEntPlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'ЕНТ (напр. 120)'**
  String get dialogEntPlaceholder;

  /// No description provided for @languageEnglish.
  ///
  /// In ru, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @searchTitle.
  ///
  /// In ru, this message translates to:
  /// **'Поиск'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск по учреждениям...'**
  String get searchHint;

  /// No description provided for @searchHistoryTitle.
  ///
  /// In ru, this message translates to:
  /// **'История поиска'**
  String get searchHistoryTitle;

  /// No description provided for @searchHistoryClear.
  ///
  /// In ru, this message translates to:
  /// **'Очистить'**
  String get searchHistoryClear;

  /// No description provided for @searchHistoryAuthRequired.
  ///
  /// In ru, this message translates to:
  /// **'Войди в аккаунт чтобы сохранять историю поиска'**
  String get searchHistoryAuthRequired;

  /// No description provided for @searchSavedFilterChip.
  ///
  /// In ru, this message translates to:
  /// **'Применить сохранённый фильтр'**
  String get searchSavedFilterChip;

  /// No description provided for @searchSaveFilter.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить фильтр'**
  String get searchSaveFilter;

  /// No description provided for @searchDeleteSavedFilter.
  ///
  /// In ru, this message translates to:
  /// **'Удалить сохранённый'**
  String get searchDeleteSavedFilter;

  /// No description provided for @searchFilterSaved.
  ///
  /// In ru, this message translates to:
  /// **'Фильтр сохранён'**
  String get searchFilterSaved;

  /// No description provided for @searchFilterDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Сохранённый фильтр удалён'**
  String get searchFilterDeleted;

  /// No description provided for @searchSectionTypes.
  ///
  /// In ru, this message translates to:
  /// **'Тип'**
  String get searchSectionTypes;

  /// No description provided for @searchSectionLangs.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get searchSectionLangs;

  /// No description provided for @searchSectionDirs.
  ///
  /// In ru, this message translates to:
  /// **'Направление'**
  String get searchSectionDirs;

  /// No description provided for @searchSectionFormats.
  ///
  /// In ru, this message translates to:
  /// **'Формат'**
  String get searchSectionFormats;

  /// No description provided for @searchSectionCosts.
  ///
  /// In ru, this message translates to:
  /// **'Стоимость'**
  String get searchSectionCosts;

  /// No description provided for @searchEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get searchEmpty;

  /// No description provided for @searchFilters.
  ///
  /// In ru, this message translates to:
  /// **'Фильтры'**
  String get searchFilters;

  /// No description provided for @searchClear.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить'**
  String get searchClear;

  /// No description provided for @searchApply.
  ///
  /// In ru, this message translates to:
  /// **'Применить'**
  String get searchApply;

  /// No description provided for @filterCity.
  ///
  /// In ru, this message translates to:
  /// **'Город'**
  String get filterCity;

  /// No description provided for @filterType.
  ///
  /// In ru, this message translates to:
  /// **'Тип'**
  String get filterType;

  /// No description provided for @filterLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Язык обучения'**
  String get filterLanguage;

  /// No description provided for @filterCost.
  ///
  /// In ru, this message translates to:
  /// **'Стоимость'**
  String get filterCost;

  /// No description provided for @filterDirection.
  ///
  /// In ru, this message translates to:
  /// **'Направление'**
  String get filterDirection;

  /// No description provided for @universityCost.
  ///
  /// In ru, this message translates to:
  /// **'Стоимость'**
  String get universityCost;

  /// No description provided for @universityDuration.
  ///
  /// In ru, this message translates to:
  /// **'Срок обучения'**
  String get universityDuration;

  /// No description provided for @universityLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Язык обучения'**
  String get universityLanguage;

  /// No description provided for @universityFormat.
  ///
  /// In ru, this message translates to:
  /// **'Формат'**
  String get universityFormat;

  /// No description provided for @universityWebsite.
  ///
  /// In ru, this message translates to:
  /// **'Сайт'**
  String get universityWebsite;

  /// No description provided for @universityInstagram.
  ///
  /// In ru, this message translates to:
  /// **'Instagram'**
  String get universityInstagram;

  /// No description provided for @universityDescription.
  ///
  /// In ru, this message translates to:
  /// **'Описание'**
  String get universityDescription;

  /// No description provided for @universityDirections.
  ///
  /// In ru, this message translates to:
  /// **'Направления'**
  String get universityDirections;

  /// No description provided for @universityRequirements.
  ///
  /// In ru, this message translates to:
  /// **'Требования'**
  String get universityRequirements;

  /// No description provided for @universityMinEnt.
  ///
  /// In ru, this message translates to:
  /// **'Мин. балл ЕНТ: {value}'**
  String universityMinEnt(int value);

  /// No description provided for @universityMinGpa.
  ///
  /// In ru, this message translates to:
  /// **'Мин. GPA: {value}'**
  String universityMinGpa(double value);

  /// No description provided for @universityMinIelts.
  ///
  /// In ru, this message translates to:
  /// **'Мин. IELTS: {value}'**
  String universityMinIelts(double value);

  /// No description provided for @universityTabDescription.
  ///
  /// In ru, this message translates to:
  /// **'описание'**
  String get universityTabDescription;

  /// No description provided for @universityTabPrograms.
  ///
  /// In ru, this message translates to:
  /// **'специальности'**
  String get universityTabPrograms;

  /// No description provided for @universityTabNews.
  ///
  /// In ru, this message translates to:
  /// **'новости'**
  String get universityTabNews;

  /// No description provided for @universityNewsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Новостей пока нет'**
  String get universityNewsEmpty;

  /// No description provided for @universityAdmissionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Условия поступления'**
  String get universityAdmissionTitle;

  /// No description provided for @universityTabReviews.
  ///
  /// In ru, this message translates to:
  /// **'Отзывы'**
  String get universityTabReviews;

  /// No description provided for @reviewsAdd.
  ///
  /// In ru, this message translates to:
  /// **'Оставить отзыв'**
  String get reviewsAdd;

  /// No description provided for @reviewsSubmit.
  ///
  /// In ru, this message translates to:
  /// **'Опубликовать'**
  String get reviewsSubmit;

  /// No description provided for @reviewsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Отзывов пока нет'**
  String get reviewsEmpty;

  /// No description provided for @reviewSpeciality.
  ///
  /// In ru, this message translates to:
  /// **'Специальность'**
  String get reviewSpeciality;

  /// No description provided for @reviewYear.
  ///
  /// In ru, this message translates to:
  /// **'Год поступления'**
  String get reviewYear;

  /// No description provided for @reviewText.
  ///
  /// In ru, this message translates to:
  /// **'Напишите ваш отзыв...'**
  String get reviewText;

  /// No description provided for @professionDuration.
  ///
  /// In ru, this message translates to:
  /// **'Срок обучения'**
  String get professionDuration;

  /// No description provided for @professionCost.
  ///
  /// In ru, this message translates to:
  /// **'Стоимость'**
  String get professionCost;

  /// No description provided for @professionLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get professionLanguage;

  /// No description provided for @professionJobs.
  ///
  /// In ru, this message translates to:
  /// **'Кем можно работать'**
  String get professionJobs;

  /// No description provided for @professionJobsExample.
  ///
  /// In ru, this message translates to:
  /// **'Разработчик, аналитик, архитектор ПО'**
  String get professionJobsExample;

  /// No description provided for @actionClose.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get actionClose;

  /// No description provided for @profileUnauthTitle.
  ///
  /// In ru, this message translates to:
  /// **'Войди, чтобы открыть профиль'**
  String get profileUnauthTitle;

  /// No description provided for @profileUnauthSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Сохраняй избранные университеты, отслеживай баллы и получай персональные рекомендации.'**
  String get profileUnauthSubtitle;

  /// No description provided for @profileUnauthCta.
  ///
  /// In ru, this message translates to:
  /// **'Зарегистрироваться'**
  String get profileUnauthCta;

  /// No description provided for @profileUnauthLogin.
  ///
  /// In ru, this message translates to:
  /// **'Уже есть аккаунт? Войти'**
  String get profileUnauthLogin;

  /// No description provided for @notificationsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Нет новостей'**
  String get notificationsEmpty;

  /// No description provided for @notificationsEmptyHint.
  ///
  /// In ru, this message translates to:
  /// **'Добавь университеты в избранное — здесь будут появляться их новости.'**
  String get notificationsEmptyHint;

  /// No description provided for @reviewsViewAll.
  ///
  /// In ru, this message translates to:
  /// **'Все отзывы'**
  String get reviewsViewAll;

  /// No description provided for @reviewsEmptyHint.
  ///
  /// In ru, this message translates to:
  /// **'Будьте первым — нажмите + чтобы оставить отзыв.'**
  String get reviewsEmptyHint;

  /// No description provided for @notificationsAuthRequired.
  ///
  /// In ru, this message translates to:
  /// **'Войди, чтобы видеть новости'**
  String get notificationsAuthRequired;

  /// No description provided for @notificationsAuthSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Добавляй университеты в избранное — и здесь будут появляться их новости.'**
  String get notificationsAuthSubtitle;

  /// No description provided for @supportTitle.
  ///
  /// In ru, this message translates to:
  /// **'Поддержка'**
  String get supportTitle;

  /// No description provided for @supportDescription.
  ///
  /// In ru, this message translates to:
  /// **'Здесь вы можете обратиться за помощью.'**
  String get supportDescription;

  /// No description provided for @supportTelegramButton.
  ///
  /// In ru, this message translates to:
  /// **'Написать в Telegram'**
  String get supportTelegramButton;

  /// No description provided for @supportResponseTime.
  ///
  /// In ru, this message translates to:
  /// **'Обычно отвечаем в течение 2–4 часов'**
  String get supportResponseTime;

  /// No description provided for @supportFaq1Question.
  ///
  /// In ru, this message translates to:
  /// **'Как найти подходящий вуз?'**
  String get supportFaq1Question;

  /// No description provided for @supportFaq1Answer.
  ///
  /// In ru, this message translates to:
  /// **'Используйте фильтры на экране поиска.'**
  String get supportFaq1Answer;

  /// No description provided for @supportFaq2Question.
  ///
  /// In ru, this message translates to:
  /// **'Как добавить вуз в избранное?'**
  String get supportFaq2Question;

  /// No description provided for @supportFaq2Answer.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите на иконку сердца. Нужен аккаунт.'**
  String get supportFaq2Answer;

  /// No description provided for @supportFaq3Question.
  ///
  /// In ru, this message translates to:
  /// **'Как сменить язык?'**
  String get supportFaq3Question;

  /// No description provided for @supportFaq3Answer.
  ///
  /// In ru, this message translates to:
  /// **'Настройки → Язык.'**
  String get supportFaq3Answer;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In ru, this message translates to:
  /// **'Удалить аккаунт'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteAccountConfirmTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить аккаунт?'**
  String get settingsDeleteAccountConfirmTitle;

  /// No description provided for @settingsDeleteAccountConfirmBody.
  ///
  /// In ru, this message translates to:
  /// **'Все данные будут удалены навсегда.'**
  String get settingsDeleteAccountConfirmBody;

  /// No description provided for @settingsDeleteAccountCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get settingsDeleteAccountCancel;

  /// No description provided for @settingsDeleteAccountConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get settingsDeleteAccountConfirm;

  /// No description provided for @settingsDeleteAccountSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт удалён'**
  String get settingsDeleteAccountSuccess;

  /// No description provided for @registerSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Введите email для создания аккаунта'**
  String get registerSubtitle;

  /// No description provided for @validationEmailRequired.
  ///
  /// In ru, this message translates to:
  /// **'Введите email'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Некорректный формат email'**
  String get validationEmailInvalid;

  /// No description provided for @reviewDeleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить отзыв?'**
  String get reviewDeleteTitle;

  /// No description provided for @reviewDeleteBody.
  ///
  /// In ru, this message translates to:
  /// **'Это действие нельзя отменить.'**
  String get reviewDeleteBody;

  /// No description provided for @reviewDeleteConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get reviewDeleteConfirm;

  /// No description provided for @reviewThanksTitle.
  ///
  /// In ru, this message translates to:
  /// **'Спасибо за ваш отзыв!'**
  String get reviewThanksTitle;

  /// No description provided for @reviewThanksSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Ваш отзыв поможет другим абитуриентам.'**
  String get reviewThanksSubtitle;

  /// No description provided for @profileScoresEnt.
  ///
  /// In ru, this message translates to:
  /// **'ЕНТ'**
  String get profileScoresEnt;

  /// No description provided for @profileEntLabel.
  ///
  /// In ru, this message translates to:
  /// **'ЕНТ'**
  String get profileEntLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
