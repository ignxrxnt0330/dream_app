import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('es')
  ];

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'about'**
  String get about;

  /// No description provided for @aboutTheApp.
  ///
  /// In en, this message translates to:
  /// **'about the app'**
  String get aboutTheApp;

  /// No description provided for @allData.
  ///
  /// In en, this message translates to:
  /// **'all data'**
  String get allData;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'all time'**
  String get allTime;

  /// No description provided for @appLang.
  ///
  /// In en, this message translates to:
  /// **'app language'**
  String get appLang;

  /// No description provided for @appLangDesc.
  ///
  /// In en, this message translates to:
  /// **'change the app\'s language'**
  String get appLangDesc;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'dream_app'**
  String get appTitle;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'are you sure?'**
  String get areYouSure;

  /// No description provided for @asc.
  ///
  /// In en, this message translates to:
  /// **'asc'**
  String get asc;

  /// No description provided for @bad.
  ///
  /// In en, this message translates to:
  /// **'bad'**
  String get bad;

  /// No description provided for @badChoide.
  ///
  /// In en, this message translates to:
  /// **'you are making a really bad choice'**
  String get badChoide;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'calendar'**
  String get calendar;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get cancel;

  /// No description provided for @changeColors.
  ///
  /// In en, this message translates to:
  /// **'change the app colors'**
  String get changeColors;

  /// No description provided for @characters.
  ///
  /// In en, this message translates to:
  /// **'characters'**
  String get characters;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'close'**
  String get close;

  /// No description provided for @colors.
  ///
  /// In en, this message translates to:
  /// **'colors'**
  String get colors;

  /// No description provided for @config.
  ///
  /// In en, this message translates to:
  /// **'config'**
  String get config;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'confirm'**
  String get confirm;

  /// No description provided for @confirmAction.
  ///
  /// In en, this message translates to:
  /// **'do you really want to {action}?'**
  String confirmAction(Object action);

  /// No description provided for @consolas.
  ///
  /// In en, this message translates to:
  /// **'Consolas'**
  String get consolas;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'current streak'**
  String get currentStreak;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'dark mode'**
  String get darkMode;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'date'**
  String get date;

  /// No description provided for @dateFormat.
  ///
  /// In en, this message translates to:
  /// **'dd-MM-yyyy HH:mm'**
  String get dateFormat;

  /// No description provided for @defaultTitle.
  ///
  /// In en, this message translates to:
  /// **'default title'**
  String get defaultTitle;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'delete all dreams'**
  String get deleteAll;

  /// No description provided for @deleteAllDesc.
  ///
  /// In en, this message translates to:
  /// **'delete all of your dreams'**
  String get deleteAllDesc;

  /// No description provided for @deleteThisDream.
  ///
  /// In en, this message translates to:
  /// **'delete this dream'**
  String get deleteThisDream;

  /// No description provided for @desc.
  ///
  /// In en, this message translates to:
  /// **'desc'**
  String get desc;

  /// No description provided for @descLength.
  ///
  /// In en, this message translates to:
  /// **'desctLength'**
  String get descLength;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'description'**
  String get description;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'asdasdasd...'**
  String get descriptionHint;

  /// No description provided for @dmY.
  ///
  /// In en, this message translates to:
  /// **'dd/MM/yyyy'**
  String get dmY;

  /// No description provided for @dream.
  ///
  /// In en, this message translates to:
  /// **'dream'**
  String get dream;

  /// No description provided for @dreamJournalingApp.
  ///
  /// In en, this message translates to:
  /// **'dream journaling app'**
  String get dreamJournalingApp;

  /// No description provided for @dreamLucidness.
  ///
  /// In en, this message translates to:
  /// **'dream lucidness'**
  String get dreamLucidness;

  /// No description provided for @dreamMood.
  ///
  /// In en, this message translates to:
  /// **'Dream mood'**
  String get dreamMood;

  /// No description provided for @dreamRating.
  ///
  /// In en, this message translates to:
  /// **'Dream rating'**
  String get dreamRating;

  /// No description provided for @dreamType.
  ///
  /// In en, this message translates to:
  /// **'dream type'**
  String get dreamType;

  /// No description provided for @dreams.
  ///
  /// In en, this message translates to:
  /// **'dreams'**
  String get dreams;

  /// No description provided for @dreamsPerDay.
  ///
  /// In en, this message translates to:
  /// **'dreams per day'**
  String get dreamsPerDay;

  /// No description provided for @editDream.
  ///
  /// In en, this message translates to:
  /// **'edit dream'**
  String get editDream;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'empty'**
  String get empty;

  /// No description provided for @es.
  ///
  /// In en, this message translates to:
  /// **'es'**
  String get es;

  /// No description provided for @exportDreams.
  ///
  /// In en, this message translates to:
  /// **'export dreams'**
  String get exportDreams;

  /// No description provided for @exportDreamsDesc.
  ///
  /// In en, this message translates to:
  /// **'download your dreams as a json file so you can keep them safe'**
  String get exportDreamsDesc;

  /// No description provided for @extreme.
  ///
  /// In en, this message translates to:
  /// **'extreme'**
  String get extreme;

  /// No description provided for @fav.
  ///
  /// In en, this message translates to:
  /// **'fav'**
  String get fav;

  /// No description provided for @filterDreams.
  ///
  /// In en, this message translates to:
  /// **'filter dreams'**
  String get filterDreams;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'good'**
  String get good;

  /// No description provided for @great.
  ///
  /// In en, this message translates to:
  /// **'great'**
  String get great;

  /// No description provided for @hidden.
  ///
  /// In en, this message translates to:
  /// **'hidden'**
  String get hidden;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'high'**
  String get high;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'home'**
  String get home;

  /// No description provided for @importDreams.
  ///
  /// In en, this message translates to:
  /// **'import dreams'**
  String get importDreams;

  /// No description provided for @importDreamsDesc.
  ///
  /// In en, this message translates to:
  /// **'import your previously exported dreams'**
  String get importDreamsDesc;

  /// No description provided for @lastExportedDate.
  ///
  /// In en, this message translates to:
  /// **'last exported {date}'**
  String lastExportedDate(Object date);

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'longest streak'**
  String get longestStreak;

  /// No description provided for @lucidness.
  ///
  /// In en, this message translates to:
  /// **'lucidness'**
  String get lucidness;

  /// No description provided for @meh.
  ///
  /// In en, this message translates to:
  /// **'meh'**
  String get meh;

  /// No description provided for @mild.
  ///
  /// In en, this message translates to:
  /// **'mild'**
  String get mild;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'monthly'**
  String get monthly;

  /// No description provided for @mood.
  ///
  /// In en, this message translates to:
  /// **'mood'**
  String get mood;

  /// No description provided for @nameCount.
  ///
  /// In en, this message translates to:
  /// **'nameCount'**
  String get nameCount;

  /// No description provided for @names.
  ///
  /// In en, this message translates to:
  /// **'names'**
  String get names;

  /// No description provided for @neutral.
  ///
  /// In en, this message translates to:
  /// **'neutral'**
  String get neutral;

  /// No description provided for @newDream.
  ///
  /// In en, this message translates to:
  /// **'new dream'**
  String get newDream;

  /// No description provided for @nightmare.
  ///
  /// In en, this message translates to:
  /// **'nightmare'**
  String get nightmare;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'no'**
  String get no;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'no data available'**
  String get noDataAvailable;

  /// No description provided for @noExportData.
  ///
  /// In en, this message translates to:
  /// **'no export data'**
  String get noExportData;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'none'**
  String get none;

  /// No description provided for @paralysis.
  ///
  /// In en, this message translates to:
  /// **'paralysis'**
  String get paralysis;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'rating'**
  String get rating;

  /// No description provided for @reopen.
  ///
  /// In en, this message translates to:
  /// **'close and reopen the app'**
  String get reopen;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'required'**
  String get required;

  /// No description provided for @resetDefault.
  ///
  /// In en, this message translates to:
  /// **'reset default'**
  String get resetDefault;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'restart app'**
  String get restart;

  /// No description provided for @setAppLang.
  ///
  /// In en, this message translates to:
  /// **'set the app\'s language'**
  String get setAppLang;

  /// No description provided for @setDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'set default title'**
  String get setDefaultTitle;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'stats'**
  String get stats;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @toggleDarkMode.
  ///
  /// In en, this message translates to:
  /// **'swtich between dark and light mode'**
  String get toggleDarkMode;

  /// No description provided for @types.
  ///
  /// In en, this message translates to:
  /// **'yypes'**
  String get types;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'weekly'**
  String get weekly;

  /// No description provided for @words.
  ///
  /// In en, this message translates to:
  /// **'words'**
  String get words;

  /// No description provided for @xNames.
  ///
  /// In en, this message translates to:
  /// **'{nameCount} people'**
  String xNames(Object nameCount);

  /// No description provided for @xNamesMore.
  ///
  /// In en, this message translates to:
  /// **'{nameCount} more'**
  String xNamesMore(Object nameCount);

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'yearly'**
  String get yearly;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get yes;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
