// class RouteNames {
//   RouteNames._();

//   // ── Сплэш ─────────────────────────────────────────────────
//   static const String splash = '/';

//   // ── Онбординг (язык выбирается на WelcomeScreen) ──────────
//   static const String welcome = '/welcome';
//     static const onboarding = '/onboarding';

//   // ── Авторизация (по требованию) ───────────────────────────
//   static const String login = '/login';
//   static const String register = '/register';
//   static const String forgotPassword = '/forgot-password';
//   static const String phoneOtp = '/phone-otp';
  
//   static const String profileSetup = '/profile-setup';

//   // ── Основные экраны ───────────────────────────────────────
//   static const String home = '/main/home';
//   static const String notifications = '/main/notifications';
//   static const String profile = '/main/profile';

//   // ── Профиль ───────────────────────────────────────────────
//   static const String profileSettings = '/profile-settings';

//   // ── Детальные экраны ──────────────────────────────────────
//   static const String search = '/search';
//   static const String filters = '/filters';
//   static const String favorites = '/favorites';
//   static const String savedSearches = '/saved-searches';
//   static const String newsFeed = '/news';
//   static const String helpCenter = '/help-center';
//   static const String universityReviews = '/university/:id/reviews';


// }

/// Все маршруты приложения Sticky.
abstract final class RouteNames {
  static const String splash          = '/';
  static const String welcome         = '/welcome';
  static const String onboarding      = '/onboarding';
  static const String login           = '/login';
  static const String register        = '/register';
  static const String forgotPassword  = '/forgot-password';
  static const String phoneOtp        = '/phone-otp';
  static const String profileSetup    = '/profile-setup';
  static const String home            = '/home';
  static const String notifications   = '/notifications';
  static const String profile         = '/profile';
  static const String profileSettings = '/profile-settings';
  static const String favorites       = '/favorites';
  static const String savedSearches   = '/saved-searches';
  static const String newsFeed        = '/news';
  static const String helpCenter      = '/help';
  static const String search          = '/search';

  /// Страница поддержки с Telegram-ботом.
  static const String support         = '/support';
}