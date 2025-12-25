import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
    Locale('it')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Vestium'**
  String get appTitle;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your personal virtual wardrobe.'**
  String get splashSubtitle;

  /// No description provided for @splashDescription.
  ///
  /// In en, this message translates to:
  /// **'Organize your style, create outfits, and\nshare your fashion journey.'**
  String get splashDescription;

  /// No description provided for @splashCheckingAuth.
  ///
  /// In en, this message translates to:
  /// **'Checking authentication...'**
  String get splashCheckingAuth;

  /// No description provided for @splashSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get splashSignUp;

  /// No description provided for @splashContinueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get splashContinueAsGuest;

  /// No description provided for @splashAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get splashAlreadyHaveAccount;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue your style journey'**
  String get loginSubtitle;

  /// No description provided for @loginEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get loginEmailRequired;

  /// No description provided for @loginEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get loginEmailInvalid;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get loginPasswordRequired;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get loginForgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get loginNoAccount;

  /// No description provided for @loginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get loginCreateAccount;

  /// No description provided for @loginWelcomeBackUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {userName}!'**
  String loginWelcomeBackUser(Object userName);

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get loginPasswordHint;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signupTitle;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join Vestium and start your style journey'**
  String get signupSubtitle;

  /// No description provided for @signupFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get signupFullNameRequired;

  /// No description provided for @signupFullNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get signupFullNameTooShort;

  /// No description provided for @signupEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get signupEmailRequired;

  /// No description provided for @signupEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get signupEmailInvalid;

  /// No description provided for @signupPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get signupPasswordRequired;

  /// No description provided for @signupPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get signupPasswordTooShort;

  /// No description provided for @signupButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signupButton;

  /// No description provided for @signupHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get signupHaveAccount;

  /// No description provided for @signupSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signupSignIn;

  /// No description provided for @signupWelcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome {userName}!'**
  String signupWelcomeUser(Object userName);

  /// No description provided for @fieldEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get fieldEmailLabel;

  /// No description provided for @fieldEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get fieldEmailHint;

  /// No description provided for @fieldFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fieldFullNameLabel;

  /// No description provided for @fieldFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get fieldFullNameHint;

  /// No description provided for @fieldPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get fieldPasswordLabel;

  /// No description provided for @fieldPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get fieldPasswordHint;

  /// No description provided for @homeAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Vestium'**
  String get homeAppTitle;

  /// No description provided for @homeRefreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Refresh failed: {error}'**
  String homeRefreshFailed(Object error);

  /// No description provided for @homeLikeRequiresLogin.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to like posts!'**
  String get homeLikeRequiresLogin;

  /// No description provided for @homeLikesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} likes'**
  String homeLikesCount(Object count);

  /// No description provided for @homeViewAllComments.
  ///
  /// In en, this message translates to:
  /// **'View all {count} comments'**
  String homeViewAllComments(Object count);

  /// No description provided for @homeReachedEndOfFeed.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the end of your feed'**
  String get homeReachedEndOfFeed;

  /// No description provided for @homeRetryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get homeRetryButton;

  /// No description provided for @homeNoPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet. Follow some users to see their posts!'**
  String get homeNoPostsYet;

  /// No description provided for @homeFindUsersButton.
  ///
  /// In en, this message translates to:
  /// **'Find Users'**
  String get homeFindUsersButton;

  /// No description provided for @homeSearchTabHint.
  ///
  /// In en, this message translates to:
  /// **'Go to the search tab to find users to follow!'**
  String get homeSearchTabHint;

  /// No description provided for @homeNewPosts.
  ///
  /// In en, this message translates to:
  /// **'New posts'**
  String get homeNewPosts;

  /// No description provided for @searchRecentHeader.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get searchRecentHeader;

  /// No description provided for @searchDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get searchDeleteAll;

  /// No description provided for @searchDiscoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get searchDiscoverTitle;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search users, outfits, tags...'**
  String get searchPlaceholder;

  /// No description provided for @searchFollowing.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get searchFollowing;

  /// No description provided for @searchFollow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get searchFollow;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get searchNoResults;

  /// No description provided for @searchTrySomethingElse.
  ///
  /// In en, this message translates to:
  /// **'Try searching for something else'**
  String get searchTrySomethingElse;

  /// No description provided for @newPostTitle.
  ///
  /// In en, this message translates to:
  /// **'New Post'**
  String get newPostTitle;

  /// No description provided for @newPostButton.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get newPostButton;

  /// No description provided for @captionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Write a caption for your outfit...'**
  String get captionPlaceholder;

  /// No description provided for @outfitPickerEmpty.
  ///
  /// In en, this message translates to:
  /// **'Choose an Outfit'**
  String get outfitPickerEmpty;

  /// No description provided for @publicPostLabel.
  ///
  /// In en, this message translates to:
  /// **'Public Post'**
  String get publicPostLabel;

  /// No description provided for @publicPostDescription.
  ///
  /// In en, this message translates to:
  /// **'Your post will be visible to all Vestium users'**
  String get publicPostDescription;

  /// No description provided for @selectOutfitTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Outfit'**
  String get selectOutfitTitle;

  /// No description provided for @selectOutfitContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get selectOutfitContinue;

  /// No description provided for @selectOutfitSavedOutfits.
  ///
  /// In en, this message translates to:
  /// **'Saved Outfits'**
  String get selectOutfitSavedOutfits;

  /// No description provided for @selectOutfitGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get selectOutfitGallery;

  /// No description provided for @selectOutfitNoOutfits.
  ///
  /// In en, this message translates to:
  /// **'No outfits yet'**
  String get selectOutfitNoOutfits;

  /// No description provided for @selectOutfitCreateFirst.
  ///
  /// In en, this message translates to:
  /// **'Create your first outfit to see it here.'**
  String get selectOutfitCreateFirst;

  /// No description provided for @galleryEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Gallery will appear here once access is managed.'**
  String get galleryEmptyMessage;

  /// No description provided for @wardrobeMyWardrobe.
  ///
  /// In en, this message translates to:
  /// **'My Wardrobe'**
  String get wardrobeMyWardrobe;

  /// No description provided for @wardrobeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get wardrobeAll;

  /// No description provided for @wardrobeEmptyFull.
  ///
  /// In en, this message translates to:
  /// **'Your wardrobe is empty'**
  String get wardrobeEmptyFull;

  /// No description provided for @wardrobeEmptyCategory.
  ///
  /// In en, this message translates to:
  /// **'No items in \"{category}\" category'**
  String wardrobeEmptyCategory(Object category);

  /// No description provided for @wardrobeAddItem.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to add your first item'**
  String get wardrobeAddItem;

  /// No description provided for @wardrobeErrorRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get wardrobeErrorRetry;

  /// No description provided for @wardrobeNoCategory.
  ///
  /// In en, this message translates to:
  /// **'No category'**
  String get wardrobeNoCategory;

  /// No description provided for @wardrobeUnnamedItem.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Item'**
  String get wardrobeUnnamedItem;

  /// No description provided for @userProfileDefaultUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userProfileDefaultUser;

  /// No description provided for @userProfileRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get userProfileRetry;

  /// No description provided for @userProfileFollowing.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get userProfileFollowing;

  /// No description provided for @userProfileFollow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get userProfileFollow;

  /// No description provided for @userProfilePostsLabel.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get userProfilePostsLabel;

  /// No description provided for @userProfileFollowersLabel.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get userProfileFollowersLabel;

  /// No description provided for @userProfileFollowingLabel.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get userProfileFollowingLabel;

  /// No description provided for @userProfileNoPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get userProfileNoPostsYet;

  /// No description provided for @myProfileUnknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get myProfileUnknownUser;

  /// No description provided for @myProfileNoBio.
  ///
  /// In en, this message translates to:
  /// **'No bio'**
  String get myProfileNoBio;

  /// No description provided for @myProfilePostsLabel.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get myProfilePostsLabel;

  /// No description provided for @myProfileOutfitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Outfits'**
  String get myProfileOutfitsLabel;

  /// No description provided for @myProfileFollowersLabel.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get myProfileFollowersLabel;

  /// No description provided for @myProfileFollowingLabel.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get myProfileFollowingLabel;

  /// No description provided for @myProfileNoPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get myProfileNoPostsYet;

  /// No description provided for @myProfileNoOutfitsYet.
  ///
  /// In en, this message translates to:
  /// **'No outfits yet'**
  String get myProfileNoOutfitsYet;

  /// No description provided for @myProfileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get myProfileEditProfile;

  /// No description provided for @myProfileSettingsButton.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get myProfileSettingsButton;

  /// No description provided for @galleryAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Gallery Access'**
  String get galleryAccessTitle;

  /// No description provided for @galleryAccessDescription.
  ///
  /// In en, this message translates to:
  /// **'Vestium needs access to your gallery to pick pictures of your clothing items and add them to your virtual wardrobe.'**
  String get galleryAccessDescription;

  /// No description provided for @galleryAccessAllowButton.
  ///
  /// In en, this message translates to:
  /// **'Allow Gallery Access'**
  String get galleryAccessAllowButton;

  /// No description provided for @galleryAccessMaybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get galleryAccessMaybeLater;

  /// No description provided for @galleryAccessPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your pictures are private'**
  String get galleryAccessPrivacyTitle;

  /// No description provided for @galleryAccessPrivacyDescription.
  ///
  /// In en, this message translates to:
  /// **'We only use your camera to capture clothing items. Your photos stay on your device.'**
  String get galleryAccessPrivacyDescription;

  /// No description provided for @galleryAccessPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get galleryAccessPermissionRequired;

  /// No description provided for @galleryAccessPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Gallery access has been permanently denied. Please enable it in app settings.'**
  String get galleryAccessPermissionDenied;

  /// No description provided for @galleryAccessCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get galleryAccessCancel;

  /// No description provided for @galleryAccessSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get galleryAccessSettings;

  /// No description provided for @cameraAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera Access'**
  String get cameraAccessTitle;

  /// No description provided for @cameraAccessDescription.
  ///
  /// In en, this message translates to:
  /// **'Vestium needs access to your camera to capture photos of your clothing items and add them to your virtual wardrobe.'**
  String get cameraAccessDescription;

  /// No description provided for @cameraAccessAllowButton.
  ///
  /// In en, this message translates to:
  /// **'Allow Camera Access'**
  String get cameraAccessAllowButton;

  /// No description provided for @cameraAccessMaybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get cameraAccessMaybeLater;

  /// No description provided for @cameraAccessPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your photos are private'**
  String get cameraAccessPrivacyTitle;

  /// No description provided for @cameraAccessPrivacyDescription.
  ///
  /// In en, this message translates to:
  /// **'We only use your camera to capture clothing items. Your photos stay on your device.'**
  String get cameraAccessPrivacyDescription;

  /// No description provided for @selectItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Item'**
  String get selectItemTitle;

  /// No description provided for @selectItemContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get selectItemContinueButton;

  /// No description provided for @selectItemEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Photos Yet'**
  String get selectItemEmptyTitle;

  /// No description provided for @selectItemEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Visit your gallery or take a photo to get started.'**
  String get selectItemEmptyDescription;

  /// No description provided for @editItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get editItemTitle;

  /// No description provided for @editItemCropTitle.
  ///
  /// In en, this message translates to:
  /// **'Crop Image'**
  String get editItemCropTitle;

  /// No description provided for @editItemRemoveBgTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Background'**
  String get editItemRemoveBgTitle;

  /// No description provided for @editItemDragText.
  ///
  /// In en, this message translates to:
  /// **'Drag to adjust crop area'**
  String get editItemDragText;

  /// No description provided for @editItemResetButton.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get editItemResetButton;

  /// No description provided for @editItemDoneButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get editItemDoneButton;

  /// No description provided for @editItemCropButton.
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get editItemCropButton;

  /// No description provided for @editItemRemoveBgButton.
  ///
  /// In en, this message translates to:
  /// **'Remove BG'**
  String get editItemRemoveBgButton;

  /// No description provided for @editItemInstructionText.
  ///
  /// In en, this message translates to:
  /// **'Draw on the image to remove background'**
  String get editItemInstructionText;

  /// No description provided for @editItemEraserSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Eraser Size'**
  String get editItemEraserSizeLabel;

  /// No description provided for @editItemSaveButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editItemSaveButtonLabel;

  /// No description provided for @editItemSaveErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to save edited image: {error}'**
  String editItemSaveErrorMessage(Object error);

  /// No description provided for @editItemCropSaveError.
  ///
  /// In en, this message translates to:
  /// **'Error saving crop: {error}'**
  String editItemCropSaveError(Object error);

  /// No description provided for @editItemDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get editItemDetailsTitle;

  /// No description provided for @editItemDetailsItemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get editItemDetailsItemName;

  /// No description provided for @editItemDetailsItemNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter item name'**
  String get editItemDetailsItemNameHint;

  /// No description provided for @editItemDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get editItemDetailsDescription;

  /// No description provided for @editItemDetailsDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Add description...'**
  String get editItemDetailsDescriptionHint;

  /// No description provided for @editItemDetailsCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get editItemDetailsCategories;

  /// No description provided for @editItemDetailsSeason.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get editItemDetailsSeason;

  /// No description provided for @editItemDetailsSeasonHint.
  ///
  /// In en, this message translates to:
  /// **'Select season'**
  String get editItemDetailsSeasonHint;

  /// No description provided for @editItemDetailsSpring.
  ///
  /// In en, this message translates to:
  /// **'Spring'**
  String get editItemDetailsSpring;

  /// No description provided for @editItemDetailsSummer.
  ///
  /// In en, this message translates to:
  /// **'Summer'**
  String get editItemDetailsSummer;

  /// No description provided for @editItemDetailsFall.
  ///
  /// In en, this message translates to:
  /// **'Fall'**
  String get editItemDetailsFall;

  /// No description provided for @editItemDetailsWinter.
  ///
  /// In en, this message translates to:
  /// **'Winter'**
  String get editItemDetailsWinter;

  /// No description provided for @editItemDetailsAllSeason.
  ///
  /// In en, this message translates to:
  /// **'All Season'**
  String get editItemDetailsAllSeason;

  /// No description provided for @editItemDetailsSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get editItemDetailsSaveChanges;

  /// No description provided for @editItemDetailsDeleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get editItemDetailsDeleteItem;

  /// No description provided for @editItemDetailsDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get editItemDetailsDeleteConfirmTitle;

  /// No description provided for @editItemDetailsDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get editItemDetailsDeleteConfirmMessage;

  /// No description provided for @editItemDetailsDeleteConfirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get editItemDetailsDeleteConfirmCancel;

  /// No description provided for @editItemDetailsDeleteConfirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get editItemDetailsDeleteConfirmDelete;

  /// No description provided for @editItemDetailsSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Item updated successfully!'**
  String get editItemDetailsSuccessMessage;

  /// No description provided for @editItemDetailsDeleteSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Item deleted successfully!'**
  String get editItemDetailsDeleteSuccessMessage;

  /// No description provided for @editItemDetailsValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please enter item name and select at least one category'**
  String get editItemDetailsValidationError;

  /// No description provided for @editItemDetailsBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Cannot Delete Item'**
  String get editItemDetailsBlockedTitle;

  /// No description provided for @editItemDetailsBlockedMessage.
  ///
  /// In en, this message translates to:
  /// **'This item is used in the following outfits:'**
  String get editItemDetailsBlockedMessage;

  /// No description provided for @editItemDetailsBlockedOK.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get editItemDetailsBlockedOK;

  /// No description provided for @editItemDetailsItemNotFound.
  ///
  /// In en, this message translates to:
  /// **'Item not found'**
  String get editItemDetailsItemNotFound;

  /// No description provided for @itemDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Item Details'**
  String get itemDetailsTitle;

  /// No description provided for @itemDetailsItemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemDetailsItemName;

  /// No description provided for @itemDetailsItemNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Blue Denim Jacket'**
  String get itemDetailsItemNameHint;

  /// No description provided for @itemDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get itemDetailsDescription;

  /// No description provided for @itemDetailsDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Add notes about this item...'**
  String get itemDetailsDescriptionHint;

  /// No description provided for @itemDetailsSeason.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get itemDetailsSeason;

  /// No description provided for @itemDetailsSeasonHint.
  ///
  /// In en, this message translates to:
  /// **'Select season'**
  String get itemDetailsSeasonHint;

  /// No description provided for @itemDetailsSeasonSpring.
  ///
  /// In en, this message translates to:
  /// **'Spring'**
  String get itemDetailsSeasonSpring;

  /// No description provided for @itemDetailsSeasonSummer.
  ///
  /// In en, this message translates to:
  /// **'Summer'**
  String get itemDetailsSeasonSummer;

  /// No description provided for @itemDetailsSeasonFall.
  ///
  /// In en, this message translates to:
  /// **'Fall'**
  String get itemDetailsSeasonFall;

  /// No description provided for @itemDetailsSeasonWinter.
  ///
  /// In en, this message translates to:
  /// **'Winter'**
  String get itemDetailsSeasonWinter;

  /// No description provided for @itemDetailsSeasonAllSeason.
  ///
  /// In en, this message translates to:
  /// **'All Season'**
  String get itemDetailsSeasonAllSeason;

  /// No description provided for @itemDetailsCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get itemDetailsCategories;

  /// No description provided for @itemDetailsCategoriesLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading categories...'**
  String get itemDetailsCategoriesLoading;

  /// No description provided for @itemDetailsCategoriesError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load categories'**
  String get itemDetailsCategoriesError;

  /// No description provided for @itemDetailsCategoriesRetry.
  ///
  /// In en, this message translates to:
  /// **'Tap to retry'**
  String get itemDetailsCategoriesRetry;

  /// No description provided for @itemDetailsCategoriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get itemDetailsCategoriesEmpty;

  /// No description provided for @itemDetailsAddToWardrobe.
  ///
  /// In en, this message translates to:
  /// **'Add to Wardrobe'**
  String get itemDetailsAddToWardrobe;

  /// No description provided for @itemDetailsAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Item added to wardrobe!'**
  String get itemDetailsAddedSuccess;

  /// No description provided for @itemDetailsNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter an item name'**
  String get itemDetailsNameRequired;

  /// No description provided for @itemDetailsCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one category'**
  String get itemDetailsCategoryRequired;

  /// No description provided for @takePicTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get takePicTitle;

  /// No description provided for @takePicPosition.
  ///
  /// In en, this message translates to:
  /// **'Position your clothing item'**
  String get takePicPosition;

  /// No description provided for @takePicTapToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap here to start taking picture'**
  String get takePicTapToStart;

  /// No description provided for @myProfilePosts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get myProfilePosts;

  /// No description provided for @myProfileOutfits.
  ///
  /// In en, this message translates to:
  /// **'Outfits'**
  String get myProfileOutfits;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get settingsProfileUpdated;

  /// No description provided for @settingsAccountSection.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get settingsAccountSection;

  /// No description provided for @settingsAccountManagement.
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get settingsAccountManagement;

  /// No description provided for @settingsCategoriesSection.
  ///
  /// In en, this message translates to:
  /// **'CATEGORIES'**
  String get settingsCategoriesSection;

  /// No description provided for @settingsManageCategoriesItems.
  ///
  /// In en, this message translates to:
  /// **'Manage Categories For Items'**
  String get settingsManageCategoriesItems;

  /// No description provided for @settingsManageCategoriesOutfits.
  ///
  /// In en, this message translates to:
  /// **'Manage Categories For Outfits'**
  String get settingsManageCategoriesOutfits;

  /// No description provided for @settingsNotificationsSection.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS'**
  String get settingsNotificationsSection;

  /// No description provided for @settingsPushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get settingsPushNotifications;

  /// No description provided for @settingsEmailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get settingsEmailNotifications;

  /// No description provided for @settingsSupportSection.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT'**
  String get settingsSupportSection;

  /// No description provided for @settingsHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get settingsHelpCenter;

  /// No description provided for @settingsLogoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get settingsLogoutDialogTitle;

  /// No description provided for @settingsLogoutDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get settingsLogoutDialogMessage;

  /// No description provided for @settingsLogoutCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsLogoutCancel;

  /// No description provided for @settingsLogoutButton.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get settingsLogoutButton;

  /// No description provided for @settingsEditName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get settingsEditName;

  /// No description provided for @settingsEditNameHint.
  ///
  /// In en, this message translates to:
  /// **'My Name'**
  String get settingsEditNameHint;

  /// No description provided for @settingsEditUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get settingsEditUsername;

  /// No description provided for @settingsEditUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'my_username'**
  String get settingsEditUsernameHint;

  /// No description provided for @settingsEditBio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get settingsEditBio;

  /// No description provided for @settingsEditBioHint.
  ///
  /// In en, this message translates to:
  /// **'Fashion enthusiast ✨ | Style inspiration'**
  String get settingsEditBioHint;

  /// No description provided for @settingsEditCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsEditCancel;

  /// No description provided for @settingsEditSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get settingsEditSave;

  /// No description provided for @settingsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get settingsEdit;

  /// No description provided for @photoPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get photoPreviewTitle;

  /// No description provided for @photoPreviewRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get photoPreviewRetake;

  /// No description provided for @photoPreviewUsePhoto.
  ///
  /// In en, this message translates to:
  /// **'Use Photo'**
  String get photoPreviewUsePhoto;

  /// No description provided for @photoPreviewLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load image'**
  String get photoPreviewLoadError;

  /// No description provided for @myPostsTitle.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get myPostsTitle;

  /// No description provided for @myPostsAllDeleted.
  ///
  /// In en, this message translates to:
  /// **'All posts have been deleted'**
  String get myPostsAllDeleted;

  /// No description provided for @myPostsDefaultUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get myPostsDefaultUser;

  /// No description provided for @myPostsLikesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} likes'**
  String myPostsLikesCount(Object count);

  /// No description provided for @myPostsViewComments.
  ///
  /// In en, this message translates to:
  /// **'View all {count} comments'**
  String myPostsViewComments(Object count);

  /// No description provided for @myPostsDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Post?'**
  String get myPostsDeleteDialogTitle;

  /// No description provided for @myPostsDeleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this post?\nThis action cannot be undone and the post\nwill be removed from your profile.'**
  String get myPostsDeleteDialogMessage;

  /// No description provided for @myPostsDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get myPostsDeleteButton;

  /// No description provided for @myPostsDeleteCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get myPostsDeleteCancel;

  /// No description provided for @commentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsTitle;

  /// No description provided for @commentsNoComments.
  ///
  /// In en, this message translates to:
  /// **'No comments'**
  String get commentsNoComments;

  /// No description provided for @commentsLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to comment'**
  String get commentsLoginRequired;

  /// No description provided for @commentsAddComment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get commentsAddComment;

  /// No description provided for @commentsDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String commentsDaysAgo(Object count);

  /// No description provided for @commentsHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String commentsHoursAgo(Object count);

  /// No description provided for @commentsMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String commentsMinutesAgo(Object count);

  /// No description provided for @commentsJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get commentsJustNow;

  /// No description provided for @commentsRecently.
  ///
  /// In en, this message translates to:
  /// **'Recently'**
  String get commentsRecently;

  /// No description provided for @commentsUnknownUser.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get commentsUnknownUser;

  /// No description provided for @accountManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Manager'**
  String get accountManagerTitle;

  /// No description provided for @accountManagerChangeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get accountManagerChangeEmail;

  /// No description provided for @accountManagerChangeEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your email address'**
  String get accountManagerChangeEmailSubtitle;

  /// No description provided for @accountManagerChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get accountManagerChangePassword;

  /// No description provided for @accountManagerChangePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your password'**
  String get accountManagerChangePasswordSubtitle;

  /// No description provided for @accountManagerChangeFullName.
  ///
  /// In en, this message translates to:
  /// **'Change Full Name'**
  String get accountManagerChangeFullName;

  /// No description provided for @accountManagerChangeFullNameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your display name'**
  String get accountManagerChangeFullNameSubtitle;

  /// No description provided for @accountManagerDangerZone.
  ///
  /// In en, this message translates to:
  /// **'DANGER ZONE'**
  String get accountManagerDangerZone;

  /// No description provided for @accountManagerDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get accountManagerDeleteAccount;

  /// No description provided for @accountManagerDeleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account'**
  String get accountManagerDeleteAccountSubtitle;

  /// No description provided for @accountManagerChangeEmailDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get accountManagerChangeEmailDialogTitle;

  /// No description provided for @accountManagerChangeEmailDialogDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your new email and confirm with your password'**
  String get accountManagerChangeEmailDialogDescription;

  /// No description provided for @accountManagerNewEmail.
  ///
  /// In en, this message translates to:
  /// **'New Email'**
  String get accountManagerNewEmail;

  /// No description provided for @accountManagerNewEmailHint.
  ///
  /// In en, this message translates to:
  /// **'newemail@example.com'**
  String get accountManagerNewEmailHint;

  /// No description provided for @accountManagerCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get accountManagerCurrentPassword;

  /// No description provided for @accountManagerChangeEmailButton.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get accountManagerChangeEmailButton;

  /// No description provided for @accountManagerCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get accountManagerCancel;

  /// No description provided for @accountManagerChangeFullNameDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Full Name'**
  String get accountManagerChangeFullNameDialogTitle;

  /// No description provided for @accountManagerChangeFullNameDialogDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your new display name'**
  String get accountManagerChangeFullNameDialogDescription;

  /// No description provided for @accountManagerFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get accountManagerFullName;

  /// No description provided for @accountManagerFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get accountManagerFullNameHint;

  /// No description provided for @accountManagerSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get accountManagerSave;

  /// No description provided for @accountManagerChangePasswordDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get accountManagerChangePasswordDialogTitle;

  /// No description provided for @accountManagerChangePasswordDialogDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password and new password'**
  String get accountManagerChangePasswordDialogDescription;

  /// No description provided for @accountManagerNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get accountManagerNewPassword;

  /// No description provided for @accountManagerConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get accountManagerConfirmPassword;

  /// No description provided for @accountManagerChangePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get accountManagerChangePasswordButton;

  /// No description provided for @accountManagerDeleteAccountDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get accountManagerDeleteAccountDialogTitle;

  /// No description provided for @accountManagerDeleteAccountDialogDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete your account? This action cannot be undone.'**
  String get accountManagerDeleteAccountDialogDescription;

  /// No description provided for @accountManagerDeleteAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get accountManagerDeleteAccountButton;

  /// No description provided for @accountManagerFinalConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Final Confirmation'**
  String get accountManagerFinalConfirmation;

  /// No description provided for @accountManagerFinalConfirmationDescription.
  ///
  /// In en, this message translates to:
  /// **'Type DELETE and enter your password to confirm account deletion'**
  String get accountManagerFinalConfirmationDescription;

  /// No description provided for @accountManagerTypeDelete.
  ///
  /// In en, this message translates to:
  /// **'Type DELETE to confirm'**
  String get accountManagerTypeDelete;

  /// No description provided for @accountManagerTypeDeleteHint.
  ///
  /// In en, this message translates to:
  /// **'Type DELETE'**
  String get accountManagerTypeDeleteHint;

  /// No description provided for @accountManagerPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get accountManagerPassword;

  /// No description provided for @followersTitle.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followersTitle;

  /// No description provided for @followersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search followers...'**
  String get followersSearchHint;

  /// No description provided for @followersNotFound.
  ///
  /// In en, this message translates to:
  /// **'No followers found'**
  String get followersNotFound;

  /// No description provided for @followersFollow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get followersFollow;

  /// No description provided for @followersFollowing.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get followersFollowing;

  /// No description provided for @followingTitle.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get followingTitle;

  /// No description provided for @followingSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search following...'**
  String get followingSearchHint;

  /// No description provided for @followingNotFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get followingNotFound;

  /// No description provided for @manageCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Categories For Items'**
  String get manageCategoriesTitle;

  /// No description provided for @manageCategoriesNewHint.
  ///
  /// In en, this message translates to:
  /// **'New category name...'**
  String get manageCategoriesNewHint;

  /// No description provided for @manageCategoriesItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String manageCategoriesItemCount(Object count);

  /// No description provided for @manageCategoriesEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get manageCategoriesEditTitle;

  /// No description provided for @manageCategoriesEditHint.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get manageCategoriesEditHint;

  /// No description provided for @manageCategoriesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get manageCategoriesDeleteTitle;

  /// No description provided for @manageCategoriesDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String manageCategoriesDeleteMessage(Object name);

  /// No description provided for @manageCategoriesCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get manageCategoriesCancel;

  /// No description provided for @manageCategoriesSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get manageCategoriesSave;

  /// No description provided for @manageCategoriesDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get manageCategoriesDelete;

  /// No description provided for @manageCategoriesInfo.
  ///
  /// In en, this message translates to:
  /// **'Categories help you organize your wardrobe items. Items can belong to multiple categories.'**
  String get manageCategoriesInfo;

  /// No description provided for @manageOutfitCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Categories For Outfits'**
  String get manageOutfitCategoriesTitle;

  /// No description provided for @helpCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenterTitle;

  /// No description provided for @helpCenterEmailUs.
  ///
  /// In en, this message translates to:
  /// **'Email Us'**
  String get helpCenterEmailUs;

  /// No description provided for @helpCenterFAQTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get helpCenterFAQTitle;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get notificationsRetry;

  /// No description provided for @notificationsLiked.
  ///
  /// In en, this message translates to:
  /// **' liked your outfit'**
  String get notificationsLiked;

  /// No description provided for @notificationsCommented.
  ///
  /// In en, this message translates to:
  /// **' commented: \"{comment}\"'**
  String notificationsCommented(String comment);

  /// No description provided for @notificationsFollowed.
  ///
  /// In en, this message translates to:
  /// **' started following you'**
  String get notificationsFollowed;

  /// No description provided for @notificationsInteracted.
  ///
  /// In en, this message translates to:
  /// **' interacted with your content'**
  String get notificationsInteracted;

  /// No description provided for @notificationsDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String notificationsDaysAgo(int count);

  /// No description provided for @notificationsHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String notificationsHoursAgo(int count);

  /// No description provided for @notificationsMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String notificationsMinutesAgo(int count);

  /// No description provided for @notificationsJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get notificationsJustNow;

  /// No description provided for @notificationsRecently.
  ///
  /// In en, this message translates to:
  /// **'Recently'**
  String get notificationsRecently;

  /// No description provided for @notificationsErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications'**
  String get notificationsErrorMessage;

  /// No description provided for @saveOutfitTitle.
  ///
  /// In en, this message translates to:
  /// **'Save Outfit'**
  String get saveOutfitTitle;

  /// No description provided for @saveOutfitNoDataError.
  ///
  /// In en, this message translates to:
  /// **'No outfit data found. Please create an outfit first.'**
  String get saveOutfitNoDataError;

  /// No description provided for @saveOutfitNoDataFound.
  ///
  /// In en, this message translates to:
  /// **'No outfit data found'**
  String get saveOutfitNoDataFound;

  /// No description provided for @saveOutfitName.
  ///
  /// In en, this message translates to:
  /// **'Outfit Name'**
  String get saveOutfitName;

  /// No description provided for @saveOutfitNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Casual Friday Look'**
  String get saveOutfitNameHint;

  /// No description provided for @saveOutfitDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get saveOutfitDescription;

  /// No description provided for @saveOutfitDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Add notes about this outfit...'**
  String get saveOutfitDescriptionHint;

  /// No description provided for @saveOutfitSeason.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get saveOutfitSeason;

  /// No description provided for @saveOutfitSeasonHint.
  ///
  /// In en, this message translates to:
  /// **'Select season'**
  String get saveOutfitSeasonHint;

  /// No description provided for @saveOutfitCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get saveOutfitCategories;

  /// No description provided for @saveOutfitItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} item in outfit'**
  String saveOutfitItemsCount(int count);

  /// No description provided for @saveOutfitItemsCountPlural.
  ///
  /// In en, this message translates to:
  /// **'{count} items in outfit'**
  String saveOutfitItemsCountPlural(int count);

  /// No description provided for @saveOutfitSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save to Wardrobe'**
  String get saveOutfitSaveButton;

  /// No description provided for @editOutfitTitle.
  ///
  /// In en, this message translates to:
  /// **'Outfit Details'**
  String get editOutfitTitle;

  /// No description provided for @editOutfitLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading outfit...'**
  String get editOutfitLoading;

  /// No description provided for @editOutfitError.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong'**
  String get editOutfitError;

  /// No description provided for @editOutfitTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get editOutfitTryAgain;

  /// No description provided for @editOutfitGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get editOutfitGoBack;

  /// No description provided for @editOutfitNotFound.
  ///
  /// In en, this message translates to:
  /// **'Outfit not found'**
  String get editOutfitNotFound;

  /// No description provided for @editOutfitNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'The outfit may have been deleted or doesn\'t exist'**
  String get editOutfitNotFoundMessage;

  /// No description provided for @editOutfitNoImage.
  ///
  /// In en, this message translates to:
  /// **'No outfit image'**
  String get editOutfitNoImage;

  /// No description provided for @editOutfitItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Items in this outfit'**
  String get editOutfitItemsTitle;

  /// No description provided for @editOutfitDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Outfit Details'**
  String get editOutfitDetailsTitle;

  /// No description provided for @editOutfitDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your outfit information'**
  String get editOutfitDetailsSubtitle;

  /// No description provided for @editOutfitNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Outfit Name'**
  String get editOutfitNameLabel;

  /// No description provided for @editOutfitNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Summer Casual'**
  String get editOutfitNameHint;

  /// No description provided for @editOutfitDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get editOutfitDescriptionLabel;

  /// No description provided for @editOutfitDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Perfect outfit for a casual summer day'**
  String get editOutfitDescriptionHint;

  /// No description provided for @editOutfitSeasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get editOutfitSeasonLabel;

  /// No description provided for @editOutfitSeasonHint.
  ///
  /// In en, this message translates to:
  /// **'Select season'**
  String get editOutfitSeasonHint;

  /// No description provided for @editOutfitErrorName.
  ///
  /// In en, this message translates to:
  /// **'Please enter an outfit name'**
  String get editOutfitErrorName;

  /// No description provided for @editOutfitErrorCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one category'**
  String get editOutfitErrorCategory;

  /// No description provided for @editOutfitSuccessSave.
  ///
  /// In en, this message translates to:
  /// **'Outfit updated successfully!'**
  String get editOutfitSuccessSave;

  /// No description provided for @editOutfitErrorSave.
  ///
  /// In en, this message translates to:
  /// **'Error saving outfit: {error}'**
  String editOutfitErrorSave(String error);

  /// No description provided for @editOutfitDeleteDialog.
  ///
  /// In en, this message translates to:
  /// **'Delete Outfit'**
  String get editOutfitDeleteDialog;

  /// No description provided for @editOutfitDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String editOutfitDeleteMessage(String name);

  /// No description provided for @editOutfitDeleteWarning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get editOutfitDeleteWarning;

  /// No description provided for @editOutfitDeleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting outfit...'**
  String get editOutfitDeleting;

  /// No description provided for @editOutfitDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Outfit deleted successfully!'**
  String get editOutfitDeleteSuccess;

  /// No description provided for @editOutfitDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Error deleting outfit: {error}'**
  String editOutfitDeleteError(String error);

  /// No description provided for @editOutfitCannotDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Cannot Delete Outfit'**
  String get editOutfitCannotDeleteTitle;

  /// No description provided for @editOutfitCannotDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This outfit is used in {count} {posts}.'**
  String editOutfitCannotDeleteMessage(int count, String posts);

  /// No description provided for @editOutfitCannotDeleteInstruction.
  ///
  /// In en, this message translates to:
  /// **'To delete this outfit, you must first delete the {posts} that use it.'**
  String editOutfitCannotDeleteInstruction(String posts);

  /// No description provided for @editOutfitCannotDeleteInfo.
  ///
  /// In en, this message translates to:
  /// **'Go to your posts and delete the {ones} using this outfit first.'**
  String editOutfitCannotDeleteInfo(String ones);

  /// No description provided for @editOutfitPost.
  ///
  /// In en, this message translates to:
  /// **'post'**
  String get editOutfitPost;

  /// No description provided for @editOutfitPosts.
  ///
  /// In en, this message translates to:
  /// **'posts'**
  String get editOutfitPosts;

  /// No description provided for @editOutfitOne.
  ///
  /// In en, this message translates to:
  /// **'one'**
  String get editOutfitOne;

  /// No description provided for @editOutfitOnes.
  ///
  /// In en, this message translates to:
  /// **'ones'**
  String get editOutfitOnes;

  /// No description provided for @editOutfitWarningUsed.
  ///
  /// In en, this message translates to:
  /// **'This outfit is used in {count} {posts}'**
  String editOutfitWarningUsed(int count, String posts);

  /// No description provided for @editOutfitWarningDeleteFirst.
  ///
  /// In en, this message translates to:
  /// **'Delete the {posts} first to delete this outfit'**
  String editOutfitWarningDeleteFirst(String posts);

  /// No description provided for @editOutfitDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete Outfit'**
  String get editOutfitDeleteButton;

  /// No description provided for @editOutfitCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get editOutfitCancelButton;

  /// No description provided for @editOutfitSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get editOutfitSaveButton;

  /// No description provided for @editOutfitGoToPostsButton.
  ///
  /// In en, this message translates to:
  /// **'Go to Posts'**
  String get editOutfitGoToPostsButton;

  /// No description provided for @editOutfitLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view your profile'**
  String get editOutfitLoginRequired;

  /// No description provided for @editOutfitImageLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading image...'**
  String get editOutfitImageLoading;

  /// No description provided for @editOutfitImageNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Image not available'**
  String get editOutfitImageNotAvailable;

  /// No description provided for @seasonSpring.
  ///
  /// In en, this message translates to:
  /// **'Spring'**
  String get seasonSpring;

  /// No description provided for @seasonSummer.
  ///
  /// In en, this message translates to:
  /// **'Summer'**
  String get seasonSummer;

  /// No description provided for @seasonFall.
  ///
  /// In en, this message translates to:
  /// **'Fall'**
  String get seasonFall;

  /// No description provided for @seasonWinter.
  ///
  /// In en, this message translates to:
  /// **'Winter'**
  String get seasonWinter;

  /// No description provided for @seasonAllSeason.
  ///
  /// In en, this message translates to:
  /// **'All Season'**
  String get seasonAllSeason;

  /// No description provided for @outfitDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Outfit Details'**
  String get outfitDetailsTitle;

  /// No description provided for @outfitDetailsError.
  ///
  /// In en, this message translates to:
  /// **'Error loading outfit details'**
  String get outfitDetailsError;

  /// No description provided for @outfitDetailsDeleteDialog.
  ///
  /// In en, this message translates to:
  /// **'Delete Outfit?'**
  String get outfitDetailsDeleteDialog;

  /// No description provided for @outfitDetailsDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this outfit?\nThis action cannot be undone.'**
  String get outfitDetailsDeleteMessage;

  /// No description provided for @outfitDetailsDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get outfitDetailsDeleteButton;

  /// No description provided for @outfitDetailsCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get outfitDetailsCancelButton;

  /// No description provided for @outfitDetailsShareComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Share functionality - Coming soon'**
  String get outfitDetailsShareComingSoon;

  /// No description provided for @outfitDetailsOutfitDeleted.
  ///
  /// In en, this message translates to:
  /// **'Outfit deleted'**
  String get outfitDetailsOutfitDeleted;

  /// No description provided for @outfitDetailsShareButton.
  ///
  /// In en, this message translates to:
  /// **'Share Outfit'**
  String get outfitDetailsShareButton;

  /// No description provided for @outfitDetailsDeleteButtonAction.
  ///
  /// In en, this message translates to:
  /// **'Delete Outfit'**
  String get outfitDetailsDeleteButtonAction;

  /// No description provided for @outfitDetailsUnnamedOutfit.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Outfit'**
  String get outfitDetailsUnnamedOutfit;

  /// No description provided for @outfitDetailsCreatedDefault.
  ///
  /// In en, this message translates to:
  /// **'Created on October 20, 2025'**
  String get outfitDetailsCreatedDefault;

  /// No description provided for @outfitDetailsItemsCount.
  ///
  /// In en, this message translates to:
  /// **'Items ({count})'**
  String outfitDetailsItemsCount(int count);

  /// No description provided for @outfitDetailsNoItems.
  ///
  /// In en, this message translates to:
  /// **'No items in this outfit'**
  String get outfitDetailsNoItems;

  /// No description provided for @outfitDetailsUnnamedItem.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Item'**
  String get outfitDetailsUnnamedItem;

  /// No description provided for @outfitDetailsUncategorized.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized'**
  String get outfitDetailsUncategorized;

  /// No description provided for @createOutfitCapturing.
  ///
  /// In en, this message translates to:
  /// **'Capturing outfit...'**
  String get createOutfitCapturing;

  /// No description provided for @createOutfitAddAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one item to the outfit'**
  String get createOutfitAddAtLeastOne;

  /// No description provided for @createOutfitSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Outfit saved successfully!'**
  String get createOutfitSaveSuccess;

  /// No description provided for @createOutfitErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading items'**
  String get createOutfitErrorLoading;

  /// No description provided for @createOutfitTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get createOutfitTryAgain;

  /// No description provided for @createOutfitZoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom In'**
  String get createOutfitZoomIn;

  /// No description provided for @createOutfitZoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom Out'**
  String get createOutfitZoomOut;

  /// No description provided for @createOutfitResetSize.
  ///
  /// In en, this message translates to:
  /// **'Reset Size'**
  String get createOutfitResetSize;

  /// No description provided for @createOutfitBringToFront.
  ///
  /// In en, this message translates to:
  /// **'Bring to Front'**
  String get createOutfitBringToFront;

  /// No description provided for @createOutfitSendToBack.
  ///
  /// In en, this message translates to:
  /// **'Send to Back'**
  String get createOutfitSendToBack;

  /// No description provided for @createOutfitRemoveFromOutfit.
  ///
  /// In en, this message translates to:
  /// **'Remove from Outfit'**
  String get createOutfitRemoveFromOutfit;

  /// No description provided for @createOutfitAddItems.
  ///
  /// In en, this message translates to:
  /// **'Add Items'**
  String get createOutfitAddItems;

  /// No description provided for @createOutfitItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String createOutfitItemsCount(int count);

  /// No description provided for @createOutfitAddedToOutfit.
  ///
  /// In en, this message translates to:
  /// **'Added {itemName} to outfit'**
  String createOutfitAddedToOutfit(String itemName);

  /// No description provided for @createOutfitRemoveItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Item'**
  String get createOutfitRemoveItemTitle;

  /// No description provided for @createOutfitRemoveItemMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove this item from the outfit?'**
  String get createOutfitRemoveItemMessage;

  /// No description provided for @createOutfitCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get createOutfitCancel;

  /// No description provided for @createOutfitRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get createOutfitRemove;

  /// No description provided for @createOutfitYourItems.
  ///
  /// In en, this message translates to:
  /// **'Your Items'**
  String get createOutfitYourItems;

  /// No description provided for @createOutfitTotalCount.
  ///
  /// In en, this message translates to:
  /// **'{count} total'**
  String createOutfitTotalCount(int count);

  /// No description provided for @createOutfitNoItems.
  ///
  /// In en, this message translates to:
  /// **'No items in your wardrobe'**
  String get createOutfitNoItems;

  /// No description provided for @postsDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get postsDetailsTitle;

  /// No description provided for @postsDetailsMustLoginToLike.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to like posts!'**
  String get postsDetailsMustLoginToLike;

  /// No description provided for @postsDetailsLikesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} likes'**
  String postsDetailsLikesCount(int count);

  /// No description provided for @postsDetailsViewAllComments.
  ///
  /// In en, this message translates to:
  /// **'View all {count} comments'**
  String postsDetailsViewAllComments(int count);

  /// No description provided for @postsDetailsImageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Image not found'**
  String get postsDetailsImageNotFound;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
    case 'it': return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
