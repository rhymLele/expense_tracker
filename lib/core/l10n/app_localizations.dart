import 'package:flutter/material.dart';
import 'translations/en.dart';
import 'translations/vi.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('vi'),
    Locale('en'),
  ];

  static const _translations = {
    'vi': viTranslations,
    'en': enTranslations,
  };

  String translate(String key) {
    final langCode = locale.languageCode;
    return _translations[langCode]?[key] ??
        _translations['vi']?[key] ??
        key;
  }

  // Shorthand
  String get appName => translate('app_name');
  String get ok => translate('ok');
  String get cancel => translate('cancel');
  String get confirm => translate('confirm');
  String get save => translate('save');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get close => translate('close');
  String get back => translate('back');
  String get next => translate('next');
  String get done => translate('done');
  String get retry => translate('retry');
  String get loading => translate('loading');
  String get error => translate('error');
  String get success => translate('success');
  String get warning => translate('warning');

  // Auth
  String get login => translate('login');
  String get logout => translate('logout');
  String get register => translate('register');
  String get email => translate('email');
  String get password => translate('password');
  String get confirmPassword => translate('confirm_password');
  String get forgotPassword => translate('forgot_password');
  String get fullName => translate('full_name');

  // Validation
  String get fieldRequired => translate('field_required');
  String get emailInvalid => translate('email_invalid');
  String get passwordMinLength => translate('password_min_length');
  String get passwordsNotMatch => translate('passwords_not_match');
  String get phoneInvalid => translate('phone_invalid');

  // Errors
  String get errorNetwork => translate('error_network');
  String get errorServer => translate('error_server');
  String get errorUnknown => translate('error_unknown');
  String get errorNotFound => translate('error_not_found');

  // Navigation
  String get home => translate('home');
  String get profile => translate('profile');
  String get settings => translate('settings');
  String get notifications => translate('notifications');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
