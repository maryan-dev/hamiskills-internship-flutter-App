import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'l10n/app_localizations.dart';
import 'l10n/somali_fallback_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => AuthProvider()),
            ChangeNotifierProvider(create: (context) => ProductProvider()),
            ChangeNotifierProvider(
              create: (context) => ThemeProvider(
                initialMode: ThemeMode.system,
              ),
            ),
            ChangeNotifierProvider(
              create: (context) => LocaleProvider(),
            ),
            ProxyProvider2<AuthProvider, ProductProvider, CartProvider>(
              update: (context, authProvider, productProvider, previous) {
                final cartProvider = previous ?? CartProvider();
                final userId = authProvider.user?.uid;
                cartProvider.setUser(userId, context);
                return cartProvider;
              },
            ),
          ],
          child: Consumer2<ThemeProvider, LocaleProvider>(
            builder: (context, themeProvider, localeProvider, _) {
              return MaterialApp(
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context).appTitle,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeProvider.themeMode,
                locale: localeProvider.locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  SomaliMaterialLocalizationsDelegate(),
                  SomaliWidgetsLocalizationsDelegate(),
                  SomaliCupertinoLocalizationsDelegate(),
                ],
                home: const SplashScreen(),
                debugShowCheckedModeBanner: false,
              );
            },
          ),
        );
      },
    );
  }
}
