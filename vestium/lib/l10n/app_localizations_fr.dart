// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Vestium';

  @override
  String get splashSubtitle => 'Votre dressing virtuel personnel.';

  @override
  String get splashDescription =>
      'Organisez votre style, créez des tenues\net partagez votre parcours mode.';

  @override
  String get splashCheckingAuth => 'Vérification de l\'authentification...';

  @override
  String get splashSignUp => 'S\'inscrire';

  @override
  String get splashContinueAsGuest => 'Continuer en invité';

  @override
  String get splashAlreadyHaveAccount => 'Vous avez déjà un compte ?';

  @override
  String get loginTitle => 'Content de vous revoir';

  @override
  String get loginSubtitle =>
      'Connectez-vous pour continuer votre aventure mode';

  @override
  String get loginEmailRequired => 'Veuillez entrer votre e-mail';

  @override
  String get loginEmailInvalid => 'Veuillez entrer un e-mail valide';

  @override
  String get loginPasswordRequired => 'Veuillez entrer votre mot de passe';

  @override
  String get loginForgotPassword => 'Mot de passe oublié ?';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get loginNoAccount => 'Vous n\'avez pas de compte ? ';

  @override
  String get loginCreateAccount => 'Créer un compte';

  @override
  String loginWelcomeBackUser(Object userName) {
    return 'Bon retour, $userName !';
  }

  @override
  String get loginEmailLabel => 'E-mail';

  @override
  String get loginEmailHint => 'vous@example.com';

  @override
  String get loginPasswordLabel => 'Mot de passe';

  @override
  String get loginPasswordHint => '••••••••';

  @override
  String get signupTitle => 'Créer un compte';

  @override
  String get signupSubtitle =>
      'Rejoignez Vestium et commencez votre parcours de style';

  @override
  String get signupFullNameRequired => 'Veuillez entrer votre nom complet';

  @override
  String get signupFullNameTooShort =>
      'Le nom doit contenir au moins 2 caractères';

  @override
  String get signupEmailRequired => 'Veuillez entrer votre e-mail';

  @override
  String get signupEmailInvalid => 'Veuillez entrer un e-mail valide';

  @override
  String get signupPasswordRequired => 'Veuillez entrer un mot de passe';

  @override
  String get signupPasswordTooShort =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get signupButton => 'Créer un compte';

  @override
  String get signupHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get signupSignIn => 'Se connecter';

  @override
  String signupWelcomeUser(Object userName) {
    return 'Bienvenue $userName !';
  }

  @override
  String get fieldEmailLabel => 'E-mail';

  @override
  String get fieldEmailHint => 'vous@example.com';

  @override
  String get fieldFullNameLabel => 'Nom complet';

  @override
  String get fieldFullNameHint => 'Votre nom';

  @override
  String get fieldPasswordLabel => 'Mot de passe';

  @override
  String get fieldPasswordHint => '••••••••';

  @override
  String get homeAppTitle => 'Vestium';

  @override
  String homeRefreshFailed(Object error) {
    return 'Actualisation échouée : $error';
  }

  @override
  String get homeLikeRequiresLogin =>
      'Vous devez être connecté pour aimer les publications !';

  @override
  String homeLikesCount(Object count) {
    return '$count J\'aime';
  }

  @override
  String homeViewAllComments(Object count) {
    return 'Voir les $count commentaires';
  }

  @override
  String get homeReachedEndOfFeed =>
      'Vous avez atteint la fin de votre fil d\'actualité';

  @override
  String get homeRetryButton => 'Réessayer';

  @override
  String get homeNoPostsYet =>
      'Aucune publication pour le moment. Suivez des utilisateurs pour voir leurs publications !';

  @override
  String get homeFindUsersButton => 'Trouver des utilisateurs';

  @override
  String get homeSearchTabHint =>
      'Allez à l\'onglet recherche pour trouver des utilisateurs à suivre !';

  @override
  String get homeNewPosts => 'Nouvelles publications';

  @override
  String get searchRecentHeader => 'Récent';

  @override
  String get searchDeleteAll => 'Supprimer tout';

  @override
  String get searchDiscoverTitle => 'Découvrir';

  @override
  String get searchPlaceholder =>
      'Rechercher des utilisateurs, des tenues, des tags...';

  @override
  String get searchFollowing => 'Suivi';

  @override
  String get searchFollow => 'Suivre';

  @override
  String get searchNoResults => 'Aucun résultat trouvé';

  @override
  String get searchTrySomethingElse =>
      'Essayez de chercher quelque chose d\'autre';

  @override
  String get newPostTitle => 'Nouvelle publication';

  @override
  String get newPostButton => 'Publier';

  @override
  String get captionPlaceholder => 'Écrivez une légende pour votre tenue...';

  @override
  String get outfitPickerEmpty => 'Choisir une tenue';

  @override
  String get publicPostLabel => 'Publication publique';

  @override
  String get publicPostDescription =>
      'Votre publication sera visible par tous les utilisateurs de Vestium';

  @override
  String get selectOutfitTitle => 'Sélectionner une tenue';

  @override
  String get selectOutfitContinue => 'Continuer';

  @override
  String get selectOutfitSavedOutfits => 'Tenues enregistrées';

  @override
  String get selectOutfitGallery => 'Galerie';

  @override
  String get selectOutfitNoOutfits => 'Aucune tenue pour le moment';

  @override
  String get selectOutfitCreateFirst =>
      'Créez votre première tenue pour la voir ici.';

  @override
  String get galleryEmptyMessage =>
      'La galerie apparaîtra une fois l\'accès géré.';

  @override
  String get wardrobeMyWardrobe => 'Ma Garde-robe';

  @override
  String get wardrobeAll => 'Tous';

  @override
  String get wardrobeEmptyFull => 'Votre garde-robe est vide';

  @override
  String wardrobeEmptyCategory(Object category) {
    return 'Aucun article dans la catégorie \"$category\"';
  }

  @override
  String get wardrobeAddItem =>
      'Appuyez sur le bouton + pour ajouter votre premier article';

  @override
  String get wardrobeErrorRetry => 'Réessayer';

  @override
  String get wardrobeNoCategory => 'Aucune catégorie';

  @override
  String get wardrobeUnnamedItem => 'Article sans nom';

  @override
  String get userProfileDefaultUser => 'Utilisateur';

  @override
  String get userProfileRetry => 'Réessayer';

  @override
  String get userProfileFollowing => 'Suivi';

  @override
  String get userProfileFollow => 'Suivre';

  @override
  String get userProfilePostsLabel => 'Publications';

  @override
  String get userProfileFollowersLabel => 'Abonnés';

  @override
  String get userProfileFollowingLabel => 'Abonnements';

  @override
  String get userProfileNoPostsYet => 'Aucune publication pour le moment';

  @override
  String get myProfileUnknownUser => 'Utilisateur inconnu';

  @override
  String get myProfileNoBio => 'Aucune biographie';

  @override
  String get myProfilePostsLabel => 'Publications';

  @override
  String get myProfileOutfitsLabel => 'Tenues';

  @override
  String get myProfileFollowersLabel => 'Abonnés';

  @override
  String get myProfileFollowingLabel => 'Abonnements';

  @override
  String get myProfileNoPostsYet => 'Aucune publication pour le moment';

  @override
  String get myProfileNoOutfitsYet => 'Aucune tenue pour le moment';

  @override
  String get myProfileEditProfile => 'Modifier le profil';

  @override
  String get myProfileSettingsButton => 'Paramètres';

  @override
  String get galleryAccessTitle => 'Accès à la galerie';

  @override
  String get galleryAccessDescription =>
      'Vestium a besoin d\'accéder à votre galerie pour prendre des photos de vos vêtements et les ajouter à votre garde-robe virtuelle.';

  @override
  String get galleryAccessAllowButton => 'Autoriser l\'accès à la galerie';

  @override
  String get galleryAccessMaybeLater => 'Plus tard';

  @override
  String get galleryAccessPrivacyTitle => 'Vos photos sont privées';

  @override
  String get galleryAccessPrivacyDescription =>
      'Nous utilisons uniquement votre caméra pour capturer des vêtements. Vos photos restent sur votre appareil.';

  @override
  String get galleryAccessPermissionRequired => 'Permission requise';

  @override
  String get galleryAccessPermissionDenied =>
      'L\'accès à la galerie a été définitivement refusé. Veuillez l\'activer dans les paramètres de l\'application.';

  @override
  String get galleryAccessCancel => 'Annuler';

  @override
  String get galleryAccessSettings => 'Paramètres';

  @override
  String get cameraAccessTitle => 'Accès à la caméra';

  @override
  String get cameraAccessDescription =>
      'Vestium a besoin d\'accéder à votre caméra pour prendre des photos de vos vêtements et les ajouter à votre garde-robe virtuelle.';

  @override
  String get cameraAccessAllowButton => 'Autoriser l\'accès à la caméra';

  @override
  String get cameraAccessMaybeLater => 'Plus tard';

  @override
  String get cameraAccessPrivacyTitle => 'Vos photos sont privées';

  @override
  String get cameraAccessPrivacyDescription =>
      'Nous utilisons uniquement votre caméra pour capturer des vêtements. Vos photos restent sur votre appareil.';

  @override
  String get selectItemTitle => 'Sélectionner un article';

  @override
  String get selectItemContinueButton => 'Continuer';

  @override
  String get selectItemEmptyTitle => 'Aucune photo pour le moment';

  @override
  String get selectItemEmptyDescription =>
      'Consultez votre galerie ou prenez une photo pour commencer.';

  @override
  String get editItemTitle => 'Modifier l\'article';

  @override
  String get editItemCropTitle => 'Recadrer l\'image';

  @override
  String get editItemRemoveBgTitle => 'Supprimer l\'arrière-plan';

  @override
  String get editItemDragText =>
      'Faites glisser pour ajuster la zone de recadrage';

  @override
  String get editItemResetButton => 'Réinitialiser';

  @override
  String get editItemDoneButton => 'Terminé';

  @override
  String get editItemCropButton => 'Recadrer';

  @override
  String get editItemRemoveBgButton => 'Supprimer BG';

  @override
  String get editItemInstructionText =>
      'Dessinez sur l\'image pour supprimer l\'arrière-plan';

  @override
  String get editItemEraserSizeLabel => 'Taille de la gomme';

  @override
  String get editItemSaveButtonLabel => 'Enregistrer';

  @override
  String editItemSaveErrorMessage(Object error) {
    return 'Erreur lors de l\'enregistrement de l\'image modifiée: $error';
  }

  @override
  String editItemCropSaveError(Object error) {
    return 'Erreur lors de l\'enregistrement du recadrage: $error';
  }

  @override
  String get editItemDetailsTitle => 'Modifier l\'article';

  @override
  String get editItemDetailsItemName => 'Nom de l\'article';

  @override
  String get editItemDetailsItemNameHint => 'Entrez le nom de l\'article';

  @override
  String get editItemDetailsDescription => 'Description (optionnel)';

  @override
  String get editItemDetailsDescriptionHint => 'Ajouter une description...';

  @override
  String get editItemDetailsCategories => 'Catégories';

  @override
  String get editItemDetailsSeason => 'Saison';

  @override
  String get editItemDetailsSeasonHint => 'Sélectionner une saison';

  @override
  String get editItemDetailsSpring => 'Printemps';

  @override
  String get editItemDetailsSummer => 'Été';

  @override
  String get editItemDetailsFall => 'Automne';

  @override
  String get editItemDetailsWinter => 'Hiver';

  @override
  String get editItemDetailsAllSeason => 'Toutes les saisons';

  @override
  String get editItemDetailsSaveChanges => 'Enregistrer les modifications';

  @override
  String get editItemDetailsDeleteItem => 'Supprimer l\'article';

  @override
  String get editItemDetailsDeleteConfirmTitle => 'Supprimer l\'article';

  @override
  String get editItemDetailsDeleteConfirmMessage =>
      'Êtes-vous sûr de vouloir supprimer cet article?';

  @override
  String get editItemDetailsDeleteConfirmCancel => 'Annuler';

  @override
  String get editItemDetailsDeleteConfirmDelete => 'Supprimer';

  @override
  String get editItemDetailsSuccessMessage => 'Article mis à jour avec succès!';

  @override
  String get editItemDetailsDeleteSuccessMessage =>
      'Article supprimé avec succès!';

  @override
  String get editItemDetailsValidationError =>
      'Veuillez entrer le nom de l\'article et sélectionner au moins une catégorie';

  @override
  String get editItemDetailsBlockedTitle =>
      'Impossible de supprimer l\'article';

  @override
  String get editItemDetailsBlockedMessage =>
      'Cet article est utilisé dans les tenues suivantes:';

  @override
  String get editItemDetailsBlockedOK => 'OK';

  @override
  String get editItemDetailsItemNotFound => 'Article introuvable';

  @override
  String get itemDetailsTitle => 'Détails de l\'article';

  @override
  String get itemDetailsItemName => 'Nom de l\'article';

  @override
  String get itemDetailsItemNameHint => 'par ex., Veste en jean bleu';

  @override
  String get itemDetailsDescription => 'Description (optionnel)';

  @override
  String get itemDetailsDescriptionHint =>
      'Ajouter des notes sur cet article...';

  @override
  String get itemDetailsSeason => 'Saison';

  @override
  String get itemDetailsSeasonHint => 'Sélectionner la saison';

  @override
  String get itemDetailsSeasonSpring => 'Printemps';

  @override
  String get itemDetailsSeasonSummer => 'Été';

  @override
  String get itemDetailsSeasonFall => 'Automne';

  @override
  String get itemDetailsSeasonWinter => 'Hiver';

  @override
  String get itemDetailsSeasonAllSeason => 'Toute saison';

  @override
  String get itemDetailsCategories => 'Catégories';

  @override
  String get itemDetailsCategoriesLoading => 'Chargement des catégories...';

  @override
  String get itemDetailsCategoriesError => 'Échec du chargement des catégories';

  @override
  String get itemDetailsCategoriesRetry => 'Appuyer pour réessayer';

  @override
  String get itemDetailsCategoriesEmpty => 'Aucune catégorie disponible';

  @override
  String get itemDetailsAddToWardrobe => 'Ajouter à la garde-robe';

  @override
  String get itemDetailsAddedSuccess => 'Article ajouté à la garde-robe !';

  @override
  String get itemDetailsNameRequired => 'Veuillez entrer un nom d\'article';

  @override
  String get itemDetailsCategoryRequired =>
      'Veuillez sélectionner au moins une catégorie';

  @override
  String get takePicTitle => 'Ajouter un article';

  @override
  String get takePicPosition => 'Positionnez votre vêtement';

  @override
  String get takePicTapToStart =>
      'Appuyez ici pour commencer à prendre une photo';

  @override
  String get myProfilePosts => 'Publications';

  @override
  String get myProfileOutfits => 'Tenues';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsProfileUpdated => 'Profil mis à jour';

  @override
  String get settingsAccountSection => 'COMPTE';

  @override
  String get settingsAccountManagement => 'Gestion du compte';

  @override
  String get settingsCategoriesSection => 'CATÉGORIES';

  @override
  String get settingsManageCategoriesItems =>
      'Gérer les catégories d\'articles';

  @override
  String get settingsManageCategoriesOutfits =>
      'Gérer les catégories de tenues';

  @override
  String get settingsNotificationsSection => 'NOTIFICATIONS';

  @override
  String get settingsPushNotifications => 'Notifications push';

  @override
  String get settingsEmailNotifications => 'Notifications par e-mail';

  @override
  String get settingsSupportSection => 'ASSISTANCE';

  @override
  String get settingsHelpCenter => 'Centre d\'aide';

  @override
  String get settingsLogoutDialogTitle => 'Se déconnecter';

  @override
  String get settingsLogoutDialogMessage =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get settingsLogoutCancel => 'Annuler';

  @override
  String get settingsLogoutButton => 'Se déconnecter';

  @override
  String get settingsEditName => 'Nom';

  @override
  String get settingsEditNameHint => 'Mon nom';

  @override
  String get settingsEditUsername => 'Nom d\'utilisateur';

  @override
  String get settingsEditUsernameHint => 'mon_nom_utilisateur';

  @override
  String get settingsEditBio => 'Bio';

  @override
  String get settingsEditBioHint => 'Passionné de mode ✨ | Inspiration style';

  @override
  String get settingsEditCancel => 'Annuler';

  @override
  String get settingsEditSave => 'Enregistrer';

  @override
  String get settingsEdit => 'Modifier';

  @override
  String get photoPreviewTitle => 'Ajouter un article';

  @override
  String get photoPreviewRetake => 'Reprendre';

  @override
  String get photoPreviewUsePhoto => 'Utiliser la photo';

  @override
  String get photoPreviewLoadError => 'Échec du chargement de l\'image';

  @override
  String get myPostsTitle => 'Publications';

  @override
  String get myPostsAllDeleted => 'Toutes les publications ont été supprimées';

  @override
  String get myPostsDefaultUser => 'Utilisateur';

  @override
  String myPostsLikesCount(Object count) {
    return '$count J\'aime';
  }

  @override
  String myPostsViewComments(Object count) {
    return 'Voir les $count commentaires';
  }

  @override
  String get myPostsDeleteDialogTitle => 'Supprimer la publication ?';

  @override
  String get myPostsDeleteDialogMessage =>
      'Êtes-vous sûr de vouloir supprimer cette publication ?\nCette action est irréversible et la publication\nsera supprimée de votre profil.';

  @override
  String get myPostsDeleteButton => 'Supprimer';

  @override
  String get myPostsDeleteCancel => 'Annuler';

  @override
  String get commentsTitle => 'Commentaires';

  @override
  String get commentsNoComments => 'Aucun commentaire';

  @override
  String get commentsLoginRequired => 'Vous devez être connecté pour commenter';

  @override
  String get commentsAddComment => 'Ajouter un commentaire...';

  @override
  String commentsDaysAgo(Object count) {
    return 'Il y a ${count}j';
  }

  @override
  String commentsHoursAgo(Object count) {
    return 'Il y a ${count}h';
  }

  @override
  String commentsMinutesAgo(Object count) {
    return 'Il y a ${count}m';
  }

  @override
  String get commentsJustNow => 'À l\'instant';

  @override
  String get commentsRecently => 'Récemment';

  @override
  String get commentsUnknownUser => 'inconnu';

  @override
  String get accountManagerTitle => 'Gestionnaire de compte';

  @override
  String get accountManagerChangeEmail => 'Changer l\'e-mail';

  @override
  String get accountManagerChangeEmailSubtitle =>
      'Mettre à jour votre adresse e-mail';

  @override
  String get accountManagerChangePassword => 'Changer le mot de passe';

  @override
  String get accountManagerChangePasswordSubtitle =>
      'Mettre à jour votre mot de passe';

  @override
  String get accountManagerChangeFullName => 'Changer le nom complet';

  @override
  String get accountManagerChangeFullNameSubtitle =>
      'Mettre à jour votre nom d\'affichage';

  @override
  String get accountManagerDangerZone => 'ZONE DANGEREUSE';

  @override
  String get accountManagerDeleteAccount => 'Supprimer le compte';

  @override
  String get accountManagerDeleteAccountSubtitle =>
      'Supprimer définitivement votre compte';

  @override
  String get accountManagerChangeEmailDialogTitle => 'Changer l\'e-mail';

  @override
  String get accountManagerChangeEmailDialogDescription =>
      'Entrez votre nouvel e-mail et confirmez avec votre mot de passe';

  @override
  String get accountManagerNewEmail => 'Nouvel e-mail';

  @override
  String get accountManagerNewEmailHint => 'nouvemail@exemple.com';

  @override
  String get accountManagerCurrentPassword => 'Mot de passe actuel';

  @override
  String get accountManagerChangeEmailButton => 'Changer l\'e-mail';

  @override
  String get accountManagerCancel => 'Annuler';

  @override
  String get accountManagerChangeFullNameDialogTitle =>
      'Changer le nom complet';

  @override
  String get accountManagerChangeFullNameDialogDescription =>
      'Entrez votre nouveau nom d\'affichage';

  @override
  String get accountManagerFullName => 'Nom complet';

  @override
  String get accountManagerFullNameHint => 'Votre nom';

  @override
  String get accountManagerSave => 'Enregistrer';

  @override
  String get accountManagerChangePasswordDialogTitle =>
      'Changer le mot de passe';

  @override
  String get accountManagerChangePasswordDialogDescription =>
      'Entrez votre mot de passe actuel et votre nouveau mot de passe';

  @override
  String get accountManagerNewPassword => 'Nouveau mot de passe';

  @override
  String get accountManagerConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get accountManagerChangePasswordButton => 'Changer le mot de passe';

  @override
  String get accountManagerDeleteAccountDialogTitle => 'Supprimer le compte';

  @override
  String get accountManagerDeleteAccountDialogDescription =>
      'Êtes-vous sûr de vouloir supprimer définitivement votre compte ? Cette action ne peut pas être annulée.';

  @override
  String get accountManagerDeleteAccountButton => 'Supprimer le compte';

  @override
  String get accountManagerFinalConfirmation => 'Confirmation finale';

  @override
  String get accountManagerFinalConfirmationDescription =>
      'Tapez DELETE et entrez votre mot de passe pour confirmer la suppression du compte';

  @override
  String get accountManagerTypeDelete => 'Tapez DELETE pour confirmer';

  @override
  String get accountManagerTypeDeleteHint => 'Tapez DELETE';

  @override
  String get accountManagerPassword => 'Mot de passe';

  @override
  String get followersTitle => 'Abonnés';

  @override
  String get followersSearchHint => 'Rechercher des abonnés...';

  @override
  String get followersNotFound => 'Aucun abonné trouvé';

  @override
  String get followersFollow => 'Suivre';

  @override
  String get followersFollowing => 'Abonné';

  @override
  String get followingTitle => 'Abonnements';

  @override
  String get followingSearchHint => 'Rechercher des abonnements...';

  @override
  String get followingNotFound => 'Aucun résultat trouvé';

  @override
  String get manageCategoriesTitle => 'Gérer les catégories d\'articles';

  @override
  String get manageCategoriesNewHint => 'Nom de la nouvelle catégorie...';

  @override
  String manageCategoriesItemCount(Object count) {
    return '$count articles';
  }

  @override
  String get manageCategoriesEditTitle => 'Modifier la catégorie';

  @override
  String get manageCategoriesEditHint => 'Nom de la catégorie';

  @override
  String get manageCategoriesDeleteTitle => 'Supprimer la catégorie';

  @override
  String manageCategoriesDeleteMessage(Object name) {
    return 'Êtes-vous sûr de vouloir supprimer \"$name\" ?';
  }

  @override
  String get manageCategoriesCancel => 'Annuler';

  @override
  String get manageCategoriesSave => 'Enregistrer';

  @override
  String get manageCategoriesDelete => 'Supprimer';

  @override
  String get manageCategoriesInfo =>
      'Les catégories vous aident à organiser vos articles de garde-robe. Les articles peuvent appartenir à plusieurs catégories.';

  @override
  String get manageOutfitCategoriesTitle => 'Gérer les catégories de tenues';

  @override
  String get helpCenterTitle => 'Centre d\'aide';

  @override
  String get helpCenterEmailUs => 'Nous contacter par email';

  @override
  String get helpCenterFAQTitle => 'Questions fréquemment posées';

  @override
  String get helpCenterFAQ1Question =>
      'Comment ajouter des articles à ma garde-robe ?';

  @override
  String get helpCenterFAQ1Answer =>
      'Vous pouvez ajouter des articles à votre garde-robe en appuyant sur l\'icône de la caméra dans l\'onglet garde-robe. Prenez une photo de votre vêtement. Ajoutez ensuite des détails comme la catégorie, la couleur et la saison.';

  @override
  String get helpCenterFAQ2Question => 'Comment créer une tenue ?';

  @override
  String get helpCenterFAQ2Answer =>
      'Pour créer une tenue, accédez à la section Tenues et appuyez sur le bouton \"Créer nouveau\". Sélectionnez des articles de votre garde-robe et organisez-les pour créer la combinaison de tenue souhaitée.';

  @override
  String get helpCenterFAQ3Question =>
      'Puis-je modifier ou supprimer des articles de la garde-robe ?';

  @override
  String get helpCenterFAQ3Answer =>
      'Oui, vous pouvez modifier ou supprimer des articles de la garde-robe en appuyant sur l\'article dans votre garde-robe. Sélectionnez l\'option de modification pour modifier les détails ou l\'option de suppression pour supprimer l\'article.';

  @override
  String get helpCenterFAQ4Question => 'Comment partager mes tenues ?';

  @override
  String get helpCenterFAQ4Answer =>
      'Pour partager vos tenues, ouvrez la tenue que vous souhaitez partager et appuyez sur le bouton de partage. Vous pouvez partager par email, sur les réseaux sociaux ou générer un lien à partager avec d\'autres.';

  @override
  String get helpCenterFAQ5Question => 'Comment gérer mes catégories ?';

  @override
  String get helpCenterFAQ5Answer =>
      'Vous pouvez gérer vos catégories dans la section Paramètres sous Catégories de garde-robe. Ajoutez, modifiez ou supprimez des catégories pour organiser vos articles comme vous le souhaitez.';

  @override
  String get helpCenterFAQ6Question => 'Puis-je rendre mon profil privé ?';

  @override
  String get helpCenterFAQ6Answer =>
      'Oui, vous pouvez rendre votre profil privé dans les Paramètres du compte. Activez l\'option \"Profil privé\" pour contrôler qui peut voir votre garde-robe et vos tenues.';

  @override
  String get helpCenterFAQ7Question =>
      'Comment réinitialiser mon mot de passe ?';

  @override
  String get helpCenterFAQ7Answer =>
      'Accédez aux Paramètres du compte et sélectionnez \"Changer le mot de passe\". Vous pouvez également utiliser l\'option \"Mot de passe oublié\" sur l\'écran de connexion pour réinitialiser par email.';

  @override
  String get helpCenterFAQ8Question => 'Comment supprimer mon compte ?';

  @override
  String get helpCenterFAQ8Answer =>
      'Pour supprimer votre compte, accédez aux Paramètres du compte et faites défiler jusqu\'à la section \"Zone dangereuse\". Sélectionnez \"Supprimer le compte\" et suivez les étapes de confirmation. Cette action est permanente.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsRetry => 'Réessayer';

  @override
  String get notificationsLiked => ' a aimé votre tenue';

  @override
  String notificationsCommented(String comment) {
    return ' a commenté : \"$comment\"';
  }

  @override
  String get notificationsFollowed => ' a commencé à vous suivre';

  @override
  String get notificationsInteracted => ' a interagi avec votre contenu';

  @override
  String notificationsDaysAgo(int count) {
    return 'Il y a ${count}j';
  }

  @override
  String notificationsHoursAgo(int count) {
    return 'Il y a ${count}h';
  }

  @override
  String notificationsMinutesAgo(int count) {
    return 'Il y a ${count}m';
  }

  @override
  String get notificationsJustNow => 'À l\'instant';

  @override
  String get notificationsRecently => 'Récemment';

  @override
  String get notificationsErrorMessage =>
      'Échec du chargement des notifications';

  @override
  String get saveOutfitTitle => 'Enregistrer la tenue';

  @override
  String get saveOutfitNoDataError =>
      'Aucune donnée de tenue trouvée. Veuillez d\'abord créer une tenue.';

  @override
  String get saveOutfitNoDataFound => 'Aucune donnée de tenue trouvée';

  @override
  String get saveOutfitName => 'Nom de la tenue';

  @override
  String get saveOutfitNameHint => 'par ex., Look vendredi décontracté';

  @override
  String get saveOutfitDescription => 'Description (facultatif)';

  @override
  String get saveOutfitDescriptionHint =>
      'Ajoutez des notes sur cette tenue...';

  @override
  String get saveOutfitSeason => 'Saison';

  @override
  String get saveOutfitSeasonHint => 'Sélectionner la saison';

  @override
  String get saveOutfitCategories => 'Catégories';

  @override
  String saveOutfitItemsCount(int count) {
    return '$count article dans la tenue';
  }

  @override
  String saveOutfitItemsCountPlural(int count) {
    return '$count articles dans la tenue';
  }

  @override
  String get saveOutfitSaveButton => 'Enregistrer dans la garde-robe';

  @override
  String get editOutfitTitle => 'Détails de la tenue';

  @override
  String get editOutfitLoading => 'Chargement de la tenue...';

  @override
  String get editOutfitError => 'Oups! Quelque chose s\'est mal passé';

  @override
  String get editOutfitTryAgain => 'Réessayer';

  @override
  String get editOutfitGoBack => 'Retour';

  @override
  String get editOutfitNotFound => 'Tenue introuvable';

  @override
  String get editOutfitNotFoundMessage =>
      'La tenue a peut-être été supprimée ou n\'existe pas';

  @override
  String get editOutfitNoImage => 'Aucune image de tenue';

  @override
  String get editOutfitItemsTitle => 'Articles dans cette tenue';

  @override
  String get editOutfitDetailsTitle => 'Modifier les détails de la tenue';

  @override
  String get editOutfitDetailsSubtitle =>
      'Mettez à jour les informations de votre tenue';

  @override
  String get editOutfitNameLabel => 'Nom de la tenue';

  @override
  String get editOutfitNameHint => 'par ex., Décontracté d\'été';

  @override
  String get editOutfitDescriptionLabel => 'Description';

  @override
  String get editOutfitDescriptionHint =>
      'Tenue parfaite pour une journée d\'été décontractée';

  @override
  String get editOutfitSeasonLabel => 'Saison';

  @override
  String get editOutfitSeasonHint => 'Sélectionner la saison';

  @override
  String get editOutfitErrorName => 'Veuillez saisir un nom de tenue';

  @override
  String get editOutfitErrorCategory =>
      'Veuillez sélectionner au moins une catégorie';

  @override
  String get editOutfitSuccessSave => 'Tenue mise à jour avec succès!';

  @override
  String editOutfitErrorSave(String error) {
    return 'Erreur lors de l\'enregistrement de la tenue: $error';
  }

  @override
  String get editOutfitDeleteDialog => 'Supprimer la tenue';

  @override
  String editOutfitDeleteMessage(String name) {
    return 'Êtes-vous sûr de vouloir supprimer \"$name\"?';
  }

  @override
  String get editOutfitDeleteWarning =>
      'Cette action ne peut pas être annulée.';

  @override
  String get editOutfitDeleting => 'Suppression de la tenue...';

  @override
  String get editOutfitDeleteSuccess => 'Tenue supprimée avec succès!';

  @override
  String editOutfitDeleteError(String error) {
    return 'Erreur lors de la suppression de la tenue: $error';
  }

  @override
  String get editOutfitCannotDeleteTitle => 'Impossible de supprimer la tenue';

  @override
  String editOutfitCannotDeleteMessage(int count, String posts) {
    return 'Cette tenue est utilisée dans $count $posts.';
  }

  @override
  String editOutfitCannotDeleteInstruction(String posts) {
    return 'Pour supprimer cette tenue, vous devez d\'abord supprimer les $posts qui l\'utilisent.';
  }

  @override
  String editOutfitCannotDeleteInfo(String ones) {
    return 'Accédez à vos publications et supprimez $ones utilisant cette tenue en premier.';
  }

  @override
  String get editOutfitPost => 'publication';

  @override
  String get editOutfitPosts => 'publications';

  @override
  String get editOutfitOne => 'celle';

  @override
  String get editOutfitOnes => 'celles';

  @override
  String editOutfitWarningUsed(int count, String posts) {
    return 'Cette tenue est utilisée dans $count $posts';
  }

  @override
  String editOutfitWarningDeleteFirst(String posts) {
    return 'Supprimez d\'abord les $posts pour supprimer cette tenue';
  }

  @override
  String get editOutfitDeleteButton => 'Supprimer la tenue';

  @override
  String get editOutfitCancelButton => 'Annuler';

  @override
  String get editOutfitSaveButton => 'Enregistrer les modifications';

  @override
  String get editOutfitGoToPostsButton => 'Aller aux publications';

  @override
  String get editOutfitLoginRequired =>
      'Veuillez vous connecter pour voir votre profil';

  @override
  String get editOutfitImageLoading => 'Chargement de l\'image...';

  @override
  String get editOutfitImageNotAvailable => 'Image non disponible';

  @override
  String get seasonSpring => 'Printemps';

  @override
  String get seasonSummer => 'Été';

  @override
  String get seasonFall => 'Automne';

  @override
  String get seasonWinter => 'Hiver';

  @override
  String get seasonAllSeason => 'Toutes saisons';

  @override
  String get outfitDetailsTitle => 'Détails de la tenue';

  @override
  String get outfitDetailsError =>
      'Erreur lors du chargement des détails de la tenue';

  @override
  String get outfitDetailsDeleteDialog => 'Supprimer la tenue ?';

  @override
  String get outfitDetailsDeleteMessage =>
      'Êtes-vous sûr de vouloir supprimer cette tenue ?\nCette action ne peut pas être annulée.';

  @override
  String get outfitDetailsDeleteButton => 'Supprimer';

  @override
  String get outfitDetailsCancelButton => 'Annuler';

  @override
  String get outfitDetailsShareComingSoon =>
      'Fonctionnalité de partage - Bientôt disponible';

  @override
  String get outfitDetailsOutfitDeleted => 'Tenue supprimée';

  @override
  String get outfitDetailsShareButton => 'Partager la tenue';

  @override
  String get outfitDetailsDeleteButtonAction => 'Supprimer la tenue';

  @override
  String get outfitDetailsUnnamedOutfit => 'Tenue sans nom';

  @override
  String get outfitDetailsCreatedDefault => 'Créé le 20 octobre 2025';

  @override
  String outfitDetailsItemsCount(int count) {
    return 'Articles ($count)';
  }

  @override
  String get outfitDetailsNoItems => 'Aucun article dans cette tenue';

  @override
  String get outfitDetailsUnnamedItem => 'Article sans nom';

  @override
  String get outfitDetailsUncategorized => 'Non catégorisé';

  @override
  String get createOutfitTitle => 'Créer une tenue';

  @override
  String get createOutfitSaveTooltip => 'Enregistrer la tenue';

  @override
  String get createOutfitCapturing => 'Capture de la tenue...';

  @override
  String get createOutfitAddAtLeastOne =>
      'Veuillez ajouter au moins un article à la tenue';

  @override
  String get createOutfitSaveSuccess => 'Tenue enregistrée avec succès !';

  @override
  String get createOutfitErrorLoading =>
      'Erreur lors du chargement des articles';

  @override
  String get createOutfitTryAgain => 'Réessayer';

  @override
  String get createOutfitZoomIn => 'Agrandir';

  @override
  String get createOutfitZoomOut => 'Réduire';

  @override
  String get createOutfitResetSize => 'Réinitialiser la taille';

  @override
  String get createOutfitBringToFront => 'Mettre au premier plan';

  @override
  String get createOutfitSendToBack => 'Mettre à l\'arrière-plan';

  @override
  String get createOutfitRemoveFromOutfit => 'Retirer de la tenue';

  @override
  String get createOutfitAddItems => 'Ajouter des articles';

  @override
  String createOutfitItemsCount(int count) {
    return '$count articles';
  }

  @override
  String createOutfitAddedToOutfit(String itemName) {
    return '$itemName ajouté à la tenue';
  }

  @override
  String get createOutfitRemoveItemTitle => 'Retirer l\'article';

  @override
  String get createOutfitRemoveItemMessage =>
      'Retirer cet article de la tenue ?';

  @override
  String get createOutfitCancel => 'Annuler';

  @override
  String get createOutfitRemove => 'Retirer';

  @override
  String get createOutfitYourItems => 'Vos articles';

  @override
  String createOutfitTotalCount(int count) {
    return '$count au total';
  }

  @override
  String get createOutfitNoItems => 'Aucun article dans votre garde-robe';

  @override
  String get postsDetailsTitle => 'Publications';

  @override
  String get postsDetailsMustLoginToLike =>
      'Vous devez être connecté pour aimer les publications !';

  @override
  String postsDetailsLikesCount(int count) {
    return '$count j\'aime';
  }

  @override
  String postsDetailsViewAllComments(int count) {
    return 'Voir les $count commentaires';
  }

  @override
  String get postsDetailsImageNotFound => 'Image introuvable';
}
