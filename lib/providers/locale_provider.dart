import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class LocaleProvider extends ChangeNotifier {
  LocaleProvider({Locale? initialLocale})
      : _locale = initialLocale ?? AppLocalizations.supportedLocales.first;

  Locale _locale;

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    if (!AppLocalizations.supportedLocales
        .any((supported) => supported.languageCode == locale.languageCode)) {
      return;
    }
    _locale = locale;
    notifyListeners();
  }
}












