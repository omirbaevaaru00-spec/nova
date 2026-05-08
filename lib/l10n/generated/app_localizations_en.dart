// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'WELCOME';

  @override
  String get welcomeDescription =>
      'A handy service for applicants —\ncompare universities, check passing\nscores, choose a major\nand submit documents in one tap.';

  @override
  String get welcomeSkip => 'Skip';

  @override
  String get continueText => 'Continue';

  @override
  String get chooseLanguage => 'Choose language';

  @override
  String get languageRussian => 'Russian';

  @override
  String get languageRussianSubtitle => 'Russian interface';

  @override
  String get languageKazakh => 'Kazakh';

  @override
  String get languageKazakhSubtitle => 'Kazakh interface';

  @override
  String get localeShortRu => 'RU';

  @override
  String get localeShortKk => 'KZ';

  @override
  String get quizTitle => 'Choose what you\'re\ninterested in';

  @override
  String get quizSubtitle =>
      'We\'ll tailor the feed to your goals,\ninterests and plans';

  @override
  String get quizSelected => 'Selected';

  @override
  String get quizSkip => 'Skip';

  @override
  String get quizNext => 'Next';

  @override
  String get interestIT => 'IT & Technology';

  @override
  String get interestMedicine => 'Medicine';

  @override
  String get interestBusiness => 'Business & Economics';

  @override
  String get interestGrants => 'Grants';

  @override
  String get interestDesign => 'Design & Creative';

  @override
  String get interestLaw => 'Law';

  @override
  String get interestPedagogy => 'Pedagogy';

  @override
  String get interestEngineering => 'Engineering';

  @override
  String get interestBachelor => 'Bachelor';

  @override
  String get interestCollege => 'College';

  @override
  String get interestMaster => 'Master';

  @override
  String get navHome => 'Home';

  @override
  String get navNotifications => 'Alerts';

  @override
  String get navProfile => 'Profile';

  @override
  String get screenNotifications => 'Notifications';

  @override
  String get screenFavorites => 'Favorites';

  @override
  String get screenNews => 'News';

  @override
  String get screenSavedSearches => 'Saved searches';

  @override
  String get favoriteAuthRequired => 'Save to favorites';

  @override
  String get favoriteAuthSubtitle =>
      'To save a university to favorites\nyou need to sign up';

  @override
  String get actionRegister => 'Sign up';

  @override
  String get actionLater => 'Later';

  @override
  String get universityTypeStateShort => 'State';

  @override
  String get universityTypePrivateShort => 'Private';

  @override
  String get loginTitle => 'Welcome back!';

  @override
  String get loginSubtitle => 'We missed you — great to see you again!';

  @override
  String get loginIdHint => 'Email or phone';

  @override
  String get passwordHint => 'Password';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginAction => 'Sign in';

  @override
  String get loginNoAccountPrefix => 'No account? ';

  @override
  String get loginPhoneSoon => 'Phone sign-in — coming soon';

  @override
  String get orDivider => 'OR';

  @override
  String get googleSignIn => 'Sign in with Google';

  @override
  String get forgotTitle => 'Forgot password?';

  @override
  String get forgotSubtitle =>
      'Enter your email — we\'ll send\na link to reset your password';

  @override
  String get forgotSentTitle => 'Email sent!';

  @override
  String forgotSentSubtitle(String email) {
    return 'We\'ve sent a password reset link to\n$email';
  }

  @override
  String get emailHint => 'Email';

  @override
  String get forgotSendAction => 'Send link';

  @override
  String get forgotBackToLogin => 'Back to sign in';

  @override
  String get forgotCheckSpam => 'Didn\'t get it? Check the Spam folder';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorUserNotFound => 'User not found';

  @override
  String get errorEmailNotFound => 'No user with this email';

  @override
  String get errorWrongPassword => 'Wrong password';

  @override
  String get errorInvalidEmail => 'Invalid email format';

  @override
  String get errorUserDisabled => 'Account disabled';

  @override
  String get errorTooManyRequests => 'Too many attempts. Wait a moment.';

  @override
  String get errorInvalidCredential => 'Invalid email or password';

  @override
  String get errorLogin => 'Sign-in error. Please try again.';

  @override
  String get errorInvalidPhone => 'Invalid phone number. Check and try again.';

  @override
  String get errorQuotaExceeded => 'SMS limit exceeded. Try later.';

  @override
  String get errorNetwork => 'No internet. Check your connection.';

  @override
  String get registerTitle => 'Enter your phone\nor email';

  @override
  String get registerModePhone => 'Phone';

  @override
  String get registerModeEmail => 'Email';

  @override
  String get registerPhoneLabel => 'Phone number';

  @override
  String get registerPhoneCountryCode => 'KZ +7';

  @override
  String get registerPhoneHint => '7XX XXX XX XX';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerEmailHint => 'example@mail.com';

  @override
  String get registerPolicy => 'Read our Privacy Policy';

  @override
  String get registerProceed => 'Continue';

  @override
  String get registerHasAccountPrefix => 'Already have an account? ';

  @override
  String get registerLoginAction => 'Sign in';

  @override
  String get googleContinue => 'Continue with Google';

  @override
  String get googleError => 'Google sign-in error';

  @override
  String get phoneOtpTitle => 'Enter the code';

  @override
  String phoneOtpSubtitle(String phone) {
    return 'We sent an SMS to\n$phone';
  }

  @override
  String get phoneOtpResend => 'Resend code';

  @override
  String phoneOtpResendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get phoneOtpVerify => 'Verify';

  @override
  String get phoneOtpInvalidCode => 'Wrong code. Check and try again.';

  @override
  String get profileSetupTitle => 'Tell us about yourself';

  @override
  String get profileSetupSubtitle =>
      'Fill out your profile — it takes\nless than a minute';

  @override
  String get profileSetupNameLabel => 'Name / Nickname';

  @override
  String get profileSetupNameHint => 'e.g. Aruuke';

  @override
  String get profileSetupCityLabel => 'City';

  @override
  String get profileSetupCityHint => 'e.g. Almaty';

  @override
  String get profileSetupPasswordLabel => 'Choose a password';

  @override
  String get profileSetupPasswordHint => 'At least 6 characters';

  @override
  String get profileSetupContinue => 'Continue';

  @override
  String get errorEmailInUse =>
      'This email is already registered. Use Sign in.';

  @override
  String get errorWeakPassword => 'Password too weak. Minimum 6 characters.';

  @override
  String get errorAuth => 'Auth error. Please try again.';

  @override
  String get profileFallbackName => 'User';

  @override
  String get profileFavoritesSection => 'favorites';

  @override
  String get profileFavoritesEmpty => 'No favorite universities yet';

  @override
  String get profilePhotoTitle => 'Profile photo';

  @override
  String get profilePhotoTake => 'Take photo';

  @override
  String get profilePhotoPick => 'Pick from gallery';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileLogout => 'Sign out';

  @override
  String get profileGuestTitle => 'Sign in';

  @override
  String get profileGuestSubtitle => 'To see favorites and search history';

  @override
  String get profileScores => 'My scores';

  @override
  String get profileFavorites => 'Favorites';

  @override
  String get profileSavedSearches => 'Saved searches';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileEditScores => 'Edit scores';

  @override
  String get profileEditInterests => 'Edit interests';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileTheme => 'Dark theme';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSaved => 'Saved';

  @override
  String get settingsSaveError => 'Failed to save';

  @override
  String get settingsEditProfile => 'Edit profile';

  @override
  String get settingsEmpty => 'Not set';

  @override
  String get settingsEditScores => 'Edit scores';

  @override
  String get settingsQuiz => 'Take interests quiz';

  @override
  String get settingsInterestsEmpty => 'Not selected';

  @override
  String get settingsLanguageItem => 'Change language';

  @override
  String get settingsThemeItem => 'Dark theme';

  @override
  String get settingsPhotoItem => 'Add photo';

  @override
  String get settingsPhotoSubtitle => 'Take a photo or pick from gallery';

  @override
  String get settingsHelpItem => 'Need help';

  @override
  String get settingsHelpSubtitle => 'Help center · FAQ and support';

  @override
  String get settingsLogoutItem => 'Sign out';

  @override
  String get settingsLogoutConfirmTitle => 'Sign out?';

  @override
  String get settingsLogoutConfirmText => 'Are you sure you want to sign out?';

  @override
  String get actionExit => 'Sign out';

  @override
  String get actionSave => 'Save';

  @override
  String get actionOk => 'OK';

  @override
  String get settingsAuthTitle => 'Sign in required';

  @override
  String get settingsAuthText => 'Sign in to save scores.';

  @override
  String get settingsPhotoUpdated => 'Photo updated';

  @override
  String get settingsPhotoError => 'Photo upload error';

  @override
  String get dialogNamePlaceholder => 'Name / nickname';

  @override
  String get dialogCityPlaceholder => 'City (e.g. Almaty)';

  @override
  String get dialogGpaPlaceholder => 'GPA (e.g. 3.8)';

  @override
  String get dialogIeltsPlaceholder => 'IELTS (e.g. 7.0)';

  @override
  String get dialogEntPlaceholder => 'ENT (e.g. 120)';

  @override
  String get languageEnglish => 'English';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchHint => 'Search institutions...';

  @override
  String get searchHistoryTitle => 'Search history';

  @override
  String get searchHistoryClear => 'Clear';

  @override
  String get searchHistoryAuthRequired => 'Sign in to save search history';

  @override
  String get searchSavedFilterChip => 'Apply saved filter';

  @override
  String get searchSaveFilter => 'Save filter';

  @override
  String get searchDeleteSavedFilter => 'Delete saved';

  @override
  String get searchFilterSaved => 'Filter saved';

  @override
  String get searchFilterDeleted => 'Saved filter deleted';

  @override
  String get searchSectionTypes => 'Type';

  @override
  String get searchSectionLangs => 'Language';

  @override
  String get searchSectionDirs => 'Field';

  @override
  String get searchSectionFormats => 'Format';

  @override
  String get searchSectionCosts => 'Cost';

  @override
  String get searchEmpty => 'Nothing found';

  @override
  String get searchFilters => 'Filters';

  @override
  String get searchClear => 'Clear';

  @override
  String get searchApply => 'Apply';

  @override
  String get filterCity => 'City';

  @override
  String get filterType => 'Type';

  @override
  String get filterLanguage => 'Language';

  @override
  String get filterCost => 'Cost';

  @override
  String get filterDirection => 'Field';

  @override
  String get universityCost => 'Cost';

  @override
  String get universityDuration => 'Duration';

  @override
  String get universityLanguage => 'Language';

  @override
  String get universityFormat => 'Format';

  @override
  String get universityWebsite => 'Website';

  @override
  String get universityInstagram => 'Instagram';

  @override
  String get universityDescription => 'Description';

  @override
  String get universityDirections => 'Directions';

  @override
  String get universityRequirements => 'Requirements';

  @override
  String universityMinEnt(int value) {
    return 'Min. ENT: $value';
  }

  @override
  String universityMinGpa(double value) {
    return 'Min. GPA: $value';
  }

  @override
  String universityMinIelts(double value) {
    return 'Min. IELTS: $value';
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
}
