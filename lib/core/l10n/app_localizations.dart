import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';

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
  static const List<Locale> supportedLocales = <Locale>[Locale('ar')];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'براعم'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In ar, this message translates to:
  /// **'نتعلّم الكلمات بالصور والصوت'**
  String get appTagline;

  /// No description provided for @next.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get next;

  /// No description provided for @listen.
  ///
  /// In ar, this message translates to:
  /// **'استمع'**
  String get listen;

  /// No description provided for @quizTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختبار'**
  String get quizTitle;

  /// No description provided for @whereIs.
  ///
  /// In ar, this message translates to:
  /// **'وين {label}؟'**
  String whereIs(String label);

  /// No description provided for @wellDone.
  ///
  /// In ar, this message translates to:
  /// **'أحسنت!'**
  String get wellDone;

  /// No description provided for @tryAgain.
  ///
  /// In ar, this message translates to:
  /// **'جرّب تاني'**
  String get tryAgain;

  /// No description provided for @keyboardHintNext.
  ///
  /// In ar, this message translates to:
  /// **'المسافة أو ← للتالي'**
  String get keyboardHintNext;

  /// No description provided for @keyboardHintChoose.
  ///
  /// In ar, this message translates to:
  /// **'الأرقام أو الأسهم للاختيار'**
  String get keyboardHintChoose;

  /// No description provided for @greeting.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً {name}'**
  String greeting(String name);

  /// No description provided for @chooseGroup.
  ///
  /// In ar, this message translates to:
  /// **'اختَر مجموعة'**
  String get chooseGroup;

  /// No description provided for @learnTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعلّم'**
  String get learnTitle;

  /// No description provided for @chooseModeHint.
  ///
  /// In ar, this message translates to:
  /// **'اختَر تعلّم أو اختبار، ثم اضغط مجموعة'**
  String get chooseModeHint;

  /// No description provided for @allGroups.
  ///
  /// In ar, this message translates to:
  /// **'كل المجموعات'**
  String get allGroups;

  /// No description provided for @letsLearn.
  ///
  /// In ar, this message translates to:
  /// **'نبدأ نتعلّم؟'**
  String get letsLearn;

  /// No description provided for @progressOf.
  ///
  /// In ar, this message translates to:
  /// **'{done} / {total}'**
  String progressOf(int done, int total);

  /// No description provided for @addProfile.
  ///
  /// In ar, this message translates to:
  /// **'إضافة طفل'**
  String get addProfile;

  /// No description provided for @newProfile.
  ///
  /// In ar, this message translates to:
  /// **'طفل جديد'**
  String get newProfile;

  /// No description provided for @childName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الطفل'**
  String get childName;

  /// No description provided for @chooseAvatar.
  ///
  /// In ar, this message translates to:
  /// **'اختَر صورة'**
  String get chooseAvatar;

  /// No description provided for @modeNormal.
  ///
  /// In ar, this message translates to:
  /// **'عادي'**
  String get modeNormal;

  /// No description provided for @modeSupport.
  ///
  /// In ar, this message translates to:
  /// **'دعم'**
  String get modeSupport;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @gardenGrowing.
  ///
  /// In ar, this message translates to:
  /// **'حديقتك تكبر!'**
  String get gardenGrowing;

  /// No description provided for @masteredWords.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{لم تُتقن كلمات بعد} =1{أتقنت كلمة واحدة} =2{أتقنت كلمتين} few{أتقنت {count} كلمات} other{أتقنت {count} كلمة}}'**
  String masteredWords(int count);

  /// No description provided for @keepGoing.
  ///
  /// In ar, this message translates to:
  /// **'نكمل؟'**
  String get keepGoing;

  /// No description provided for @parentArea.
  ///
  /// In ar, this message translates to:
  /// **'منطقة الأهل'**
  String get parentArea;

  /// No description provided for @enterPin.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رمز الأهل'**
  String get enterPin;

  /// No description provided for @createPin.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ رمزاً للأهل'**
  String get createPin;

  /// No description provided for @confirmPin.
  ///
  /// In ar, this message translates to:
  /// **'أعِد إدخال الرمز'**
  String get confirmPin;

  /// No description provided for @pinWrong.
  ///
  /// In ar, this message translates to:
  /// **'حاول مرة أخرى'**
  String get pinWrong;

  /// No description provided for @pinMismatch.
  ///
  /// In ar, this message translates to:
  /// **'الرمزان غير متطابقين'**
  String get pinMismatch;

  /// No description provided for @tabReports.
  ///
  /// In ar, this message translates to:
  /// **'التقارير'**
  String get tabReports;

  /// No description provided for @tabContent.
  ///
  /// In ar, this message translates to:
  /// **'المحتوى'**
  String get tabContent;

  /// No description provided for @tabSettings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get tabSettings;

  /// No description provided for @tabProfiles.
  ///
  /// In ar, this message translates to:
  /// **'الأطفال'**
  String get tabProfiles;

  /// No description provided for @reportMastered.
  ///
  /// In ar, this message translates to:
  /// **'متقَنة'**
  String get reportMastered;

  /// No description provided for @reportLearning.
  ///
  /// In ar, this message translates to:
  /// **'قيد التعلّم'**
  String get reportLearning;

  /// No description provided for @reportNew.
  ///
  /// In ar, this message translates to:
  /// **'جديدة'**
  String get reportNew;

  /// No description provided for @reportArchived.
  ///
  /// In ar, this message translates to:
  /// **'مؤرشفة'**
  String get reportArchived;

  /// No description provided for @reportAccuracy.
  ///
  /// In ar, this message translates to:
  /// **'نسبة الإجابات الصحيحة'**
  String get reportAccuracy;

  /// No description provided for @reportMasteredThisWeek.
  ///
  /// In ar, this message translates to:
  /// **'أُتقنت هذا الأسبوع'**
  String get reportMasteredThisWeek;

  /// No description provided for @reportPerItem.
  ///
  /// In ar, this message translates to:
  /// **'تقدّم كل عنصر'**
  String get reportPerItem;

  /// No description provided for @reportNoData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات بعد — ابدأ جلسة تعلّم أولاً'**
  String get reportNoData;

  /// No description provided for @settingsMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع'**
  String get settingsMode;

  /// No description provided for @settingsChoices.
  ///
  /// In ar, this message translates to:
  /// **'عدد خيارات الاختبار'**
  String get settingsChoices;

  /// No description provided for @settingsSessionLength.
  ///
  /// In ar, this message translates to:
  /// **'طول الجلسة'**
  String get settingsSessionLength;

  /// No description provided for @settingsActiveWindow.
  ///
  /// In ar, this message translates to:
  /// **'عدد الكلمات النشطة'**
  String get settingsActiveWindow;

  /// No description provided for @settingsMute.
  ///
  /// In ar, this message translates to:
  /// **'كتم الصوت'**
  String get settingsMute;

  /// No description provided for @praiseSounds.
  ///
  /// In ar, this message translates to:
  /// **'أصوات التشجيع'**
  String get praiseSounds;

  /// No description provided for @praiseSoundsHint.
  ///
  /// In ar, this message translates to:
  /// **'تُسمع عند الإجابة الصحيحة'**
  String get praiseSoundsHint;

  /// No description provided for @addSound.
  ///
  /// In ar, this message translates to:
  /// **'أضف صوت'**
  String get addSound;

  /// No description provided for @soundName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الصوت'**
  String get soundName;

  /// No description provided for @pickAudioFile.
  ///
  /// In ar, this message translates to:
  /// **'اختر ملف صوت'**
  String get pickAudioFile;

  /// No description provided for @orRecord.
  ///
  /// In ar, this message translates to:
  /// **'أو سجّل بصوتك'**
  String get orRecord;

  /// No description provided for @restore.
  ///
  /// In ar, this message translates to:
  /// **'استرجاع'**
  String get restore;

  /// No description provided for @noPraises.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أصوات تشجيع مفعّلة'**
  String get noPraises;

  /// No description provided for @resetDefaults.
  ///
  /// In ar, this message translates to:
  /// **'إعادة الإعدادات الافتراضية'**
  String get resetDefaults;

  /// No description provided for @resetConfirm.
  ///
  /// In ar, this message translates to:
  /// **'سيُعاد كل شيء للوضع الافتراضي، وتُحذف أصواتك المسجّلة. متابعة؟'**
  String get resetConfirm;

  /// No description provided for @resetDone.
  ///
  /// In ar, this message translates to:
  /// **'تمت إعادة الإعدادات'**
  String get resetDone;

  /// No description provided for @settingsTheme.
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In ar, this message translates to:
  /// **'تلقائي'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In ar, this message translates to:
  /// **'فاتح'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In ar, this message translates to:
  /// **'داكن'**
  String get themeDark;

  /// No description provided for @addItem.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عنصر'**
  String get addItem;

  /// No description provided for @editItem.
  ///
  /// In ar, this message translates to:
  /// **'تعديل عنصر'**
  String get editItem;

  /// No description provided for @itemLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم العنصر'**
  String get itemLabel;

  /// No description provided for @itemCategory.
  ///
  /// In ar, this message translates to:
  /// **'المجموعة'**
  String get itemCategory;

  /// No description provided for @pickImage.
  ///
  /// In ar, this message translates to:
  /// **'اختَر صورة'**
  String get pickImage;

  /// No description provided for @takePhoto.
  ///
  /// In ar, this message translates to:
  /// **'التقط صورة'**
  String get takePhoto;

  /// No description provided for @recordAudio.
  ///
  /// In ar, this message translates to:
  /// **'سجّل الصوت'**
  String get recordAudio;

  /// No description provided for @stopRecording.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف التسجيل'**
  String get stopRecording;

  /// No description provided for @playAudio.
  ///
  /// In ar, this message translates to:
  /// **'تشغيل'**
  String get playAudio;

  /// No description provided for @itemSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم الحفظ'**
  String get itemSaved;

  /// No description provided for @requiredField.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get requiredField;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'لحظة…'**
  String get loading;

  /// No description provided for @startSession.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ'**
  String get startSession;

  /// No description provided for @back.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get back;

  /// No description provided for @muteOn.
  ///
  /// In ar, this message translates to:
  /// **'الصوت مكتوم'**
  String get muteOn;

  /// No description provided for @muteOff.
  ///
  /// In ar, this message translates to:
  /// **'الصوت يعمل'**
  String get muteOff;
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
      <String>['ar'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
