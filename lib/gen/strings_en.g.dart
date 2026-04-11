///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsCommonEn common = TranslationsCommonEn._(_root);
	late final TranslationsAuthEn auth = TranslationsAuthEn._(_root);
	late final TranslationsRegistrationEn registration = TranslationsRegistrationEn._(_root);
	late final TranslationsNavEn nav = TranslationsNavEn._(_root);
	late final TranslationsGarageEn garage = TranslationsGarageEn._(_root);
	late final TranslationsMaintenanceEn maintenance = TranslationsMaintenanceEn._(_root);
	late final TranslationsProfileEn profile = TranslationsProfileEn._(_root);
	late final TranslationsNotificationsEn notifications = TranslationsNotificationsEn._(_root);
	late final TranslationsMapEn map = TranslationsMapEn._(_root);
	late final TranslationsWeatherWidgetEn weatherWidget = TranslationsWeatherWidgetEn._(_root);
	late final TranslationsCurrencyEn currency = TranslationsCurrencyEn._(_root);
	late final TranslationsValidatorsEn validators = TranslationsValidatorsEn._(_root);
	late final TranslationsWeatherEn weather = TranslationsWeatherEn._(_root);
	late final TranslationsTimeEn time = TranslationsTimeEn._(_root);
}

// Path: common
class TranslationsCommonEn {
	TranslationsCommonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'DriveTrack'
	String get appName => 'DriveTrack';

	/// en: 'OK'
	String get ok => 'OK';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'An unexpected error occurred'
	String get error => 'An unexpected error occurred';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Unknown Vehicle'
	String get unknownVehicle => 'Unknown Vehicle';

	/// en: 'Free'
	String get free => 'Free';

	/// en: 'None'
	String get none => 'None';

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'Settings & Units'
	String get settingsAndUnits => 'Settings & Units';

	/// en: 'Real-time examples'
	String get realTimeExamples => 'Real-time examples';

	/// en: 'Total distance'
	String get totalDistance => 'Total distance';

	/// en: 'Operating temperature'
	String get operatingTemperature => 'Operating temperature';

	/// en: 'No connection. Check your internet and try again.'
	String get networkError => 'No connection. Check your internet and try again.';

	/// en: 'The request took too long. Please try again.'
	String get timeoutError => 'The request took too long. Please try again.';

	/// en: 'Incorrect email or password.'
	String get unauthorizedError => 'Incorrect email or password.';

	/// en: 'The requested resource was not found.'
	String get notFoundError => 'The requested resource was not found.';

	/// en: 'The data entered is not valid. Please review and try again.'
	String get validationError => 'The data entered is not valid. Please review and try again.';

	/// en: 'The server is unavailable. Please try again later.'
	String get serverError => 'The server is unavailable. Please try again later.';

	/// en: 'We could not complete the request. Please try again.'
	String get requestError => 'We could not complete the request. Please try again.';
}

// Path: auth
class TranslationsAuthEn {
	TranslationsAuthEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Welcome Back'
	String get welcomeBack => 'Welcome Back';

	/// en: 'Sign in to continue tracking your vehicles'
	String get signInSubtitle => 'Sign in to continue tracking your vehicles';

	/// en: 'EMAIL ADDRESS'
	String get emailAddress => 'EMAIL ADDRESS';

	/// en: 'john@example.com'
	String get emailPlaceholder => 'john@example.com';

	/// en: 'PASSWORD'
	String get password => 'PASSWORD';

	/// en: 'Forgot Password?'
	String get forgotPassword => 'Forgot Password?';

	/// en: 'Sign In'
	String get signIn => 'Sign In';

	/// en: 'Don't have an account? '
	String get noAccount => 'Don\'t have an account? ';

	/// en: 'Sign Up'
	String get signUp => 'Sign Up';
}

// Path: registration
class TranslationsRegistrationEn {
	TranslationsRegistrationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Create Account'
	String get title => 'Create Account';

	/// en: 'Fill in your details to get started'
	String get subtitle => 'Fill in your details to get started';

	/// en: 'Your intelligent vehicle companion'
	String get appTagline => 'Your intelligent vehicle companion';

	/// en: 'FULL NAME'
	String get fullName => 'FULL NAME';

	/// en: 'John Doe'
	String get fullNamePlaceholder => 'John Doe';

	/// en: 'PHONE NUMBER'
	String get phoneNumber => 'PHONE NUMBER';

	/// en: '+1 234 567 8900'
	String get phonePlaceholder => '+1 234 567 8900';

	/// en: '10–15 digits, including country code'
	String get phoneHint => '10–15 digits, including country code';

	/// en: 'DATE OF BIRTH'
	String get dateOfBirth => 'DATE OF BIRTH';

	/// en: 'YYYY-MM-DD'
	String get datePlaceholder => 'YYYY-MM-DD';

	/// en: 'Min. 8 characters'
	String get passwordPlaceholder => 'Min. 8 characters';

	/// en: 'Create Account'
	String get createAccount => 'Create Account';

	/// en: 'Welcome to DriveTrack!'
	String get welcomeSuccess => 'Welcome to DriveTrack!';

	/// en: 'Already have an account? '
	String get alreadyHaveAccount => 'Already have an account? ';

	/// en: 'Weak'
	String get passwordWeak => 'Weak';

	/// en: 'Fair'
	String get passwordFair => 'Fair';

	/// en: 'Strong'
	String get passwordStrong => 'Strong';

	/// en: '8+ characters'
	String get passwordCheck8Chars => '8+ characters';

	/// en: 'Uppercase'
	String get passwordCheckUppercase => 'Uppercase';

	/// en: 'Number'
	String get passwordCheckNumber => 'Number';
}

// Path: nav
class TranslationsNavEn {
	TranslationsNavEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Garage'
	String get garage => 'Garage';

	/// en: 'History'
	String get history => 'History';

	/// en: 'Map'
	String get map => 'Map';

	/// en: 'Profile'
	String get profile => 'Profile';
}

// Path: garage
class TranslationsGarageEn {
	TranslationsGarageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Your Vehicles'
	String get yourVehicles => 'Your Vehicles';

	/// en: 'Add Vehicle'
	String get addVehicle => 'Add Vehicle';

	/// en: 'Vehicle added successfully'
	String get vehicleAdded => 'Vehicle added successfully';

	/// en: 'Vehicle updated successfully'
	String get vehicleUpdated => 'Vehicle updated successfully';

	/// en: 'Vehicle removed'
	String get vehicleRemoved => 'Vehicle removed';

	/// en: 'Error adding vehicle: {error}'
	String get errorAddingVehicle => 'Error adding vehicle: {error}';

	/// en: 'Error updating vehicle: {error}'
	String get errorUpdatingVehicle => 'Error updating vehicle: {error}';

	/// en: 'Error removing vehicle: {error}'
	String get errorRemovingVehicle => 'Error removing vehicle: {error}';

	/// en: 'Service logged for {vehicleName}'
	String get serviceLogged => 'Service logged for {vehicleName}';

	/// en: 'Service record updated'
	String get serviceRecordUpdated => 'Service record updated';

	/// en: 'Remove Vehicle'
	String get removeVehicleTitle => 'Remove Vehicle';

	/// en: 'Are you sure you want to remove "{vehicleName}" from your garage? This action will also delete all associated maintenance records.'
	String get removeVehicleMessage => 'Are you sure you want to remove "{vehicleName}" from your garage? This action will also delete all associated maintenance records.';

	/// en: 'Oops! Sync Failed'
	String get errorSyncFailed => 'Oops! Sync Failed';

	/// en: 'We could not load your vehicles from the garage. Please check your connection.'
	String get errorSyncMessage => 'We could not load your vehicles from the garage. Please check your connection.';

	/// en: '(one) {Vehicle} (other) {Vehicles}'
	String vehicleCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'Vehicle',
		other: 'Vehicles',
	);

	/// en: 'Your Vehicle'
	String get yourVehicle => 'Your Vehicle';

	/// en: 'Plate not set'
	String get plateNotSet => 'Plate not set';

	/// en: 'Overall Health'
	String get overallHealth => 'Overall Health';

	/// en: 'Total Spent'
	String get totalSpent => 'Total Spent';

	/// en: 'Services'
	String get services => 'Services';

	/// en: 'Last: {title} ({time})'
	String get lastService => 'Last: {title} ({time})';

	/// en: 'Services Due'
	String get servicesDue => 'Services Due';

	/// en: 'No records found'
	String get noRecordsFound => 'No records found';

	/// en: 'Keep track of your vehicle's health by logging your first service.'
	String get noRecordsMessage => 'Keep track of your vehicle\'s health\nby logging your first service.';

	/// en: 'Your Garage is Empty'
	String get emptyGarageTitle => 'Your Garage is Empty';

	/// en: 'Tap the button below to add your first vehicle and start tracking its performance.'
	String get emptyGarageMessage => 'Tap the button below to add your first vehicle and start tracking its performance.';

	/// en: 'Delete Service Record'
	String get deleteServiceTitle => 'Delete Service Record';

	/// en: 'Are you sure you want to delete this record for "{title}"? This action cannot be undone.'
	String get deleteServiceMessage => 'Are you sure you want to delete this record for "{title}"? This action cannot be undone.';

	/// en: 'Edit Vehicle'
	String get editVehicle => 'Edit Vehicle';

	/// en: 'Remove Vehicle'
	String get removeVehicle => 'Remove Vehicle';

	/// en: 'Vehicle Type'
	String get vehicleType => 'Vehicle Type';

	/// en: 'Vehicles'
	String get vehicles => 'Vehicles';

	/// en: 'Good morning,'
	String get goodMorning => 'Good morning,';

	/// en: 'My Garage'
	String get myGarage => 'My Garage';

	/// en: 'Avg Health'
	String get avgHealth => 'Avg Health';

	/// en: 'Total Miles'
	String get totalMiles => 'Total Miles';

	/// en: 'Alerts'
	String get alerts => 'Alerts';

	late final TranslationsGarageAddVehicleFormEn addVehicleForm = TranslationsGarageAddVehicleFormEn._(_root);
	late final TranslationsGarageVehicleTypesEn vehicleTypes = TranslationsGarageVehicleTypesEn._(_root);

	/// en: 'Vehicle Health'
	String get vehicleHealth => 'Vehicle Health';

	/// en: 'Limit {mileage} mi'
	String get limitMileage => 'Limit {mileage} mi';

	/// en: 'Healthy'
	String get statusHealthy => 'Healthy';

	/// en: 'Needs Service'
	String get statusNeedsService => 'Needs Service';

	/// en: 'Critical'
	String get statusCritical => 'Critical';

	/// en: 'LAST SERVICE'
	String get recentServiceLabel => 'LAST SERVICE';

	/// en: 'RECENT MAINTENANCE'
	String get recentMaintenance => 'RECENT MAINTENANCE';

	/// en: '(one) {1 record} (zero) {0 records} (other) {{count} records}'
	String recordsCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '1 record',
		zero: '0 records',
		other: '{count} records',
	);

	/// en: 'Total Miles'
	String get totalDistanceMiles => 'Total Miles';

	/// en: 'Total Kilometers'
	String get totalDistanceKm => 'Total Kilometers';

	/// en: 'Notifications, {count} unread'
	String get notificationsUnread => 'Notifications, {count} unread';

	/// en: 'Notifications, no new updates'
	String get notificationsNone => 'Notifications, no new updates';
}

// Path: maintenance
class TranslationsMaintenanceEn {
	TranslationsMaintenanceEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Maintenance'
	String get title => 'Maintenance';

	/// en: 'Maintenance Log'
	String get logTitle => 'Maintenance Log';

	/// en: 'Full service history for your vehicles'
	String get logSubtitle => 'Full service history for your vehicles';

	/// en: 'All Vehicles'
	String get allVehicles => 'All Vehicles';

	/// en: 'Add Service'
	String get addService => 'Add Service';

	/// en: 'Service added successfully'
	String get serviceAdded => 'Service added successfully';

	/// en: 'Service record updated'
	String get serviceUpdated => 'Service record updated';

	/// en: 'Service record removed'
	String get serviceRemoved => 'Service record removed';

	/// en: 'Error adding service: {error}'
	String get errorAddingService => 'Error adding service: {error}';

	/// en: 'Error updating record: {error}'
	String get errorUpdatingService => 'Error updating record: {error}';

	/// en: 'Error removing record: {error}'
	String get errorRemovingService => 'Error removing record: {error}';

	/// en: 'Remove Entry?'
	String get removeEntryTitle => 'Remove Entry?';

	/// en: 'Are you sure you want to remove the record for "{title}"? This action cannot be undone.'
	String get removeEntryMessage => 'Are you sure you want to remove the record for "{title}"? This action cannot be undone.';

	/// en: 'Something went wrong'
	String get errorTitle => 'Something went wrong';

	/// en: 'We had trouble fetching your data. Please check your connection or try again.'
	String get errorMessage => 'We had trouble fetching your data. Please check your connection or try again.';

	/// en: 'Total Spent'
	String get totalSpent => 'Total Spent';

	/// en: 'Services'
	String get servicesLabel => 'Services';

	/// en: 'Vehicles'
	String get vehiclesLabel => 'Vehicles';

	/// en: 'No records found'
	String get noRecordsTitle => 'No records found';

	/// en: 'Try adjusting your filters or search to find what you're looking for.'
	String get noRecordsFiltering => 'Try adjusting your filters or search to find what you\'re looking for.';

	/// en: 'Start tracking your vehicle's maintenance history to keep it in peak performance.'
	String get noRecordsEmpty => 'Start tracking your vehicle\'s maintenance history to keep it in peak performance.';

	/// en: 'No service records yet'
	String get noServiceRecords => 'No service records yet';

	/// en: 'Add Service Record'
	String get addServiceRecord => 'Add Service Record';

	/// en: 'Log a maintenance activity'
	String get logActivity => 'Log a maintenance activity';

	/// en: 'Vehicle'
	String get vehicle => 'Vehicle';

	/// en: 'Service Description'
	String get serviceDescription => 'Service Description';

	/// en: 'Date'
	String get date => 'Date';

	/// en: 'Cost (USD)'
	String get costUsd => 'Cost (USD)';

	/// en: 'Mileage'
	String get mileage => 'Mileage';

	/// en: 'Category'
	String get category => 'Category';

	/// en: 'Notes'
	String get notes => 'Notes';

	/// en: 'Additional notes (optional)'
	String get notesHint => 'Additional notes (optional)';

	/// en: 'Service'
	String get service => 'Service';

	/// en: 'Edit Entry'
	String get editEntry => 'Edit Entry';

	/// en: 'Delete Entry'
	String get deleteEntry => 'Delete Entry';

	/// en: 'Total Investment'
	String get totalInvestment => 'Total Investment';

	/// en: 'Professional Service'
	String get professionalService => 'Professional Service';

	/// en: 'No additional notes provided for this service entry.'
	String get noNotes => 'No additional notes provided for this service entry.';

	/// en: 'e.g., Oil Change, Tire Rotation...'
	String get servicePlaceholder => 'e.g., Oil Change, Tire Rotation...';

	/// en: 'e.g., 42000'
	String get mileagePlaceholder => 'e.g., 42000';

	/// en: 'Additional details...'
	String get detailsPlaceholder => 'Additional details...';

	/// en: 'Update Record'
	String get btnUpdate => 'Update Record';

	/// en: 'Save Service Record'
	String get btnSave => 'Save Service Record';

	/// en: 'Record Updated'
	String get btnUpdated => 'Record Updated';

	/// en: 'Record Saved'
	String get btnSaved => 'Record Saved';

	/// en: 'RECORD PREVIEW'
	String get recordPreview => 'RECORD PREVIEW';

	/// en: 'Untitled Service'
	String get untitledService => 'Untitled Service';

	/// en: 'Unknown'
	String get unknownVehicle => 'Unknown';

	/// en: 'COST'
	String get costLabel => 'COST';

	/// en: 'Free'
	String get costFree => 'Free';

	/// en: 'MILEAGE'
	String get mileageLabel => 'MILEAGE';

	/// en: 'SERVICE NOTES'
	String get serviceNotesLabel => 'SERVICE NOTES';

	/// en: 'General'
	String get categoryGeneral => 'General';

	/// en: 'History'
	String get historyLabel => 'History';

	late final TranslationsMaintenanceCategoriesEn categories = TranslationsMaintenanceCategoriesEn._(_root);
}

// Path: profile
class TranslationsProfileEn {
	TranslationsProfileEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Vehicle Preferences'
	String get vehiclePreferences => 'Vehicle Preferences';

	/// en: 'Favorite Vehicles'
	String get favoriteVehicles => 'Favorite Vehicles';

	/// en: '(one) {1 favorite saved} (zero) {No favorites saved} (other) {{n} favorites saved}'
	String favoritesSaved({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '1 favorite saved',
		zero: 'No favorites saved',
		other: '{n} favorites saved',
	);

	/// en: 'No favorite vehicles yet'
	String get noFavorites => 'No favorite vehicles yet';

	/// en: 'Notifications'
	String get notifications => 'Notifications';

	/// en: 'Configure your alerts'
	String get configureAlerts => 'Configure your alerts';

	/// en: 'Push Notifications'
	String get pushNotifications => 'Push Notifications';

	/// en: 'Service Reminders'
	String get serviceReminders => 'Service Reminders';

	/// en: 'Critical Alerts'
	String get criticalAlerts => 'Critical Alerts';

	/// en: 'Privacy & Security'
	String get privacySecurity => 'Privacy & Security';

	/// en: '2FA active · Protected'
	String get securitySubtitleActive => '2FA active · Protected';

	/// en: 'Password, 2FA'
	String get securitySubtitleDefault => 'Password, 2FA';

	/// en: 'Password Reset'
	String get passwordReset => 'Password Reset';

	/// en: 'Last changed 30 days ago'
	String get passwordLastChanged => 'Last changed 30 days ago';

	/// en: 'Reset'
	String get reset => 'Reset';

	/// en: 'Two-Factor Auth (2FA)'
	String get twoFactor => 'Two-Factor Auth (2FA)';

	/// en: '● Enabled'
	String get twoFactorEnabled => '● Enabled';

	/// en: '○ Disabled — tap to enable'
	String get twoFactorDisabled => '○ Disabled — tap to enable';

	/// en: 'App Settings'
	String get appSettings => 'App Settings';

	/// en: 'Theme: {theme} · Language: {language}'
	String get appSettingsSubtitle => 'Theme: {theme} · Language: {language}';

	/// en: 'Dark'
	String get themeDark => 'Dark';

	/// en: 'Light'
	String get themeLight => 'Light';

	/// en: 'Theme'
	String get theme => 'Theme';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Feedback & Support'
	String get feedbackSupport => 'Feedback & Support';

	/// en: 'Rate DriveTrack'
	String get rateDriveTrack => 'Rate DriveTrack';

	/// en: 'Share your experience'
	String get shareExperience => 'Share your experience';

	/// en: 'Help & Support'
	String get helpSupport => 'Help & Support';

	/// en: 'FAQs, Contact us'
	String get faqsContact => 'FAQs, Contact us';

	/// en: 'FAQs'
	String get faqs => 'FAQs';

	/// en: 'Chat Support'
	String get chatSupport => 'Chat Support';

	/// en: 'Sign Out'
	String get signOut => 'Sign Out';

	/// en: 'Crafted with ❤️ for Drivers worldwide'
	String get footerTagline => 'Crafted with ❤️ for Drivers worldwide';

	/// en: 'Driver'
	String get driver => 'Driver';

	/// en: 'Active Status'
	String get activeStatus => 'Active Status';

	/// en: 'Member since {year}'
	String get memberSince => 'Member since {year}';

	/// en: 'Vehicles'
	String get statsVehicles => 'Vehicles';

	/// en: 'linked'
	String get statsVehiclesSub => 'linked';

	/// en: 'Services'
	String get statsServices => 'Services';

	/// en: 'logged'
	String get statsServicesSub => 'logged';

	/// en: 'Saved'
	String get statsSaved => 'Saved';

	/// en: 'in costs'
	String get statsSavedSub => 'in costs';

	/// en: 'Unit System'
	String get systemOfUnits => 'Unit System';

	/// en: 'Metric'
	String get metric => 'Metric';

	/// en: 'Imperial'
	String get imperial => 'Imperial';
}

// Path: notifications
class TranslationsNotificationsEn {
	TranslationsNotificationsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Notifications'
	String get title => 'Notifications';

	/// en: '{unread} unread · {total} total'
	String get unreadSummary => '{unread} unread · {total} total';

	/// en: 'Mark all read'
	String get markAllRead => 'Mark all read';

	/// en: 'All'
	String get filterAll => 'All';

	/// en: 'Unread'
	String get filterUnread => 'Unread';

	/// en: 'Warnings'
	String get filterWarnings => 'Warnings';

	/// en: 'Success'
	String get filterSuccess => 'Success';

	/// en: 'Weather'
	String get filterWeather => 'Weather';

	/// en: 'All'
	String get summaryAll => 'All';

	/// en: 'Warnings'
	String get summaryWarnings => 'Warnings';

	/// en: 'Success'
	String get summarySuccess => 'Success';

	/// en: 'Weather'
	String get summaryWeather => 'Weather';

	/// en: 'All caught up!'
	String get emptyTitle => 'All caught up!';

	/// en: 'No notifications in this category'
	String get emptySubtitle => 'No notifications in this category';

	/// en: 'Error loading notifications'
	String get errorLoading => 'Error loading notifications';

	/// en: 'Check your connection and try again.'
	String get errorHint => 'Check your connection and try again.';

	/// en: 'Retry'
	String get retryButton => 'Retry';

	/// en: 'Read all'
	String get markAllReadButton => 'Read all';

	/// en: 'No notifications'
	String get emptyPageTitle => 'No notifications';

	/// en: 'When you receive notifications they will appear here.'
	String get emptyPageSubtitle => 'When you receive notifications they will appear here.';

	/// en: 'Warning'
	String get typeWarning => 'Warning';

	/// en: 'Success'
	String get typeSuccess => 'Success';

	/// en: 'Weather'
	String get typeWeather => 'Weather';

	/// en: 'Info'
	String get typeInfo => 'Info';

	/// en: 'Error'
	String get typeError => 'Error';

	/// en: 'Info'
	String get filterInfo => 'Info';

	/// en: 'Info'
	String get summaryInfo => 'Info';

	late final TranslationsNotificationsMocksEn mocks = TranslationsNotificationsMocksEn._(_root);
}

// Path: map
class TranslationsMapEn {
	TranslationsMapEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Explore Nearby'
	String get exploreNearby => 'Explore Nearby';

	/// en: 'Service Map'
	String get title => 'Service Map';

	/// en: 'Live'
	String get live => 'Live';

	/// en: 'Search workshops, gas stations...'
	String get searchHint => 'Search workshops, gas stations...';

	/// en: 'All'
	String get filterAll => 'All';

	/// en: 'Workshops'
	String get filterWorkshops => 'Workshops';

	/// en: 'Gas Stations'
	String get filterGasStations => 'Gas Stations';

	/// en: 'You'
	String get you => 'You';

	/// en: 'CITY PARK'
	String get cityPark => 'CITY PARK';

	/// en: 'Nearby Results'
	String get nearbyResults => 'Nearby Results';

	/// en: 'Swipe up to see all options'
	String get swipeUp => 'Swipe up to see all options';

	/// en: 'Open Now'
	String get openNow => 'Open Now';

	/// en: 'Closed'
	String get closed => 'Closed';

	/// en: 'Navigate'
	String get navigate => 'Navigate';

	/// en: 'Navigating to {name}...'
	String get navigatingTo => 'Navigating to {name}...';

	/// en: 'Calling {phone}...'
	String get calling => 'Calling {phone}...';

	/// en: '{count} locations found'
	String get locationsFound => '{count} locations found';

	/// en: 'Specialties'
	String get specialties => 'Specialties';

	/// en: 'My Location'
	String get myLocation => 'My Location';

	/// en: 'Loading map...'
	String get loadingMap => 'Loading map...';

	/// en: 'Could not load locations'
	String get errorLoadingMap => 'Could not load locations';

	/// en: 'No results found'
	String get noResults => 'No results found';

	/// en: 'Zoom In'
	String get zoomIn => 'Zoom In';

	/// en: 'Zoom Out'
	String get zoomOut => 'Zoom Out';

	/// en: 'The map server is overloaded. Please retry in a few seconds.'
	String get overpassError => 'The map server is overloaded. Please retry in a few seconds.';

	/// en: 'Search this area'
	String get searchThisArea => 'Search this area';

	/// en: 'Searching for GPS location... Make sure location is enabled on your device.'
	String get gpsSearching => 'Searching for GPS location... Make sure location is enabled on your device.';
}

// Path: weatherWidget
class TranslationsWeatherWidgetEn {
	TranslationsWeatherWidgetEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'WEATHER ALERT'
	String get alert => 'WEATHER ALERT';

	/// en: '{weather} · {temp}'
	String get condition => '{weather} · {temp}';

	/// en: '{value}%'
	String get humidity => '{value}%';

	/// en: 'Getting weather...'
	String get loading => 'Getting weather...';

	/// en: 'Weather unavailable'
	String get errorTitle => 'Weather unavailable';

	/// en: 'Tap to retry'
	String get errorRetry => 'Tap to retry';

	/// en: 'Approximate location'
	String get fallbackLocation => 'Approximate location';

	/// en: 'Updated {time}'
	String get lastUpdated => 'Updated {time}';

	late final TranslationsWeatherWidgetConditionsEn conditions = TranslationsWeatherWidgetConditionsEn._(_root);
	late final TranslationsWeatherWidgetRecommendationsEn recommendations = TranslationsWeatherWidgetRecommendationsEn._(_root);
}

// Path: currency
class TranslationsCurrencyEn {
	TranslationsCurrencyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Currency Converter'
	String get title => 'Currency Converter';

	/// en: 'Refresh Rate'
	String get refreshTooltip => 'Refresh Rate';

	/// en: 'Amount ({code})'
	String get amountLabel => 'Amount ({code})';

	/// en: 'Swap Currencies'
	String get swapTooltip => 'Swap Currencies';

	/// en: 'Converted Amount'
	String get convertedAmount => 'Converted Amount';

	/// en: 'Rate: 1 {from} = {rate} {to}'
	String get rateLabel => 'Rate: 1 {from} = {rate} {to}';

	/// en: 'Failed to load exchange rates'
	String get errorLoad => 'Failed to load exchange rates';

	/// en: 'Try Again'
	String get tryAgain => 'Try Again';

	/// en: 'CURRENCY CONVERTER'
	String get converterLabel => 'CURRENCY CONVERTER';

	/// en: 'Refresh Rate'
	String get refreshRate => 'Refresh Rate';

	/// en: 'Swap Currencies'
	String get swapCurrencies => 'Swap Currencies';

	/// en: 'Rate: 1 {from} = {rate} {to}'
	String get rateDesc => 'Rate: 1 {from} = {rate} {to}';

	/// en: 'Failed to load exchange rates'
	String get errorLoadingRates => 'Failed to load exchange rates';
}

// Path: validators
class TranslationsValidatorsEn {
	TranslationsValidatorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '{field} is required'
	String get requiredParams => '{field} is required';

	/// en: '{field} cannot be empty'
	String get notEmptyParams => '{field} cannot be empty';

	/// en: '{field} must be at least {min}'
	String get minParams => '{field} must be at least {min}';

	/// en: '{field} cannot exceed {max}'
	String get maxParams => '{field} cannot exceed {max}';

	/// en: 'License plate is required'
	String get plateRequired => 'License plate is required';

	/// en: 'Plate is too short'
	String get plateTooShort => 'Plate is too short';

	/// en: 'Plate is too long'
	String get plateTooLong => 'Plate is too long';

	/// en: 'Must be a valid number'
	String get numberRequired => 'Must be a valid number';

	/// en: 'Email is required'
	String get emailRequired => 'Email is required';

	/// en: 'Enter a valid email address'
	String get emailInvalid => 'Enter a valid email address';

	/// en: 'Password is required'
	String get passwordRequired => 'Password is required';

	/// en: 'Password must be at least 8 characters'
	String get passwordLength => 'Password must be at least 8 characters';

	/// en: 'Must contain at least one uppercase letter'
	String get passwordUppercase => 'Must contain at least one uppercase letter';

	/// en: 'Must contain at least one number'
	String get passwordNumber => 'Must contain at least one number';

	/// en: 'Full name is required'
	String get nameRequired => 'Full name is required';

	/// en: 'Name must be at least 3 characters'
	String get nameLength => 'Name must be at least 3 characters';

	/// en: 'Phone number is required'
	String get phoneRequired => 'Phone number is required';

	/// en: 'Phone must be 10–15 digits'
	String get phoneLength => 'Phone must be 10–15 digits';

	/// en: 'Date is required'
	String get dateRequired => 'Date is required';

	/// en: 'You must be at least 16 years old'
	String get ageRequirement => 'You must be at least 16 years old';

	/// en: 'Invalid date format'
	String get invalidDateFormat => 'Invalid date format';
}

// Path: weather
class TranslationsWeatherEn {
	TranslationsWeatherEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'WEATHER ALERT'
	String get alert => 'WEATHER ALERT';

	/// en: 'Weather unavailable'
	String get unavailable => 'Weather unavailable';

	/// en: 'Tap to retry'
	String get tapToRetry => 'Tap to retry';

	late final TranslationsWeatherConditionsEn conditions = TranslationsWeatherConditionsEn._(_root);
	late final TranslationsWeatherRecommendationsEn recommendations = TranslationsWeatherRecommendationsEn._(_root);
}

// Path: time
class TranslationsTimeEn {
	TranslationsTimeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Now'
	String get now => 'Now';

	/// en: 'Today'
	String get today => 'Today';

	/// en: '{n} min ago'
	String get minutesAgo => '{n} min ago';

	/// en: '{n}h ago'
	String get hoursAgo => '{n}h ago';

	/// en: '{n}d ago'
	String get daysAgo => '{n}d ago';

	/// en: '{n}m ago'
	String get monthsAgo => '{n}m ago';

	/// en: '{n}y ago'
	String get yearsAgo => '{n}y ago';
}

// Path: garage.addVehicleForm
class TranslationsGarageAddVehicleFormEn {
	TranslationsGarageAddVehicleFormEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add Vehicle'
	String get titleAdd => 'Add Vehicle';

	/// en: 'Update Vehicle'
	String get titleUpdate => 'Update Vehicle';

	/// en: 'Link a new vehicle to your garage'
	String get subtitle => 'Link a new vehicle to your garage';

	/// en: 'Brand / Make'
	String get brandLabel => 'Brand / Make';

	/// en: 'Select brand...'
	String get brandHint => 'Select brand...';

	/// en: 'Model'
	String get modelLabel => 'Model';

	/// en: 'e.g., Camry, Civic, F-150'
	String get modelHintCar => 'e.g., Camry, Civic, F-150';

	/// en: 'e.g., CBR 600RR, R1, Ninja'
	String get modelHintMoto => 'e.g., CBR 600RR, R1, Ninja';

	/// en: 'Year'
	String get yearLabel => 'Year';

	/// en: 'Select year...'
	String get yearHint => 'Select year...';

	/// en: 'License Plate'
	String get plateLabel => 'License Plate';

	/// en: 'e.g., ABC-1234'
	String get plateHint => 'e.g., ABC-1234';

	/// en: 'Letters, numbers, and hyphens only'
	String get plateSubHint => 'Letters, numbers, and hyphens only';

	/// en: 'Starting Mileage (mi)'
	String get mileageLabel => 'Starting Mileage (mi)';

	/// en: 'e.g., 25000'
	String get mileageHint => 'e.g., 25000';

	/// en: 'Current odometer reading'
	String get mileageSubHint => 'Current odometer reading';

	/// en: 'Save Vehicle'
	String get btnSave => 'Save Vehicle';

	/// en: 'Update Vehicle'
	String get btnUpdate => 'Update Vehicle';

	/// en: 'Vehicle Saved'
	String get btnSaved => 'Vehicle Saved';

	/// en: 'Vehicle Updated'
	String get btnUpdated => 'Vehicle Updated';

	/// en: 'Cancel'
	String get btnCancel => 'Cancel';
}

// Path: garage.vehicleTypes
class TranslationsGarageVehicleTypesEn {
	TranslationsGarageVehicleTypesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Car'
	String get car => 'Car';

	/// en: 'Motorcycle'
	String get motorcycle => 'Motorcycle';
}

// Path: maintenance.categories
class TranslationsMaintenanceCategoriesEn {
	TranslationsMaintenanceCategoriesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'General'
	String get general => 'General';

	/// en: 'Fluid Service'
	String get fluidService => 'Fluid Service';

	/// en: 'Wear & Tear'
	String get wearAndTear => 'Wear & Tear';

	/// en: 'Inspection'
	String get inspection => 'Inspection';

	/// en: 'Cosmetic'
	String get cosmetic => 'Cosmetic';

	/// en: 'Electrical'
	String get electrical => 'Electrical';
}

// Path: notifications.mocks
class TranslationsNotificationsMocksEn {
	TranslationsNotificationsMocksEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsNotificationsMocksN1En n1 = TranslationsNotificationsMocksN1En._(_root);
	late final TranslationsNotificationsMocksN2En n2 = TranslationsNotificationsMocksN2En._(_root);
	late final TranslationsNotificationsMocksN3En n3 = TranslationsNotificationsMocksN3En._(_root);
	late final TranslationsNotificationsMocksN4En n4 = TranslationsNotificationsMocksN4En._(_root);
	late final TranslationsNotificationsMocksN5En n5 = TranslationsNotificationsMocksN5En._(_root);
	late final TranslationsNotificationsMocksN6En n6 = TranslationsNotificationsMocksN6En._(_root);
	late final TranslationsNotificationsMocksN7En n7 = TranslationsNotificationsMocksN7En._(_root);
	late final TranslationsNotificationsMocksN8En n8 = TranslationsNotificationsMocksN8En._(_root);
}

// Path: weatherWidget.conditions
class TranslationsWeatherWidgetConditionsEn {
	TranslationsWeatherWidgetConditionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Clear'
	String get clear => 'Clear';

	/// en: 'Cloudy'
	String get clouds => 'Cloudy';

	/// en: 'Rainy'
	String get rain => 'Rainy';

	/// en: 'Drizzle'
	String get drizzle => 'Drizzle';

	/// en: 'Thunderstorm'
	String get thunderstorm => 'Thunderstorm';

	/// en: 'Snowing'
	String get snow => 'Snowing';

	/// en: 'Foggy'
	String get fog => 'Foggy';

	/// en: 'Extreme weather'
	String get extreme => 'Extreme weather';

	/// en: 'Variable weather'
	String get unknown => 'Variable weather';
}

// Path: weatherWidget.recommendations
class TranslationsWeatherWidgetRecommendationsEn {
	TranslationsWeatherWidgetRecommendationsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '⚠️ Extreme heat. Stay hydrated and check engine cooling system.'
	String get extremeHeat => '⚠️ Extreme heat. Stay hydrated and check engine cooling system.';

	/// en: 'Stay hydrated. Make sure air conditioning is working properly.'
	String get stayHydrated => 'Stay hydrated. Make sure air conditioning is working properly.';

	/// en: '⚠️ Below freezing. Warm up engine before driving and check antifreeze.'
	String get freezing => '⚠️ Below freezing. Warm up engine before driving and check antifreeze.';

	/// en: 'Bundle up. Check battery health and warm up engine briefly.'
	String get coldWeather => 'Bundle up. Check battery health and warm up engine briefly.';

	/// en: 'Reduce speed by 30% and increase following distance. Enable headlights.'
	String get rainyConditions => 'Reduce speed by 30% and increase following distance. Enable headlights.';

	/// en: '⚠️ Thunderstorm alert. Avoid driving if possible. Stay inside vehicle.'
	String get thunderstorm => '⚠️ Thunderstorm alert. Avoid driving if possible. Stay inside vehicle.';

	/// en: '⚠️ Snow conditions. Use chains and drastically reduce speed.'
	String get snowConditions => '⚠️ Snow conditions. Use chains and drastically reduce speed.';

	/// en: 'Use low beams. Reduce speed and maintain extra following distance.'
	String get foggyConditions => 'Use low beams. Reduce speed and maintain extra following distance.';

	/// en: 'Strong wind detected. Grip the wheel firmly, especially on bridges.'
	String get strongWind => 'Strong wind detected. Grip the wheel firmly, especially on bridges.';

	/// en: 'Extreme conditions. Avoid driving and seek safe shelter.'
	String get extremeWeather => 'Extreme conditions. Avoid driving and seek safe shelter.';

	/// en: 'Stable driving conditions. Have a safe trip!'
	String get kDefault => 'Stable driving conditions. Have a safe trip!';
}

// Path: weather.conditions
class TranslationsWeatherConditionsEn {
	TranslationsWeatherConditionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Clear'
	String get clear => 'Clear';

	/// en: 'Cloudy'
	String get cloudy => 'Cloudy';

	/// en: 'Rainy'
	String get rainy => 'Rainy';

	/// en: 'Drizzle'
	String get drizzle => 'Drizzle';

	/// en: 'Storm'
	String get storm => 'Storm';

	/// en: 'Snow'
	String get snow => 'Snow';

	/// en: 'Foggy'
	String get foggy => 'Foggy';

	/// en: 'Extreme'
	String get extreme => 'Extreme';

	/// en: 'Variable'
	String get variable => 'Variable';
}

// Path: weather.recommendations
class TranslationsWeatherRecommendationsEn {
	TranslationsWeatherRecommendationsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Extreme heat. Stay hydrated and check engine cooling system.'
	String get extremeHeat => 'Extreme heat. Stay hydrated and check engine cooling system.';

	/// en: 'Stay hydrated. Make sure air conditioning is working properly.'
	String get stayHydrated => 'Stay hydrated. Make sure air conditioning is working properly.';

	/// en: 'Below freezing. Warm up engine before driving and check antifreeze.'
	String get freezing => 'Below freezing. Warm up engine before driving and check antifreeze.';

	/// en: 'Bundle up. Check battery health and warm up engine briefly.'
	String get coldWeather => 'Bundle up. Check battery health and warm up engine briefly.';

	/// en: 'Reduce speed by 30% and increase following distance. Enable headlights.'
	String get rainyConditions => 'Reduce speed by 30% and increase following distance. Enable headlights.';

	/// en: 'Thunderstorm alert. Avoid driving if possible. Stay inside vehicle.'
	String get thunderstorm => 'Thunderstorm alert. Avoid driving if possible. Stay inside vehicle.';

	/// en: 'Snow conditions. Use chains and drastically reduce speed.'
	String get snowConditions => 'Snow conditions. Use chains and drastically reduce speed.';

	/// en: 'Use low beams. Reduce speed and maintain extra following distance.'
	String get foggyConditions => 'Use low beams. Reduce speed and maintain extra following distance.';

	/// en: 'Strong wind detected. Grip the wheel firmly, especially on bridges.'
	String get strongWind => 'Strong wind detected. Grip the wheel firmly, especially on bridges.';

	/// en: 'Extreme conditions. Avoid driving and seek safe shelter.'
	String get extremeWeather => 'Extreme conditions. Avoid driving and seek safe shelter.';

	/// en: 'Stable driving conditions. Have a safe trip!'
	String get stable => 'Stable driving conditions. Have a safe trip!';
}

// Path: notifications.mocks.n1
class TranslationsNotificationsMocksN1En {
	TranslationsNotificationsMocksN1En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Low tire pressure detected'
	String get title => 'Low tire pressure detected';

	/// en: 'Rear left tire is at 28 PSI. Recommended: 32 PSI.'
	String get body => 'Rear left tire is at 28 PSI. Recommended: 32 PSI.';

	/// en: '2 mins ago'
	String get time => '2 mins ago';

	/// en: 'Check Tires'
	String get action => 'Check Tires';
}

// Path: notifications.mocks.n2
class TranslationsNotificationsMocksN2En {
	TranslationsNotificationsMocksN2En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Heavy rain expected'
	String get title => 'Heavy rain expected';

	/// en: 'Severe thunderstorm warning in your area. Avoid driving if possible.'
	String get body => 'Severe thunderstorm warning in your area. Avoid driving if possible.';

	/// en: '1 hour ago'
	String get time => '1 hour ago';

	/// en: 'View Map'
	String get action => 'View Map';
}

// Path: notifications.mocks.n3
class TranslationsNotificationsMocksN3En {
	TranslationsNotificationsMocksN3En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Oil change due soon'
	String get title => 'Oil change due soon';

	/// en: 'Your Honda CBR 600RR is 200 mi away from its next scheduled oil change.'
	String get body => 'Your Honda CBR 600RR is 200 mi away from its next scheduled oil change.';

	/// en: '5 hours ago'
	String get time => '5 hours ago';

	/// en: 'Schedule'
	String get action => 'Schedule';
}

// Path: notifications.mocks.n4
class TranslationsNotificationsMocksN4En {
	TranslationsNotificationsMocksN4En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Tire rotation overdue'
	String get title => 'Tire rotation overdue';

	/// en: 'Ford Explorer tire rotation is 800 km overdue. Uneven wear may affect handling.'
	String get body => 'Ford Explorer tire rotation is 800 km overdue. Uneven wear may affect handling.';

	/// en: 'Yesterday'
	String get time => 'Yesterday';

	/// en: 'Schedule'
	String get action => 'Schedule';
}

// Path: notifications.mocks.n5
class TranslationsNotificationsMocksN5En {
	TranslationsNotificationsMocksN5En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Service completed'
	String get title => 'Service completed';

	/// en: 'Air filter replacement on Honda CBR 600RR marked as complete. Great job keeping up!'
	String get body => 'Air filter replacement on Honda CBR 600RR marked as complete. Great job keeping up!';

	/// en: '2 days ago'
	String get time => '2 days ago';
}

// Path: notifications.mocks.n6
class TranslationsNotificationsMocksN6En {
	TranslationsNotificationsMocksN6En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'DriveTrack tip'
	String get title => 'DriveTrack tip';

	/// en: 'Regular coolant checks every 30,000 km extend your engine life by up to 40%.'
	String get body => 'Regular coolant checks every 30,000 km extend your engine life by up to 40%.';

	/// en: '3 days ago'
	String get time => '3 days ago';
}

// Path: notifications.mocks.n7
class TranslationsNotificationsMocksN7En {
	TranslationsNotificationsMocksN7En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Battery health low'
	String get title => 'Battery health low';

	/// en: 'Toyota Camry battery is showing signs of degradation. Cold weather may cause issues.'
	String get body => 'Toyota Camry battery is showing signs of degradation. Cold weather may cause issues.';

	/// en: '4 days ago'
	String get time => '4 days ago';

	/// en: 'Check Battery'
	String get action => 'Check Battery';
}

// Path: notifications.mocks.n8
class TranslationsNotificationsMocksN8En {
	TranslationsNotificationsMocksN8En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Mileage milestone reached'
	String get title => 'Mileage milestone reached';

	/// en: 'Your Honda CBR 600RR just hit 12,500 km. Time for a full inspection!'
	String get body => 'Your Honda CBR 600RR just hit 12,500 km. Time for a full inspection!';

	/// en: '1 week ago'
	String get time => '1 week ago';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.appName' => 'DriveTrack',
			'common.ok' => 'OK',
			'common.cancel' => 'Cancel',
			'common.loading' => 'Loading...',
			'common.error' => 'An unexpected error occurred',
			'common.retry' => 'Retry',
			'common.save' => 'Save',
			'common.delete' => 'Delete',
			'common.edit' => 'Edit',
			'common.close' => 'Close',
			'common.confirm' => 'Confirm',
			'common.unknownVehicle' => 'Unknown Vehicle',
			'common.free' => 'Free',
			'common.none' => 'None',
			'common.back' => 'Back',
			'common.settingsAndUnits' => 'Settings & Units',
			'common.realTimeExamples' => 'Real-time examples',
			'common.totalDistance' => 'Total distance',
			'common.operatingTemperature' => 'Operating temperature',
			'common.networkError' => 'No connection. Check your internet and try again.',
			'common.timeoutError' => 'The request took too long. Please try again.',
			'common.unauthorizedError' => 'Incorrect email or password.',
			'common.notFoundError' => 'The requested resource was not found.',
			'common.validationError' => 'The data entered is not valid. Please review and try again.',
			'common.serverError' => 'The server is unavailable. Please try again later.',
			'common.requestError' => 'We could not complete the request. Please try again.',
			'auth.welcomeBack' => 'Welcome Back',
			'auth.signInSubtitle' => 'Sign in to continue tracking your vehicles',
			'auth.emailAddress' => 'EMAIL ADDRESS',
			'auth.emailPlaceholder' => 'john@example.com',
			'auth.password' => 'PASSWORD',
			'auth.forgotPassword' => 'Forgot Password?',
			'auth.signIn' => 'Sign In',
			'auth.noAccount' => 'Don\'t have an account? ',
			'auth.signUp' => 'Sign Up',
			'registration.title' => 'Create Account',
			'registration.subtitle' => 'Fill in your details to get started',
			'registration.appTagline' => 'Your intelligent vehicle companion',
			'registration.fullName' => 'FULL NAME',
			'registration.fullNamePlaceholder' => 'John Doe',
			'registration.phoneNumber' => 'PHONE NUMBER',
			'registration.phonePlaceholder' => '+1 234 567 8900',
			'registration.phoneHint' => '10–15 digits, including country code',
			'registration.dateOfBirth' => 'DATE OF BIRTH',
			'registration.datePlaceholder' => 'YYYY-MM-DD',
			'registration.passwordPlaceholder' => 'Min. 8 characters',
			'registration.createAccount' => 'Create Account',
			'registration.welcomeSuccess' => 'Welcome to DriveTrack!',
			'registration.alreadyHaveAccount' => 'Already have an account? ',
			'registration.passwordWeak' => 'Weak',
			'registration.passwordFair' => 'Fair',
			'registration.passwordStrong' => 'Strong',
			'registration.passwordCheck8Chars' => '8+ characters',
			'registration.passwordCheckUppercase' => 'Uppercase',
			'registration.passwordCheckNumber' => 'Number',
			'nav.garage' => 'Garage',
			'nav.history' => 'History',
			'nav.map' => 'Map',
			'nav.profile' => 'Profile',
			'garage.yourVehicles' => 'Your Vehicles',
			'garage.addVehicle' => 'Add Vehicle',
			'garage.vehicleAdded' => 'Vehicle added successfully',
			'garage.vehicleUpdated' => 'Vehicle updated successfully',
			'garage.vehicleRemoved' => 'Vehicle removed',
			'garage.errorAddingVehicle' => 'Error adding vehicle: {error}',
			'garage.errorUpdatingVehicle' => 'Error updating vehicle: {error}',
			'garage.errorRemovingVehicle' => 'Error removing vehicle: {error}',
			'garage.serviceLogged' => 'Service logged for {vehicleName}',
			'garage.serviceRecordUpdated' => 'Service record updated',
			'garage.removeVehicleTitle' => 'Remove Vehicle',
			'garage.removeVehicleMessage' => 'Are you sure you want to remove "{vehicleName}" from your garage? This action will also delete all associated maintenance records.',
			'garage.errorSyncFailed' => 'Oops! Sync Failed',
			'garage.errorSyncMessage' => 'We could not load your vehicles from the garage. Please check your connection.',
			'garage.vehicleCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: 'Vehicle', other: 'Vehicles', ), 
			'garage.yourVehicle' => 'Your Vehicle',
			'garage.plateNotSet' => 'Plate not set',
			'garage.overallHealth' => 'Overall Health',
			'garage.totalSpent' => 'Total Spent',
			'garage.services' => 'Services',
			'garage.lastService' => 'Last: {title} ({time})',
			'garage.servicesDue' => 'Services Due',
			'garage.noRecordsFound' => 'No records found',
			'garage.noRecordsMessage' => 'Keep track of your vehicle\'s health\nby logging your first service.',
			'garage.emptyGarageTitle' => 'Your Garage is Empty',
			'garage.emptyGarageMessage' => 'Tap the button below to add your first vehicle and start tracking its performance.',
			'garage.deleteServiceTitle' => 'Delete Service Record',
			'garage.deleteServiceMessage' => 'Are you sure you want to delete this record for "{title}"? This action cannot be undone.',
			'garage.editVehicle' => 'Edit Vehicle',
			'garage.removeVehicle' => 'Remove Vehicle',
			'garage.vehicleType' => 'Vehicle Type',
			'garage.vehicles' => 'Vehicles',
			'garage.goodMorning' => 'Good morning,',
			'garage.myGarage' => 'My Garage',
			'garage.avgHealth' => 'Avg Health',
			'garage.totalMiles' => 'Total Miles',
			'garage.alerts' => 'Alerts',
			'garage.addVehicleForm.titleAdd' => 'Add Vehicle',
			'garage.addVehicleForm.titleUpdate' => 'Update Vehicle',
			'garage.addVehicleForm.subtitle' => 'Link a new vehicle to your garage',
			'garage.addVehicleForm.brandLabel' => 'Brand / Make',
			'garage.addVehicleForm.brandHint' => 'Select brand...',
			'garage.addVehicleForm.modelLabel' => 'Model',
			'garage.addVehicleForm.modelHintCar' => 'e.g., Camry, Civic, F-150',
			'garage.addVehicleForm.modelHintMoto' => 'e.g., CBR 600RR, R1, Ninja',
			'garage.addVehicleForm.yearLabel' => 'Year',
			'garage.addVehicleForm.yearHint' => 'Select year...',
			'garage.addVehicleForm.plateLabel' => 'License Plate',
			'garage.addVehicleForm.plateHint' => 'e.g., ABC-1234',
			'garage.addVehicleForm.plateSubHint' => 'Letters, numbers, and hyphens only',
			'garage.addVehicleForm.mileageLabel' => 'Starting Mileage (mi)',
			'garage.addVehicleForm.mileageHint' => 'e.g., 25000',
			'garage.addVehicleForm.mileageSubHint' => 'Current odometer reading',
			'garage.addVehicleForm.btnSave' => 'Save Vehicle',
			'garage.addVehicleForm.btnUpdate' => 'Update Vehicle',
			'garage.addVehicleForm.btnSaved' => 'Vehicle Saved',
			'garage.addVehicleForm.btnUpdated' => 'Vehicle Updated',
			'garage.addVehicleForm.btnCancel' => 'Cancel',
			'garage.vehicleTypes.car' => 'Car',
			'garage.vehicleTypes.motorcycle' => 'Motorcycle',
			'garage.vehicleHealth' => 'Vehicle Health',
			'garage.limitMileage' => 'Limit {mileage} mi',
			'garage.statusHealthy' => 'Healthy',
			'garage.statusNeedsService' => 'Needs Service',
			'garage.statusCritical' => 'Critical',
			'garage.recentServiceLabel' => 'LAST SERVICE',
			'garage.recentMaintenance' => 'RECENT MAINTENANCE',
			'garage.recordsCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '1 record', zero: '0 records', other: '{count} records', ), 
			'garage.totalDistanceMiles' => 'Total Miles',
			'garage.totalDistanceKm' => 'Total Kilometers',
			'garage.notificationsUnread' => 'Notifications, {count} unread',
			'garage.notificationsNone' => 'Notifications, no new updates',
			'maintenance.title' => 'Maintenance',
			'maintenance.logTitle' => 'Maintenance Log',
			'maintenance.logSubtitle' => 'Full service history for your vehicles',
			'maintenance.allVehicles' => 'All Vehicles',
			'maintenance.addService' => 'Add Service',
			'maintenance.serviceAdded' => 'Service added successfully',
			'maintenance.serviceUpdated' => 'Service record updated',
			'maintenance.serviceRemoved' => 'Service record removed',
			'maintenance.errorAddingService' => 'Error adding service: {error}',
			'maintenance.errorUpdatingService' => 'Error updating record: {error}',
			'maintenance.errorRemovingService' => 'Error removing record: {error}',
			'maintenance.removeEntryTitle' => 'Remove Entry?',
			'maintenance.removeEntryMessage' => 'Are you sure you want to remove the record for "{title}"? This action cannot be undone.',
			'maintenance.errorTitle' => 'Something went wrong',
			'maintenance.errorMessage' => 'We had trouble fetching your data. Please check your connection or try again.',
			'maintenance.totalSpent' => 'Total Spent',
			'maintenance.servicesLabel' => 'Services',
			'maintenance.vehiclesLabel' => 'Vehicles',
			'maintenance.noRecordsTitle' => 'No records found',
			'maintenance.noRecordsFiltering' => 'Try adjusting your filters or search to find what you\'re looking for.',
			'maintenance.noRecordsEmpty' => 'Start tracking your vehicle\'s maintenance history to keep it in peak performance.',
			'maintenance.noServiceRecords' => 'No service records yet',
			'maintenance.addServiceRecord' => 'Add Service Record',
			'maintenance.logActivity' => 'Log a maintenance activity',
			'maintenance.vehicle' => 'Vehicle',
			'maintenance.serviceDescription' => 'Service Description',
			'maintenance.date' => 'Date',
			'maintenance.costUsd' => 'Cost (USD)',
			'maintenance.mileage' => 'Mileage',
			'maintenance.category' => 'Category',
			'maintenance.notes' => 'Notes',
			'maintenance.notesHint' => 'Additional notes (optional)',
			'maintenance.service' => 'Service',
			'maintenance.editEntry' => 'Edit Entry',
			'maintenance.deleteEntry' => 'Delete Entry',
			'maintenance.totalInvestment' => 'Total Investment',
			'maintenance.professionalService' => 'Professional Service',
			'maintenance.noNotes' => 'No additional notes provided for this service entry.',
			'maintenance.servicePlaceholder' => 'e.g., Oil Change, Tire Rotation...',
			'maintenance.mileagePlaceholder' => 'e.g., 42000',
			'maintenance.detailsPlaceholder' => 'Additional details...',
			'maintenance.btnUpdate' => 'Update Record',
			'maintenance.btnSave' => 'Save Service Record',
			'maintenance.btnUpdated' => 'Record Updated',
			'maintenance.btnSaved' => 'Record Saved',
			'maintenance.recordPreview' => 'RECORD PREVIEW',
			'maintenance.untitledService' => 'Untitled Service',
			'maintenance.unknownVehicle' => 'Unknown',
			'maintenance.costLabel' => 'COST',
			'maintenance.costFree' => 'Free',
			'maintenance.mileageLabel' => 'MILEAGE',
			'maintenance.serviceNotesLabel' => 'SERVICE NOTES',
			'maintenance.categoryGeneral' => 'General',
			'maintenance.historyLabel' => 'History',
			'maintenance.categories.general' => 'General',
			'maintenance.categories.fluidService' => 'Fluid Service',
			'maintenance.categories.wearAndTear' => 'Wear & Tear',
			'maintenance.categories.inspection' => 'Inspection',
			'maintenance.categories.cosmetic' => 'Cosmetic',
			'maintenance.categories.electrical' => 'Electrical',
			'profile.vehiclePreferences' => 'Vehicle Preferences',
			'profile.favoriteVehicles' => 'Favorite Vehicles',
			'profile.favoritesSaved' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '1 favorite saved', zero: 'No favorites saved', other: '{n} favorites saved', ), 
			'profile.noFavorites' => 'No favorite vehicles yet',
			'profile.notifications' => 'Notifications',
			'profile.configureAlerts' => 'Configure your alerts',
			'profile.pushNotifications' => 'Push Notifications',
			'profile.serviceReminders' => 'Service Reminders',
			'profile.criticalAlerts' => 'Critical Alerts',
			'profile.privacySecurity' => 'Privacy & Security',
			'profile.securitySubtitleActive' => '2FA active · Protected',
			'profile.securitySubtitleDefault' => 'Password, 2FA',
			'profile.passwordReset' => 'Password Reset',
			'profile.passwordLastChanged' => 'Last changed 30 days ago',
			'profile.reset' => 'Reset',
			'profile.twoFactor' => 'Two-Factor Auth (2FA)',
			'profile.twoFactorEnabled' => '● Enabled',
			'profile.twoFactorDisabled' => '○ Disabled — tap to enable',
			'profile.appSettings' => 'App Settings',
			'profile.appSettingsSubtitle' => 'Theme: {theme} · Language: {language}',
			'profile.themeDark' => 'Dark',
			'profile.themeLight' => 'Light',
			'profile.theme' => 'Theme',
			'profile.language' => 'Language',
			'profile.feedbackSupport' => 'Feedback & Support',
			'profile.rateDriveTrack' => 'Rate DriveTrack',
			'profile.shareExperience' => 'Share your experience',
			'profile.helpSupport' => 'Help & Support',
			'profile.faqsContact' => 'FAQs, Contact us',
			'profile.faqs' => 'FAQs',
			'profile.chatSupport' => 'Chat Support',
			'profile.signOut' => 'Sign Out',
			'profile.footerTagline' => 'Crafted with ❤️ for Drivers worldwide',
			'profile.driver' => 'Driver',
			'profile.activeStatus' => 'Active Status',
			'profile.memberSince' => 'Member since {year}',
			'profile.statsVehicles' => 'Vehicles',
			'profile.statsVehiclesSub' => 'linked',
			'profile.statsServices' => 'Services',
			'profile.statsServicesSub' => 'logged',
			'profile.statsSaved' => 'Saved',
			'profile.statsSavedSub' => 'in costs',
			'profile.systemOfUnits' => 'Unit System',
			'profile.metric' => 'Metric',
			'profile.imperial' => 'Imperial',
			'notifications.title' => 'Notifications',
			'notifications.unreadSummary' => '{unread} unread · {total} total',
			'notifications.markAllRead' => 'Mark all read',
			'notifications.filterAll' => 'All',
			'notifications.filterUnread' => 'Unread',
			'notifications.filterWarnings' => 'Warnings',
			'notifications.filterSuccess' => 'Success',
			'notifications.filterWeather' => 'Weather',
			'notifications.summaryAll' => 'All',
			'notifications.summaryWarnings' => 'Warnings',
			'notifications.summarySuccess' => 'Success',
			'notifications.summaryWeather' => 'Weather',
			'notifications.emptyTitle' => 'All caught up!',
			'notifications.emptySubtitle' => 'No notifications in this category',
			'notifications.errorLoading' => 'Error loading notifications',
			'notifications.errorHint' => 'Check your connection and try again.',
			'notifications.retryButton' => 'Retry',
			'notifications.markAllReadButton' => 'Read all',
			'notifications.emptyPageTitle' => 'No notifications',
			'notifications.emptyPageSubtitle' => 'When you receive notifications they will appear here.',
			'notifications.typeWarning' => 'Warning',
			'notifications.typeSuccess' => 'Success',
			'notifications.typeWeather' => 'Weather',
			'notifications.typeInfo' => 'Info',
			'notifications.typeError' => 'Error',
			'notifications.filterInfo' => 'Info',
			'notifications.summaryInfo' => 'Info',
			'notifications.mocks.n1.title' => 'Low tire pressure detected',
			'notifications.mocks.n1.body' => 'Rear left tire is at 28 PSI. Recommended: 32 PSI.',
			'notifications.mocks.n1.time' => '2 mins ago',
			'notifications.mocks.n1.action' => 'Check Tires',
			'notifications.mocks.n2.title' => 'Heavy rain expected',
			'notifications.mocks.n2.body' => 'Severe thunderstorm warning in your area. Avoid driving if possible.',
			'notifications.mocks.n2.time' => '1 hour ago',
			'notifications.mocks.n2.action' => 'View Map',
			'notifications.mocks.n3.title' => 'Oil change due soon',
			'notifications.mocks.n3.body' => 'Your Honda CBR 600RR is 200 mi away from its next scheduled oil change.',
			'notifications.mocks.n3.time' => '5 hours ago',
			'notifications.mocks.n3.action' => 'Schedule',
			'notifications.mocks.n4.title' => 'Tire rotation overdue',
			'notifications.mocks.n4.body' => 'Ford Explorer tire rotation is 800 km overdue. Uneven wear may affect handling.',
			'notifications.mocks.n4.time' => 'Yesterday',
			'notifications.mocks.n4.action' => 'Schedule',
			'notifications.mocks.n5.title' => 'Service completed',
			'notifications.mocks.n5.body' => 'Air filter replacement on Honda CBR 600RR marked as complete. Great job keeping up!',
			'notifications.mocks.n5.time' => '2 days ago',
			'notifications.mocks.n6.title' => 'DriveTrack tip',
			'notifications.mocks.n6.body' => 'Regular coolant checks every 30,000 km extend your engine life by up to 40%.',
			'notifications.mocks.n6.time' => '3 days ago',
			'notifications.mocks.n7.title' => 'Battery health low',
			'notifications.mocks.n7.body' => 'Toyota Camry battery is showing signs of degradation. Cold weather may cause issues.',
			'notifications.mocks.n7.time' => '4 days ago',
			'notifications.mocks.n7.action' => 'Check Battery',
			'notifications.mocks.n8.title' => 'Mileage milestone reached',
			'notifications.mocks.n8.body' => 'Your Honda CBR 600RR just hit 12,500 km. Time for a full inspection!',
			'notifications.mocks.n8.time' => '1 week ago',
			'map.exploreNearby' => 'Explore Nearby',
			'map.title' => 'Service Map',
			'map.live' => 'Live',
			'map.searchHint' => 'Search workshops, gas stations...',
			'map.filterAll' => 'All',
			'map.filterWorkshops' => 'Workshops',
			'map.filterGasStations' => 'Gas Stations',
			'map.you' => 'You',
			'map.cityPark' => 'CITY PARK',
			'map.nearbyResults' => 'Nearby Results',
			'map.swipeUp' => 'Swipe up to see all options',
			'map.openNow' => 'Open Now',
			'map.closed' => 'Closed',
			'map.navigate' => 'Navigate',
			'map.navigatingTo' => 'Navigating to {name}...',
			'map.calling' => 'Calling {phone}...',
			'map.locationsFound' => '{count} locations found',
			'map.specialties' => 'Specialties',
			'map.myLocation' => 'My Location',
			'map.loadingMap' => 'Loading map...',
			'map.errorLoadingMap' => 'Could not load locations',
			'map.noResults' => 'No results found',
			'map.zoomIn' => 'Zoom In',
			'map.zoomOut' => 'Zoom Out',
			'map.overpassError' => 'The map server is overloaded. Please retry in a few seconds.',
			'map.searchThisArea' => 'Search this area',
			'map.gpsSearching' => 'Searching for GPS location... Make sure location is enabled on your device.',
			'weatherWidget.alert' => 'WEATHER ALERT',
			'weatherWidget.condition' => '{weather} · {temp}',
			'weatherWidget.humidity' => '{value}%',
			'weatherWidget.loading' => 'Getting weather...',
			'weatherWidget.errorTitle' => 'Weather unavailable',
			'weatherWidget.errorRetry' => 'Tap to retry',
			'weatherWidget.fallbackLocation' => 'Approximate location',
			'weatherWidget.lastUpdated' => 'Updated {time}',
			'weatherWidget.conditions.clear' => 'Clear',
			'weatherWidget.conditions.clouds' => 'Cloudy',
			'weatherWidget.conditions.rain' => 'Rainy',
			'weatherWidget.conditions.drizzle' => 'Drizzle',
			'weatherWidget.conditions.thunderstorm' => 'Thunderstorm',
			'weatherWidget.conditions.snow' => 'Snowing',
			'weatherWidget.conditions.fog' => 'Foggy',
			'weatherWidget.conditions.extreme' => 'Extreme weather',
			'weatherWidget.conditions.unknown' => 'Variable weather',
			'weatherWidget.recommendations.extremeHeat' => '⚠️ Extreme heat. Stay hydrated and check engine cooling system.',
			'weatherWidget.recommendations.stayHydrated' => 'Stay hydrated. Make sure air conditioning is working properly.',
			'weatherWidget.recommendations.freezing' => '⚠️ Below freezing. Warm up engine before driving and check antifreeze.',
			'weatherWidget.recommendations.coldWeather' => 'Bundle up. Check battery health and warm up engine briefly.',
			'weatherWidget.recommendations.rainyConditions' => 'Reduce speed by 30% and increase following distance. Enable headlights.',
			'weatherWidget.recommendations.thunderstorm' => '⚠️ Thunderstorm alert. Avoid driving if possible. Stay inside vehicle.',
			'weatherWidget.recommendations.snowConditions' => '⚠️ Snow conditions. Use chains and drastically reduce speed.',
			'weatherWidget.recommendations.foggyConditions' => 'Use low beams. Reduce speed and maintain extra following distance.',
			'weatherWidget.recommendations.strongWind' => 'Strong wind detected. Grip the wheel firmly, especially on bridges.',
			'weatherWidget.recommendations.extremeWeather' => 'Extreme conditions. Avoid driving and seek safe shelter.',
			'weatherWidget.recommendations.kDefault' => 'Stable driving conditions. Have a safe trip!',
			'currency.title' => 'Currency Converter',
			'currency.refreshTooltip' => 'Refresh Rate',
			'currency.amountLabel' => 'Amount ({code})',
			'currency.swapTooltip' => 'Swap Currencies',
			'currency.convertedAmount' => 'Converted Amount',
			'currency.rateLabel' => 'Rate: 1 {from} = {rate} {to}',
			'currency.errorLoad' => 'Failed to load exchange rates',
			'currency.tryAgain' => 'Try Again',
			'currency.converterLabel' => 'CURRENCY CONVERTER',
			'currency.refreshRate' => 'Refresh Rate',
			'currency.swapCurrencies' => 'Swap Currencies',
			'currency.rateDesc' => 'Rate: 1 {from} = {rate} {to}',
			'currency.errorLoadingRates' => 'Failed to load exchange rates',
			'validators.requiredParams' => '{field} is required',
			'validators.notEmptyParams' => '{field} cannot be empty',
			'validators.minParams' => '{field} must be at least {min}',
			'validators.maxParams' => '{field} cannot exceed {max}',
			'validators.plateRequired' => 'License plate is required',
			'validators.plateTooShort' => 'Plate is too short',
			'validators.plateTooLong' => 'Plate is too long',
			'validators.numberRequired' => 'Must be a valid number',
			'validators.emailRequired' => 'Email is required',
			'validators.emailInvalid' => 'Enter a valid email address',
			'validators.passwordRequired' => 'Password is required',
			'validators.passwordLength' => 'Password must be at least 8 characters',
			'validators.passwordUppercase' => 'Must contain at least one uppercase letter',
			'validators.passwordNumber' => 'Must contain at least one number',
			'validators.nameRequired' => 'Full name is required',
			'validators.nameLength' => 'Name must be at least 3 characters',
			'validators.phoneRequired' => 'Phone number is required',
			'validators.phoneLength' => 'Phone must be 10–15 digits',
			'validators.dateRequired' => 'Date is required',
			'validators.ageRequirement' => 'You must be at least 16 years old',
			'validators.invalidDateFormat' => 'Invalid date format',
			'weather.alert' => 'WEATHER ALERT',
			'weather.unavailable' => 'Weather unavailable',
			'weather.tapToRetry' => 'Tap to retry',
			'weather.conditions.clear' => 'Clear',
			'weather.conditions.cloudy' => 'Cloudy',
			'weather.conditions.rainy' => 'Rainy',
			'weather.conditions.drizzle' => 'Drizzle',
			'weather.conditions.storm' => 'Storm',
			'weather.conditions.snow' => 'Snow',
			'weather.conditions.foggy' => 'Foggy',
			'weather.conditions.extreme' => 'Extreme',
			'weather.conditions.variable' => 'Variable',
			'weather.recommendations.extremeHeat' => 'Extreme heat. Stay hydrated and check engine cooling system.',
			'weather.recommendations.stayHydrated' => 'Stay hydrated. Make sure air conditioning is working properly.',
			'weather.recommendations.freezing' => 'Below freezing. Warm up engine before driving and check antifreeze.',
			'weather.recommendations.coldWeather' => 'Bundle up. Check battery health and warm up engine briefly.',
			'weather.recommendations.rainyConditions' => 'Reduce speed by 30% and increase following distance. Enable headlights.',
			'weather.recommendations.thunderstorm' => 'Thunderstorm alert. Avoid driving if possible. Stay inside vehicle.',
			'weather.recommendations.snowConditions' => 'Snow conditions. Use chains and drastically reduce speed.',
			'weather.recommendations.foggyConditions' => 'Use low beams. Reduce speed and maintain extra following distance.',
			'weather.recommendations.strongWind' => 'Strong wind detected. Grip the wheel firmly, especially on bridges.',
			'weather.recommendations.extremeWeather' => 'Extreme conditions. Avoid driving and seek safe shelter.',
			'weather.recommendations.stable' => 'Stable driving conditions. Have a safe trip!',
			'time.now' => 'Now',
			'time.today' => 'Today',
			'time.minutesAgo' => '{n} min ago',
			'time.hoursAgo' => '{n}h ago',
			'time.daysAgo' => '{n}d ago',
			'time.monthsAgo' => '{n}m ago',
			'time.yearsAgo' => '{n}y ago',
			_ => null,
		};
	}
}
