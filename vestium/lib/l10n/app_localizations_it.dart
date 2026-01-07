// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Vestium';

  @override
  String get splashSubtitle => 'Il tuo guardaroba virtuale personale.';

  @override
  String get splashDescription =>
      'Organizza il tuo stile, crea outfit\ne condividi il tuo viaggio di moda.';

  @override
  String get splashCheckingAuth => 'Verifica dell\'autenticazione...';

  @override
  String get splashSignUp => 'Registrati';

  @override
  String get splashContinueAsGuest => 'Continua come ospite';

  @override
  String get splashAlreadyHaveAccount => 'Hai già un account?';

  @override
  String get loginTitle => 'Bentornato';

  @override
  String get loginSubtitle => 'Accedi per continuare il tuo viaggio di stile';

  @override
  String get loginEmailRequired => 'Per favore inserisci la tua email';

  @override
  String get loginEmailInvalid => 'Per favore inserisci un\'email valida';

  @override
  String get loginPasswordRequired => 'Per favore inserisci la tua password';

  @override
  String get loginForgotPassword => 'Hai dimenticato la password?';

  @override
  String get loginButton => 'Accedi';

  @override
  String get loginNoAccount => 'Non hai un account? ';

  @override
  String get loginCreateAccount => 'Crea account';

  @override
  String loginWelcomeBackUser(Object userName) {
    return 'Bentornato, $userName!';
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
  String get signupTitle => 'Crea account';

  @override
  String get signupSubtitle =>
      'Unisciti a Vestium e inizia il tuo viaggio di stile';

  @override
  String get signupFullNameRequired =>
      'Per favore inserisci il tuo nome completo';

  @override
  String get signupFullNameTooShort =>
      'Il nome deve contenere almeno 2 caratteri';

  @override
  String get signupEmailRequired => 'Per favore inserisci la tua email';

  @override
  String get signupEmailInvalid => 'Per favore inserisci un\'email valida';

  @override
  String get signupPasswordRequired => 'Per favore inserisci una password';

  @override
  String get signupPasswordTooShort =>
      'La password deve contenere almeno 6 caratteri';

  @override
  String get signupButton => 'Crea account';

  @override
  String get signupHaveAccount => 'Hai già un account? ';

  @override
  String get signupSignIn => 'Accedi';

  @override
  String signupWelcomeUser(Object userName) {
    return 'Benvenuto $userName!';
  }

  @override
  String get fieldEmailLabel => 'Email';

  @override
  String get fieldEmailHint => 'you@example.com';

  @override
  String get fieldFullNameLabel => 'Nome completo';

  @override
  String get fieldFullNameHint => 'Il tuo nome';

  @override
  String get fieldPasswordLabel => 'Password';

  @override
  String get fieldPasswordHint => '••••••••';

  @override
  String get homeAppTitle => 'Vestium';

  @override
  String homeRefreshFailed(Object error) {
    return 'Aggiornamento non riuscito: $error';
  }

  @override
  String get homeLikeRequiresLogin =>
      'Devi essere connesso per mettere mi piace ai post!';

  @override
  String homeLikesCount(Object count) {
    return '$count Mi piace';
  }

  @override
  String homeViewAllComments(Object count) {
    return 'Visualizza tutti i $count commenti';
  }

  @override
  String get homeReachedEndOfFeed => 'Hai raggiunto la fine del tuo feed';

  @override
  String get homeRetryButton => 'Riprova';

  @override
  String get homeNoPostsYet =>
      'Nessun post ancora. Segui alcuni utenti per vedere i loro post!';

  @override
  String get homeFindUsersButton => 'Trova utenti';

  @override
  String get homeSearchTabHint =>
      'Vai alla scheda ricerca per trovare utenti da seguire!';

  @override
  String get homeNewPosts => 'Nuovi post';

  @override
  String get searchRecentHeader => 'Recente';

  @override
  String get searchDeleteAll => 'Elimina tutto';

  @override
  String get searchDiscoverTitle => 'Scopri';

  @override
  String get searchPlaceholder => 'Cerca utenti, outfit, tag...';

  @override
  String get searchFollowing => 'Seguendo';

  @override
  String get searchFollow => 'Segui';

  @override
  String get searchNoResults => 'Nessun risultato trovato';

  @override
  String get searchTrySomethingElse => 'Prova a cercare qualcos\'altro';

  @override
  String get newPostTitle => 'Nuovo Post';

  @override
  String get newPostButton => 'Pubblica';

  @override
  String get captionPlaceholder => 'Scrivi una didascalia per il tuo outfit...';

  @override
  String get outfitPickerEmpty => 'Scegli un Outfit';

  @override
  String get publicPostLabel => 'Post Pubblico';

  @override
  String get publicPostDescription =>
      'Il tuo post sarà visibile a tutti gli utenti di Vestium';

  @override
  String get selectOutfitTitle => 'Seleziona Outfit';

  @override
  String get selectOutfitContinue => 'Continua';

  @override
  String get selectOutfitSavedOutfits => 'Outfit Salvati';

  @override
  String get selectOutfitGallery => 'Galleria';

  @override
  String get selectOutfitNoOutfits => 'Nessun outfit ancora';

  @override
  String get selectOutfitCreateFirst =>
      'Crea il tuo primo outfit per vederlo qui.';

  @override
  String get galleryEmptyMessage =>
      'La galleria apparirà una volta gestito l\'accesso.';

  @override
  String get wardrobeMyWardrobe => 'Il Mio Guardaroba';

  @override
  String get wardrobeAll => 'Tutti';

  @override
  String get wardrobeEmptyFull => 'Il tuo guardaroba è vuoto';

  @override
  String wardrobeEmptyCategory(Object category) {
    return 'Nessun articolo nella categoria \"$category\"';
  }

  @override
  String get wardrobeAddItem =>
      'Tocca il pulsante + per aggiungere il tuo primo articolo';

  @override
  String get wardrobeErrorRetry => 'Riprova';

  @override
  String get wardrobeNoCategory => 'Nessuna categoria';

  @override
  String get wardrobeUnnamedItem => 'Articolo senza nome';

  @override
  String get userProfileDefaultUser => 'Utente';

  @override
  String get userProfileRetry => 'Riprova';

  @override
  String get userProfileFollowing => 'Seguendo';

  @override
  String get userProfileFollow => 'Segui';

  @override
  String get userProfilePostsLabel => 'Post';

  @override
  String get userProfileFollowersLabel => 'Follower';

  @override
  String get userProfileFollowingLabel => 'Seguendo';

  @override
  String get userProfileNoPostsYet => 'Nessun post ancora';

  @override
  String get myProfileUnknownUser => 'Utente Sconosciuto';

  @override
  String get myProfileNoBio => 'Nessuna biografia';

  @override
  String get myProfilePostsLabel => 'Post';

  @override
  String get myProfileOutfitsLabel => 'Outfit';

  @override
  String get myProfileFollowersLabel => 'Follower';

  @override
  String get myProfileFollowingLabel => 'Seguendo';

  @override
  String get myProfileNoPostsYet => 'Nessun post ancora';

  @override
  String get myProfileNoOutfitsYet => 'Nessun outfit ancora';

  @override
  String get myProfileEditProfile => 'Modifica profilo';

  @override
  String get myProfileSettingsButton => 'Impostazioni';

  @override
  String get galleryAccessTitle => 'Accesso Galleria';

  @override
  String get galleryAccessDescription =>
      'Vestium ha bisogno di accedere alla tua galleria per catturare foto dei tuoi capi d\'abbigliamento e aggiungerli al tuo guardaroba virtuale.';

  @override
  String get galleryAccessAllowButton => 'Consenti Accesso Galleria';

  @override
  String get galleryAccessMaybeLater => 'Forse Dopo';

  @override
  String get galleryAccessPrivacyTitle => 'Le tue foto sono private';

  @override
  String get galleryAccessPrivacyDescription =>
      'Utilizziamo la fotocamera solo per catturare capi d\'abbigliamento. Le tue foto rimangono sul tuo dispositivo.';

  @override
  String get galleryAccessPermissionRequired => 'Permesso Richiesto';

  @override
  String get galleryAccessPermissionDenied =>
      'L\'accesso alla galleria è stato negato in modo permanente. Abilita nelle impostazioni dell\'app.';

  @override
  String get galleryAccessCancel => 'Annulla';

  @override
  String get galleryAccessSettings => 'Impostazioni';

  @override
  String get cameraAccessTitle => 'Accesso Fotocamera';

  @override
  String get cameraAccessDescription =>
      'Vestium ha bisogno di accedere alla tua fotocamera per catturare foto dei tuoi capi d\'abbigliamento e aggiungerli al tuo guardaroba virtuale.';

  @override
  String get cameraAccessAllowButton => 'Consenti Accesso Fotocamera';

  @override
  String get cameraAccessMaybeLater => 'Forse Dopo';

  @override
  String get cameraAccessPrivacyTitle => 'Le tue foto sono private';

  @override
  String get cameraAccessPrivacyDescription =>
      'Utilizziamo la fotocamera solo per catturare capi d\'abbigliamento. Le tue foto rimangono sul tuo dispositivo.';

  @override
  String get selectItemTitle => 'Seleziona Articolo';

  @override
  String get selectItemContinueButton => 'Continua';

  @override
  String get selectItemEmptyTitle => 'Nessuna Foto Ancora';

  @override
  String get selectItemEmptyDescription =>
      'Visita la tua galleria o scatta una foto per iniziare.';

  @override
  String get editItemTitle => 'Modifica articolo';

  @override
  String get editItemCropTitle => 'Ritaglia immagine';

  @override
  String get editItemRemoveBgTitle => 'Rimuovi sfondo';

  @override
  String get editItemDragText => 'Trascina per regolare l\'area di ritaglio';

  @override
  String get editItemResetButton => 'Ripristina';

  @override
  String get editItemDoneButton => 'Fatto';

  @override
  String get editItemCropButton => 'Ritaglia';

  @override
  String get editItemRemoveBgButton => 'Rimuovi BG';

  @override
  String get editItemInstructionText =>
      'Disegna sull\'immagine per rimuovere lo sfondo';

  @override
  String get editItemEraserSizeLabel => 'Dimensione gomma';

  @override
  String get editItemSaveButtonLabel => 'Salva';

  @override
  String editItemSaveErrorMessage(Object error) {
    return 'Errore nel salvataggio dell\'immagine modificata: $error';
  }

  @override
  String editItemCropSaveError(Object error) {
    return 'Errore nel salvataggio del ritaglio: $error';
  }

  @override
  String get editItemDetailsTitle => 'Modifica articolo';

  @override
  String get editItemDetailsItemName => 'Nome articolo';

  @override
  String get editItemDetailsItemNameHint => 'Inserisci il nome dell\'articolo';

  @override
  String get editItemDetailsDescription => 'Descrizione (facoltativa)';

  @override
  String get editItemDetailsDescriptionHint => 'Aggiungi descrizione...';

  @override
  String get editItemDetailsCategories => 'Categorie';

  @override
  String get editItemDetailsSeason => 'Stagione';

  @override
  String get editItemDetailsSeasonHint => 'Seleziona stagione';

  @override
  String get editItemDetailsSpring => 'Primavera';

  @override
  String get editItemDetailsSummer => 'Estate';

  @override
  String get editItemDetailsFall => 'Autunno';

  @override
  String get editItemDetailsWinter => 'Inverno';

  @override
  String get editItemDetailsAllSeason => 'Tutte le stagioni';

  @override
  String get editItemDetailsSaveChanges => 'Salva modifiche';

  @override
  String get editItemDetailsDeleteItem => 'Elimina articolo';

  @override
  String get editItemDetailsDeleteConfirmTitle => 'Elimina articolo';

  @override
  String get editItemDetailsDeleteConfirmMessage =>
      'Sei sicuro di voler eliminare questo articolo?';

  @override
  String get editItemDetailsDeleteConfirmCancel => 'Annulla';

  @override
  String get editItemDetailsDeleteConfirmDelete => 'Elimina';

  @override
  String get editItemDetailsSuccessMessage =>
      'Articolo aggiornato con successo!';

  @override
  String get editItemDetailsDeleteSuccessMessage =>
      'Articolo eliminato con successo!';

  @override
  String get editItemDetailsValidationError =>
      'Inserisci il nome dell\'articolo e seleziona almeno una categoria';

  @override
  String get editItemDetailsBlockedTitle => 'Impossibile eliminare l\'articolo';

  @override
  String get editItemDetailsBlockedMessage =>
      'Questo articolo è utilizzato negli abiti seguenti:';

  @override
  String get editItemDetailsBlockedOK => 'OK';

  @override
  String get editItemDetailsItemNotFound => 'Articolo non trovato';

  @override
  String get itemDetailsTitle => 'Dettagli articolo';

  @override
  String get itemDetailsItemName => 'Nome articolo';

  @override
  String get itemDetailsItemNameHint => 'es., Giacca di jeans blu';

  @override
  String get itemDetailsDescription => 'Descrizione (opzionale)';

  @override
  String get itemDetailsDescriptionHint =>
      'Aggiungi note su questo articolo...';

  @override
  String get itemDetailsSeason => 'Stagione';

  @override
  String get itemDetailsSeasonHint => 'Seleziona stagione';

  @override
  String get itemDetailsSeasonSpring => 'Primavera';

  @override
  String get itemDetailsSeasonSummer => 'Estate';

  @override
  String get itemDetailsSeasonFall => 'Autunno';

  @override
  String get itemDetailsSeasonWinter => 'Inverno';

  @override
  String get itemDetailsSeasonAllSeason => 'Tutte le stagioni';

  @override
  String get itemDetailsCategories => 'Categorie';

  @override
  String get itemDetailsCategoriesLoading => 'Caricamento categorie...';

  @override
  String get itemDetailsCategoriesError => 'Caricamento categorie non riuscito';

  @override
  String get itemDetailsCategoriesRetry => 'Tocca per riprovare';

  @override
  String get itemDetailsCategoriesEmpty => 'Nessuna categoria disponibile';

  @override
  String get itemDetailsAddToWardrobe => 'Aggiungi al guardaroba';

  @override
  String get itemDetailsAddedSuccess => 'Articolo aggiunto al guardaroba!';

  @override
  String get itemDetailsNameRequired =>
      'Per favore inserisci il nome dell\'articolo';

  @override
  String get itemDetailsCategoryRequired =>
      'Per favore seleziona almeno una categoria';

  @override
  String get takePicTitle => 'Aggiungi articolo';

  @override
  String get takePicPosition => 'Posiziona il tuo capo di abbigliamento';

  @override
  String get takePicTapToStart => 'Tocca qui per iniziare a scattare la foto';

  @override
  String get myProfilePosts => 'Post';

  @override
  String get myProfileOutfits => 'Outfit';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsProfileUpdated => 'Profilo aggiornato';

  @override
  String get settingsAccountSection => 'ACCOUNT';

  @override
  String get settingsAccountManagement => 'Gestione account';

  @override
  String get settingsCategoriesSection => 'CATEGORIE';

  @override
  String get settingsManageCategoriesItems => 'Gestisci categorie articoli';

  @override
  String get settingsManageCategoriesOutfits => 'Gestisci categorie outfit';

  @override
  String get settingsNotificationsSection => 'NOTIFICHE';

  @override
  String get settingsPushNotifications => 'Notifiche push';

  @override
  String get settingsEmailNotifications => 'Notifiche email';

  @override
  String get settingsSupportSection => 'SUPPORTO';

  @override
  String get settingsHelpCenter => 'Centro assistenza';

  @override
  String get settingsLogoutDialogTitle => 'Disconnetti';

  @override
  String get settingsLogoutDialogMessage => 'Sei sicuro di voler uscire?';

  @override
  String get settingsLogoutCancel => 'Annulla';

  @override
  String get settingsLogoutButton => 'Disconnetti';

  @override
  String get settingsEditName => 'Nome';

  @override
  String get settingsEditNameHint => 'Il mio nome';

  @override
  String get settingsEditUsername => 'Nome utente';

  @override
  String get settingsEditUsernameHint => 'mio_nome_utente';

  @override
  String get settingsEditBio => 'Bio';

  @override
  String get settingsEditBioHint =>
      'Appassionato di moda ✨ | Ispirazione stile';

  @override
  String get settingsEditCancel => 'Annulla';

  @override
  String get settingsEditSave => 'Salva';

  @override
  String get settingsEdit => 'Modifica';

  @override
  String get photoPreviewTitle => 'Aggiungi articolo';

  @override
  String get photoPreviewRetake => 'Rifai';

  @override
  String get photoPreviewUsePhoto => 'Usa foto';

  @override
  String get photoPreviewLoadError => 'Caricamento immagine non riuscito';

  @override
  String get myPostsTitle => 'Post';

  @override
  String get myPostsAllDeleted => 'Tutti i post sono stati eliminati';

  @override
  String get myPostsDefaultUser => 'Utente';

  @override
  String myPostsLikesCount(Object count) {
    return '$count Mi piace';
  }

  @override
  String myPostsViewComments(Object count) {
    return 'Visualizza tutti i $count commenti';
  }

  @override
  String get myPostsDeleteDialogTitle => 'Eliminare il post?';

  @override
  String get myPostsDeleteDialogMessage =>
      'Sei sicuro di voler eliminare questo post?\nQuesta azione non può essere annullata e il post\nverrà rimosso dal tuo profilo.';

  @override
  String get myPostsDeleteButton => 'Elimina';

  @override
  String get myPostsDeleteCancel => 'Annulla';

  @override
  String get commentsTitle => 'Commenti';

  @override
  String get commentsNoComments => 'Nessun commento';

  @override
  String get commentsLoginRequired =>
      'Devi effettuare l\'accesso per commentare';

  @override
  String get commentsAddComment => 'Aggiungi un commento...';

  @override
  String commentsDaysAgo(Object count) {
    return '${count}g fa';
  }

  @override
  String commentsHoursAgo(Object count) {
    return '${count}h fa';
  }

  @override
  String commentsMinutesAgo(Object count) {
    return '${count}m fa';
  }

  @override
  String get commentsJustNow => 'Adesso';

  @override
  String get commentsRecently => 'Di recente';

  @override
  String get commentsUnknownUser => 'sconosciuto';

  @override
  String get accountManagerTitle => 'Gestione account';

  @override
  String get accountManagerChangeEmail => 'Cambia email';

  @override
  String get accountManagerChangeEmailSubtitle =>
      'Aggiorna il tuo indirizzo email';

  @override
  String get accountManagerChangePassword => 'Cambia password';

  @override
  String get accountManagerChangePasswordSubtitle => 'Aggiorna la tua password';

  @override
  String get accountManagerChangeFullName => 'Cambia nome completo';

  @override
  String get accountManagerChangeFullNameSubtitle =>
      'Aggiorna il tuo nome visualizzato';

  @override
  String get accountManagerDangerZone => 'ZONA PERICOLOSA';

  @override
  String get accountManagerDeleteAccount => 'Elimina account';

  @override
  String get accountManagerDeleteAccountSubtitle =>
      'Elimina permanentemente il tuo account';

  @override
  String get accountManagerChangeEmailDialogTitle => 'Cambia email';

  @override
  String get accountManagerChangeEmailDialogDescription =>
      'Inserisci la tua nuova email e conferma con la password';

  @override
  String get accountManagerNewEmail => 'Nuova email';

  @override
  String get accountManagerNewEmailHint => 'nuovaemail@esempio.com';

  @override
  String get accountManagerCurrentPassword => 'Password attuale';

  @override
  String get accountManagerChangeEmailButton => 'Cambia email';

  @override
  String get accountManagerCancel => 'Annulla';

  @override
  String get accountManagerChangeFullNameDialogTitle => 'Cambia nome completo';

  @override
  String get accountManagerChangeFullNameDialogDescription =>
      'Inserisci il tuo nuovo nome visualizzato';

  @override
  String get accountManagerFullName => 'Nome completo';

  @override
  String get accountManagerFullNameHint => 'Il tuo nome';

  @override
  String get accountManagerSave => 'Salva';

  @override
  String get accountManagerChangePasswordDialogTitle => 'Cambia password';

  @override
  String get accountManagerChangePasswordDialogDescription =>
      'Inserisci la password attuale e la nuova password';

  @override
  String get accountManagerNewPassword => 'Nuova password';

  @override
  String get accountManagerConfirmPassword => 'Conferma password';

  @override
  String get accountManagerChangePasswordButton => 'Cambia password';

  @override
  String get accountManagerDeleteAccountDialogTitle => 'Elimina account';

  @override
  String get accountManagerDeleteAccountDialogDescription =>
      'Sei sicuro di voler eliminare permanentemente il tuo account? Questa azione non può essere annullata.';

  @override
  String get accountManagerDeleteAccountButton => 'Elimina account';

  @override
  String get accountManagerFinalConfirmation => 'Conferma finale';

  @override
  String get accountManagerFinalConfirmationDescription =>
      'Digita DELETE e inserisci la password per confermare l\'eliminazione dell\'account';

  @override
  String get accountManagerTypeDelete => 'Digita DELETE per confermare';

  @override
  String get accountManagerTypeDeleteHint => 'Digita DELETE';

  @override
  String get accountManagerPassword => 'Password';

  @override
  String get followersTitle => 'Follower';

  @override
  String get followersSearchHint => 'Cerca follower...';

  @override
  String get followersNotFound => 'Nessun follower trovato';

  @override
  String get followersFollow => 'Segui';

  @override
  String get followersFollowing => 'Seguendo';

  @override
  String get followingTitle => 'Seguiti';

  @override
  String get followingSearchHint => 'Cerca seguiti...';

  @override
  String get followingNotFound => 'Nessun risultato trovato';

  @override
  String get manageCategoriesTitle => 'Gestisci categorie articoli';

  @override
  String get manageCategoriesNewHint => 'Nome nuova categoria...';

  @override
  String manageCategoriesItemCount(Object count) {
    return '$count articoli';
  }

  @override
  String get manageCategoriesEditTitle => 'Modifica categoria';

  @override
  String get manageCategoriesEditHint => 'Nome categoria';

  @override
  String get manageCategoriesDeleteTitle => 'Elimina categoria';

  @override
  String manageCategoriesDeleteMessage(Object name) {
    return 'Sei sicuro di voler eliminare \"$name\"?';
  }

  @override
  String get manageCategoriesCancel => 'Annulla';

  @override
  String get manageCategoriesSave => 'Salva';

  @override
  String get manageCategoriesDelete => 'Elimina';

  @override
  String get manageCategoriesInfo =>
      'Le categorie ti aiutano a organizzare gli articoli del guardaroba. Gli articoli possono appartenere a più categorie.';

  @override
  String get manageOutfitCategoriesTitle => 'Gestisci categorie outfit';

  @override
  String get helpCenterTitle => 'Centro assistenza';

  @override
  String get helpCenterEmailUs => 'Inviaci un\'email';

  @override
  String get helpCenterFAQTitle => 'Domande frequenti';

  @override
  String get helpCenterFAQ1Question =>
      'Come aggiungo articoli al mio guardaroba?';

  @override
  String get helpCenterFAQ1Answer =>
      'Puoi aggiungere articoli al tuo guardaroba toccando l\'icona della fotocamera nella scheda guardaroba. Scatta una foto del tuo capo di abbigliamento. Quindi inserisci dettagli come categoria, colore e stagione.';

  @override
  String get helpCenterFAQ2Question => 'Come creo un outfit?';

  @override
  String get helpCenterFAQ2Answer =>
      'Per creare un outfit, vai alla sezione Outfit e tocca il pulsante \"Crea nuovo\". Seleziona articoli dal tuo guardaroba e organizzali per creare la combinazione di outfit desiderata.';

  @override
  String get helpCenterFAQ3Question =>
      'Posso modificare o eliminare articoli del guardaroba?';

  @override
  String get helpCenterFAQ3Answer =>
      'Sì, puoi modificare o eliminare articoli del guardaroba toccando l\'articolo nel tuo guardaroba. Seleziona l\'opzione di modifica per modificare i dettagli o l\'opzione di eliminazione per rimuovere l\'articolo.';

  @override
  String get helpCenterFAQ4Question => 'Come condivido i miei outfit?';

  @override
  String get helpCenterFAQ4Answer =>
      'Per condividere i tuoi outfit, apri l\'outfit che vuoi condividere e tocca il pulsante di condivisione. Puoi condividere via email, sui social media o generare un link da condividere con altri.';

  @override
  String get helpCenterFAQ5Question => 'Come gestisco le mie categorie?';

  @override
  String get helpCenterFAQ5Answer =>
      'Puoi gestire le tue categorie nella sezione Impostazioni sotto Categorie guardaroba. Aggiungi, modifica o elimina categorie per organizzare i tuoi articoli come preferisci.';

  @override
  String get helpCenterFAQ6Question => 'Posso rendere privato il mio profilo?';

  @override
  String get helpCenterFAQ6Answer =>
      'Sì, puoi rendere privato il tuo profilo nelle Impostazioni account. Attiva l\'opzione \"Profilo privato\" per controllare chi può vedere il tuo guardaroba e i tuoi outfit.';

  @override
  String get helpCenterFAQ7Question => 'Come reimposto la mia password?';

  @override
  String get helpCenterFAQ7Answer =>
      'Vai alle Impostazioni account e seleziona \"Cambia password\". Puoi anche utilizzare l\'opzione \"Password dimenticata\" nella schermata di accesso per reimpostare via email.';

  @override
  String get helpCenterFAQ8Question => 'Come elimino il mio account?';

  @override
  String get helpCenterFAQ8Answer =>
      'Per eliminare il tuo account, vai alle Impostazioni account e scorri fino alla sezione \"Zona pericolosa\". Seleziona \"Elimina account\" e segui i passaggi di conferma. Questa azione è permanente.';

  @override
  String get notificationsTitle => 'Notifiche';

  @override
  String get notificationsRetry => 'Riprova';

  @override
  String get notificationsLiked => ' ha apprezzato il tuo outfit';

  @override
  String notificationsCommented(String comment) {
    return ' ha commentato: \"$comment\"';
  }

  @override
  String get notificationsFollowed => ' ha iniziato a seguirti';

  @override
  String get notificationsInteracted => ' ha interagito con i tuoi contenuti';

  @override
  String notificationsDaysAgo(int count) {
    return '${count}g fa';
  }

  @override
  String notificationsHoursAgo(int count) {
    return '${count}h fa';
  }

  @override
  String notificationsMinutesAgo(int count) {
    return '${count}m fa';
  }

  @override
  String get notificationsJustNow => 'Proprio ora';

  @override
  String get notificationsRecently => 'Recentemente';

  @override
  String get notificationsErrorMessage => 'Impossibile caricare le notifiche';

  @override
  String get saveOutfitTitle => 'Salva outfit';

  @override
  String get saveOutfitNoDataError =>
      'Nessun dato outfit trovato. Crea prima un outfit.';

  @override
  String get saveOutfitNoDataFound => 'Nessun dato outfit trovato';

  @override
  String get saveOutfitName => 'Nome outfit';

  @override
  String get saveOutfitNameHint => 'es., Look casual venerdì';

  @override
  String get saveOutfitDescription => 'Descrizione (opzionale)';

  @override
  String get saveOutfitDescriptionHint => 'Aggiungi note su questo outfit...';

  @override
  String get saveOutfitSeason => 'Stagione';

  @override
  String get saveOutfitSeasonHint => 'Seleziona stagione';

  @override
  String get saveOutfitCategories => 'Categorie';

  @override
  String saveOutfitItemsCount(int count) {
    return '$count articolo nell\'outfit';
  }

  @override
  String saveOutfitItemsCountPlural(int count) {
    return '$count articoli nell\'outfit';
  }

  @override
  String get saveOutfitSaveButton => 'Salva nel guardaroba';

  @override
  String get editOutfitTitle => 'Dettagli outfit';

  @override
  String get editOutfitLoading => 'Caricamento outfit...';

  @override
  String get editOutfitError => 'Ops! Qualcosa è andato storto';

  @override
  String get editOutfitTryAgain => 'Riprova';

  @override
  String get editOutfitGoBack => 'Torna indietro';

  @override
  String get editOutfitNotFound => 'Outfit non trovato';

  @override
  String get editOutfitNotFoundMessage =>
      'L\'outfit potrebbe essere stato eliminato o non esiste';

  @override
  String get editOutfitNoImage => 'Nessuna immagine outfit';

  @override
  String get editOutfitItemsTitle => 'Articoli in questo outfit';

  @override
  String get editOutfitDetailsTitle => 'Modifica dettagli outfit';

  @override
  String get editOutfitDetailsSubtitle =>
      'Aggiorna le informazioni del tuo outfit';

  @override
  String get editOutfitNameLabel => 'Nome outfit';

  @override
  String get editOutfitNameHint => 'es., Casual estivo';

  @override
  String get editOutfitDescriptionLabel => 'Descrizione';

  @override
  String get editOutfitDescriptionHint =>
      'Outfit perfetto per una giornata estiva casual';

  @override
  String get editOutfitSeasonLabel => 'Stagione';

  @override
  String get editOutfitSeasonHint => 'Seleziona stagione';

  @override
  String get editOutfitErrorName => 'Inserisci un nome per l\'outfit';

  @override
  String get editOutfitErrorCategory => 'Seleziona almeno una categoria';

  @override
  String get editOutfitSuccessSave => 'Outfit aggiornato con successo!';

  @override
  String editOutfitErrorSave(String error) {
    return 'Errore nel salvataggio dell\'outfit: $error';
  }

  @override
  String get editOutfitDeleteDialog => 'Elimina outfit';

  @override
  String editOutfitDeleteMessage(String name) {
    return 'Sei sicuro di voler eliminare \"$name\"?';
  }

  @override
  String get editOutfitDeleteWarning =>
      'Questa azione non può essere annullata.';

  @override
  String get editOutfitDeleting => 'Eliminazione outfit...';

  @override
  String get editOutfitDeleteSuccess => 'Outfit eliminato con successo!';

  @override
  String editOutfitDeleteError(String error) {
    return 'Errore nell\'eliminazione dell\'outfit: $error';
  }

  @override
  String get editOutfitCannotDeleteTitle => 'Impossibile eliminare l\'outfit';

  @override
  String editOutfitCannotDeleteMessage(int count, String posts) {
    return 'Questo outfit è utilizzato in $count $posts.';
  }

  @override
  String editOutfitCannotDeleteInstruction(String posts) {
    return 'Per eliminare questo outfit, devi prima eliminare i $posts che lo utilizzano.';
  }

  @override
  String editOutfitCannotDeleteInfo(String ones) {
    return 'Vai ai tuoi post ed elimina $ones che utilizzano questo outfit.';
  }

  @override
  String get editOutfitPost => 'post';

  @override
  String get editOutfitPosts => 'post';

  @override
  String get editOutfitOne => 'quello';

  @override
  String get editOutfitOnes => 'quelli';

  @override
  String editOutfitWarningUsed(int count, String posts) {
    return 'Questo outfit è utilizzato in $count $posts';
  }

  @override
  String editOutfitWarningDeleteFirst(String posts) {
    return 'Elimina prima i $posts per eliminare questo outfit';
  }

  @override
  String get editOutfitDeleteButton => 'Elimina outfit';

  @override
  String get editOutfitCancelButton => 'Annulla';

  @override
  String get editOutfitSaveButton => 'Salva modifiche';

  @override
  String get editOutfitGoToPostsButton => 'Vai ai post';

  @override
  String get editOutfitLoginRequired =>
      'Effettua il login per visualizzare il tuo profilo';

  @override
  String get editOutfitImageLoading => 'Caricamento immagine...';

  @override
  String get editOutfitImageNotAvailable => 'Immagine non disponibile';

  @override
  String get seasonSpring => 'Primavera';

  @override
  String get seasonSummer => 'Estate';

  @override
  String get seasonFall => 'Autunno';

  @override
  String get seasonWinter => 'Inverno';

  @override
  String get seasonAllSeason => 'Tutte le stagioni';

  @override
  String get outfitDetailsTitle => 'Dettagli outfit';

  @override
  String get outfitDetailsError =>
      'Errore nel caricamento dei dettagli dell\'outfit';

  @override
  String get outfitDetailsDeleteDialog => 'Eliminare l\'outfit?';

  @override
  String get outfitDetailsDeleteMessage =>
      'Sei sicuro di voler eliminare questo outfit?\nQuesta azione non può essere annullata.';

  @override
  String get outfitDetailsDeleteButton => 'Elimina';

  @override
  String get outfitDetailsCancelButton => 'Annulla';

  @override
  String get outfitDetailsShareComingSoon =>
      'Funzionalità di condivisione - Prossimamente';

  @override
  String get outfitDetailsOutfitDeleted => 'Outfit eliminato';

  @override
  String get outfitDetailsShareButton => 'Condividi outfit';

  @override
  String get outfitDetailsDeleteButtonAction => 'Elimina outfit';

  @override
  String get outfitDetailsUnnamedOutfit => 'Outfit senza nome';

  @override
  String get outfitDetailsCreatedDefault => 'Creato il 20 ottobre 2025';

  @override
  String outfitDetailsItemsCount(int count) {
    return 'Articoli ($count)';
  }

  @override
  String get outfitDetailsNoItems => 'Nessun articolo in questo outfit';

  @override
  String get outfitDetailsUnnamedItem => 'Articolo senza nome';

  @override
  String get outfitDetailsUncategorized => 'Non categorizzato';

  @override
  String get createOutfitTitle => 'Crea outfit';

  @override
  String get createOutfitSaveTooltip => 'Salva outfit';

  @override
  String get createOutfitCapturing => 'Cattura outfit...';

  @override
  String get createOutfitAddAtLeastOne =>
      'Aggiungi almeno un articolo all\'outfit';

  @override
  String get createOutfitSaveSuccess => 'Outfit salvato con successo!';

  @override
  String get createOutfitErrorLoading =>
      'Errore nel caricamento degli articoli';

  @override
  String get createOutfitTryAgain => 'Riprova';

  @override
  String get createOutfitZoomIn => 'Ingrandisci';

  @override
  String get createOutfitZoomOut => 'Riduci';

  @override
  String get createOutfitResetSize => 'Ripristina dimensione';

  @override
  String get createOutfitBringToFront => 'Porta in primo piano';

  @override
  String get createOutfitSendToBack => 'Invia in secondo piano';

  @override
  String get createOutfitRemoveFromOutfit => 'Rimuovi dall\'outfit';

  @override
  String get createOutfitAddItems => 'Aggiungi articoli';

  @override
  String createOutfitItemsCount(int count) {
    return '$count articoli';
  }

  @override
  String createOutfitAddedToOutfit(String itemName) {
    return '$itemName aggiunto all\'outfit';
  }

  @override
  String get createOutfitRemoveItemTitle => 'Rimuovi articolo';

  @override
  String get createOutfitRemoveItemMessage =>
      'Rimuovere questo articolo dall\'outfit?';

  @override
  String get createOutfitCancel => 'Annulla';

  @override
  String get createOutfitRemove => 'Rimuovi';

  @override
  String get createOutfitYourItems => 'I tuoi articoli';

  @override
  String createOutfitTotalCount(int count) {
    return '$count totali';
  }

  @override
  String get createOutfitNoItems => 'Nessun articolo nel tuo guardaroba';

  @override
  String get postsDetailsTitle => 'Post';

  @override
  String get postsDetailsMustLoginToLike =>
      'Devi effettuare il login per mettere mi piace ai post!';

  @override
  String postsDetailsLikesCount(int count) {
    return '$count mi piace';
  }

  @override
  String postsDetailsViewAllComments(int count) {
    return 'Visualizza tutti i $count commenti';
  }

  @override
  String get postsDetailsImageNotFound => 'Immagine non trovata';
}
