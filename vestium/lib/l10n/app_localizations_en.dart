// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vestium';

  @override
  String get splashSubtitle => 'Your personal virtual wardrobe.';

  @override
  String get splashDescription => 'Organize your style, create outfits, and\nshare your fashion journey.';

  @override
  String get splashCheckingAuth => 'Checking authentication...';

  @override
  String get splashSignUp => 'Sign Up';

  @override
  String get splashContinueAsGuest => 'Continue as Guest';

  @override
  String get splashAlreadyHaveAccount => 'Already have an account?';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginSubtitle => 'Log in to continue your style journey';

  @override
  String get loginEmailRequired => 'Please enter your email';

  @override
  String get loginEmailInvalid => 'Please enter a valid email';

  @override
  String get loginPasswordRequired => 'Please enter your password';

  @override
  String get loginForgotPassword => 'Forgot Password?';

  @override
  String get loginButton => 'Sign In';

  @override
  String get loginNoAccount => 'Don\'t have an account? ';

  @override
  String get loginCreateAccount => 'Create Account';

  @override
  String loginWelcomeBackUser(Object userName) {
    return 'Welcome back, $userName!';
  }

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'you@example.com';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => '••••••••';

  @override
  String get signupTitle => 'Create Account';

  @override
  String get signupSubtitle => 'Join Vestium and start your style journey';

  @override
  String get signupFullNameRequired => 'Please enter your full name';

  @override
  String get signupFullNameTooShort => 'Name must be at least 2 characters';

  @override
  String get signupEmailRequired => 'Please enter your email';

  @override
  String get signupEmailInvalid => 'Please enter a valid email';

  @override
  String get signupPasswordRequired => 'Please enter a password';

  @override
  String get signupPasswordTooShort => 'Password must be at least 6 characters';

  @override
  String get signupButton => 'Create Account';

  @override
  String get signupHaveAccount => 'Already have an account? ';

  @override
  String get signupSignIn => 'Sign In';

  @override
  String signupWelcomeUser(Object userName) {
    return 'Welcome $userName!';
  }

  @override
  String get fieldEmailLabel => 'Email';

  @override
  String get fieldEmailHint => 'you@example.com';

  @override
  String get fieldFullNameLabel => 'Full Name';

  @override
  String get fieldFullNameHint => 'Your name';

  @override
  String get fieldPasswordLabel => 'Password';

  @override
  String get fieldPasswordHint => '••••••••';

  @override
  String get homeAppTitle => 'Vestium';

  @override
  String homeRefreshFailed(Object error) {
    return 'Refresh failed: $error';
  }

  @override
  String get homeLikeRequiresLogin => 'You must be logged in to like posts!';

  @override
  String homeLikesCount(Object count) {
    return '$count likes';
  }

  @override
  String homeViewAllComments(Object count) {
    return 'View all $count comments';
  }

  @override
  String get homeReachedEndOfFeed => 'You\'ve reached the end of your feed';

  @override
  String get homeRetryButton => 'Retry';

  @override
  String get homeNoPostsYet => 'No posts yet. Follow some users to see their posts!';

  @override
  String get homeFindUsersButton => 'Find Users';

  @override
  String get homeSearchTabHint => 'Go to the search tab to find users to follow!';

  @override
  String get homeNewPosts => 'New posts';

  @override
  String get searchRecentHeader => 'Recent';

  @override
  String get searchDeleteAll => 'Delete all';

  @override
  String get searchDiscoverTitle => 'Discover';

  @override
  String get searchPlaceholder => 'Search users, outfits, tags...';

  @override
  String get searchFollowing => 'Following';

  @override
  String get searchFollow => 'Follow';

  @override
  String get searchNoResults => 'No results found';

  @override
  String get searchTrySomethingElse => 'Try searching for something else';

  @override
  String get newPostTitle => 'New Post';

  @override
  String get newPostButton => 'Post';

  @override
  String get captionPlaceholder => 'Write a caption for your outfit...';

  @override
  String get outfitPickerEmpty => 'Choose an Outfit';

  @override
  String get publicPostLabel => 'Public Post';

  @override
  String get publicPostDescription => 'Your post will be visible to all Vestium users';

  @override
  String get selectOutfitTitle => 'Select Outfit';

  @override
  String get selectOutfitContinue => 'Continue';

  @override
  String get selectOutfitSavedOutfits => 'Saved Outfits';

  @override
  String get selectOutfitGallery => 'Gallery';

  @override
  String get selectOutfitNoOutfits => 'No outfits yet';

  @override
  String get selectOutfitCreateFirst => 'Create your first outfit to see it here.';

  @override
  String get galleryEmptyMessage => 'Gallery will appear here once access is managed.';

  @override
  String get wardrobeMyWardrobe => 'My Wardrobe';

  @override
  String get wardrobeAll => 'All';

  @override
  String get wardrobeEmptyFull => 'Your wardrobe is empty';

  @override
  String wardrobeEmptyCategory(Object category) {
    return 'No items in \"$category\" category';
  }

  @override
  String get wardrobeAddItem => 'Tap the + button to add your first item';

  @override
  String get wardrobeErrorRetry => 'Retry';

  @override
  String get wardrobeNoCategory => 'No category';

  @override
  String get wardrobeUnnamedItem => 'Unnamed Item';

  @override
  String get userProfileDefaultUser => 'User';

  @override
  String get userProfileRetry => 'Retry';

  @override
  String get userProfileFollowing => 'Following';

  @override
  String get userProfileFollow => 'Follow';

  @override
  String get userProfilePostsLabel => 'Posts';

  @override
  String get userProfileFollowersLabel => 'Followers';

  @override
  String get userProfileFollowingLabel => 'Following';

  @override
  String get userProfileNoPostsYet => 'No posts yet';

  @override
  String get myProfileUnknownUser => 'Unknown User';

  @override
  String get myProfileNoBio => 'No bio';

  @override
  String get myProfilePostsLabel => 'Posts';

  @override
  String get myProfileOutfitsLabel => 'Outfits';

  @override
  String get myProfileFollowersLabel => 'Followers';

  @override
  String get myProfileFollowingLabel => 'Following';

  @override
  String get myProfileNoPostsYet => 'No posts yet';

  @override
  String get myProfileNoOutfitsYet => 'No outfits yet';

  @override
  String get myProfileEditProfile => 'Edit Profile';

  @override
  String get myProfileSettingsButton => 'Settings';

  @override
  String get galleryAccessTitle => 'Gallery Access';

  @override
  String get galleryAccessDescription => 'Vestium needs access to your gallery to pick pictures of your clothing items and add them to your virtual wardrobe.';

  @override
  String get galleryAccessAllowButton => 'Allow Gallery Access';

  @override
  String get galleryAccessMaybeLater => 'Maybe Later';

  @override
  String get galleryAccessPrivacyTitle => 'Your pictures are private';

  @override
  String get galleryAccessPrivacyDescription => 'We only use your camera to capture clothing items. Your photos stay on your device.';

  @override
  String get galleryAccessPermissionRequired => 'Permission Required';

  @override
  String get galleryAccessPermissionDenied => 'Gallery access has been permanently denied. Please enable it in app settings.';

  @override
  String get galleryAccessCancel => 'Cancel';

  @override
  String get galleryAccessSettings => 'Settings';

  @override
  String get cameraAccessTitle => 'Camera Access';

  @override
  String get cameraAccessDescription => 'Vestium needs access to your camera to capture photos of your clothing items and add them to your virtual wardrobe.';

  @override
  String get cameraAccessAllowButton => 'Allow Camera Access';

  @override
  String get cameraAccessMaybeLater => 'Maybe Later';

  @override
  String get cameraAccessPrivacyTitle => 'Your photos are private';

  @override
  String get cameraAccessPrivacyDescription => 'We only use your camera to capture clothing items. Your photos stay on your device.';

  @override
  String get selectItemTitle => 'Select Item';

  @override
  String get selectItemContinueButton => 'Continue';

  @override
  String get selectItemEmptyTitle => 'No Photos Yet';

  @override
  String get selectItemEmptyDescription => 'Visit your gallery or take a photo to get started.';

  @override
  String get editItemTitle => 'Edit Item';

  @override
  String get editItemCropTitle => 'Crop Image';

  @override
  String get editItemRemoveBgTitle => 'Remove Background';

  @override
  String get editItemDragText => 'Drag to adjust crop area';

  @override
  String get editItemResetButton => 'Reset';

  @override
  String get editItemDoneButton => 'Done';

  @override
  String get editItemCropButton => 'Crop';

  @override
  String get editItemRemoveBgButton => 'Remove BG';

  @override
  String get editItemInstructionText => 'Draw on the image to remove background';

  @override
  String get editItemEraserSizeLabel => 'Eraser Size';

  @override
  String get editItemSaveButtonLabel => 'Save';

  @override
  String editItemSaveErrorMessage(Object error) {
    return 'Failed to save edited image: $error';
  }

  @override
  String editItemCropSaveError(Object error) {
    return 'Error saving crop: $error';
  }

  @override
  String get editItemDetailsTitle => 'Edit Item';

  @override
  String get editItemDetailsItemName => 'Item Name';

  @override
  String get editItemDetailsItemNameHint => 'Enter item name';

  @override
  String get editItemDetailsDescription => 'Description (optional)';

  @override
  String get editItemDetailsDescriptionHint => 'Add description...';

  @override
  String get editItemDetailsCategories => 'Categories';

  @override
  String get editItemDetailsSeason => 'Season';

  @override
  String get editItemDetailsSeasonHint => 'Select season';

  @override
  String get editItemDetailsSpring => 'Spring';

  @override
  String get editItemDetailsSummer => 'Summer';

  @override
  String get editItemDetailsFall => 'Fall';

  @override
  String get editItemDetailsWinter => 'Winter';

  @override
  String get editItemDetailsAllSeason => 'All Season';

  @override
  String get editItemDetailsSaveChanges => 'Save Changes';

  @override
  String get editItemDetailsDeleteItem => 'Delete Item';

  @override
  String get editItemDetailsDeleteConfirmTitle => 'Delete Item';

  @override
  String get editItemDetailsDeleteConfirmMessage => 'Are you sure you want to delete this item?';

  @override
  String get editItemDetailsDeleteConfirmCancel => 'Cancel';

  @override
  String get editItemDetailsDeleteConfirmDelete => 'Delete';

  @override
  String get editItemDetailsSuccessMessage => 'Item updated successfully!';

  @override
  String get editItemDetailsDeleteSuccessMessage => 'Item deleted successfully!';

  @override
  String get editItemDetailsValidationError => 'Please enter item name and select at least one category';

  @override
  String get editItemDetailsBlockedTitle => 'Cannot Delete Item';

  @override
  String get editItemDetailsBlockedMessage => 'This item is used in the following outfits:';

  @override
  String get editItemDetailsBlockedOK => 'OK';

  @override
  String get editItemDetailsItemNotFound => 'Item not found';

  @override
  String get itemDetailsTitle => 'Item Details';

  @override
  String get itemDetailsItemName => 'Item Name';

  @override
  String get itemDetailsItemNameHint => 'e.g., Blue Denim Jacket';

  @override
  String get itemDetailsDescription => 'Description (optional)';

  @override
  String get itemDetailsDescriptionHint => 'Add notes about this item...';

  @override
  String get itemDetailsSeason => 'Season';

  @override
  String get itemDetailsSeasonHint => 'Select season';

  @override
  String get itemDetailsSeasonSpring => 'Spring';

  @override
  String get itemDetailsSeasonSummer => 'Summer';

  @override
  String get itemDetailsSeasonFall => 'Fall';

  @override
  String get itemDetailsSeasonWinter => 'Winter';

  @override
  String get itemDetailsSeasonAllSeason => 'All Season';

  @override
  String get itemDetailsCategories => 'Categories';

  @override
  String get itemDetailsCategoriesLoading => 'Loading categories...';

  @override
  String get itemDetailsCategoriesError => 'Failed to load categories';

  @override
  String get itemDetailsCategoriesRetry => 'Tap to retry';

  @override
  String get itemDetailsCategoriesEmpty => 'No categories available';

  @override
  String get itemDetailsAddToWardrobe => 'Add to Wardrobe';

  @override
  String get itemDetailsAddedSuccess => 'Item added to wardrobe!';

  @override
  String get itemDetailsNameRequired => 'Please enter an item name';

  @override
  String get itemDetailsCategoryRequired => 'Please select at least one category';

  @override
  String get takePicTitle => 'Add Item';

  @override
  String get takePicPosition => 'Position your clothing item';

  @override
  String get takePicTapToStart => 'Tap here to start taking picture';

  @override
  String get myProfilePosts => 'Posts';

  @override
  String get myProfileOutfits => 'Outfits';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsProfileUpdated => 'Profile updated';

  @override
  String get settingsAccountSection => 'ACCOUNT';

  @override
  String get settingsAccountManagement => 'Account Management';

  @override
  String get settingsCategoriesSection => 'CATEGORIES';

  @override
  String get settingsManageCategoriesItems => 'Manage Categories For Items';

  @override
  String get settingsManageCategoriesOutfits => 'Manage Categories For Outfits';

  @override
  String get settingsNotificationsSection => 'NOTIFICATIONS';

  @override
  String get settingsPushNotifications => 'Push Notifications';

  @override
  String get settingsEmailNotifications => 'Email Notifications';

  @override
  String get settingsSupportSection => 'SUPPORT';

  @override
  String get settingsHelpCenter => 'Help Center';

  @override
  String get settingsLogoutDialogTitle => 'Log out';

  @override
  String get settingsLogoutDialogMessage => 'Are you sure you want to log out?';

  @override
  String get settingsLogoutCancel => 'Cancel';

  @override
  String get settingsLogoutButton => 'Log Out';

  @override
  String get settingsEditName => 'Name';

  @override
  String get settingsEditNameHint => 'My Name';

  @override
  String get settingsEditUsername => 'Username';

  @override
  String get settingsEditUsernameHint => 'my_username';

  @override
  String get settingsEditBio => 'Bio';

  @override
  String get settingsEditBioHint => 'Fashion enthusiast ✨ | Style inspiration';

  @override
  String get settingsEditCancel => 'Cancel';

  @override
  String get settingsEditSave => 'Save';

  @override
  String get settingsEdit => 'Edit';

  @override
  String get photoPreviewTitle => 'Add Item';

  @override
  String get photoPreviewRetake => 'Retake';

  @override
  String get photoPreviewUsePhoto => 'Use Photo';

  @override
  String get photoPreviewLoadError => 'Failed to load image';

  @override
  String get myPostsTitle => 'Posts';

  @override
  String get myPostsAllDeleted => 'All posts have been deleted';

  @override
  String get myPostsDefaultUser => 'User';

  @override
  String myPostsLikesCount(Object count) {
    return '$count likes';
  }

  @override
  String myPostsViewComments(Object count) {
    return 'View all $count comments';
  }

  @override
  String get myPostsDeleteDialogTitle => 'Delete Post?';

  @override
  String get myPostsDeleteDialogMessage => 'Are you sure you want to delete this post?\nThis action cannot be undone and the post\nwill be removed from your profile.';

  @override
  String get myPostsDeleteButton => 'Delete';

  @override
  String get myPostsDeleteCancel => 'Cancel';

  @override
  String get commentsTitle => 'Comments';

  @override
  String get commentsNoComments => 'No comments';

  @override
  String get commentsLoginRequired => 'You must be logged in to comment';

  @override
  String get commentsAddComment => 'Add a comment...';

  @override
  String commentsDaysAgo(Object count) {
    return '${count}d ago';
  }

  @override
  String commentsHoursAgo(Object count) {
    return '${count}h ago';
  }

  @override
  String commentsMinutesAgo(Object count) {
    return '${count}m ago';
  }

  @override
  String get commentsJustNow => 'Just now';

  @override
  String get commentsRecently => 'Recently';

  @override
  String get commentsUnknownUser => 'unknown';

  @override
  String get accountManagerTitle => 'Account Manager';

  @override
  String get accountManagerChangeEmail => 'Change Email';

  @override
  String get accountManagerChangeEmailSubtitle => 'Update your email address';

  @override
  String get accountManagerChangePassword => 'Change Password';

  @override
  String get accountManagerChangePasswordSubtitle => 'Update your password';

  @override
  String get accountManagerChangeFullName => 'Change Full Name';

  @override
  String get accountManagerChangeFullNameSubtitle => 'Update your display name';

  @override
  String get accountManagerDangerZone => 'DANGER ZONE';

  @override
  String get accountManagerDeleteAccount => 'Delete Account';

  @override
  String get accountManagerDeleteAccountSubtitle => 'Permanently delete your account';

  @override
  String get accountManagerChangeEmailDialogTitle => 'Change Email';

  @override
  String get accountManagerChangeEmailDialogDescription => 'Enter your new email and confirm with your password';

  @override
  String get accountManagerNewEmail => 'New Email';

  @override
  String get accountManagerNewEmailHint => 'newemail@example.com';

  @override
  String get accountManagerCurrentPassword => 'Current Password';

  @override
  String get accountManagerChangeEmailButton => 'Change Email';

  @override
  String get accountManagerCancel => 'Cancel';

  @override
  String get accountManagerChangeFullNameDialogTitle => 'Change Full Name';

  @override
  String get accountManagerChangeFullNameDialogDescription => 'Enter your new display name';

  @override
  String get accountManagerFullName => 'Full Name';

  @override
  String get accountManagerFullNameHint => 'Your name';

  @override
  String get accountManagerSave => 'Save';

  @override
  String get accountManagerChangePasswordDialogTitle => 'Change Password';

  @override
  String get accountManagerChangePasswordDialogDescription => 'Enter your current password and new password';

  @override
  String get accountManagerNewPassword => 'New Password';

  @override
  String get accountManagerConfirmPassword => 'Confirm Password';

  @override
  String get accountManagerChangePasswordButton => 'Change Password';

  @override
  String get accountManagerDeleteAccountDialogTitle => 'Delete Account';

  @override
  String get accountManagerDeleteAccountDialogDescription => 'Are you sure you want to permanently delete your account? This action cannot be undone.';

  @override
  String get accountManagerDeleteAccountButton => 'Delete Account';

  @override
  String get accountManagerFinalConfirmation => 'Final Confirmation';

  @override
  String get accountManagerFinalConfirmationDescription => 'Type DELETE and enter your password to confirm account deletion';

  @override
  String get accountManagerTypeDelete => 'Type DELETE to confirm';

  @override
  String get accountManagerTypeDeleteHint => 'Type DELETE';

  @override
  String get accountManagerPassword => 'Password';

  @override
  String get followersTitle => 'Followers';

  @override
  String get followersSearchHint => 'Search followers...';

  @override
  String get followersNotFound => 'No followers found';

  @override
  String get followersFollow => 'Follow';

  @override
  String get followersFollowing => 'Following';

  @override
  String get followingTitle => 'Following';

  @override
  String get followingSearchHint => 'Search following...';

  @override
  String get followingNotFound => 'No results found';

  @override
  String get manageCategoriesTitle => 'Manage Categories For Items';

  @override
  String get manageCategoriesNewHint => 'New category name...';

  @override
  String manageCategoriesItemCount(Object count) {
    return '$count items';
  }

  @override
  String get manageCategoriesEditTitle => 'Edit Category';

  @override
  String get manageCategoriesEditHint => 'Category name';

  @override
  String get manageCategoriesDeleteTitle => 'Delete Category';

  @override
  String manageCategoriesDeleteMessage(Object name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get manageCategoriesCancel => 'Cancel';

  @override
  String get manageCategoriesSave => 'Save';

  @override
  String get manageCategoriesDelete => 'Delete';

  @override
  String get manageCategoriesInfo => 'Categories help you organize your wardrobe items. Items can belong to multiple categories.';

  @override
  String get manageOutfitCategoriesTitle => 'Manage Categories For Outfits';

  @override
  String get helpCenterTitle => 'Help Center';

  @override
  String get helpCenterEmailUs => 'Email Us';

  @override
  String get helpCenterFAQTitle => 'Frequently Asked Questions';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsRetry => 'Retry';

  @override
  String get notificationsLiked => ' liked your outfit';

  @override
  String notificationsCommented(String comment) {
    return ' commented: \"$comment\"';
  }

  @override
  String get notificationsFollowed => ' started following you';

  @override
  String get notificationsInteracted => ' interacted with your content';

  @override
  String notificationsDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String notificationsHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String notificationsMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String get notificationsJustNow => 'Just now';

  @override
  String get notificationsRecently => 'Recently';

  @override
  String get notificationsErrorMessage => 'Failed to load notifications';

  @override
  String get saveOutfitTitle => 'Save Outfit';

  @override
  String get saveOutfitNoDataError => 'No outfit data found. Please create an outfit first.';

  @override
  String get saveOutfitNoDataFound => 'No outfit data found';

  @override
  String get saveOutfitName => 'Outfit Name';

  @override
  String get saveOutfitNameHint => 'e.g., Casual Friday Look';

  @override
  String get saveOutfitDescription => 'Description (optional)';

  @override
  String get saveOutfitDescriptionHint => 'Add notes about this outfit...';

  @override
  String get saveOutfitSeason => 'Season';

  @override
  String get saveOutfitSeasonHint => 'Select season';

  @override
  String get saveOutfitCategories => 'Categories';

  @override
  String saveOutfitItemsCount(int count) {
    return '$count item in outfit';
  }

  @override
  String saveOutfitItemsCountPlural(int count) {
    return '$count items in outfit';
  }

  @override
  String get saveOutfitSaveButton => 'Save to Wardrobe';

  @override
  String get editOutfitTitle => 'Outfit Details';

  @override
  String get editOutfitLoading => 'Loading outfit...';

  @override
  String get editOutfitError => 'Oops! Something went wrong';

  @override
  String get editOutfitTryAgain => 'Try Again';

  @override
  String get editOutfitGoBack => 'Go Back';

  @override
  String get editOutfitNotFound => 'Outfit not found';

  @override
  String get editOutfitNotFoundMessage => 'The outfit may have been deleted or doesn\'t exist';

  @override
  String get editOutfitNoImage => 'No outfit image';

  @override
  String get editOutfitItemsTitle => 'Items in this outfit';

  @override
  String get editOutfitDetailsTitle => 'Edit Outfit Details';

  @override
  String get editOutfitDetailsSubtitle => 'Update your outfit information';

  @override
  String get editOutfitNameLabel => 'Outfit Name';

  @override
  String get editOutfitNameHint => 'e.g., Summer Casual';

  @override
  String get editOutfitDescriptionLabel => 'Description';

  @override
  String get editOutfitDescriptionHint => 'Perfect outfit for a casual summer day';

  @override
  String get editOutfitSeasonLabel => 'Season';

  @override
  String get editOutfitSeasonHint => 'Select season';

  @override
  String get editOutfitErrorName => 'Please enter an outfit name';

  @override
  String get editOutfitErrorCategory => 'Please select at least one category';

  @override
  String get editOutfitSuccessSave => 'Outfit updated successfully!';

  @override
  String editOutfitErrorSave(String error) {
    return 'Error saving outfit: $error';
  }

  @override
  String get editOutfitDeleteDialog => 'Delete Outfit';

  @override
  String editOutfitDeleteMessage(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get editOutfitDeleteWarning => 'This action cannot be undone.';

  @override
  String get editOutfitDeleting => 'Deleting outfit...';

  @override
  String get editOutfitDeleteSuccess => 'Outfit deleted successfully!';

  @override
  String editOutfitDeleteError(String error) {
    return 'Error deleting outfit: $error';
  }

  @override
  String get editOutfitCannotDeleteTitle => 'Cannot Delete Outfit';

  @override
  String editOutfitCannotDeleteMessage(int count, String posts) {
    return 'This outfit is used in $count $posts.';
  }

  @override
  String editOutfitCannotDeleteInstruction(String posts) {
    return 'To delete this outfit, you must first delete the $posts that use it.';
  }

  @override
  String editOutfitCannotDeleteInfo(String ones) {
    return 'Go to your posts and delete the $ones using this outfit first.';
  }

  @override
  String get editOutfitPost => 'post';

  @override
  String get editOutfitPosts => 'posts';

  @override
  String get editOutfitOne => 'one';

  @override
  String get editOutfitOnes => 'ones';

  @override
  String editOutfitWarningUsed(int count, String posts) {
    return 'This outfit is used in $count $posts';
  }

  @override
  String editOutfitWarningDeleteFirst(String posts) {
    return 'Delete the $posts first to delete this outfit';
  }

  @override
  String get editOutfitDeleteButton => 'Delete Outfit';

  @override
  String get editOutfitCancelButton => 'Cancel';

  @override
  String get editOutfitSaveButton => 'Save Changes';

  @override
  String get editOutfitGoToPostsButton => 'Go to Posts';

  @override
  String get editOutfitLoginRequired => 'Please log in to view your profile';

  @override
  String get editOutfitImageLoading => 'Loading image...';

  @override
  String get editOutfitImageNotAvailable => 'Image not available';

  @override
  String get seasonSpring => 'Spring';

  @override
  String get seasonSummer => 'Summer';

  @override
  String get seasonFall => 'Fall';

  @override
  String get seasonWinter => 'Winter';

  @override
  String get seasonAllSeason => 'All Season';

  @override
  String get outfitDetailsTitle => 'Outfit Details';

  @override
  String get outfitDetailsError => 'Error loading outfit details';

  @override
  String get outfitDetailsDeleteDialog => 'Delete Outfit?';

  @override
  String get outfitDetailsDeleteMessage => 'Are you sure you want to delete this outfit?\nThis action cannot be undone.';

  @override
  String get outfitDetailsDeleteButton => 'Delete';

  @override
  String get outfitDetailsCancelButton => 'Cancel';

  @override
  String get outfitDetailsShareComingSoon => 'Share functionality - Coming soon';

  @override
  String get outfitDetailsOutfitDeleted => 'Outfit deleted';

  @override
  String get outfitDetailsShareButton => 'Share Outfit';

  @override
  String get outfitDetailsDeleteButtonAction => 'Delete Outfit';

  @override
  String get outfitDetailsUnnamedOutfit => 'Unnamed Outfit';

  @override
  String get outfitDetailsCreatedDefault => 'Created on October 20, 2025';

  @override
  String outfitDetailsItemsCount(int count) {
    return 'Items ($count)';
  }

  @override
  String get outfitDetailsNoItems => 'No items in this outfit';

  @override
  String get outfitDetailsUnnamedItem => 'Unnamed Item';

  @override
  String get outfitDetailsUncategorized => 'Uncategorized';

  @override
  String get createOutfitCapturing => 'Capturing outfit...';

  @override
  String get createOutfitAddAtLeastOne => 'Please add at least one item to the outfit';

  @override
  String get createOutfitSaveSuccess => 'Outfit saved successfully!';

  @override
  String get createOutfitErrorLoading => 'Error loading items';

  @override
  String get createOutfitTryAgain => 'Try Again';

  @override
  String get createOutfitZoomIn => 'Zoom In';

  @override
  String get createOutfitZoomOut => 'Zoom Out';

  @override
  String get createOutfitResetSize => 'Reset Size';

  @override
  String get createOutfitBringToFront => 'Bring to Front';

  @override
  String get createOutfitSendToBack => 'Send to Back';

  @override
  String get createOutfitRemoveFromOutfit => 'Remove from Outfit';

  @override
  String get createOutfitAddItems => 'Add Items';

  @override
  String createOutfitItemsCount(int count) {
    return '$count items';
  }

  @override
  String createOutfitAddedToOutfit(String itemName) {
    return 'Added $itemName to outfit';
  }

  @override
  String get createOutfitRemoveItemTitle => 'Remove Item';

  @override
  String get createOutfitRemoveItemMessage => 'Remove this item from the outfit?';

  @override
  String get createOutfitCancel => 'Cancel';

  @override
  String get createOutfitRemove => 'Remove';

  @override
  String get createOutfitYourItems => 'Your Items';

  @override
  String createOutfitTotalCount(int count) {
    return '$count total';
  }

  @override
  String get createOutfitNoItems => 'No items in your wardrobe';

  @override
  String get postsDetailsTitle => 'Posts';

  @override
  String get postsDetailsMustLoginToLike => 'You must be logged in to like posts!';

  @override
  String postsDetailsLikesCount(int count) {
    return '$count likes';
  }

  @override
  String postsDetailsViewAllComments(int count) {
    return 'View all $count comments';
  }

  @override
  String get postsDetailsImageNotFound => 'Image not found';
}
