// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get appTitle => 'WELCOME';

  @override
  String get welcomeDescription =>
      'Түлектерге арналған ыңғайлы қызмет —\nуниверситеттерді салыстырып, өту\nбалдарын біліп, мамандық таңда\nжәне құжаттарды бір рет басып тапсыр.';

  @override
  String get welcomeSkip => 'Өткізіп жіберу';

  @override
  String get continueText => 'Жалғастыру';

  @override
  String get chooseLanguage => 'Тілді таңдаңыз';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageRussianSubtitle => 'Орыс тіліндегі интерфейс';

  @override
  String get languageKazakh => 'Қазақша';

  @override
  String get languageKazakhSubtitle => 'Интерфейс қазақ тілінде';

  @override
  String get localeShortRu => 'РУ';

  @override
  String get localeShortKk => 'ҚАЗ';

  @override
  String get quizTitle => 'Не қызықтыратыныңды\nтаңда';

  @override
  String get quizSubtitle =>
      'Мақсаттарың, қызығушылықтарың\nжәне жоспарларың бойынша лентаны бапталамыз';

  @override
  String get quizSelected => 'Таңдалды';

  @override
  String get quizSkip => 'Өткізіп жіберу';

  @override
  String get quizNext => 'Әрі қарай';

  @override
  String get interestIT => 'IT және технологиялар';

  @override
  String get interestMedicine => 'Медицина';

  @override
  String get interestBusiness => 'Бизнес және экономика';

  @override
  String get interestGrants => 'Гранттар';

  @override
  String get interestDesign => 'Дизайн және креатив';

  @override
  String get interestLaw => 'Заңтану';

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
  String get navHome => 'Басты';

  @override
  String get navNotifications => 'Хабарлама';

  @override
  String get navProfile => 'Профиль';

  @override
  String get screenNotifications => 'Хабарламалар';

  @override
  String get screenFavorites => 'Таңдаулылар';

  @override
  String get screenNews => 'Жаңалықтар';

  @override
  String get screenSavedSearches => 'Сақталған іздеулер';

  @override
  String get favoriteAuthRequired => 'Таңдаулыларға сақтау';

  @override
  String get favoriteAuthSubtitle =>
      'Университетті таңдаулыларға сақтау үшін\nтіркелу қажет';

  @override
  String get actionRegister => 'Тіркелу';

  @override
  String get actionLater => 'Кейінірек';

  @override
  String get universityTypeStateShort => 'Мем';

  @override
  String get universityTypePrivateShort => 'Жеке';

  @override
  String get loginTitle => 'Қайта кездестік!';

  @override
  String get loginSubtitle =>
      'Сені сағындық — қайтадан ортамызға қосылғаныңға қуаныштымыз!';

  @override
  String get loginIdHint => 'Email';

  @override
  String get passwordHint => 'Құпиясөз';

  @override
  String get loginForgotPassword => 'Құпиясөзді ұмыттың ба?';

  @override
  String get loginAction => 'Кіру';

  @override
  String get loginNoAccountPrefix => 'Тіркелгің жоқ па? ';

  @override
  String get loginPhoneSoon => 'Телефонмен кіру — жақын арада қолжетімді';

  @override
  String get orDivider => 'НЕМЕСЕ';

  @override
  String get googleSignIn => 'Google арқылы кіру';

  @override
  String get forgotTitle => 'Құпиясөзді ұмыттың ба?';

  @override
  String get forgotSubtitle =>
      'Email енгіз — біз қалпына келтіру\nсілтемесін жібереміз';

  @override
  String get forgotSentTitle => 'Хат жіберілді!';

  @override
  String forgotSentSubtitle(String email) {
    return 'Қалпына келтіру сілтемесін\n$email мекенжайына жібердік';
  }

  @override
  String get emailHint => 'Электрондық пошта';

  @override
  String get forgotSendAction => 'Сілтемені жіберу';

  @override
  String get forgotBackToLogin => 'Кіруге оралу';

  @override
  String get forgotCheckSpam => 'Хат келмеді ме? «Спам» қалтасын тексер';

  @override
  String get errorGeneric => 'Бірдеңе дұрыс болмады. Қайталап көрші.';

  @override
  String get errorUserNotFound => 'Пайдаланушы табылмады';

  @override
  String get errorEmailNotFound => 'Бұл email бойынша пайдаланушы табылмады';

  @override
  String get errorWrongPassword => 'Қате құпиясөз';

  @override
  String get errorInvalidEmail => 'Email пішімі дұрыс емес';

  @override
  String get errorUserDisabled => 'Аккаунт құлыптаулы';

  @override
  String get errorTooManyRequests => 'Тым көп әрекет. Біраз күт.';

  @override
  String get errorInvalidCredential => 'Email немесе құпиясөз қате';

  @override
  String get errorLogin => 'Кіру қатесі. Қайталап көрші.';

  @override
  String get errorInvalidPhone => 'Қате телефон нөмірі. Тексеріп қайталап көр.';

  @override
  String get errorQuotaExceeded => 'SMS лимиті асып кетті. Кейінірек көр.';

  @override
  String get errorNetwork => 'Интернет жоқ. Байланысты тексер.';

  @override
  String get registerTitle => 'Телефон немесе email енгіз';

  @override
  String get registerModePhone => 'Телефон';

  @override
  String get registerModeEmail => 'Электрондық пошта';

  @override
  String get registerPhoneLabel => 'Телефон нөмірі';

  @override
  String get registerPhoneCountryCode => 'KZ +7';

  @override
  String get registerPhoneHint => '7XX XXX XX XX';

  @override
  String get registerEmailLabel => 'Электрондық пошта';

  @override
  String get registerEmailHint => 'example@mail.com';

  @override
  String get registerPolicy => 'Құпиялылық саясатымен танысыңыз';

  @override
  String get registerProceed => 'Әрі қарай';

  @override
  String get registerHasAccountPrefix => 'Тіркелгің бар ма? ';

  @override
  String get registerLoginAction => 'Кіру';

  @override
  String get googleContinue => 'Google арқылы жалғастыру';

  @override
  String get googleError => 'Google арқылы кіру қатесі';

  @override
  String get phoneOtpTitle => 'Кодты енгіз';

  @override
  String phoneOtpSubtitle(String phone) {
    return '$phone нөміріне SMS жібердік';
  }

  @override
  String get phoneOtpResend => 'Кодты қайта жіберу';

  @override
  String phoneOtpResendIn(int seconds) {
    return '$secondsс-тан кейін қайта жіберу';
  }

  @override
  String get phoneOtpVerify => 'Растау';

  @override
  String get phoneOtpInvalidCode => 'Қате код. Тексеріп қайта көр.';

  @override
  String get profileSetupTitle => 'Өзің туралы айтып бер';

  @override
  String get profileSetupSubtitle =>
      'Профильді толтыр — бір минуттан\nаз уақыт алады';

  @override
  String get profileSetupNameLabel => 'Аты / Никнейм';

  @override
  String get profileSetupNameHint => 'Мысалы: Арууке';

  @override
  String get profileSetupCityLabel => 'Қала';

  @override
  String get profileSetupCityHint => 'Мысалы: Алматы';

  @override
  String get profileSetupPasswordLabel => 'Құпиясөз ойлап тап';

  @override
  String get profileSetupPasswordHint => 'Кемінде 6 таңба';

  @override
  String get profileSetupContinue => 'Жалғастыру';

  @override
  String get errorEmailInUse => 'Бұл email тіркелген. «Кіру» арқылы кір.';

  @override
  String get errorWeakPassword => 'Құпиясөз тым қарапайым. Кемінде 6 таңба.';

  @override
  String get errorAuth => 'Авторизация қатесі. Қайталап көр.';

  @override
  String get profileFallbackName => 'Пайдаланушы';

  @override
  String get profileFavoritesSection => 'таңдаулылар';

  @override
  String get profileFavoritesEmpty => 'Таңдаулы университеттер жоқ';

  @override
  String get profilePhotoTitle => 'Профиль фотосы';

  @override
  String get profilePhotoTake => 'Сурет түсіру';

  @override
  String get profilePhotoPick => 'Галереядан таңдау';

  @override
  String get actionCancel => 'Бас тарту';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileLogout => 'Шығу';

  @override
  String get profileGuestTitle => 'Аккаунтқа кір';

  @override
  String get profileGuestSubtitle => 'Таңдаулылар мен іздеу тарихын көру үшін';

  @override
  String get profileScores => 'Менің балдарым';

  @override
  String get profileFavorites => 'Таңдаулылар';

  @override
  String get profileSavedSearches => 'Сақталған іздеулер';

  @override
  String get profileSettings => 'Баптаулар';

  @override
  String get profileEditScores => 'Балдарды өзгерту';

  @override
  String get profileEditInterests => 'Қызығушылықтарды өзгерту';

  @override
  String get profileLanguage => 'Тіл';

  @override
  String get profileTheme => 'Қараңғы тақырып';

  @override
  String get settingsTitle => 'Баптаулар';

  @override
  String get settingsSaved => 'Сақталды';

  @override
  String get settingsSaveError => 'Сақтай алмадық';

  @override
  String get settingsEditProfile => 'Профильді өңдеу';

  @override
  String get settingsEmpty => 'Толтырылмаған';

  @override
  String get settingsEditScores => 'Балдарды өңдеу';

  @override
  String get settingsQuiz => 'Қызығушылықтар сауалнамасынан өту';

  @override
  String get settingsInterestsEmpty => 'Таңдалмаған';

  @override
  String get settingsLanguageItem => 'Тілді ауыстыру';

  @override
  String get settingsThemeItem => 'Қараңғы тақырып';

  @override
  String get settingsPhotoItem => 'Фото қосу';

  @override
  String get settingsPhotoSubtitle => 'Сурет түсіру немесе галереядан таңдау';

  @override
  String get settingsHelpItem => 'Көмек керек';

  @override
  String get settingsHelpSubtitle => 'Көмек орталығы · FAQ және қолдау';

  @override
  String get settingsLogoutItem => 'Аккаунттан шығу';

  @override
  String get settingsLogoutConfirmTitle => 'Аккаунттан шығу керек пе?';

  @override
  String get settingsLogoutConfirmText => 'Шынымен шыққың келе ме?';

  @override
  String get actionExit => 'Шығу';

  @override
  String get actionSave => 'Сақтау';

  @override
  String get actionOk => 'Ок';

  @override
  String get settingsAuthTitle => 'Кіру қажет';

  @override
  String get settingsAuthText => 'Балдарды сақтау үшін аккаунтқа кір.';

  @override
  String get settingsPhotoUpdated => 'Фото жаңартылды';

  @override
  String get settingsPhotoError => 'Фото жүктеу қатесі';

  @override
  String get dialogNamePlaceholder => 'Аты / ник';

  @override
  String get dialogCityPlaceholder => 'Қала (мыс. Алматы)';

  @override
  String get dialogGpaPlaceholder => 'GPA (мыс. 3.8)';

  @override
  String get dialogIeltsPlaceholder => 'IELTS (мыс. 7.0)';

  @override
  String get dialogEntPlaceholder => 'ҰБТ (мыс. 120)';

  @override
  String get languageEnglish => 'English';

  @override
  String get searchTitle => 'Іздеу';

  @override
  String get searchHint => 'Мекемелерден іздеу...';

  @override
  String get searchHistoryTitle => 'Іздеу тарихы';

  @override
  String get searchHistoryClear => 'Тазарту';

  @override
  String get searchHistoryAuthRequired =>
      'Іздеу тарихын сақтау үшін аккаунтқа кір';

  @override
  String get searchSavedFilterChip => 'Сақталған сүзгіні қолдану';

  @override
  String get searchSaveFilter => 'Сүзгіні сақтау';

  @override
  String get searchDeleteSavedFilter => 'Сақталғанды жою';

  @override
  String get searchFilterSaved => 'Сүзгі сақталды';

  @override
  String get searchFilterDeleted => 'Сақталған сүзгі жойылды';

  @override
  String get searchSectionTypes => 'Тип';

  @override
  String get searchSectionLangs => 'Тіл';

  @override
  String get searchSectionDirs => 'Бағыт';

  @override
  String get searchSectionFormats => 'Формат';

  @override
  String get searchSectionCosts => 'Құны';

  @override
  String get searchEmpty => 'Ештеңе табылмады';

  @override
  String get searchFilters => 'Сүзгілер';

  @override
  String get searchClear => 'Тазарту';

  @override
  String get searchApply => 'Қолдану';

  @override
  String get filterCity => 'Қала';

  @override
  String get filterType => 'Тип';

  @override
  String get filterLanguage => 'Оқу тілі';

  @override
  String get filterCost => 'Баға';

  @override
  String get filterDirection => 'Бағыт';

  @override
  String get universityCost => 'Құны';

  @override
  String get universityDuration => 'Оқу мерзімі';

  @override
  String get universityLanguage => 'Оқу тілі';

  @override
  String get universityFormat => 'Формат';

  @override
  String get universityWebsite => 'Сайт';

  @override
  String get universityInstagram => 'Instagram';

  @override
  String get universityDescription => 'Сипаттама';

  @override
  String get universityDirections => 'Бағыттар';

  @override
  String get universityRequirements => 'Талаптар';

  @override
  String universityMinEnt(int value) {
    return 'Мин. ҰБТ балы: $value';
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
  String get universityTabDescription => 'сипаттама';

  @override
  String get universityTabPrograms => 'мамандықтар';

  @override
  String get universityTabNews => 'жаңалықтар';

  @override
  String get universityNewsEmpty => 'Әзірге жаңалықтар жоқ';

  @override
  String get universityAdmissionTitle => 'Түсу шарттары';

  @override
  String get universityTabReviews => 'Пікірлер';

  @override
  String get reviewsAdd => 'Пікір қалдыру';

  @override
  String get reviewsSubmit => 'Жариялау';

  @override
  String get reviewsEmpty => 'Пікірлер әлі жоқ';

  @override
  String get reviewSpeciality => 'Мамандық';

  @override
  String get reviewYear => 'Оқуға түскен жыл';

  @override
  String get reviewText => 'Пікіріңізді жазыңыз...';

  @override
  String get professionDuration => 'Оқу мерзімі';

  @override
  String get professionCost => 'Оқу ақысы';

  @override
  String get professionLanguage => 'Тіл';

  @override
  String get professionJobs => 'Кім болуға болады';

  @override
  String get professionJobsExample =>
      'Әзірлеуші, талдаушы, бағдарламалық сәулетші';

  @override
  String get actionClose => 'Жабу';

  @override
  String get profileUnauthTitle => 'Профильді ашу үшін кіріңіз';

  @override
  String get profileUnauthSubtitle =>
      'Таңдаулы университеттерді сақтаңыз, ұпайларыңызды бақылаңыз және жеке ұсынымдар алыңыз.';

  @override
  String get profileUnauthCta => 'Тіркелу';

  @override
  String get profileUnauthLogin => 'Аккаунт бар ма? Кіру';

  @override
  String get notificationsEmpty => 'Жаңалықтар жоқ';

  @override
  String get notificationsEmptyHint =>
      'Университеттерді таңдаулыға қосыңыз — олардың жаңалықтары осында пайда болады.';

  @override
  String get reviewsViewAll => 'Барлық пікірлер';

  @override
  String get reviewsEmptyHint =>
      'Бірінші болыңыз — пікір қалдыру үшін + басыңыз.';

  @override
  String get notificationsAuthRequired => 'Жаңалықтарды көру үшін кіріңіз';

  @override
  String get notificationsAuthSubtitle =>
      'Университеттерді таңдаулыға қосыңыз — олардың жаңалықтары осында пайда болады.';

  @override
  String get supportTitle => 'Қолдау';

  @override
  String get supportDescription => 'Мұнда сіз көмек сұрай аласыз.';

  @override
  String get supportTelegramButton => 'Telegram-ға жазу';

  @override
  String get supportResponseTime => 'Біз әдетте 2–4 сағат ішінде жауап береміз';

  @override
  String get supportFaq1Question => 'Қалай сәйкес университет табуға болады?';

  @override
  String get supportFaq1Answer => 'Іздеу экранындағы сүзгілерді пайдаланыңыз.';

  @override
  String get supportFaq2Question =>
      'Университетті таңдаулыларға қалай қосуға болады?';

  @override
  String get supportFaq2Answer => 'Жүрек белгішесін басыңыз. Аккаунт қажет.';

  @override
  String get supportFaq3Question => 'Тілді қалай өзгертуге болады?';

  @override
  String get supportFaq3Answer => 'Параметрлер → Тіл.';

  @override
  String get settingsDeleteAccount => 'Аккаунтты жою';

  @override
  String get settingsDeleteAccountConfirmTitle => 'Аккаунтты жою керек пе?';

  @override
  String get settingsDeleteAccountConfirmBody =>
      'Барлық деректер мәңгілікке жойылады.';

  @override
  String get settingsDeleteAccountCancel => 'Болдырмау';

  @override
  String get settingsDeleteAccountConfirm => 'Жою';

  @override
  String get settingsDeleteAccountSuccess => 'Аккаунт жойылды';

  @override
  String get registerSubtitle => 'Аккаунт жасау үшін email енгізіңіз';

  @override
  String get validationEmailRequired => 'Email енгізіңіз';

  @override
  String get validationEmailInvalid => 'Email форматы қате';

  @override
  String get reviewDeleteTitle => 'Пікірді жою керек пе?';

  @override
  String get reviewDeleteBody => 'Бұл әрекетті болдырмау мүмкін емес.';

  @override
  String get reviewDeleteConfirm => 'Жою';

  @override
  String get reviewThanksTitle => 'Пікіріңіз үшін рахмет!';

  @override
  String get reviewThanksSubtitle =>
      'Сіздің пікіріңіз басқа оқушыларға көмектеседі.';

  @override
  String get profileScoresEnt => 'ҰБТ';

  @override
  String get profileEntLabel => 'ҰБТ';
}
