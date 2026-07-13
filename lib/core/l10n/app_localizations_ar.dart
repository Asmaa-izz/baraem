// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'براعم';

  @override
  String get appTagline => 'نتعلّم الكلمات بالصور والصوت';

  @override
  String get next => 'التالي';

  @override
  String get listen => 'استمع';

  @override
  String get quizTitle => 'اختبار';

  @override
  String whereIs(String label) {
    return 'وين $label؟';
  }

  @override
  String get wellDone => 'أحسنت!';

  @override
  String get tryAgain => 'جرّب تاني';

  @override
  String get keyboardHintNext => 'المسافة أو ← للتالي';

  @override
  String get keyboardHintChoose => 'الأرقام أو الأسهم للاختيار';

  @override
  String greeting(String name) {
    return 'أهلاً $name';
  }

  @override
  String get chooseGroup => 'اختَر مجموعة';

  @override
  String get learnTitle => 'تعلّم';

  @override
  String get chooseModeHint => 'اختَر تعلّم أو اختبار، ثم اضغط مجموعة';

  @override
  String get allGroups => 'كل المجموعات';

  @override
  String get letsLearn => 'نبدأ نتعلّم؟';

  @override
  String progressOf(int done, int total) {
    return '$done / $total';
  }

  @override
  String get addProfile => 'إضافة طفل';

  @override
  String get newProfile => 'طفل جديد';

  @override
  String get childName => 'اسم الطفل';

  @override
  String get chooseAvatar => 'اختَر صورة';

  @override
  String get modeNormal => 'عادي';

  @override
  String get modeSupport => 'دعم';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get gardenGrowing => 'حديقتك تكبر!';

  @override
  String masteredWords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أتقنت $count كلمة',
      few: 'أتقنت $count كلمات',
      two: 'أتقنت كلمتين',
      one: 'أتقنت كلمة واحدة',
      zero: 'لم تُتقن كلمات بعد',
    );
    return '$_temp0';
  }

  @override
  String get keepGoing => 'نكمل؟';

  @override
  String get parentArea => 'منطقة الأهل';

  @override
  String get enterPin => 'أدخل رمز الأهل';

  @override
  String get createPin => 'أنشئ رمزاً للأهل';

  @override
  String get confirmPin => 'أعِد إدخال الرمز';

  @override
  String get pinWrong => 'حاول مرة أخرى';

  @override
  String get pinMismatch => 'الرمزان غير متطابقين';

  @override
  String get tabReports => 'التقارير';

  @override
  String get tabContent => 'المحتوى';

  @override
  String get tabSettings => 'الإعدادات';

  @override
  String get tabProfiles => 'الأطفال';

  @override
  String get reportMastered => 'متقَنة';

  @override
  String get reportLearning => 'قيد التعلّم';

  @override
  String get reportNew => 'جديدة';

  @override
  String get reportArchived => 'مؤرشفة';

  @override
  String get reportAccuracy => 'نسبة الإجابات الصحيحة';

  @override
  String get reportMasteredThisWeek => 'أُتقنت هذا الأسبوع';

  @override
  String get reportPerItem => 'تقدّم كل عنصر';

  @override
  String get reportNoData => 'لا توجد بيانات بعد — ابدأ جلسة تعلّم أولاً';

  @override
  String get settingsMode => 'الوضع';

  @override
  String get settingsChoices => 'عدد خيارات الاختبار';

  @override
  String get settingsSessionLength => 'طول الجلسة';

  @override
  String get settingsActiveWindow => 'عدد الكلمات النشطة';

  @override
  String get settingsMute => 'كتم الصوت';

  @override
  String get praiseSounds => 'أصوات التشجيع';

  @override
  String get praiseSoundsHint => 'تُسمع عند الإجابة الصحيحة';

  @override
  String get addSound => 'أضف صوت';

  @override
  String get soundName => 'اسم الصوت';

  @override
  String get pickAudioFile => 'اختر ملف صوت';

  @override
  String get orRecord => 'أو سجّل بصوتك';

  @override
  String get audioReady => 'جاهز';

  @override
  String get removeAudio => 'إزالة الصوت';

  @override
  String get editItemAudio => 'صوت الكلمة';

  @override
  String get restore => 'استرجاع';

  @override
  String get noPraises => 'لا توجد أصوات تشجيع مفعّلة';

  @override
  String get resetDefaults => 'إعادة الإعدادات الافتراضية';

  @override
  String get resetConfirm =>
      'سيُعاد كل شيء للوضع الافتراضي، وتُحذف أصواتك المسجّلة. متابعة؟';

  @override
  String get resetDone => 'تمت إعادة الإعدادات';

  @override
  String get settingsTheme => 'المظهر';

  @override
  String get themeSystem => 'تلقائي';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get editItem => 'تعديل عنصر';

  @override
  String get itemLabel => 'اسم العنصر';

  @override
  String get itemCategory => 'المجموعة';

  @override
  String get pickImage => 'اختَر صورة';

  @override
  String get takePhoto => 'التقط صورة';

  @override
  String get recordAudio => 'سجّل الصوت';

  @override
  String get stopRecording => 'إيقاف التسجيل';

  @override
  String get playAudio => 'تشغيل';

  @override
  String get itemSaved => 'تم الحفظ';

  @override
  String get requiredField => 'هذا الحقل مطلوب';

  @override
  String get loading => 'لحظة…';

  @override
  String get startSession => 'ابدأ';

  @override
  String get back => 'رجوع';

  @override
  String get muteOn => 'الصوت مكتوم';

  @override
  String get muteOff => 'الصوت يعمل';
}
