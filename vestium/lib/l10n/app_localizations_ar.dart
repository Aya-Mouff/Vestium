// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'فيستيوم';

  @override
  String get splashSubtitle => 'خزانة ملابسك الافتراضية الشخصية.';

  @override
  String get splashDescription => 'نظّم أسلوبك، وأنشئ إطلالات،\nوشارك رحلتك في عالم الموضة.';

  @override
  String get splashCheckingAuth => 'جاري التحقق من تسجيل الدخول...';

  @override
  String get splashSignUp => 'إنشاء حساب';

  @override
  String get splashContinueAsGuest => 'المتابعة كضيف';

  @override
  String get splashAlreadyHaveAccount => 'هل لديك حساب بالفعل؟';

  @override
  String get loginTitle => 'مرحبًا بعودتك';

  @override
  String get loginSubtitle => 'سجّل الدخول لمواصلة رحلتك مع الأناقة';

  @override
  String get loginEmailRequired => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get loginEmailInvalid => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get loginPasswordRequired => 'يرجى إدخال كلمة المرور';

  @override
  String get loginForgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get loginNoAccount => 'ليس لديك حساب؟ ';

  @override
  String get loginCreateAccount => 'إنشاء حساب';

  @override
  String loginWelcomeBackUser(Object userName) {
    return 'مرحبًا بعودتك، $userName!';
  }

  @override
  String get loginEmailLabel => 'البريد الإلكتروني';

  @override
  String get loginEmailHint => 'you@example.com';

  @override
  String get loginPasswordLabel => 'كلمة المرور';

  @override
  String get loginPasswordHint => '••••••••';

  @override
  String get signupTitle => 'إنشاء حساب';

  @override
  String get signupSubtitle => 'انضم إلى فيستيوم وابدأ رحلتك في الأناقة';

  @override
  String get signupFullNameRequired => 'يرجى إدخال اسمك الكامل';

  @override
  String get signupFullNameTooShort => 'يجب أن يتكون الاسم من حرفين على الأقل';

  @override
  String get signupEmailRequired => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get signupEmailInvalid => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get signupPasswordRequired => 'يرجى إدخال كلمة المرور';

  @override
  String get signupPasswordTooShort => 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get signupButton => 'إنشاء حساب';

  @override
  String get signupHaveAccount => 'هل لديك حساب بالفعل؟ ';

  @override
  String get signupSignIn => 'تسجيل الدخول';

  @override
  String signupWelcomeUser(Object userName) {
    return 'مرحبًا بك $userName!';
  }

  @override
  String get fieldEmailLabel => 'البريد الإلكتروني';

  @override
  String get fieldEmailHint => 'you@example.com';

  @override
  String get fieldFullNameLabel => 'الاسم الكامل';

  @override
  String get fieldFullNameHint => 'اسمك';

  @override
  String get fieldPasswordLabel => 'كلمة المرور';

  @override
  String get fieldPasswordHint => '••••••••';

  @override
  String get homeAppTitle => 'فيستيوم';

  @override
  String homeRefreshFailed(Object error) {
    return 'فشل التحديث: $error';
  }

  @override
  String get homeLikeRequiresLogin => 'يجب أن تكون مسجل دخول لتقييم المنشورات!';

  @override
  String homeLikesCount(Object count) {
    return '$count إعجاب';
  }

  @override
  String homeViewAllComments(Object count) {
    return 'عرض جميع $count التعليقات';
  }

  @override
  String get homeReachedEndOfFeed => 'لقد وصلت إلى نهاية الخلاصة الخاصة بك';

  @override
  String get homeRetryButton => 'حاول مرة أخرى';

  @override
  String get homeNoPostsYet => 'لا توجد منشورات حتى الآن. اتبع بعض المستخدمين لرؤية منشوراتهم!';

  @override
  String get homeFindUsersButton => 'البحث عن المستخدمين';

  @override
  String get homeSearchTabHint => 'انتقل إلى علامة التبويب البحث للعثور على مستخدمين للمتابعة!';

  @override
  String get homeNewPosts => 'منشورات جديدة';

  @override
  String get searchRecentHeader => 'الأخير';

  @override
  String get searchDeleteAll => 'حذف الكل';

  @override
  String get searchDiscoverTitle => 'اكتشف';

  @override
  String get searchPlaceholder => 'ابحث عن المستخدمين والإطلالات والعلامات...';

  @override
  String get searchFollowing => 'يتابع';

  @override
  String get searchFollow => 'متابعة';

  @override
  String get searchNoResults => 'لم يتم العثور على نتائج';

  @override
  String get searchTrySomethingElse => 'حاول البحث عن شيء آخر';

  @override
  String get newPostTitle => 'منشور جديد';

  @override
  String get newPostButton => 'نشر';

  @override
  String get captionPlaceholder => 'اكتب عنوان لإطلالتك...';

  @override
  String get outfitPickerEmpty => 'اختر إطلالة';

  @override
  String get publicPostLabel => 'منشور عام';

  @override
  String get publicPostDescription => 'سيكون منشورك مرئياً لجميع مستخدمي فيستيوم';

  @override
  String get selectOutfitTitle => 'اختر إطلالة';

  @override
  String get selectOutfitContinue => 'متابعة';

  @override
  String get selectOutfitSavedOutfits => 'الإطلالات المحفوظة';

  @override
  String get selectOutfitGallery => 'المعرض';

  @override
  String get selectOutfitNoOutfits => 'لا توجد إطلالات حتى الآن';

  @override
  String get selectOutfitCreateFirst => 'أنشئ إطلالتك الأولى لرؤيتها هنا.';

  @override
  String get galleryEmptyMessage => 'سيظهر المعرض بمجرد إدارة الوصول.';

  @override
  String get wardrobeMyWardrobe => 'خزانة ملابسي';

  @override
  String get wardrobeAll => 'الكل';

  @override
  String get wardrobeEmptyFull => 'خزانة ملابسك فارغة';

  @override
  String wardrobeEmptyCategory(Object category) {
    return 'لا توجد عناصر في فئة \"$category\"';
  }

  @override
  String get wardrobeAddItem => 'انقر على زر + لإضافة عنصرك الأول';

  @override
  String get wardrobeErrorRetry => 'حاول مرة أخرى';

  @override
  String get wardrobeNoCategory => 'بدون فئة';

  @override
  String get wardrobeUnnamedItem => 'عنصر بدون اسم';

  @override
  String get userProfileDefaultUser => 'مستخدم';

  @override
  String get userProfileRetry => 'حاول مرة أخرى';

  @override
  String get userProfileFollowing => 'متابع';

  @override
  String get userProfileFollow => 'متابعة';

  @override
  String get userProfilePostsLabel => 'المنشورات';

  @override
  String get userProfileFollowersLabel => 'المتابعون';

  @override
  String get userProfileFollowingLabel => 'المتابعة';

  @override
  String get userProfileNoPostsYet => 'لا توجد منشورات حتى الآن';

  @override
  String get myProfileUnknownUser => 'مستخدم غير معروف';

  @override
  String get myProfileNoBio => 'لا توجد سيرة ذاتية';

  @override
  String get myProfilePostsLabel => 'المنشورات';

  @override
  String get myProfileOutfitsLabel => 'الإطلالات';

  @override
  String get myProfileFollowersLabel => 'المتابعون';

  @override
  String get myProfileFollowingLabel => 'المتابعة';

  @override
  String get myProfileNoPostsYet => 'لا توجد منشورات حتى الآن';

  @override
  String get myProfileNoOutfitsYet => 'لا توجد إطلالات حتى الآن';

  @override
  String get myProfileEditProfile => 'تعديل الملف الشخصي';

  @override
  String get myProfileSettingsButton => 'الإعدادات';

  @override
  String get galleryAccessTitle => 'الوصول إلى المعرض';

  @override
  String get galleryAccessDescription => 'يحتاج Vestium إلى الوصول إلى معرضك لالالتقاط الصور لعناصر الملابس وإضافتها إلى خزانة الملابس الافتراضية.';

  @override
  String get galleryAccessAllowButton => 'السماح بالوصول إلى المعرض';

  @override
  String get galleryAccessMaybeLater => 'ربما لاحقاً';

  @override
  String get galleryAccessPrivacyTitle => 'صورك خاصة';

  @override
  String get galleryAccessPrivacyDescription => 'نحن نستخدم الكاميرا فقط لالالتقاط عناصر الملابس. تبقى صورك على جهازك.';

  @override
  String get galleryAccessPermissionRequired => 'الإذن مطلوبة';

  @override
  String get galleryAccessPermissionDenied => 'لقد تم رفض الوصول إلى المعرض بشكل دائم. يرجى تفعيله في إعدادات التطبيق.';

  @override
  String get galleryAccessCancel => 'إلغاء';

  @override
  String get galleryAccessSettings => 'الإعدادات';

  @override
  String get cameraAccessTitle => 'الوصول إلى الكاميرا';

  @override
  String get cameraAccessDescription => 'يحتاج Vestium إلى الوصول إلى كاميرتك للالتقاط الصور لعناصر الملابس وإضافتها إلى خزانة الملابس الافتراضية.';

  @override
  String get cameraAccessAllowButton => 'السماح بالوصول إلى الكاميرا';

  @override
  String get cameraAccessMaybeLater => 'ربما لاحقاً';

  @override
  String get cameraAccessPrivacyTitle => 'صورك خاصة';

  @override
  String get cameraAccessPrivacyDescription => 'نحن نستخدم الكاميرا فقط لالتقاط عناصر الملابس. تبقى صورك على جهازك.';

  @override
  String get selectItemTitle => 'اختر عنصراً';

  @override
  String get selectItemContinueButton => 'متابعة';

  @override
  String get selectItemEmptyTitle => 'لا توجد صور حتى الآن';

  @override
  String get selectItemEmptyDescription => 'تصفح معرض الصور أو التقط صورة للبدء.';

  @override
  String get editItemTitle => 'تعديل العنصر';

  @override
  String get editItemCropTitle => 'قص الصورة';

  @override
  String get editItemRemoveBgTitle => 'إزالة الخلفية';

  @override
  String get editItemDragText => 'اسحب لضبط منطقة القص';

  @override
  String get editItemResetButton => 'إعادة تعيين';

  @override
  String get editItemDoneButton => 'تم';

  @override
  String get editItemCropButton => 'قص';

  @override
  String get editItemRemoveBgButton => 'إزالة الخلفية';

  @override
  String get editItemInstructionText => 'ارسم على الصورة لإزالة الخلفية';

  @override
  String get editItemEraserSizeLabel => 'حجم الممحاة';

  @override
  String get editItemSaveButtonLabel => 'حفظ';

  @override
  String editItemSaveErrorMessage(Object error) {
    return 'فشل في حفظ الصورة المعدلة: $error';
  }

  @override
  String editItemCropSaveError(Object error) {
    return 'خطأ في حفظ القص: $error';
  }

  @override
  String get editItemDetailsTitle => 'تعديل العنصر';

  @override
  String get editItemDetailsItemName => 'اسم العنصر';

  @override
  String get editItemDetailsItemNameHint => 'أدخل اسم العنصر';

  @override
  String get editItemDetailsDescription => 'الوصف (اختياري)';

  @override
  String get editItemDetailsDescriptionHint => 'أضف وصفاً...';

  @override
  String get editItemDetailsCategories => 'الفئات';

  @override
  String get editItemDetailsSeason => 'الموسم';

  @override
  String get editItemDetailsSeasonHint => 'اختر الموسم';

  @override
  String get editItemDetailsSpring => 'الربيع';

  @override
  String get editItemDetailsSummer => 'الصيف';

  @override
  String get editItemDetailsFall => 'الخريف';

  @override
  String get editItemDetailsWinter => 'الشتاء';

  @override
  String get editItemDetailsAllSeason => 'جميع الفصول';

  @override
  String get editItemDetailsSaveChanges => 'حفظ التغييرات';

  @override
  String get editItemDetailsDeleteItem => 'حذف العنصر';

  @override
  String get editItemDetailsDeleteConfirmTitle => 'حذف العنصر';

  @override
  String get editItemDetailsDeleteConfirmMessage => 'هل أنت متأكد من رغبتك في حذف هذا العنصر؟';

  @override
  String get editItemDetailsDeleteConfirmCancel => 'إلغاء';

  @override
  String get editItemDetailsDeleteConfirmDelete => 'حذف';

  @override
  String get editItemDetailsSuccessMessage => 'تم تحديث العنصر بنجاح!';

  @override
  String get editItemDetailsDeleteSuccessMessage => 'تم حذف العنصر بنجاح!';

  @override
  String get editItemDetailsValidationError => 'يرجى إدخال اسم العنصر واختيار فئة واحدة على الأقل';

  @override
  String get editItemDetailsBlockedTitle => 'لا يمكن حذف العنصر';

  @override
  String get editItemDetailsBlockedMessage => 'يتم استخدام هذا العنصر في الملابس التالية:';

  @override
  String get editItemDetailsBlockedOK => 'حسناً';

  @override
  String get editItemDetailsItemNotFound => 'العنصر غير موجود';

  @override
  String get itemDetailsTitle => 'تفاصيل العنصر';

  @override
  String get itemDetailsItemName => 'اسم العنصر';

  @override
  String get itemDetailsItemNameHint => 'مثال: جاكيت جينز أزرق';

  @override
  String get itemDetailsDescription => 'الوصف (اختياري)';

  @override
  String get itemDetailsDescriptionHint => 'أضف ملاحظات حول هذا العنصر...';

  @override
  String get itemDetailsSeason => 'الموسم';

  @override
  String get itemDetailsSeasonHint => 'اختر الموسم';

  @override
  String get itemDetailsSeasonSpring => 'الربيع';

  @override
  String get itemDetailsSeasonSummer => 'الصيف';

  @override
  String get itemDetailsSeasonFall => 'الخريف';

  @override
  String get itemDetailsSeasonWinter => 'الشتاء';

  @override
  String get itemDetailsSeasonAllSeason => 'جميع المواسم';

  @override
  String get itemDetailsCategories => 'الفئات';

  @override
  String get itemDetailsCategoriesLoading => 'جارٍ تحميل الفئات...';

  @override
  String get itemDetailsCategoriesError => 'فشل تحميل الفئات';

  @override
  String get itemDetailsCategoriesRetry => 'انقر للمحاولة مرة أخرى';

  @override
  String get itemDetailsCategoriesEmpty => 'لا توجد فئات متاحة';

  @override
  String get itemDetailsAddToWardrobe => 'إضافة إلى خزانة الملابس';

  @override
  String get itemDetailsAddedSuccess => 'تمت إضافة العنصر إلى خزانة الملابس!';

  @override
  String get itemDetailsNameRequired => 'يرجى إدخال اسم العنصر';

  @override
  String get itemDetailsCategoryRequired => 'يرجى تحديد فئة واحدة على الأقل';

  @override
  String get takePicTitle => 'إضافة عنصر';

  @override
  String get takePicPosition => 'ضع قطعة الملابس الخاصة بك';

  @override
  String get takePicTapToStart => 'انقر هنا لبدء التقاط الصورة';

  @override
  String get myProfilePosts => 'المنشورات';

  @override
  String get myProfileOutfits => 'الإطلالات';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsProfileUpdated => 'تم تحديث الملف الشخصي';

  @override
  String get settingsAccountSection => 'الحساب';

  @override
  String get settingsAccountManagement => 'إدارة الحساب';

  @override
  String get settingsCategoriesSection => 'الفئات';

  @override
  String get settingsManageCategoriesItems => 'إدارة فئات العناصر';

  @override
  String get settingsManageCategoriesOutfits => 'إدارة فئات الإطلالات';

  @override
  String get settingsNotificationsSection => 'الإشعارات';

  @override
  String get settingsPushNotifications => 'إشعارات الدفع';

  @override
  String get settingsEmailNotifications => 'إشعارات البريد الإلكتروني';

  @override
  String get settingsSupportSection => 'الدعم';

  @override
  String get settingsHelpCenter => 'مركز المساعدة';

  @override
  String get settingsLogoutDialogTitle => 'تسجيل الخروج';

  @override
  String get settingsLogoutDialogMessage => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get settingsLogoutCancel => 'إلغاء';

  @override
  String get settingsLogoutButton => 'تسجيل الخروج';

  @override
  String get settingsEditName => 'الاسم';

  @override
  String get settingsEditNameHint => 'اسمي';

  @override
  String get settingsEditUsername => 'اسم المستخدم';

  @override
  String get settingsEditUsernameHint => 'اسم_المستخدم';

  @override
  String get settingsEditBio => 'السيرة الذاتية';

  @override
  String get settingsEditBioHint => 'عاشق للموضة ✨ | إلهام الأناقة';

  @override
  String get settingsEditCancel => 'إلغاء';

  @override
  String get settingsEditSave => 'حفظ';

  @override
  String get settingsEdit => 'تعديل';

  @override
  String get photoPreviewTitle => 'إضافة عنصر';

  @override
  String get photoPreviewRetake => 'إعادة التقاط';

  @override
  String get photoPreviewUsePhoto => 'استخدام الصورة';

  @override
  String get photoPreviewLoadError => 'فشل تحميل الصورة';

  @override
  String get myPostsTitle => 'المنشورات';

  @override
  String get myPostsAllDeleted => 'تم حذف جميع المنشورات';

  @override
  String get myPostsDefaultUser => 'مستخدم';

  @override
  String myPostsLikesCount(Object count) {
    return '$count إعجاب';
  }

  @override
  String myPostsViewComments(Object count) {
    return 'عرض جميع التعليقات الـ $count';
  }

  @override
  String get myPostsDeleteDialogTitle => 'حذف المنشور؟';

  @override
  String get myPostsDeleteDialogMessage => 'هل أنت متأكد من رغبتك في حذف هذا المنشور؟\nلا يمكن التراجع عن هذا الإجراء وسيتم\nإزالة المنشور من ملفك الشخصي.';

  @override
  String get myPostsDeleteButton => 'حذف';

  @override
  String get myPostsDeleteCancel => 'إلغاء';

  @override
  String get commentsTitle => 'التعليقات';

  @override
  String get commentsNoComments => 'لا توجد تعليقات';

  @override
  String get commentsLoginRequired => 'يجب عليك تسجيل الدخول للتعليق';

  @override
  String get commentsAddComment => 'أضف تعليقاً...';

  @override
  String commentsDaysAgo(Object count) {
    return 'منذ $count يوم';
  }

  @override
  String commentsHoursAgo(Object count) {
    return 'منذ $count ساعة';
  }

  @override
  String commentsMinutesAgo(Object count) {
    return 'منذ $count دقيقة';
  }

  @override
  String get commentsJustNow => 'الآن';

  @override
  String get commentsRecently => 'مؤخراً';

  @override
  String get commentsUnknownUser => 'غير معروف';

  @override
  String get accountManagerTitle => 'إدارة الحساب';

  @override
  String get accountManagerChangeEmail => 'تغيير البريد الإلكتروني';

  @override
  String get accountManagerChangeEmailSubtitle => 'تحديث عنوان بريدك الإلكتروني';

  @override
  String get accountManagerChangePassword => 'تغيير كلمة المرور';

  @override
  String get accountManagerChangePasswordSubtitle => 'تحديث كلمة المرور الخاصة بك';

  @override
  String get accountManagerChangeFullName => 'تغيير الاسم الكامل';

  @override
  String get accountManagerChangeFullNameSubtitle => 'تحديث اسم العرض الخاص بك';

  @override
  String get accountManagerDangerZone => 'منطقة الخطر';

  @override
  String get accountManagerDeleteAccount => 'حذف الحساب';

  @override
  String get accountManagerDeleteAccountSubtitle => 'حذف حسابك بشكل دائم';

  @override
  String get accountManagerChangeEmailDialogTitle => 'تغيير البريد الإلكتروني';

  @override
  String get accountManagerChangeEmailDialogDescription => 'أدخل بريدك الإلكتروني الجديد وأكده بكلمة المرور';

  @override
  String get accountManagerNewEmail => 'البريد الإلكتروني الجديد';

  @override
  String get accountManagerNewEmailHint => 'newemail@example.com';

  @override
  String get accountManagerCurrentPassword => 'كلمة المرور الحالية';

  @override
  String get accountManagerChangeEmailButton => 'تغيير البريد الإلكتروني';

  @override
  String get accountManagerCancel => 'إلغاء';

  @override
  String get accountManagerChangeFullNameDialogTitle => 'تغيير الاسم الكامل';

  @override
  String get accountManagerChangeFullNameDialogDescription => 'أدخل اسم العرض الجديد';

  @override
  String get accountManagerFullName => 'الاسم الكامل';

  @override
  String get accountManagerFullNameHint => 'اسمك';

  @override
  String get accountManagerSave => 'حفظ';

  @override
  String get accountManagerChangePasswordDialogTitle => 'تغيير كلمة المرور';

  @override
  String get accountManagerChangePasswordDialogDescription => 'أدخل كلمة المرور الحالية وكلمة المرور الجديدة';

  @override
  String get accountManagerNewPassword => 'كلمة المرور الجديدة';

  @override
  String get accountManagerConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get accountManagerChangePasswordButton => 'تغيير كلمة المرور';

  @override
  String get accountManagerDeleteAccountDialogTitle => 'حذف الحساب';

  @override
  String get accountManagerDeleteAccountDialogDescription => 'هل أنت متأكد أنك تريد حذف حسابك نهائياً؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get accountManagerDeleteAccountButton => 'حذف الحساب';

  @override
  String get accountManagerFinalConfirmation => 'التأكيد النهائي';

  @override
  String get accountManagerFinalConfirmationDescription => 'اكتب DELETE وأدخل كلمة المرور لتأكيد حذف الحساب';

  @override
  String get accountManagerTypeDelete => 'اكتب DELETE للتأكيد';

  @override
  String get accountManagerTypeDeleteHint => 'اكتب DELETE';

  @override
  String get accountManagerPassword => 'كلمة المرور';

  @override
  String get followersTitle => 'المتابعون';

  @override
  String get followersSearchHint => 'البحث عن متابعين...';

  @override
  String get followersNotFound => 'لم يتم العثور على متابعين';

  @override
  String get followersFollow => 'متابعة';

  @override
  String get followersFollowing => 'يتابع';

  @override
  String get followingTitle => 'يتابع';

  @override
  String get followingSearchHint => 'البحت عن متابعين...';

  @override
  String get followingNotFound => 'لم يتم العثور على نتائج';

  @override
  String get manageCategoriesTitle => 'إدارة فئات العناصر';

  @override
  String get manageCategoriesNewHint => 'اسم الفئة الجديدة...';

  @override
  String manageCategoriesItemCount(Object count) {
    return '$count عناصر';
  }

  @override
  String get manageCategoriesEditTitle => 'تعديل الفئة';

  @override
  String get manageCategoriesEditHint => 'اسم الفئة';

  @override
  String get manageCategoriesDeleteTitle => 'حذف الفئة';

  @override
  String manageCategoriesDeleteMessage(Object name) {
    return 'هل أنت متأكد أنك تريد حذف \"$name\"؟';
  }

  @override
  String get manageCategoriesCancel => 'إلغاء';

  @override
  String get manageCategoriesSave => 'حفظ';

  @override
  String get manageCategoriesDelete => 'حذف';

  @override
  String get manageCategoriesInfo => 'تساعدك الفئات في تنظيم عناصر خزانة ملابسك. يمكن أن تنتمي العناصر إلى فئات متعددة.';

  @override
  String get manageOutfitCategoriesTitle => 'إدارة فئات التنسيقات';

  @override
  String get helpCenterTitle => 'مركز المساعدة';

  @override
  String get helpCenterEmailUs => 'راسلنا عبر البريد الإلكتروني';

  @override
  String get helpCenterFAQTitle => 'الأسئلة المتكررة';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsRetry => 'إعادة المحاولة';

  @override
  String get notificationsLiked => ' أعجب بتنسيقك';

  @override
  String notificationsCommented(String comment) {
    return ' علق: \"$comment\"';
  }

  @override
  String get notificationsFollowed => ' بدأ بمتابعتك';

  @override
  String get notificationsInteracted => ' تفاعل مع محتواك';

  @override
  String notificationsDaysAgo(int count) {
    return 'منذ $count يوم';
  }

  @override
  String notificationsHoursAgo(int count) {
    return 'منذ $count ساعة';
  }

  @override
  String notificationsMinutesAgo(int count) {
    return 'منذ $count دقيقة';
  }

  @override
  String get notificationsJustNow => 'الآن';

  @override
  String get notificationsRecently => 'مؤخراً';

  @override
  String get notificationsErrorMessage => 'فشل تحميل الإشعارات';

  @override
  String get saveOutfitTitle => 'حفظ التنسيق';

  @override
  String get saveOutfitNoDataError => 'لم يتم العثور على بيانات التنسيق. يرجى إنشاء تنسيق أولاً.';

  @override
  String get saveOutfitNoDataFound => 'لم يتم العثور على بيانات التنسيق';

  @override
  String get saveOutfitName => 'اسم التنسيق';

  @override
  String get saveOutfitNameHint => 'مثال: إطلالة الجمعة غير الرسمية';

  @override
  String get saveOutfitDescription => 'الوصف (اختياري)';

  @override
  String get saveOutfitDescriptionHint => 'أضف ملاحظات حول هذا التنسيق...';

  @override
  String get saveOutfitSeason => 'الموسم';

  @override
  String get saveOutfitSeasonHint => 'اختر الموسم';

  @override
  String get saveOutfitCategories => 'الفئات';

  @override
  String saveOutfitItemsCount(int count) {
    return '$count عنصر في التنسيق';
  }

  @override
  String saveOutfitItemsCountPlural(int count) {
    return '$count عناصر في التنسيق';
  }

  @override
  String get saveOutfitSaveButton => 'حفظ في خزانة الملابس';

  @override
  String get editOutfitTitle => 'تفاصيل التنسيق';

  @override
  String get editOutfitLoading => 'تحميل التنسيق...';

  @override
  String get editOutfitError => 'عذراً! حدث خطأ ما';

  @override
  String get editOutfitTryAgain => 'حاول مرة أخرى';

  @override
  String get editOutfitGoBack => 'العودة';

  @override
  String get editOutfitNotFound => 'التنسيق غير موجود';

  @override
  String get editOutfitNotFoundMessage => 'ربما تم حذف التنسيق أو أنه غير موجود';

  @override
  String get editOutfitNoImage => 'لا توجد صورة للتنسيق';

  @override
  String get editOutfitItemsTitle => 'العناصر في هذا التنسيق';

  @override
  String get editOutfitDetailsTitle => 'تحرير تفاصيل التنسيق';

  @override
  String get editOutfitDetailsSubtitle => 'قم بتحديث معلومات تنسيقك';

  @override
  String get editOutfitNameLabel => 'اسم التنسيق';

  @override
  String get editOutfitNameHint => 'مثال: غير رسمي صيفي';

  @override
  String get editOutfitDescriptionLabel => 'الوصف';

  @override
  String get editOutfitDescriptionHint => 'تنسيق مثالي ليوم صيفي غير رسمي';

  @override
  String get editOutfitSeasonLabel => 'الموسم';

  @override
  String get editOutfitSeasonHint => 'اختر الموسم';

  @override
  String get editOutfitErrorName => 'يرجى إدخال اسم التنسيق';

  @override
  String get editOutfitErrorCategory => 'يرجى تحديد فئة واحدة على الأقل';

  @override
  String get editOutfitSuccessSave => 'تم تحديث التنسيق بنجاح!';

  @override
  String editOutfitErrorSave(String error) {
    return 'خطأ في حفظ التنسيق: $error';
  }

  @override
  String get editOutfitDeleteDialog => 'حذف التنسيق';

  @override
  String editOutfitDeleteMessage(String name) {
    return 'هل أنت متأكد من رغبتك في حذف \"$name\"؟';
  }

  @override
  String get editOutfitDeleteWarning => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get editOutfitDeleting => 'جاري حذف التنسيق...';

  @override
  String get editOutfitDeleteSuccess => 'تم حذف التنسيق بنجاح!';

  @override
  String editOutfitDeleteError(String error) {
    return 'خطأ في حذف التنسيق: $error';
  }

  @override
  String get editOutfitCannotDeleteTitle => 'لا يمكن حذف التنسيق';

  @override
  String editOutfitCannotDeleteMessage(int count, String posts) {
    return 'هذا التنسيق مستخدم في $count $posts.';
  }

  @override
  String editOutfitCannotDeleteInstruction(String posts) {
    return 'لحذف هذا التنسيق، يجب أولاً حذف $posts التي تستخدمه.';
  }

  @override
  String editOutfitCannotDeleteInfo(String ones) {
    return 'انتقل إلى منشوراتك واحذف $ones التي تستخدم هذا التنسيق أولاً.';
  }

  @override
  String get editOutfitPost => 'منشور';

  @override
  String get editOutfitPosts => 'منشورات';

  @override
  String get editOutfitOne => 'واحد';

  @override
  String get editOutfitOnes => 'منشورات';

  @override
  String editOutfitWarningUsed(int count, String posts) {
    return 'هذا التنسيق مستخدم في $count $posts';
  }

  @override
  String editOutfitWarningDeleteFirst(String posts) {
    return 'احذف $posts أولاً لحذف هذا التنسيق';
  }

  @override
  String get editOutfitDeleteButton => 'حذف التنسيق';

  @override
  String get editOutfitCancelButton => 'إلغاء';

  @override
  String get editOutfitSaveButton => 'حفظ التغييرات';

  @override
  String get editOutfitGoToPostsButton => 'انتقل إلى المنشورات';

  @override
  String get editOutfitLoginRequired => 'يرجى تسجيل الدخول لعرض ملفك الشخصي';

  @override
  String get editOutfitImageLoading => 'جاري تحميل الصورة...';

  @override
  String get editOutfitImageNotAvailable => 'الصورة غير متاحة';

  @override
  String get seasonSpring => 'الربيع';

  @override
  String get seasonSummer => 'الصيف';

  @override
  String get seasonFall => 'الخريف';

  @override
  String get seasonWinter => 'الشتاء';

  @override
  String get seasonAllSeason => 'جميع المواسم';

  @override
  String get outfitDetailsTitle => 'تفاصيل التنسيق';

  @override
  String get outfitDetailsError => 'خطأ في تحميل تفاصيل التنسيق';

  @override
  String get outfitDetailsDeleteDialog => 'حذف التنسيق؟';

  @override
  String get outfitDetailsDeleteMessage => 'هل أنت متأكد من حذف هذا التنسيق؟\nلا يمكن التراجع عن هذا الإجراء.';

  @override
  String get outfitDetailsDeleteButton => 'حذف';

  @override
  String get outfitDetailsCancelButton => 'إلغاء';

  @override
  String get outfitDetailsShareComingSoon => 'ميزة المشاركة - قريباً';

  @override
  String get outfitDetailsOutfitDeleted => 'تم حذف التنسيق';

  @override
  String get outfitDetailsShareButton => 'مشاركة التنسيق';

  @override
  String get outfitDetailsDeleteButtonAction => 'حذف التنسيق';

  @override
  String get outfitDetailsUnnamedOutfit => 'تنسيق بدون اسم';

  @override
  String get outfitDetailsCreatedDefault => 'تم الإنشاء في 20 أكتوبر 2025';

  @override
  String outfitDetailsItemsCount(int count) {
    return 'العناصر ($count)';
  }

  @override
  String get outfitDetailsNoItems => 'لا توجد عناصر في هذا التنسيق';

  @override
  String get outfitDetailsUnnamedItem => 'عنصر بدون اسم';

  @override
  String get outfitDetailsUncategorized => 'غير مصنف';

  @override
  String get createOutfitCapturing => 'جاري التقاط التنسيق...';

  @override
  String get createOutfitAddAtLeastOne => 'يرجى إضافة عنصر واحد على الأقل إلى التنسيق';

  @override
  String get createOutfitSaveSuccess => 'تم حفظ التنسيق بنجاح!';

  @override
  String get createOutfitErrorLoading => 'خطأ في تحميل العناصر';

  @override
  String get createOutfitTryAgain => 'حاول مرة أخرى';

  @override
  String get createOutfitZoomIn => 'تكبير';

  @override
  String get createOutfitZoomOut => 'تصغير';

  @override
  String get createOutfitResetSize => 'إعادة تعيين الحجم';

  @override
  String get createOutfitBringToFront => 'إحضار للأمام';

  @override
  String get createOutfitSendToBack => 'إرسال للخلف';

  @override
  String get createOutfitRemoveFromOutfit => 'إزالة من التنسيق';

  @override
  String get createOutfitAddItems => 'إضافة عناصر';

  @override
  String createOutfitItemsCount(int count) {
    return '$count عناصر';
  }

  @override
  String createOutfitAddedToOutfit(String itemName) {
    return 'تمت إضافة $itemName إلى التنسيق';
  }

  @override
  String get createOutfitRemoveItemTitle => 'إزالة العنصر';

  @override
  String get createOutfitRemoveItemMessage => 'هل تريد إزالة هذا العنصر من التنسيق؟';

  @override
  String get createOutfitCancel => 'إلغاء';

  @override
  String get createOutfitRemove => 'إزالة';

  @override
  String get createOutfitYourItems => 'عناصرك';

  @override
  String createOutfitTotalCount(int count) {
    return '$count إجمالي';
  }

  @override
  String get createOutfitNoItems => 'لا توجد عناصر في خزانة ملابسك';

  @override
  String get postsDetailsTitle => 'المنشورات';

  @override
  String get postsDetailsMustLoginToLike => 'يجب عليك تسجيل الدخول للإعجاب بالمنشورات!';

  @override
  String postsDetailsLikesCount(int count) {
    return '$count إعجاب';
  }

  @override
  String postsDetailsViewAllComments(int count) {
    return 'عرض جميع التعليقات الـ $count';
  }

  @override
  String get postsDetailsImageNotFound => 'الصورة غير موجودة';
}
