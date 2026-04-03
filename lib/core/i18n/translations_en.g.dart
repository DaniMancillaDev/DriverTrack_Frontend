///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsEn extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEn({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsEn _root = this; // ignore: unused_field

	@override 
	TranslationsEn $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEn(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsCommonEn common = _TranslationsCommonEn._(_root);
	@override late final _TranslationsAuthEn auth = _TranslationsAuthEn._(_root);
	@override late final _TranslationsRegistrationEn registration = _TranslationsRegistrationEn._(_root);
	@override late final _TranslationsNavEn nav = _TranslationsNavEn._(_root);
	@override late final _TranslationsGarageEn garage = _TranslationsGarageEn._(_root);
	@override late final _TranslationsMaintenanceEn maintenance = _TranslationsMaintenanceEn._(_root);
	@override late final _TranslationsProfileEn profile = _TranslationsProfileEn._(_root);
	@override late final _TranslationsNotificationsEn notifications = _TranslationsNotificationsEn._(_root);
	@override late final _TranslationsMapEn map = _TranslationsMapEn._(_root);
	@override late final _TranslationsWeatherWidgetEn weatherWidget = _TranslationsWeatherWidgetEn._(_root);
	@override late final _TranslationsCurrencyEn currency = _TranslationsCurrencyEn._(_root);
	@override late final _TranslationsValidatorsEn validators = _TranslationsValidatorsEn._(_root);
	@override late final _TranslationsWeatherEn weather = _TranslationsWeatherEn._(_root);
	@override late final _TranslationsTimeEn time = _TranslationsTimeEn._(_root);
}

// Path: common
class _TranslationsCommonEn extends TranslationsCommonEs {
	_TranslationsCommonEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get appName => 'DriveTrack';
	@override String get ok => 'OK';
	@override String get cancel => 'Cancel';
	@override String get loading => 'Loading...';
	@override String get error => 'An unexpected error occurred';
	@override String get retry => 'Retry';
	@override String get save => 'Save';
	@override String get delete => 'Delete';
	@override String get edit => 'Edit';
	@override String get close => 'Close';
	@override String get confirm => 'Confirm';
	@override String get unknownVehicle => 'Unknown Vehicle';
	@override String get free => 'Free';
	@override String get none => 'None';
}

// Path: auth
class _TranslationsAuthEn extends TranslationsAuthEs {
	_TranslationsAuthEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get welcomeBack => 'Welcome Back';
	@override String get signInSubtitle => 'Sign in to continue tracking your vehicles';
	@override String get emailAddress => 'EMAIL ADDRESS';
	@override String get emailPlaceholder => 'john@example.com';
	@override String get password => 'PASSWORD';
	@override String get forgotPassword => 'Forgot Password?';
	@override String get signIn => 'Sign In';
	@override String get noAccount => 'Don\'t have an account? ';
	@override String get signUp => 'Sign Up';
}

// Path: registration
class _TranslationsRegistrationEn extends TranslationsRegistrationEs {
	_TranslationsRegistrationEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Create Account';
	@override String get subtitle => 'Fill in your details to get started';
	@override String get appTagline => 'Your intelligent vehicle companion';
	@override String get fullName => 'FULL NAME';
	@override String get fullNamePlaceholder => 'John Doe';
	@override String get phoneNumber => 'PHONE NUMBER';
	@override String get phonePlaceholder => '+1 234 567 8900';
	@override String get phoneHint => '10–15 digits, including country code';
	@override String get dateOfBirth => 'DATE OF BIRTH';
	@override String get datePlaceholder => 'YYYY-MM-DD';
	@override String get passwordPlaceholder => 'Min. 8 characters';
	@override String get createAccount => 'Create Account';
	@override String get welcomeSuccess => 'Welcome to DriveTrack!';
	@override String get alreadyHaveAccount => 'Already have an account? ';
	@override String get passwordWeak => 'Weak';
	@override String get passwordFair => 'Fair';
	@override String get passwordStrong => 'Strong';
	@override String get passwordCheck8Chars => '8+ characters';
	@override String get passwordCheckUppercase => 'Uppercase';
	@override String get passwordCheckNumber => 'Number';
}

// Path: nav
class _TranslationsNavEn extends TranslationsNavEs {
	_TranslationsNavEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get garage => 'Garage';
	@override String get history => 'History';
	@override String get map => 'Map';
	@override String get profile => 'Profile';
}

// Path: garage
class _TranslationsGarageEn extends TranslationsGarageEs {
	_TranslationsGarageEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get yourVehicles => 'Your Vehicles';
	@override String get addVehicle => 'Add Vehicle';
	@override String get vehicleAdded => 'Vehicle added successfully';
	@override String get vehicleUpdated => 'Vehicle updated successfully';
	@override String get vehicleRemoved => 'Vehicle removed';
	@override String get errorAddingVehicle => 'Error adding vehicle: {error}';
	@override String get errorUpdatingVehicle => 'Error updating vehicle: {error}';
	@override String get errorRemovingVehicle => 'Error removing vehicle: {error}';
	@override String get serviceLogged => 'Service logged for {vehicleName}';
	@override String get serviceRecordUpdated => 'Service record updated';
	@override String get removeVehicleTitle => 'Remove Vehicle';
	@override String get removeVehicleMessage => 'Are you sure you want to remove "{vehicleName}" from your garage? This action will also delete all associated maintenance records.';
	@override String get errorSyncFailed => 'Oops! Sync Failed';
	@override String get errorSyncMessage => 'We could not load your vehicles from the garage. Please check your connection.';
	@override String vehicleCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'Vehicle',
		other: 'Vehicles',
	);
	@override String get yourVehicle => 'Your Vehicle';
	@override String get plateNotSet => 'Plate not set';
	@override String get overallHealth => 'Overall Health';
	@override String get totalSpent => 'Total Spent';
	@override String get services => 'Services';
	@override String get lastService => 'Last: {title} ({time})';
	@override String get servicesDue => 'Services Due';
	@override String get noRecordsFound => 'No records found';
	@override String get noRecordsMessage => 'Keep track of your vehicle\'s health\nby logging your first service.';
	@override String get emptyGarageTitle => 'Your Garage is Empty';
	@override String get emptyGarageMessage => 'Tap the button below to add your first vehicle and start tracking its performance.';
	@override String get deleteServiceTitle => 'Delete Service Record';
	@override String get deleteServiceMessage => 'Are you sure you want to delete this record for "{title}"? This action cannot be undone.';
	@override String get editVehicle => 'Edit Vehicle';
	@override String get removeVehicle => 'Remove Vehicle';
	@override String get vehicleType => 'Vehicle Type';
	@override String get vehicles => 'Vehicles';
	@override String get goodMorning => 'Good morning,';
	@override String get myGarage => 'My Garage';
	@override String get avgHealth => 'Avg Health';
	@override String get totalMiles => 'Total Miles';
	@override String get alerts => 'Alerts';
	@override late final _TranslationsGarageAddVehicleFormEn addVehicleForm = _TranslationsGarageAddVehicleFormEn._(_root);
	@override late final _TranslationsGarageVehicleTypesEn vehicleTypes = _TranslationsGarageVehicleTypesEn._(_root);
	@override String get vehicleHealth => 'Vehicle Health';
	@override String get limitMileage => 'Limit {mileage} mi';
	@override String get statusHealthy => 'Healthy';
	@override String get statusNeedsService => 'Needs Service';
	@override String get statusCritical => 'Critical';
	@override String get recentServiceLabel => 'LAST SERVICE';
	@override String get recentMaintenance => 'RECENT MAINTENANCE';
	@override String recordsCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '1 record',
		zero: '0 records',
		other: '{count} records',
	);
	@override String get totalDistanceMiles => 'Total Miles';
	@override String get totalDistanceKm => 'Total Kilometers';
}

// Path: maintenance
class _TranslationsMaintenanceEn extends TranslationsMaintenanceEs {
	_TranslationsMaintenanceEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Maintenance';
	@override String get logTitle => 'Maintenance Log';
	@override String get logSubtitle => 'Full service history for your vehicles';
	@override String get allVehicles => 'All Vehicles';
	@override String get addService => 'Add Service';
	@override String get serviceAdded => 'Service added successfully';
	@override String get serviceUpdated => 'Service record updated';
	@override String get serviceRemoved => 'Service record removed';
	@override String get errorAddingService => 'Error adding service: {error}';
	@override String get errorUpdatingService => 'Error updating record: {error}';
	@override String get errorRemovingService => 'Error removing record: {error}';
	@override String get removeEntryTitle => 'Remove Entry?';
	@override String get removeEntryMessage => 'Are you sure you want to remove the record for "{title}"? This action cannot be undone.';
	@override String get errorTitle => 'Something went wrong';
	@override String get errorMessage => 'We had trouble fetching your data. Please check your connection or try again.';
	@override String get totalSpent => 'Total Spent';
	@override String get servicesLabel => 'Services';
	@override String get vehiclesLabel => 'Vehicles';
	@override String get noRecordsTitle => 'No records found';
	@override String get noRecordsFiltering => 'Try adjusting your filters or search to find what you\'re looking for.';
	@override String get noRecordsEmpty => 'Start tracking your vehicle\'s maintenance history to keep it in peak performance.';
	@override String get noServiceRecords => 'No service records yet';
	@override String get addServiceRecord => 'Add Service Record';
	@override String get logActivity => 'Log a maintenance activity';
	@override String get vehicle => 'Vehicle';
	@override String get serviceDescription => 'Service Description';
	@override String get date => 'Date';
	@override String get costUsd => 'Cost (USD)';
	@override String get mileage => 'Mileage';
	@override String get category => 'Category';
	@override String get notes => 'Notes';
	@override String get notesHint => 'Additional notes (optional)';
	@override String get service => 'Service';
	@override String get editEntry => 'Edit Entry';
	@override String get deleteEntry => 'Delete Entry';
	@override String get totalInvestment => 'Total Investment';
	@override String get professionalService => 'Professional Service';
	@override String get noNotes => 'No additional notes provided for this service entry.';
	@override String get servicePlaceholder => 'e.g., Oil Change, Tire Rotation...';
	@override String get mileagePlaceholder => 'e.g., 42000';
	@override String get detailsPlaceholder => 'Additional details...';
	@override String get btnUpdate => 'Update Record';
	@override String get btnSave => 'Save Service Record';
	@override String get btnUpdated => 'Record Updated';
	@override String get btnSaved => 'Record Saved';
	@override String get recordPreview => 'RECORD PREVIEW';
	@override String get untitledService => 'Untitled Service';
	@override String get unknownVehicle => 'Unknown';
	@override String get costLabel => 'COST';
	@override String get costFree => 'Free';
	@override String get mileageLabel => 'MILEAGE';
}

// Path: profile
class _TranslationsProfileEn extends TranslationsProfileEs {
	_TranslationsProfileEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get vehiclePreferences => 'Vehicle Preferences';
	@override String get favoriteVehicles => 'Favorite Vehicles';
	@override String favoritesSaved({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '1 favorite saved',
		zero: 'No favorites saved',
		other: '{n} favorites saved',
	);
	@override String get noFavorites => 'No favorite vehicles yet';
	@override String get notifications => 'Notifications';
	@override String get configureAlerts => 'Configure your alerts';
	@override String get pushNotifications => 'Push Notifications';
	@override String get serviceReminders => 'Service Reminders';
	@override String get criticalAlerts => 'Critical Alerts';
	@override String get privacySecurity => 'Privacy & Security';
	@override String get securitySubtitleActive => '2FA active · Protected';
	@override String get securitySubtitleDefault => 'Password, 2FA';
	@override String get passwordReset => 'Password Reset';
	@override String get passwordLastChanged => 'Last changed 30 days ago';
	@override String get reset => 'Reset';
	@override String get twoFactor => 'Two-Factor Auth (2FA)';
	@override String get twoFactorEnabled => '● Enabled';
	@override String get twoFactorDisabled => '○ Disabled — tap to enable';
	@override String get appSettings => 'App Settings';
	@override String get appSettingsSubtitle => 'Theme: {theme} · Language: {language}';
	@override String get themeDark => 'Dark';
	@override String get themeLight => 'Light';
	@override String get theme => 'Theme';
	@override String get language => 'Language';
	@override String get feedbackSupport => 'Feedback & Support';
	@override String get rateDriveTrack => 'Rate DriveTrack';
	@override String get shareExperience => 'Share your experience';
	@override String get helpSupport => 'Help & Support';
	@override String get faqsContact => 'FAQs, Contact us';
	@override String get faqs => 'FAQs';
	@override String get chatSupport => 'Chat Support';
	@override String get signOut => 'Sign Out';
	@override String get footerTagline => 'Crafted with ❤️ for Drivers worldwide';
	@override String get driver => 'Driver';
	@override String get activeStatus => 'Active Status';
	@override String get memberSince => 'Member since {year}';
	@override String get statsVehicles => 'Vehicles';
	@override String get statsVehiclesSub => 'linked';
	@override String get statsServices => 'Services';
	@override String get statsServicesSub => 'logged';
	@override String get statsSaved => 'Saved';
	@override String get statsSavedSub => 'in costs';
	@override String get systemOfUnits => 'Unit System';
	@override String get metric => 'Metric';
	@override String get imperial => 'Imperial';
}

// Path: notifications
class _TranslationsNotificationsEn extends TranslationsNotificationsEs {
	_TranslationsNotificationsEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notifications';
	@override String get unreadSummary => '{unread} unread · {total} total';
	@override String get markAllRead => 'Mark all read';
	@override String get filterAll => 'All';
	@override String get filterUnread => 'Unread';
	@override String get filterWarnings => 'Warnings';
	@override String get filterSuccess => 'Success';
	@override String get filterWeather => 'Weather';
	@override String get summaryAll => 'All';
	@override String get summaryWarnings => 'Warnings';
	@override String get summarySuccess => 'Success';
	@override String get summaryWeather => 'Weather';
	@override String get emptyTitle => 'All caught up!';
	@override String get emptySubtitle => 'No notifications in this category';
	@override String get errorLoading => 'Error loading notifications';
	@override String get errorHint => 'Check your connection and try again.';
	@override String get retryButton => 'Retry';
	@override String get markAllReadButton => 'Read all';
	@override String get emptyPageTitle => 'No notifications';
	@override String get emptyPageSubtitle => 'When you receive notifications they will appear here.';
	@override String get typeWarning => 'Warning';
	@override String get typeSuccess => 'Success';
	@override String get typeWeather => 'Weather';
	@override String get typeInfo => 'Info';
	@override late final _TranslationsNotificationsMocksEn mocks = _TranslationsNotificationsMocksEn._(_root);
}

// Path: map
class _TranslationsMapEn extends TranslationsMapEs {
	_TranslationsMapEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get exploreNearby => 'Explore Nearby';
	@override String get title => 'Service Map';
	@override String get live => 'Live';
	@override String get searchHint => 'Search workshops, gas stations...';
	@override String get filterAll => 'All';
	@override String get filterWorkshops => 'Workshops';
	@override String get filterGasStations => 'Gas Stations';
	@override String get you => 'You';
	@override String get cityPark => 'CITY PARK';
	@override String get nearbyResults => 'Nearby Results';
	@override String get swipeUp => 'Swipe up to see all options';
	@override String get openNow => 'Open Now';
	@override String get closed => 'Closed';
	@override String get navigate => 'Navigate';
	@override String get navigatingTo => 'Navigating to {name}...';
	@override String get calling => 'Calling {phone}...';
	@override String get locationsFound => '{count} locations found';
	@override String get specialties => 'Specialties';
	@override String get myLocation => 'My Location';
	@override String get loadingMap => 'Loading map...';
	@override String get errorLoadingMap => 'Could not load locations';
	@override String get noResults => 'No results found';
	@override String get zoomIn => 'Zoom In';
	@override String get zoomOut => 'Zoom Out';
	@override String get overpassError => 'The map server is overloaded. Please retry in a few seconds.';
	@override String get searchThisArea => 'Search this area';
}

// Path: weatherWidget
class _TranslationsWeatherWidgetEn extends TranslationsWeatherWidgetEs {
	_TranslationsWeatherWidgetEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get alert => 'WEATHER ALERT';
	@override String get condition => '{weather} · {temp}';
	@override String get humidity => '{value}%';
	@override String get loading => 'Getting weather...';
	@override String get errorTitle => 'Weather unavailable';
	@override String get errorRetry => 'Tap to retry';
	@override String get fallbackLocation => 'Approximate location';
	@override String get lastUpdated => 'Updated {time}';
	@override late final _TranslationsWeatherWidgetConditionsEn conditions = _TranslationsWeatherWidgetConditionsEn._(_root);
	@override late final _TranslationsWeatherWidgetRecommendationsEn recommendations = _TranslationsWeatherWidgetRecommendationsEn._(_root);
}

// Path: currency
class _TranslationsCurrencyEn extends TranslationsCurrencyEs {
	_TranslationsCurrencyEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Currency Converter';
	@override String get refreshTooltip => 'Refresh Rate';
	@override String get amountLabel => 'Amount ({code})';
	@override String get swapTooltip => 'Swap Currencies';
	@override String get convertedAmount => 'Converted Amount';
	@override String get rateLabel => 'Rate: 1 {from} = {rate} {to}';
	@override String get errorLoad => 'Failed to load exchange rates';
	@override String get tryAgain => 'Try Again';
	@override String get converterLabel => 'CURRENCY CONVERTER';
	@override String get refreshRate => 'Refresh Rate';
	@override String get swapCurrencies => 'Swap Currencies';
	@override String get rateDesc => 'Rate: 1 {from} = {rate} {to}';
	@override String get errorLoadingRates => 'Failed to load exchange rates';
}

// Path: validators
class _TranslationsValidatorsEn extends TranslationsValidatorsEs {
	_TranslationsValidatorsEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get requiredParams => '{field} is required';
	@override String get notEmptyParams => '{field} cannot be empty';
	@override String get minParams => '{field} must be at least {min}';
	@override String get maxParams => '{field} cannot exceed {max}';
	@override String get plateRequired => 'License plate is required';
	@override String get plateTooShort => 'Plate is too short';
	@override String get plateTooLong => 'Plate is too long';
	@override String get numberRequired => 'Must be a valid number';
	@override String get emailRequired => 'Email is required';
	@override String get emailInvalid => 'Enter a valid email address';
	@override String get passwordRequired => 'Password is required';
	@override String get passwordLength => 'Password must be at least 8 characters';
	@override String get passwordUppercase => 'Must contain at least one uppercase letter';
	@override String get passwordNumber => 'Must contain at least one number';
	@override String get nameRequired => 'Full name is required';
	@override String get nameLength => 'Name must be at least 3 characters';
	@override String get phoneRequired => 'Phone number is required';
	@override String get phoneLength => 'Phone must be 10–15 digits';
	@override String get dateRequired => 'Date is required';
	@override String get ageRequirement => 'You must be at least 16 years old';
	@override String get invalidDateFormat => 'Invalid date format';
}

// Path: weather
class _TranslationsWeatherEn extends TranslationsWeatherEs {
	_TranslationsWeatherEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get alert => 'WEATHER ALERT';
	@override String get unavailable => 'Weather unavailable';
	@override String get tapToRetry => 'Tap to retry';
	@override late final _TranslationsWeatherConditionsEn conditions = _TranslationsWeatherConditionsEn._(_root);
	@override late final _TranslationsWeatherRecommendationsEn recommendations = _TranslationsWeatherRecommendationsEn._(_root);
}

// Path: time
class _TranslationsTimeEn extends TranslationsTimeEs {
	_TranslationsTimeEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get now => 'Now';
	@override String get today => 'Today';
	@override String get minutesAgo => '{n} min ago';
	@override String get hoursAgo => '{n}h ago';
	@override String get daysAgo => '{n}d ago';
	@override String get monthsAgo => '{n}m ago';
	@override String get yearsAgo => '{n}y ago';
}

// Path: garage.addVehicleForm
class _TranslationsGarageAddVehicleFormEn extends TranslationsGarageAddVehicleFormEs {
	_TranslationsGarageAddVehicleFormEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get titleAdd => 'Add Vehicle';
	@override String get titleUpdate => 'Update Vehicle';
	@override String get subtitle => 'Link a new vehicle to your garage';
	@override String get brandLabel => 'Brand / Make';
	@override String get brandHint => 'Select brand...';
	@override String get modelLabel => 'Model';
	@override String get modelHintCar => 'e.g., Camry, Civic, F-150';
	@override String get modelHintMoto => 'e.g., CBR 600RR, R1, Ninja';
	@override String get yearLabel => 'Year';
	@override String get yearHint => 'Select year...';
	@override String get plateLabel => 'License Plate';
	@override String get plateHint => 'e.g., ABC-1234';
	@override String get plateSubHint => 'Letters, numbers, and hyphens only';
	@override String get mileageLabel => 'Starting Mileage (mi)';
	@override String get mileageHint => 'e.g., 25000';
	@override String get mileageSubHint => 'Current odometer reading';
	@override String get btnSave => 'Save Vehicle';
	@override String get btnUpdate => 'Update Vehicle';
	@override String get btnSaved => 'Vehicle Saved';
	@override String get btnUpdated => 'Vehicle Updated';
	@override String get btnCancel => 'Cancel';
}

// Path: garage.vehicleTypes
class _TranslationsGarageVehicleTypesEn extends TranslationsGarageVehicleTypesEs {
	_TranslationsGarageVehicleTypesEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get car => 'Car';
	@override String get motorcycle => 'Motorcycle';
}

// Path: notifications.mocks
class _TranslationsNotificationsMocksEn extends TranslationsNotificationsMocksEs {
	_TranslationsNotificationsMocksEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsNotificationsMocksN1En n1 = _TranslationsNotificationsMocksN1En._(_root);
	@override late final _TranslationsNotificationsMocksN2En n2 = _TranslationsNotificationsMocksN2En._(_root);
	@override late final _TranslationsNotificationsMocksN3En n3 = _TranslationsNotificationsMocksN3En._(_root);
	@override late final _TranslationsNotificationsMocksN4En n4 = _TranslationsNotificationsMocksN4En._(_root);
	@override late final _TranslationsNotificationsMocksN5En n5 = _TranslationsNotificationsMocksN5En._(_root);
	@override late final _TranslationsNotificationsMocksN6En n6 = _TranslationsNotificationsMocksN6En._(_root);
	@override late final _TranslationsNotificationsMocksN7En n7 = _TranslationsNotificationsMocksN7En._(_root);
	@override late final _TranslationsNotificationsMocksN8En n8 = _TranslationsNotificationsMocksN8En._(_root);
}

// Path: weatherWidget.conditions
class _TranslationsWeatherWidgetConditionsEn extends TranslationsWeatherWidgetConditionsEs {
	_TranslationsWeatherWidgetConditionsEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get clear => 'Clear';
	@override String get clouds => 'Cloudy';
	@override String get rain => 'Rainy';
	@override String get drizzle => 'Drizzle';
	@override String get thunderstorm => 'Thunderstorm';
	@override String get snow => 'Snowing';
	@override String get fog => 'Foggy';
	@override String get extreme => 'Extreme weather';
	@override String get unknown => 'Variable weather';
}

// Path: weatherWidget.recommendations
class _TranslationsWeatherWidgetRecommendationsEn extends TranslationsWeatherWidgetRecommendationsEs {
	_TranslationsWeatherWidgetRecommendationsEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get extremeHeat => '⚠️ Extreme heat. Stay hydrated and check engine cooling system.';
	@override String get stayHydrated => 'Stay hydrated. Make sure air conditioning is working properly.';
	@override String get freezing => '⚠️ Below freezing. Warm up engine before driving and check antifreeze.';
	@override String get coldWeather => 'Bundle up. Check battery health and warm up engine briefly.';
	@override String get rainyConditions => 'Reduce speed by 30% and increase following distance. Enable headlights.';
	@override String get thunderstorm => '⚠️ Thunderstorm alert. Avoid driving if possible. Stay inside vehicle.';
	@override String get snowConditions => '⚠️ Snow conditions. Use chains and drastically reduce speed.';
	@override String get foggyConditions => 'Use low beams. Reduce speed and maintain extra following distance.';
	@override String get strongWind => 'Strong wind detected. Grip the wheel firmly, especially on bridges.';
	@override String get extremeWeather => 'Extreme conditions. Avoid driving and seek safe shelter.';
	@override String get kDefault => 'Stable driving conditions. Have a safe trip!';
}

// Path: weather.conditions
class _TranslationsWeatherConditionsEn extends TranslationsWeatherConditionsEs {
	_TranslationsWeatherConditionsEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get clear => 'Clear';
	@override String get cloudy => 'Cloudy';
	@override String get rainy => 'Rainy';
	@override String get drizzle => 'Drizzle';
	@override String get storm => 'Storm';
	@override String get snow => 'Snow';
	@override String get foggy => 'Foggy';
	@override String get extreme => 'Extreme';
	@override String get variable => 'Variable';
}

// Path: weather.recommendations
class _TranslationsWeatherRecommendationsEn extends TranslationsWeatherRecommendationsEs {
	_TranslationsWeatherRecommendationsEn._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get extremeHeat => 'Extreme heat. Stay hydrated and check engine cooling system.';
	@override String get stayHydrated => 'Stay hydrated. Make sure air conditioning is working properly.';
	@override String get freezing => 'Below freezing. Warm up engine before driving and check antifreeze.';
	@override String get coldWeather => 'Bundle up. Check battery health and warm up engine briefly.';
	@override String get rainyConditions => 'Reduce speed by 30% and increase following distance. Enable headlights.';
	@override String get thunderstorm => 'Thunderstorm alert. Avoid driving if possible. Stay inside vehicle.';
	@override String get snowConditions => 'Snow conditions. Use chains and drastically reduce speed.';
	@override String get foggyConditions => 'Use low beams. Reduce speed and maintain extra following distance.';
	@override String get strongWind => 'Strong wind detected. Grip the wheel firmly, especially on bridges.';
	@override String get extremeWeather => 'Extreme conditions. Avoid driving and seek safe shelter.';
	@override String get stable => 'Stable driving conditions. Have a safe trip!';
}

// Path: notifications.mocks.n1
class _TranslationsNotificationsMocksN1En extends TranslationsNotificationsMocksN1Es {
	_TranslationsNotificationsMocksN1En._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Low tire pressure detected';
	@override String get body => 'Rear left tire is at 28 PSI. Recommended: 32 PSI.';
	@override String get time => '2 mins ago';
	@override String get action => 'Check Tires';
}

// Path: notifications.mocks.n2
class _TranslationsNotificationsMocksN2En extends TranslationsNotificationsMocksN2Es {
	_TranslationsNotificationsMocksN2En._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Heavy rain expected';
	@override String get body => 'Severe thunderstorm warning in your area. Avoid driving if possible.';
	@override String get time => '1 hour ago';
	@override String get action => 'View Map';
}

// Path: notifications.mocks.n3
class _TranslationsNotificationsMocksN3En extends TranslationsNotificationsMocksN3Es {
	_TranslationsNotificationsMocksN3En._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Oil change due soon';
	@override String get body => 'Your Honda CBR 600RR is 200 mi away from its next scheduled oil change.';
	@override String get time => '5 hours ago';
	@override String get action => 'Schedule';
}

// Path: notifications.mocks.n4
class _TranslationsNotificationsMocksN4En extends TranslationsNotificationsMocksN4Es {
	_TranslationsNotificationsMocksN4En._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tire rotation overdue';
	@override String get body => 'Ford Explorer tire rotation is 800 km overdue. Uneven wear may affect handling.';
	@override String get time => 'Yesterday';
	@override String get action => 'Schedule';
}

// Path: notifications.mocks.n5
class _TranslationsNotificationsMocksN5En extends TranslationsNotificationsMocksN5Es {
	_TranslationsNotificationsMocksN5En._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Service completed';
	@override String get body => 'Air filter replacement on Honda CBR 600RR marked as complete. Great job keeping up!';
	@override String get time => '2 days ago';
}

// Path: notifications.mocks.n6
class _TranslationsNotificationsMocksN6En extends TranslationsNotificationsMocksN6Es {
	_TranslationsNotificationsMocksN6En._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'DriveTrack tip';
	@override String get body => 'Regular coolant checks every 30,000 km extend your engine life by up to 40%.';
	@override String get time => '3 days ago';
}

// Path: notifications.mocks.n7
class _TranslationsNotificationsMocksN7En extends TranslationsNotificationsMocksN7Es {
	_TranslationsNotificationsMocksN7En._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Battery health low';
	@override String get body => 'Toyota Camry battery is showing signs of degradation. Cold weather may cause issues.';
	@override String get time => '4 days ago';
	@override String get action => 'Check Battery';
}

// Path: notifications.mocks.n8
class _TranslationsNotificationsMocksN8En extends TranslationsNotificationsMocksN8Es {
	_TranslationsNotificationsMocksN8En._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mileage milestone reached';
	@override String get body => 'Your Honda CBR 600RR just hit 12,500 km. Time for a full inspection!';
	@override String get time => '1 week ago';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEn {
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
