import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [
    Locale('en'),
    Locale('so'),
  ];

  static const _localizedValues = {
    'en': {
      'appTitle': 'Hami MiniMarket',
      'welcome': 'Welcome!',
      'tagline': 'Fresh fruits and vegetables',
      'subtitle': 'Your one-stop community shop',
      'featuredProducts': 'Featured Products',
      'seeAll': 'See All',
      'loadingProducts': 'Loading products...',
      'noProducts': 'No products available',
      'addProducts': 'Please add products in Firestore',
      'retry': 'Retry',
      'refresh': 'Refresh',
      'profile': 'Profile',
      'status': 'Status',
      'email': 'Email',
      'personalData': 'Personal Data',
      'orderStatus': 'Order Status',
      'messages': 'Messages',
      'notifications': 'Notifications',
      'trackingOrder': 'Tracking Order',
      'logout': 'Logout',
      'language': 'Language',
      'languageDescription': 'Switch between English and Somali',
      'languageEnglish': 'English',
      'languageSomali': 'Somali',
      'themeLight': 'Light mode',
      'themeDark': 'Dark mode',
      'specialOffer': 'Special Offer!',
      'specialOfferDescription': 'Get 10% off on orders above \$50',
      'home': 'Home',
      'products': 'Products',
      'cart': 'Cart',
      'dashboard': 'Dashboard',
      'addToCart': 'Add to Cart',
      'inStock': 'In Stock',
      'description': 'Description',
      'viewCart': 'VIEW CART',
      'addedToCartMessage': 'added to cart!',
    },
    'so': {
      'appTitle': 'Hami MiniMarket',
      'welcome': 'Ku soo dhawoow!',
      'tagline': 'Khadar khudaar iyo miro cusub',
      'subtitle': 'Dukaankaaga bulshada',
      'featuredProducts': 'Alaabooyinka La Xulay',
      'seeAll': 'Dhammaan',
      'loadingProducts': 'Alaabooyinka ayaa soo dhacaya...',
      'noProducts': 'Wax alaab ah lama helin',
      'addProducts': 'Fadlan ku dar alaabooyinka Firestore',
      'retry': 'Isku day mar kale',
      'refresh': 'Cusboonaysii',
      'profile': 'Profile',
      'status': 'Xaalad',
      'email': 'Email',
      'personalData': 'Xogta Shaqsiga',
      'orderStatus': 'Xaalada Dalabka',
      'messages': 'Fariimaha',
      'notifications': 'Ogeysiisyada',
      'trackingOrder': 'Raac Dalabka',
      'logout': 'Ka Bax',
      'language': 'Luuqad',
      'languageDescription': 'U beddel Ingiriisi ama Soomaali',
      'languageEnglish': 'Ingiriisi',
      'languageSomali': 'Soomaali',
      'themeLight': 'Habka Iftiinka',
      'themeDark': 'Habka Madow',
      'specialOffer': 'Dalab Gaar ah!',
      'specialOfferDescription': 'Hel 10% dhimis marka ka badan \$50',
      'home': 'Hoyga',
      'products': 'Alaabooyinka',
      'cart': 'Gaadhiga',
      'dashboard': 'Guddi',
      'addToCart': 'Ku dar Gaadhi',
      'inStock': 'Kaydka ku jira',
      'description': 'Sharaxaad',
      'viewCart': 'FIIRI GAADHIGA',
      'addedToCartMessage': 'ayaa lagu daray gaadhiga!',
    },
  };

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  String _text(String key) {
    final languageCode = locale.languageCode;
    return _localizedValues[languageCode]?[key] ??
        _localizedValues['en']![key]!;
  }

  String get appTitle => _text('appTitle');
  String get welcome => _text('welcome');
  String get tagline => _text('tagline');
  String get subtitle => _text('subtitle');
  String get featuredProducts => _text('featuredProducts');
  String get seeAll => _text('seeAll');
  String get loadingProducts => _text('loadingProducts');
  String get noProducts => _text('noProducts');
  String get addProducts => _text('addProducts');
  String get retry => _text('retry');
  String get refresh => _text('refresh');
  String get profile => _text('profile');
  String get status => _text('status');
  String get email => _text('email');
  String get personalData => _text('personalData');
  String get orderStatus => _text('orderStatus');
  String get messages => _text('messages');
  String get notifications => _text('notifications');
  String get trackingOrder => _text('trackingOrder');
  String get logout => _text('logout');
  String get language => _text('language');
  String get languageDescription => _text('languageDescription');
  String get languageEnglish => _text('languageEnglish');
  String get languageSomali => _text('languageSomali');
  String get themeLight => _text('themeLight');
  String get themeDark => _text('themeDark');
  String get specialOffer => _text('specialOffer');
  String get specialOfferDescription => _text('specialOfferDescription');
  String get home => _text('home');
  String get products => _text('products');
  String get cart => _text('cart');
  String get dashboard => _text('dashboard');
  String get addToCart => _text('addToCart');
  String get inStock => _text('inStock');
  String get description => _text('description');
  String get viewCart => _text('viewCart');
  String get addedToCartMessage => _text('addedToCartMessage');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .any((supported) => supported.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}

