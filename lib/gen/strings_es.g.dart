///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsEs with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEs({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.es,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <es>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsEs _root = this; // ignore: unused_field

	@override 
	TranslationsEs $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEs(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsCommonEs common = _TranslationsCommonEs._(_root);
	@override late final _TranslationsAuthEs auth = _TranslationsAuthEs._(_root);
	@override late final _TranslationsRegistrationEs registration = _TranslationsRegistrationEs._(_root);
	@override late final _TranslationsNavEs nav = _TranslationsNavEs._(_root);
	@override late final _TranslationsGarageEs garage = _TranslationsGarageEs._(_root);
	@override late final _TranslationsMaintenanceEs maintenance = _TranslationsMaintenanceEs._(_root);
	@override late final _TranslationsProfileEs profile = _TranslationsProfileEs._(_root);
	@override late final _TranslationsNotificationsEs notifications = _TranslationsNotificationsEs._(_root);
	@override late final _TranslationsMapEs map = _TranslationsMapEs._(_root);
	@override late final _TranslationsWeatherWidgetEs weatherWidget = _TranslationsWeatherWidgetEs._(_root);
	@override late final _TranslationsCurrencyEs currency = _TranslationsCurrencyEs._(_root);
	@override late final _TranslationsValidatorsEs validators = _TranslationsValidatorsEs._(_root);
	@override late final _TranslationsWeatherEs weather = _TranslationsWeatherEs._(_root);
	@override late final _TranslationsTimeEs time = _TranslationsTimeEs._(_root);
}

// Path: common
class _TranslationsCommonEs implements TranslationsCommonEn {
	_TranslationsCommonEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get appName => 'DriveTrack';
	@override String get ok => 'Aceptar';
	@override String get cancel => 'Cancelar';
	@override String get loading => 'Cargando...';
	@override String get error => 'Ocurrió un error inesperado';
	@override String get retry => 'Reintentar';
	@override String get save => 'Guardar';
	@override String get delete => 'Eliminar';
	@override String get edit => 'Editar';
	@override String get close => 'Cerrar';
	@override String get confirm => 'Confirmar';
	@override String get unknownVehicle => 'Vehículo desconocido';
	@override String get free => 'Gratis';
	@override String get none => 'Ninguno';
	@override String get back => 'Volver';
	@override String get settingsAndUnits => 'Configuración y Unidades';
	@override String get realTimeExamples => 'Ejemplos en tiempo real';
	@override String get totalDistance => 'Distancia total';
	@override String get operatingTemperature => 'Temperatura de operación';
	@override String get networkError => 'Sin conexión. Verifica tu internet e intenta de nuevo.';
	@override String get timeoutError => 'La solicitud tardó demasiado. Intenta de nuevo.';
	@override String get unauthorizedError => 'Correo o contraseña incorrectos.';
	@override String get notFoundError => 'El recurso solicitado no fue encontrado.';
	@override String get validationError => 'Los datos ingresados no son válidos. Revísalos e intenta de nuevo.';
	@override String get serverError => 'El servidor no está disponible. Intenta más tarde.';
	@override String get requestError => 'No pudimos completar la solicitud. Intenta de nuevo.';
}

// Path: auth
class _TranslationsAuthEs implements TranslationsAuthEn {
	_TranslationsAuthEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get welcomeBack => 'Bienvenido de vuelta';
	@override String get signInSubtitle => 'Inicia sesión para continuar rastreando tus vehículos';
	@override String get emailAddress => 'CORREO ELECTRÓNICO';
	@override String get emailPlaceholder => 'juan@ejemplo.com';
	@override String get password => 'CONTRASEÑA';
	@override String get forgotPassword => '¿Olvidaste tu contraseña?';
	@override String get signIn => 'Iniciar sesión';
	@override String get noAccount => '¿No tienes una cuenta? ';
	@override String get signUp => 'Regístrate';
}

// Path: registration
class _TranslationsRegistrationEs implements TranslationsRegistrationEn {
	_TranslationsRegistrationEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Crear cuenta';
	@override String get subtitle => 'Completa tus datos para comenzar';
	@override String get appTagline => 'Tu compañero inteligente de vehículos';
	@override String get fullName => 'NOMBRE COMPLETO';
	@override String get fullNamePlaceholder => 'Juan Pérez';
	@override String get phoneNumber => 'NÚMERO DE TELÉFONO';
	@override String get phonePlaceholder => '+52 55 1234 5678';
	@override String get phoneHint => '10–15 dígitos, incluyendo código de país';
	@override String get dateOfBirth => 'FECHA DE NACIMIENTO';
	@override String get datePlaceholder => 'YYYY-MM-DD';
	@override String get passwordPlaceholder => 'Mín. 8 caracteres';
	@override String get createAccount => 'Crear cuenta';
	@override String get welcomeSuccess => '¡Bienvenido a DriveTrack!';
	@override String get alreadyHaveAccount => '¿Ya tienes cuenta? ';
	@override String get passwordWeak => 'Débil';
	@override String get passwordFair => 'Regular';
	@override String get passwordStrong => 'Fuerte';
	@override String get passwordCheck8Chars => '8+ caracteres';
	@override String get passwordCheckUppercase => 'Mayúscula';
	@override String get passwordCheckNumber => 'Número';
}

// Path: nav
class _TranslationsNavEs implements TranslationsNavEn {
	_TranslationsNavEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get garage => 'Garaje';
	@override String get history => 'Historial';
	@override String get map => 'Mapa';
	@override String get profile => 'Perfil';
}

// Path: garage
class _TranslationsGarageEs implements TranslationsGarageEn {
	_TranslationsGarageEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get yourVehicles => 'Tus vehículos';
	@override String get addVehicle => 'Agregar vehículo';
	@override String get vehicleAdded => 'Vehículo agregado exitosamente';
	@override String get vehicleUpdated => 'Vehículo actualizado exitosamente';
	@override String get vehicleRemoved => 'Vehículo eliminado';
	@override String get errorAddingVehicle => 'Error al agregar vehículo: {error}';
	@override String get errorUpdatingVehicle => 'Error al actualizar vehículo: {error}';
	@override String get errorRemovingVehicle => 'Error al eliminar vehículo: {error}';
	@override String get serviceLogged => 'Servicio registrado para {vehicleName}';
	@override String get serviceRecordUpdated => 'Registro de servicio actualizado';
	@override String get removeVehicleTitle => '¿Eliminar vehículo?';
	@override String get removeVehicleMessage => '¿Estás seguro de que quieres eliminar "{vehicleName}" de tu garaje? Esta acción también eliminará todos los registros de mantenimiento asociados.';
	@override String get errorSyncFailed => '¡Error de sincronización!';
	@override String get errorSyncMessage => 'No pudimos cargar tus vehículos. Por favor verifica tu conexión.';
	@override String vehicleCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: 'Vehículo',
		other: 'Vehículos',
	);
	@override String get yourVehicle => 'Tu vehículo';
	@override String get plateNotSet => 'Matrícula no configurada';
	@override String get overallHealth => 'Salud general';
	@override String get totalSpent => 'Total gastado';
	@override String get services => 'Servicios';
	@override String get lastService => 'Último: {title} ({time})';
	@override String get servicesDue => 'Servicios pendientes';
	@override String get noRecordsFound => 'No se encontraron registros';
	@override String get noRecordsMessage => 'Lleva el control de tu vehículo\nregistrando tu primer servicio.';
	@override String get emptyGarageTitle => 'Tu garaje está vacío';
	@override String get emptyGarageMessage => 'Toca el botón de abajo para agregar tu primer vehículo y comenzar a rastrear su rendimiento.';
	@override String get deleteServiceTitle => '¿Eliminar registro de servicio?';
	@override String get deleteServiceMessage => '¿Estás seguro de que quieres eliminar este registro de "{title}"? Esta acción no se puede deshacer.';
	@override String get editVehicle => 'Editar vehículo';
	@override String get removeVehicle => 'Eliminar vehículo';
	@override String get vehicleType => 'Tipo de vehículo';
	@override String get vehicles => 'Vehículos';
	@override String get goodMorning => 'Buenos días,';
	@override String get myGarage => 'Mi garaje';
	@override String get avgHealth => 'Salud prom.';
	@override String get totalMiles => 'Millas totales';
	@override String get alerts => 'Alertas';
	@override late final _TranslationsGarageAddVehicleFormEs addVehicleForm = _TranslationsGarageAddVehicleFormEs._(_root);
	@override late final _TranslationsGarageVehicleTypesEs vehicleTypes = _TranslationsGarageVehicleTypesEs._(_root);
	@override String get vehicleHealth => 'Salud del Vehículo';
	@override String get limitMileage => 'Límite: {mileage} mi';
	@override String get statusHealthy => 'Saludable';
	@override String get statusNeedsService => 'Requiere Servicio';
	@override String get statusCritical => 'Crítico';
	@override String get recentServiceLabel => 'ÚLTIMO';
	@override String get recentMaintenance => 'MANTENIMIENTO RECIENTE';
	@override String recordsCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: '1 registro',
		zero: '0 registros',
		other: '{count} registros',
	);
	@override String get totalDistanceMiles => 'Millas totales';
	@override String get totalDistanceKm => 'Kilómetros totales';
	@override String get unitKilometers => 'Kilómetros';
	@override String get unitMiShort => 'mi';
	@override String get unitKmShort => 'km';
	@override String get notificationsUnread => 'Notificaciones, {count} no leídas';
	@override String get notificationsNone => 'Notificaciones, sin novedades';
}

// Path: maintenance
class _TranslationsMaintenanceEs implements TranslationsMaintenanceEn {
	_TranslationsMaintenanceEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mantenimiento';
	@override String get logTitle => 'Registro de mantenimiento';
	@override String get logSubtitle => 'Historial completo de servicio para tus vehículos';
	@override String get allVehicles => 'Todos los vehículos';
	@override String get addService => 'Agregar servicio';
	@override String get serviceAdded => 'Servicio agregado exitosamente';
	@override String get serviceUpdated => 'Registro de servicio actualizado';
	@override String get serviceRemoved => 'Registro de servicio eliminado';
	@override String get errorAddingService => 'Error al agregar servicio: {error}';
	@override String get errorUpdatingService => 'Error al actualizar registro: {error}';
	@override String get errorRemovingService => 'Error al eliminar registro: {error}';
	@override String get removeEntryTitle => '¿Eliminar registro?';
	@override String get removeEntryMessage => '¿Estás seguro de que quieres eliminar el registro de "{title}"? Esta acción no se puede deshacer.';
	@override String get errorTitle => 'Algo salió mal';
	@override String get errorMessage => 'Tuvimos problemas al obtener tus datos. Por favor verifica tu conexión o intenta de nuevo.';
	@override String get totalSpent => 'Total gastado';
	@override String get servicesLabel => 'Servicios';
	@override String get vehiclesLabel => 'Vehículos';
	@override String get noRecordsTitle => 'No se encontraron registros';
	@override String get noRecordsFiltering => 'Intenta ajustar tus filtros o búsqueda para encontrar lo que buscas.';
	@override String get noRecordsEmpty => 'Comienza a rastrear el historial de mantenimiento de tu vehículo para mantenerlo en máximo rendimiento.';
	@override String get noServiceRecords => 'Aún no hay registros de servicio';
	@override String get addServiceRecord => 'Agregar registro de servicio';
	@override String get logActivity => 'Registrar una actividad de mantenimiento';
	@override String get vehicle => 'Vehículo';
	@override String get serviceDescription => 'Descripción del servicio';
	@override String get date => 'Fecha';
	@override String get costUsd => 'Costo (USD)';
	@override String get mileage => 'Kilometraje';
	@override String get category => 'Categoría';
	@override String get notes => 'Notas';
	@override String get notesHint => 'Notas adicionales (opcional)';
	@override String get service => 'Servicio';
	@override String get editEntry => 'Editar registro';
	@override String get deleteEntry => 'Eliminar registro';
	@override String get totalInvestment => 'Inversión total';
	@override String get professionalService => 'Servicio profesional';
	@override String get noNotes => 'No se proporcionaron notas adicionales para esta entrada de servicio.';
	@override String get servicePlaceholder => 'ej. Cambio de aceite, Rotación...';
	@override String get mileagePlaceholder => 'ej. 42000';
	@override String get detailsPlaceholder => 'Detalles adicionales...';
	@override String get btnUpdate => 'Actualizar Registro';
	@override String get btnSave => 'Guardar Registro';
	@override String get btnUpdated => 'Registro Actualizado';
	@override String get btnSaved => 'Registro Guardado';
	@override String get recordPreview => 'VISTA PREVIA';
	@override String get untitledService => 'Servicio sin título';
	@override String get unknownVehicle => 'Desconocido';
	@override String get costLabel => 'COSTO';
	@override String get costFree => 'Gratis';
	@override String get mileageLabel => 'KILOMETRAJE';
	@override String get serviceNotesLabel => 'NOTAS DEL SERVICIO';
	@override String get categoryGeneral => 'General';
	@override String get historyLabel => 'Historial';
	@override late final _TranslationsMaintenanceCategoriesEs categories = _TranslationsMaintenanceCategoriesEs._(_root);
}

// Path: profile
class _TranslationsProfileEs implements TranslationsProfileEn {
	_TranslationsProfileEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get vehiclePreferences => 'Preferencias de vehículo';
	@override String get favoriteVehicles => 'Vehículos favoritos';
	@override String favoritesSaved({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: '1 favorito guardado',
		zero: 'Sin favoritos guardados',
		other: '{n} favoritos guardados',
	);
	@override String get noFavorites => 'Aún no tienes vehículos favoritos';
	@override String get notifications => 'Notificaciones';
	@override String get configureAlerts => 'Configura tus alertas';
	@override String get pushNotifications => 'Notificaciones push';
	@override String get serviceReminders => 'Recordatorios de servicio';
	@override String get criticalAlerts => 'Alertas críticas';
	@override String get privacySecurity => 'Privacidad y seguridad';
	@override String get securitySubtitleActive => '2FA activo · Protegido';
	@override String get securitySubtitleDefault => 'Contraseña, 2FA';
	@override String get passwordReset => 'Restablecer contraseña';
	@override String get passwordLastChanged => 'Último cambio hace 30 días';
	@override String get reset => 'Restablecer';
	@override String get twoFactor => 'Autenticación en dos pasos (2FA)';
	@override String get twoFactorEnabled => '● Activo';
	@override String get twoFactorDisabled => '○ Inactivo — toca para activar';
	@override String get appSettings => 'Configuración de la app';
	@override String get appSettingsSubtitle => 'Tema: {theme} · Idioma: {language}';
	@override String get themeDark => 'Oscuro';
	@override String get themeLight => 'Claro';
	@override String get theme => 'Tema';
	@override String get language => 'Idioma';
	@override String get feedbackSupport => 'Comentarios y soporte';
	@override String get rateDriveTrack => 'Calificar DriveTrack';
	@override String get shareExperience => 'Comparte tu experiencia';
	@override String get helpSupport => 'Ayuda y soporte';
	@override String get faqsContact => 'Preguntas frecuentes, Contáctanos';
	@override String get faqs => 'Preguntas frecuentes';
	@override String get chatSupport => 'Soporte por chat';
	@override String get signOut => 'Cerrar sesión';
	@override String get footerTagline => 'Hecho con ❤️ para conductores en todo el mundo';
	@override String get driver => 'Conductor';
	@override String get activeStatus => 'Estado activo';
	@override String get memberSince => 'Miembro desde {year}';
	@override String get statsVehicles => 'Vehículos';
	@override String get statsVehiclesSub => 'vinculados';
	@override String get statsServices => 'Servicios';
	@override String get statsServicesSub => 'registrados';
	@override String get statsSaved => 'Ahorros';
	@override String get statsSavedSub => 'en costos';
	@override String get systemOfUnits => 'Sistema de Unidades';
	@override String get metric => 'Métrico';
	@override String get imperial => 'Imperial';
}

// Path: notifications
class _TranslationsNotificationsEs implements TranslationsNotificationsEn {
	_TranslationsNotificationsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notificaciones';
	@override String get unreadSummary => '{unread} sin leer · {total} en total';
	@override String get markAllRead => 'Marcar todo como leído';
	@override String get filterAll => 'Todos';
	@override String get filterUnread => 'No leídos';
	@override String get filterWarnings => 'Advertencias';
	@override String get filterSuccess => 'Exitosos';
	@override String get filterWeather => 'Clima';
	@override String get summaryAll => 'Todos';
	@override String get summaryWarnings => 'Advertencias';
	@override String get summarySuccess => 'Exitosos';
	@override String get summaryWeather => 'Clima';
	@override String get emptyTitle => '¡Todo al día!';
	@override String get emptySubtitle => 'No hay notificaciones en esta categoría';
	@override String get errorLoading => 'Error al cargar notificaciones';
	@override String get errorHint => 'Verifica tu conexión y vuelve a intentarlo.';
	@override String get retryButton => 'Reintentar';
	@override String get markAllReadButton => 'Leer todas';
	@override String get emptyPageTitle => 'Sin notificaciones';
	@override String get emptyPageSubtitle => 'Cuando recibas notificaciones aparecerán aquí.';
	@override String get typeWarning => 'Advertencia';
	@override String get typeSuccess => 'Exitoso';
	@override String get typeWeather => 'Clima';
	@override String get typeInfo => 'Información';
	@override String get typeError => 'Error';
	@override String get filterInfo => 'Info';
	@override String get summaryInfo => 'Info';
	@override late final _TranslationsNotificationsMocksEs mocks = _TranslationsNotificationsMocksEs._(_root);
}

// Path: map
class _TranslationsMapEs implements TranslationsMapEn {
	_TranslationsMapEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get exploreNearby => 'Explorar cercano';
	@override String get title => 'Mapa de servicios';
	@override String get live => 'En vivo';
	@override String get searchHint => 'Buscar talleres, gasolineras...';
	@override String get filterAll => 'Todos';
	@override String get filterWorkshops => 'Talleres';
	@override String get filterGasStations => 'Gasolineras';
	@override String get you => 'Tú';
	@override String get cityPark => 'PARQUE CENTRAL';
	@override String get nearbyResults => 'Resultados cercanos';
	@override String get swipeUp => 'Desliza hacia arriba para ver todas las opciones';
	@override String get openNow => 'Abierto ahora';
	@override String get closed => 'Cerrado';
	@override String get navigate => 'Navegar';
	@override String get navigatingTo => 'Navegando a {name}...';
	@override String get calling => 'Llamando a {phone}...';
	@override String get locationsFound => '{count} ubicaciones encontradas';
	@override String get specialties => 'Especialidades';
	@override String get myLocation => 'Mi Ubicación';
	@override String get loadingMap => 'Cargando mapa...';
	@override String get errorLoadingMap => 'No se pudieron cargar las ubicaciones';
	@override String get noResults => 'No se encontraron resultados';
	@override String get zoomIn => 'Acercar';
	@override String get zoomOut => 'Alejar';
	@override String get overpassError => 'El servidor de mapas está saturado. Reintenta en unos segundos.';
	@override String get searchThisArea => 'Buscar en esta zona';
	@override String get gpsSearching => 'Buscando ubicación GPS... Asegúrate de tener la ubicación activada en tu dispositivo.';
}

// Path: weatherWidget
class _TranslationsWeatherWidgetEs implements TranslationsWeatherWidgetEn {
	_TranslationsWeatherWidgetEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get alert => 'ALERTA DEL CLIMA';
	@override String get condition => '{weather} · {temp}';
	@override String get humidity => '{value}%';
	@override String get loading => 'Obteniendo clima...';
	@override String get errorTitle => 'Clima no disponible';
	@override String get errorRetry => 'Toca para reintentar';
	@override String get fallbackLocation => 'Ubicación aproximada';
	@override String get lastUpdated => 'Actualizado {time}';
	@override late final _TranslationsWeatherWidgetConditionsEs conditions = _TranslationsWeatherWidgetConditionsEs._(_root);
	@override late final _TranslationsWeatherWidgetRecommendationsEs recommendations = _TranslationsWeatherWidgetRecommendationsEs._(_root);
}

// Path: currency
class _TranslationsCurrencyEs implements TranslationsCurrencyEn {
	_TranslationsCurrencyEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Convertidor de Divisas';
	@override String get refreshTooltip => 'Actualizar Tasa';
	@override String get amountLabel => 'Monto ({code})';
	@override String get swapTooltip => 'Intercambiar Divisas';
	@override String get convertedAmount => 'Monto convertido';
	@override String get rateLabel => 'Tasa: 1 {from} = {rate} {to}';
	@override String get errorLoad => 'Error al cargar tasas de cambio';
	@override String get tryAgain => 'Intentar de nuevo';
	@override String get converterLabel => 'CONVERTIDOR DE DIVISAS';
	@override String get refreshRate => 'Actualizar tasa';
	@override String get swapCurrencies => 'Intercambiar divisas';
	@override String get rateDesc => 'Tasa: 1 {from} = {rate} {to}';
	@override String get errorLoadingRates => 'Error al cargar tasas de cambio';
}

// Path: validators
class _TranslationsValidatorsEs implements TranslationsValidatorsEn {
	_TranslationsValidatorsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get requiredParams => '{field} es requerido';
	@override String get notEmptyParams => 'El campo {field} no puede estar vacío';
	@override String get minParams => '{field} debe ser al menos {min}';
	@override String get maxParams => '{field} no puede exceder {max}';
	@override String get plateRequired => 'La matrícula es obligatoria';
	@override String get plateTooShort => 'La matrícula es muy corta';
	@override String get plateTooLong => 'La matrícula es muy larga';
	@override String get numberRequired => 'Debe ser un número válido';
	@override String get emailRequired => 'El correo es obligatorio';
	@override String get emailInvalid => 'Ingresa un correo electrónico válido';
	@override String get passwordRequired => 'La contraseña es obligatoria';
	@override String get passwordLength => 'La contraseña debe tener al menos 8 caracteres';
	@override String get passwordUppercase => 'Debe contener al menos una letra mayúscula';
	@override String get passwordNumber => 'Debe contener al menos un número';
	@override String get nameRequired => 'El nombre completo es obligatorio';
	@override String get nameLength => 'El nombre debe tener al menos 3 caracteres';
	@override String get phoneRequired => 'El número de teléfono es obligatorio';
	@override String get phoneLength => 'El teléfono debe tener entre 10 y 15 dígitos';
	@override String get dateRequired => 'La fecha es requerida';
	@override String get ageRequirement => 'Debes tener al menos 16 años';
	@override String get invalidDateFormat => 'Formato de fecha inválido';
}

// Path: weather
class _TranslationsWeatherEs implements TranslationsWeatherEn {
	_TranslationsWeatherEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get alert => 'ALERTA CLIMÁTICA';
	@override String get unavailable => 'Clima no disponible';
	@override String get tapToRetry => 'Toca para reintentar';
	@override late final _TranslationsWeatherConditionsEs conditions = _TranslationsWeatherConditionsEs._(_root);
	@override late final _TranslationsWeatherRecommendationsEs recommendations = _TranslationsWeatherRecommendationsEs._(_root);
}

// Path: time
class _TranslationsTimeEs implements TranslationsTimeEn {
	_TranslationsTimeEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get now => 'Ahora';
	@override String get today => 'Hoy';
	@override String get minutesAgo => 'Hace {n} min';
	@override String get hoursAgo => 'Hace {n}h';
	@override String get daysAgo => 'Hace {n}d';
	@override String get monthsAgo => 'Hace {n}m';
	@override String get yearsAgo => 'Hace {n}a';
}

// Path: garage.addVehicleForm
class _TranslationsGarageAddVehicleFormEs implements TranslationsGarageAddVehicleFormEn {
	_TranslationsGarageAddVehicleFormEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get titleAdd => 'Añadir Vehículo';
	@override String get titleUpdate => 'Actualizar Vehículo';
	@override String get subtitle => 'Vincula un nuevo vehículo a tu garaje';
	@override String get brandLabel => 'Marca';
	@override String get brandHint => 'Seleccionar marca...';
	@override String get modelLabel => 'Modelo';
	@override String get modelHintCar => 'ej., Camry, Civic, F-150';
	@override String get modelHintMoto => 'ej., CBR 600RR, R1, Ninja';
	@override String get yearLabel => 'Año';
	@override String get yearHint => 'Seleccionar año...';
	@override String get plateLabel => 'Matrícula';
	@override String get plateHint => 'ej., ABC-1234';
	@override String get plateSubHint => 'Solo letras y números (y guiones)';
	@override String get mileageLabel => 'Kilometraje inicial (mi)';
	@override String get mileageHint => 'ej., 25000';
	@override String get mileageSubHint => 'Lectura actual del odómetro';
	@override String get btnSave => 'Guardar Vehículo';
	@override String get btnSaveCar => 'Guardar Coche';
	@override String get btnSaveMoto => 'Guardar Motocicleta';
	@override String get btnUpdate => 'Actualizar Vehículo';
	@override String get btnSaved => 'Vehículo Guardado';
	@override String get btnSavedCar => 'Coche Guardado';
	@override String get btnSavedMoto => 'Motocicleta Guardada';
	@override String get btnUpdated => 'Vehículo Actualizado';
	@override String get btnCancel => 'Cancelar';
}

// Path: garage.vehicleTypes
class _TranslationsGarageVehicleTypesEs implements TranslationsGarageVehicleTypesEn {
	_TranslationsGarageVehicleTypesEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get car => 'Coche';
	@override String get motorcycle => 'Motocicleta';
}

// Path: maintenance.categories
class _TranslationsMaintenanceCategoriesEs implements TranslationsMaintenanceCategoriesEn {
	_TranslationsMaintenanceCategoriesEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get general => 'General';
	@override String get fluidService => 'Fluidos';
	@override String get wearAndTear => 'Desgaste';
	@override String get inspection => 'Inspección';
	@override String get cosmetic => 'Estética';
	@override String get electrical => 'Eléctrico';
}

// Path: notifications.mocks
class _TranslationsNotificationsMocksEs implements TranslationsNotificationsMocksEn {
	_TranslationsNotificationsMocksEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsNotificationsMocksN1Es n1 = _TranslationsNotificationsMocksN1Es._(_root);
	@override late final _TranslationsNotificationsMocksN2Es n2 = _TranslationsNotificationsMocksN2Es._(_root);
	@override late final _TranslationsNotificationsMocksN3Es n3 = _TranslationsNotificationsMocksN3Es._(_root);
	@override late final _TranslationsNotificationsMocksN4Es n4 = _TranslationsNotificationsMocksN4Es._(_root);
	@override late final _TranslationsNotificationsMocksN5Es n5 = _TranslationsNotificationsMocksN5Es._(_root);
	@override late final _TranslationsNotificationsMocksN6Es n6 = _TranslationsNotificationsMocksN6Es._(_root);
	@override late final _TranslationsNotificationsMocksN7Es n7 = _TranslationsNotificationsMocksN7Es._(_root);
	@override late final _TranslationsNotificationsMocksN8Es n8 = _TranslationsNotificationsMocksN8Es._(_root);
}

// Path: weatherWidget.conditions
class _TranslationsWeatherWidgetConditionsEs implements TranslationsWeatherWidgetConditionsEn {
	_TranslationsWeatherWidgetConditionsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get clear => 'Despejado';
	@override String get clouds => 'Nublado';
	@override String get rain => 'Lluvioso';
	@override String get drizzle => 'Llovizna';
	@override String get thunderstorm => 'Tormenta';
	@override String get snow => 'Nevando';
	@override String get fog => 'Neblina';
	@override String get extreme => 'Clima extremo';
	@override String get unknown => 'Clima variable';
}

// Path: weatherWidget.recommendations
class _TranslationsWeatherWidgetRecommendationsEs implements TranslationsWeatherWidgetRecommendationsEn {
	_TranslationsWeatherWidgetRecommendationsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get extremeHeat => '⚠️ Calor extremo. Mantén hidratación constante y verifica el enfriamiento del motor.';
	@override String get stayHydrated => 'Mantente hidratado. Verifica que el aire acondicionado funcione correctamente.';
	@override String get freezing => '⚠️ Temperatura bajo cero. Calienta el motor antes de conducir y verifica anticongelante.';
	@override String get coldWeather => 'Abrígate bien. Verifica la batería y calienta el motor brevemente.';
	@override String get rainyConditions => 'Reduce velocidad un 30% y aumenta la distancia de seguimiento. Enciende las luces.';
	@override String get thunderstorm => '⚠️ Tormenta eléctrica. Evita conducir si es posible. Mantente dentro del vehículo.';
	@override String get snowConditions => '⚠️ Condiciones de nieve. Usa cadenas y reduce drásticamente la velocidad.';
	@override String get foggyConditions => 'Usa luces bajas. Reduce la velocidad y mantén distancia extra.';
	@override String get strongWind => 'Viento fuerte detectado. Sujeta bien el volante, especialmente en puentes.';
	@override String get extremeWeather => '⚠️ Condiciones extremas. Evita conducir y busca refugio seguro.';
	@override String get kDefault => 'Condiciones estables para conducir. ¡Buen viaje!';
}

// Path: weather.conditions
class _TranslationsWeatherConditionsEs implements TranslationsWeatherConditionsEn {
	_TranslationsWeatherConditionsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get clear => 'Despejado';
	@override String get cloudy => 'Nublado';
	@override String get rainy => 'Lluvioso';
	@override String get drizzle => 'Llovizna';
	@override String get storm => 'Tormenta';
	@override String get snow => 'Nieve';
	@override String get foggy => 'Niebla';
	@override String get extreme => 'Extremo';
	@override String get variable => 'Variable';
}

// Path: weather.recommendations
class _TranslationsWeatherRecommendationsEs implements TranslationsWeatherRecommendationsEn {
	_TranslationsWeatherRecommendationsEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get extremeHeat => 'Calor extremo. Mantente hidratado y revisa el sistema de enfriamiento del motor.';
	@override String get stayHydrated => 'Mantente hidratado. Asegúrate de que el aire acondicionado funcione correctamente.';
	@override String get freezing => 'Temperaturas bajo cero. Calienta el motor antes de conducir y revisa el anticongelante.';
	@override String get coldWeather => 'Abrígate bien. Revisa el estado de la batería y calienta el motor brevemente.';
	@override String get rainyConditions => 'Reduce la velocidad un 30% y aumenta la distancia de seguridad. Enciende las luces.';
	@override String get thunderstorm => 'Alerta de tormenta eléctrica. Evita conducir si es posible. Quédate dentro del vehículo.';
	@override String get snowConditions => 'Condiciones de nieve. Usa cadenas y reduce drásticamente la velocidad.';
	@override String get foggyConditions => 'Usa luces bajas. Reduce la velocidad y mantén una mayor distancia de seguridad.';
	@override String get strongWind => 'Vientos fuertes detectados. Sujeta el volante con firmeza, especialmente en puentes.';
	@override String get extremeWeather => 'Condiciones extremas. Evita conducir y busca un refugio seguro.';
	@override String get stable => 'Condiciones de conducción estables. ¡Buen viaje!';
}

// Path: notifications.mocks.n1
class _TranslationsNotificationsMocksN1Es implements TranslationsNotificationsMocksN1En {
	_TranslationsNotificationsMocksN1Es._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Presión de neumáticos baja';
	@override String get body => 'El neumático trasero izquierdo está a 28 PSI. Recomendado: 32 PSI.';
	@override String get time => 'hace 2 min';
	@override String get action => 'Revisar Neumáticos';
}

// Path: notifications.mocks.n2
class _TranslationsNotificationsMocksN2Es implements TranslationsNotificationsMocksN2En {
	_TranslationsNotificationsMocksN2Es._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Se espera lluvia fuerte';
	@override String get body => 'Alerta de tormenta severa en tu área. Evita conducir si es posible.';
	@override String get time => 'hace 1 hora';
	@override String get action => 'Ver Mapa';
}

// Path: notifications.mocks.n3
class _TranslationsNotificationsMocksN3Es implements TranslationsNotificationsMocksN3En {
	_TranslationsNotificationsMocksN3Es._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cambio de aceite pronto';
	@override String get body => 'Tu Honda CBR 600RR está a 300 km de su próximo cambio de aceite.';
	@override String get time => 'hace 5 horas';
	@override String get action => 'Programar';
}

// Path: notifications.mocks.n4
class _TranslationsNotificationsMocksN4Es implements TranslationsNotificationsMocksN4En {
	_TranslationsNotificationsMocksN4Es._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Rotación de neumáticos';
	@override String get body => 'La rotación de neumáticos del Ford Explorer está 800 km retrasada.';
	@override String get time => 'Ayer';
	@override String get action => 'Programar';
}

// Path: notifications.mocks.n5
class _TranslationsNotificationsMocksN5Es implements TranslationsNotificationsMocksN5En {
	_TranslationsNotificationsMocksN5Es._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Servicio completado';
	@override String get body => 'Reemplazo de filtro de aire en Honda CBR 600RR marcado como completo. ¡Buen trabajo!';
	@override String get time => 'hace 2 días';
}

// Path: notifications.mocks.n6
class _TranslationsNotificationsMocksN6Es implements TranslationsNotificationsMocksN6En {
	_TranslationsNotificationsMocksN6Es._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Consejo DriveTrack';
	@override String get body => 'Las revisiones regulares de refrigerante extienden la vida de tu motor un 40%.';
	@override String get time => 'hace 3 días';
}

// Path: notifications.mocks.n7
class _TranslationsNotificationsMocksN7Es implements TranslationsNotificationsMocksN7En {
	_TranslationsNotificationsMocksN7Es._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Batería baja';
	@override String get body => 'La batería del Toyota Camry muestra signos de degradación. El frío puede causar problemas.';
	@override String get time => 'hace 4 días';
	@override String get action => 'Revisar Batería';
}

// Path: notifications.mocks.n8
class _TranslationsNotificationsMocksN8Es implements TranslationsNotificationsMocksN8En {
	_TranslationsNotificationsMocksN8Es._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Hito de kilometraje';
	@override String get body => 'Tu Honda CBR 600RR ha alcanzado los 12,500 km. Hora de una inspección completa!';
	@override String get time => 'hace 1 semana';
}

/// The flat map containing all translations for locale <es>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEs {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.appName' => 'DriveTrack',
			'common.ok' => 'Aceptar',
			'common.cancel' => 'Cancelar',
			'common.loading' => 'Cargando...',
			'common.error' => 'Ocurrió un error inesperado',
			'common.retry' => 'Reintentar',
			'common.save' => 'Guardar',
			'common.delete' => 'Eliminar',
			'common.edit' => 'Editar',
			'common.close' => 'Cerrar',
			'common.confirm' => 'Confirmar',
			'common.unknownVehicle' => 'Vehículo desconocido',
			'common.free' => 'Gratis',
			'common.none' => 'Ninguno',
			'common.back' => 'Volver',
			'common.settingsAndUnits' => 'Configuración y Unidades',
			'common.realTimeExamples' => 'Ejemplos en tiempo real',
			'common.totalDistance' => 'Distancia total',
			'common.operatingTemperature' => 'Temperatura de operación',
			'common.networkError' => 'Sin conexión. Verifica tu internet e intenta de nuevo.',
			'common.timeoutError' => 'La solicitud tardó demasiado. Intenta de nuevo.',
			'common.unauthorizedError' => 'Correo o contraseña incorrectos.',
			'common.notFoundError' => 'El recurso solicitado no fue encontrado.',
			'common.validationError' => 'Los datos ingresados no son válidos. Revísalos e intenta de nuevo.',
			'common.serverError' => 'El servidor no está disponible. Intenta más tarde.',
			'common.requestError' => 'No pudimos completar la solicitud. Intenta de nuevo.',
			'auth.welcomeBack' => 'Bienvenido de vuelta',
			'auth.signInSubtitle' => 'Inicia sesión para continuar rastreando tus vehículos',
			'auth.emailAddress' => 'CORREO ELECTRÓNICO',
			'auth.emailPlaceholder' => 'juan@ejemplo.com',
			'auth.password' => 'CONTRASEÑA',
			'auth.forgotPassword' => '¿Olvidaste tu contraseña?',
			'auth.signIn' => 'Iniciar sesión',
			'auth.noAccount' => '¿No tienes una cuenta? ',
			'auth.signUp' => 'Regístrate',
			'registration.title' => 'Crear cuenta',
			'registration.subtitle' => 'Completa tus datos para comenzar',
			'registration.appTagline' => 'Tu compañero inteligente de vehículos',
			'registration.fullName' => 'NOMBRE COMPLETO',
			'registration.fullNamePlaceholder' => 'Juan Pérez',
			'registration.phoneNumber' => 'NÚMERO DE TELÉFONO',
			'registration.phonePlaceholder' => '+52 55 1234 5678',
			'registration.phoneHint' => '10–15 dígitos, incluyendo código de país',
			'registration.dateOfBirth' => 'FECHA DE NACIMIENTO',
			'registration.datePlaceholder' => 'YYYY-MM-DD',
			'registration.passwordPlaceholder' => 'Mín. 8 caracteres',
			'registration.createAccount' => 'Crear cuenta',
			'registration.welcomeSuccess' => '¡Bienvenido a DriveTrack!',
			'registration.alreadyHaveAccount' => '¿Ya tienes cuenta? ',
			'registration.passwordWeak' => 'Débil',
			'registration.passwordFair' => 'Regular',
			'registration.passwordStrong' => 'Fuerte',
			'registration.passwordCheck8Chars' => '8+ caracteres',
			'registration.passwordCheckUppercase' => 'Mayúscula',
			'registration.passwordCheckNumber' => 'Número',
			'nav.garage' => 'Garaje',
			'nav.history' => 'Historial',
			'nav.map' => 'Mapa',
			'nav.profile' => 'Perfil',
			'garage.yourVehicles' => 'Tus vehículos',
			'garage.addVehicle' => 'Agregar vehículo',
			'garage.vehicleAdded' => 'Vehículo agregado exitosamente',
			'garage.vehicleUpdated' => 'Vehículo actualizado exitosamente',
			'garage.vehicleRemoved' => 'Vehículo eliminado',
			'garage.errorAddingVehicle' => 'Error al agregar vehículo: {error}',
			'garage.errorUpdatingVehicle' => 'Error al actualizar vehículo: {error}',
			'garage.errorRemovingVehicle' => 'Error al eliminar vehículo: {error}',
			'garage.serviceLogged' => 'Servicio registrado para {vehicleName}',
			'garage.serviceRecordUpdated' => 'Registro de servicio actualizado',
			'garage.removeVehicleTitle' => '¿Eliminar vehículo?',
			'garage.removeVehicleMessage' => '¿Estás seguro de que quieres eliminar "{vehicleName}" de tu garaje? Esta acción también eliminará todos los registros de mantenimiento asociados.',
			'garage.errorSyncFailed' => '¡Error de sincronización!',
			'garage.errorSyncMessage' => 'No pudimos cargar tus vehículos. Por favor verifica tu conexión.',
			'garage.vehicleCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n, one: 'Vehículo', other: 'Vehículos', ), 
			'garage.yourVehicle' => 'Tu vehículo',
			'garage.plateNotSet' => 'Matrícula no configurada',
			'garage.overallHealth' => 'Salud general',
			'garage.totalSpent' => 'Total gastado',
			'garage.services' => 'Servicios',
			'garage.lastService' => 'Último: {title} ({time})',
			'garage.servicesDue' => 'Servicios pendientes',
			'garage.noRecordsFound' => 'No se encontraron registros',
			'garage.noRecordsMessage' => 'Lleva el control de tu vehículo\nregistrando tu primer servicio.',
			'garage.emptyGarageTitle' => 'Tu garaje está vacío',
			'garage.emptyGarageMessage' => 'Toca el botón de abajo para agregar tu primer vehículo y comenzar a rastrear su rendimiento.',
			'garage.deleteServiceTitle' => '¿Eliminar registro de servicio?',
			'garage.deleteServiceMessage' => '¿Estás seguro de que quieres eliminar este registro de "{title}"? Esta acción no se puede deshacer.',
			'garage.editVehicle' => 'Editar vehículo',
			'garage.removeVehicle' => 'Eliminar vehículo',
			'garage.vehicleType' => 'Tipo de vehículo',
			'garage.vehicles' => 'Vehículos',
			'garage.goodMorning' => 'Buenos días,',
			'garage.myGarage' => 'Mi garaje',
			'garage.avgHealth' => 'Salud prom.',
			'garage.totalMiles' => 'Millas totales',
			'garage.alerts' => 'Alertas',
			'garage.addVehicleForm.titleAdd' => 'Añadir Vehículo',
			'garage.addVehicleForm.titleUpdate' => 'Actualizar Vehículo',
			'garage.addVehicleForm.subtitle' => 'Vincula un nuevo vehículo a tu garaje',
			'garage.addVehicleForm.brandLabel' => 'Marca',
			'garage.addVehicleForm.brandHint' => 'Seleccionar marca...',
			'garage.addVehicleForm.modelLabel' => 'Modelo',
			'garage.addVehicleForm.modelHintCar' => 'ej., Camry, Civic, F-150',
			'garage.addVehicleForm.modelHintMoto' => 'ej., CBR 600RR, R1, Ninja',
			'garage.addVehicleForm.yearLabel' => 'Año',
			'garage.addVehicleForm.yearHint' => 'Seleccionar año...',
			'garage.addVehicleForm.plateLabel' => 'Matrícula',
			'garage.addVehicleForm.plateHint' => 'ej., ABC-1234',
			'garage.addVehicleForm.plateSubHint' => 'Solo letras y números (y guiones)',
			'garage.addVehicleForm.mileageLabel' => 'Kilometraje inicial (mi)',
			'garage.addVehicleForm.mileageHint' => 'ej., 25000',
			'garage.addVehicleForm.mileageSubHint' => 'Lectura actual del odómetro',
			'garage.addVehicleForm.btnSave' => 'Guardar Vehículo',
			'garage.addVehicleForm.btnSaveCar' => 'Guardar Coche',
			'garage.addVehicleForm.btnSaveMoto' => 'Guardar Motocicleta',
			'garage.addVehicleForm.btnUpdate' => 'Actualizar Vehículo',
			'garage.addVehicleForm.btnSaved' => 'Vehículo Guardado',
			'garage.addVehicleForm.btnSavedCar' => 'Coche Guardado',
			'garage.addVehicleForm.btnSavedMoto' => 'Motocicleta Guardada',
			'garage.addVehicleForm.btnUpdated' => 'Vehículo Actualizado',
			'garage.addVehicleForm.btnCancel' => 'Cancelar',
			'garage.vehicleTypes.car' => 'Coche',
			'garage.vehicleTypes.motorcycle' => 'Motocicleta',
			'garage.vehicleHealth' => 'Salud del Vehículo',
			'garage.limitMileage' => 'Límite: {mileage} mi',
			'garage.statusHealthy' => 'Saludable',
			'garage.statusNeedsService' => 'Requiere Servicio',
			'garage.statusCritical' => 'Crítico',
			'garage.recentServiceLabel' => 'ÚLTIMO',
			'garage.recentMaintenance' => 'MANTENIMIENTO RECIENTE',
			'garage.recordsCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n, one: '1 registro', zero: '0 registros', other: '{count} registros', ), 
			'garage.totalDistanceMiles' => 'Millas totales',
			'garage.totalDistanceKm' => 'Kilómetros totales',
			'garage.unitKilometers' => 'Kilómetros',
			'garage.unitMiShort' => 'mi',
			'garage.unitKmShort' => 'km',
			'garage.notificationsUnread' => 'Notificaciones, {count} no leídas',
			'garage.notificationsNone' => 'Notificaciones, sin novedades',
			'maintenance.title' => 'Mantenimiento',
			'maintenance.logTitle' => 'Registro de mantenimiento',
			'maintenance.logSubtitle' => 'Historial completo de servicio para tus vehículos',
			'maintenance.allVehicles' => 'Todos los vehículos',
			'maintenance.addService' => 'Agregar servicio',
			'maintenance.serviceAdded' => 'Servicio agregado exitosamente',
			'maintenance.serviceUpdated' => 'Registro de servicio actualizado',
			'maintenance.serviceRemoved' => 'Registro de servicio eliminado',
			'maintenance.errorAddingService' => 'Error al agregar servicio: {error}',
			'maintenance.errorUpdatingService' => 'Error al actualizar registro: {error}',
			'maintenance.errorRemovingService' => 'Error al eliminar registro: {error}',
			'maintenance.removeEntryTitle' => '¿Eliminar registro?',
			'maintenance.removeEntryMessage' => '¿Estás seguro de que quieres eliminar el registro de "{title}"? Esta acción no se puede deshacer.',
			'maintenance.errorTitle' => 'Algo salió mal',
			'maintenance.errorMessage' => 'Tuvimos problemas al obtener tus datos. Por favor verifica tu conexión o intenta de nuevo.',
			'maintenance.totalSpent' => 'Total gastado',
			'maintenance.servicesLabel' => 'Servicios',
			'maintenance.vehiclesLabel' => 'Vehículos',
			'maintenance.noRecordsTitle' => 'No se encontraron registros',
			'maintenance.noRecordsFiltering' => 'Intenta ajustar tus filtros o búsqueda para encontrar lo que buscas.',
			'maintenance.noRecordsEmpty' => 'Comienza a rastrear el historial de mantenimiento de tu vehículo para mantenerlo en máximo rendimiento.',
			'maintenance.noServiceRecords' => 'Aún no hay registros de servicio',
			'maintenance.addServiceRecord' => 'Agregar registro de servicio',
			'maintenance.logActivity' => 'Registrar una actividad de mantenimiento',
			'maintenance.vehicle' => 'Vehículo',
			'maintenance.serviceDescription' => 'Descripción del servicio',
			'maintenance.date' => 'Fecha',
			'maintenance.costUsd' => 'Costo (USD)',
			'maintenance.mileage' => 'Kilometraje',
			'maintenance.category' => 'Categoría',
			'maintenance.notes' => 'Notas',
			'maintenance.notesHint' => 'Notas adicionales (opcional)',
			'maintenance.service' => 'Servicio',
			'maintenance.editEntry' => 'Editar registro',
			'maintenance.deleteEntry' => 'Eliminar registro',
			'maintenance.totalInvestment' => 'Inversión total',
			'maintenance.professionalService' => 'Servicio profesional',
			'maintenance.noNotes' => 'No se proporcionaron notas adicionales para esta entrada de servicio.',
			'maintenance.servicePlaceholder' => 'ej. Cambio de aceite, Rotación...',
			'maintenance.mileagePlaceholder' => 'ej. 42000',
			'maintenance.detailsPlaceholder' => 'Detalles adicionales...',
			'maintenance.btnUpdate' => 'Actualizar Registro',
			'maintenance.btnSave' => 'Guardar Registro',
			'maintenance.btnUpdated' => 'Registro Actualizado',
			'maintenance.btnSaved' => 'Registro Guardado',
			'maintenance.recordPreview' => 'VISTA PREVIA',
			'maintenance.untitledService' => 'Servicio sin título',
			'maintenance.unknownVehicle' => 'Desconocido',
			'maintenance.costLabel' => 'COSTO',
			'maintenance.costFree' => 'Gratis',
			'maintenance.mileageLabel' => 'KILOMETRAJE',
			'maintenance.serviceNotesLabel' => 'NOTAS DEL SERVICIO',
			'maintenance.categoryGeneral' => 'General',
			'maintenance.historyLabel' => 'Historial',
			'maintenance.categories.general' => 'General',
			'maintenance.categories.fluidService' => 'Fluidos',
			'maintenance.categories.wearAndTear' => 'Desgaste',
			'maintenance.categories.inspection' => 'Inspección',
			'maintenance.categories.cosmetic' => 'Estética',
			'maintenance.categories.electrical' => 'Eléctrico',
			'profile.vehiclePreferences' => 'Preferencias de vehículo',
			'profile.favoriteVehicles' => 'Vehículos favoritos',
			'profile.favoritesSaved' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n, one: '1 favorito guardado', zero: 'Sin favoritos guardados', other: '{n} favoritos guardados', ), 
			'profile.noFavorites' => 'Aún no tienes vehículos favoritos',
			'profile.notifications' => 'Notificaciones',
			'profile.configureAlerts' => 'Configura tus alertas',
			'profile.pushNotifications' => 'Notificaciones push',
			'profile.serviceReminders' => 'Recordatorios de servicio',
			'profile.criticalAlerts' => 'Alertas críticas',
			'profile.privacySecurity' => 'Privacidad y seguridad',
			'profile.securitySubtitleActive' => '2FA activo · Protegido',
			'profile.securitySubtitleDefault' => 'Contraseña, 2FA',
			'profile.passwordReset' => 'Restablecer contraseña',
			'profile.passwordLastChanged' => 'Último cambio hace 30 días',
			'profile.reset' => 'Restablecer',
			'profile.twoFactor' => 'Autenticación en dos pasos (2FA)',
			'profile.twoFactorEnabled' => '● Activo',
			'profile.twoFactorDisabled' => '○ Inactivo — toca para activar',
			'profile.appSettings' => 'Configuración de la app',
			'profile.appSettingsSubtitle' => 'Tema: {theme} · Idioma: {language}',
			'profile.themeDark' => 'Oscuro',
			'profile.themeLight' => 'Claro',
			'profile.theme' => 'Tema',
			'profile.language' => 'Idioma',
			'profile.feedbackSupport' => 'Comentarios y soporte',
			'profile.rateDriveTrack' => 'Calificar DriveTrack',
			'profile.shareExperience' => 'Comparte tu experiencia',
			'profile.helpSupport' => 'Ayuda y soporte',
			'profile.faqsContact' => 'Preguntas frecuentes, Contáctanos',
			'profile.faqs' => 'Preguntas frecuentes',
			'profile.chatSupport' => 'Soporte por chat',
			'profile.signOut' => 'Cerrar sesión',
			'profile.footerTagline' => 'Hecho con ❤️ para conductores en todo el mundo',
			'profile.driver' => 'Conductor',
			'profile.activeStatus' => 'Estado activo',
			'profile.memberSince' => 'Miembro desde {year}',
			'profile.statsVehicles' => 'Vehículos',
			'profile.statsVehiclesSub' => 'vinculados',
			'profile.statsServices' => 'Servicios',
			'profile.statsServicesSub' => 'registrados',
			'profile.statsSaved' => 'Ahorros',
			'profile.statsSavedSub' => 'en costos',
			'profile.systemOfUnits' => 'Sistema de Unidades',
			'profile.metric' => 'Métrico',
			'profile.imperial' => 'Imperial',
			'notifications.title' => 'Notificaciones',
			'notifications.unreadSummary' => '{unread} sin leer · {total} en total',
			'notifications.markAllRead' => 'Marcar todo como leído',
			'notifications.filterAll' => 'Todos',
			'notifications.filterUnread' => 'No leídos',
			'notifications.filterWarnings' => 'Advertencias',
			'notifications.filterSuccess' => 'Exitosos',
			'notifications.filterWeather' => 'Clima',
			'notifications.summaryAll' => 'Todos',
			'notifications.summaryWarnings' => 'Advertencias',
			'notifications.summarySuccess' => 'Exitosos',
			'notifications.summaryWeather' => 'Clima',
			'notifications.emptyTitle' => '¡Todo al día!',
			'notifications.emptySubtitle' => 'No hay notificaciones en esta categoría',
			'notifications.errorLoading' => 'Error al cargar notificaciones',
			'notifications.errorHint' => 'Verifica tu conexión y vuelve a intentarlo.',
			'notifications.retryButton' => 'Reintentar',
			'notifications.markAllReadButton' => 'Leer todas',
			'notifications.emptyPageTitle' => 'Sin notificaciones',
			'notifications.emptyPageSubtitle' => 'Cuando recibas notificaciones aparecerán aquí.',
			'notifications.typeWarning' => 'Advertencia',
			'notifications.typeSuccess' => 'Exitoso',
			'notifications.typeWeather' => 'Clima',
			'notifications.typeInfo' => 'Información',
			'notifications.typeError' => 'Error',
			'notifications.filterInfo' => 'Info',
			'notifications.summaryInfo' => 'Info',
			'notifications.mocks.n1.title' => 'Presión de neumáticos baja',
			'notifications.mocks.n1.body' => 'El neumático trasero izquierdo está a 28 PSI. Recomendado: 32 PSI.',
			'notifications.mocks.n1.time' => 'hace 2 min',
			'notifications.mocks.n1.action' => 'Revisar Neumáticos',
			'notifications.mocks.n2.title' => 'Se espera lluvia fuerte',
			'notifications.mocks.n2.body' => 'Alerta de tormenta severa en tu área. Evita conducir si es posible.',
			'notifications.mocks.n2.time' => 'hace 1 hora',
			'notifications.mocks.n2.action' => 'Ver Mapa',
			'notifications.mocks.n3.title' => 'Cambio de aceite pronto',
			'notifications.mocks.n3.body' => 'Tu Honda CBR 600RR está a 300 km de su próximo cambio de aceite.',
			'notifications.mocks.n3.time' => 'hace 5 horas',
			'notifications.mocks.n3.action' => 'Programar',
			'notifications.mocks.n4.title' => 'Rotación de neumáticos',
			'notifications.mocks.n4.body' => 'La rotación de neumáticos del Ford Explorer está 800 km retrasada.',
			'notifications.mocks.n4.time' => 'Ayer',
			'notifications.mocks.n4.action' => 'Programar',
			'notifications.mocks.n5.title' => 'Servicio completado',
			'notifications.mocks.n5.body' => 'Reemplazo de filtro de aire en Honda CBR 600RR marcado como completo. ¡Buen trabajo!',
			'notifications.mocks.n5.time' => 'hace 2 días',
			'notifications.mocks.n6.title' => 'Consejo DriveTrack',
			'notifications.mocks.n6.body' => 'Las revisiones regulares de refrigerante extienden la vida de tu motor un 40%.',
			'notifications.mocks.n6.time' => 'hace 3 días',
			'notifications.mocks.n7.title' => 'Batería baja',
			'notifications.mocks.n7.body' => 'La batería del Toyota Camry muestra signos de degradación. El frío puede causar problemas.',
			'notifications.mocks.n7.time' => 'hace 4 días',
			'notifications.mocks.n7.action' => 'Revisar Batería',
			'notifications.mocks.n8.title' => 'Hito de kilometraje',
			'notifications.mocks.n8.body' => 'Tu Honda CBR 600RR ha alcanzado los 12,500 km. Hora de una inspección completa!',
			'notifications.mocks.n8.time' => 'hace 1 semana',
			'map.exploreNearby' => 'Explorar cercano',
			'map.title' => 'Mapa de servicios',
			'map.live' => 'En vivo',
			'map.searchHint' => 'Buscar talleres, gasolineras...',
			'map.filterAll' => 'Todos',
			'map.filterWorkshops' => 'Talleres',
			'map.filterGasStations' => 'Gasolineras',
			'map.you' => 'Tú',
			'map.cityPark' => 'PARQUE CENTRAL',
			'map.nearbyResults' => 'Resultados cercanos',
			'map.swipeUp' => 'Desliza hacia arriba para ver todas las opciones',
			'map.openNow' => 'Abierto ahora',
			'map.closed' => 'Cerrado',
			'map.navigate' => 'Navegar',
			'map.navigatingTo' => 'Navegando a {name}...',
			'map.calling' => 'Llamando a {phone}...',
			'map.locationsFound' => '{count} ubicaciones encontradas',
			'map.specialties' => 'Especialidades',
			'map.myLocation' => 'Mi Ubicación',
			'map.loadingMap' => 'Cargando mapa...',
			'map.errorLoadingMap' => 'No se pudieron cargar las ubicaciones',
			'map.noResults' => 'No se encontraron resultados',
			'map.zoomIn' => 'Acercar',
			'map.zoomOut' => 'Alejar',
			'map.overpassError' => 'El servidor de mapas está saturado. Reintenta en unos segundos.',
			'map.searchThisArea' => 'Buscar en esta zona',
			'map.gpsSearching' => 'Buscando ubicación GPS... Asegúrate de tener la ubicación activada en tu dispositivo.',
			'weatherWidget.alert' => 'ALERTA DEL CLIMA',
			'weatherWidget.condition' => '{weather} · {temp}',
			'weatherWidget.humidity' => '{value}%',
			'weatherWidget.loading' => 'Obteniendo clima...',
			'weatherWidget.errorTitle' => 'Clima no disponible',
			'weatherWidget.errorRetry' => 'Toca para reintentar',
			'weatherWidget.fallbackLocation' => 'Ubicación aproximada',
			'weatherWidget.lastUpdated' => 'Actualizado {time}',
			'weatherWidget.conditions.clear' => 'Despejado',
			'weatherWidget.conditions.clouds' => 'Nublado',
			'weatherWidget.conditions.rain' => 'Lluvioso',
			'weatherWidget.conditions.drizzle' => 'Llovizna',
			'weatherWidget.conditions.thunderstorm' => 'Tormenta',
			'weatherWidget.conditions.snow' => 'Nevando',
			'weatherWidget.conditions.fog' => 'Neblina',
			'weatherWidget.conditions.extreme' => 'Clima extremo',
			'weatherWidget.conditions.unknown' => 'Clima variable',
			'weatherWidget.recommendations.extremeHeat' => '⚠️ Calor extremo. Mantén hidratación constante y verifica el enfriamiento del motor.',
			'weatherWidget.recommendations.stayHydrated' => 'Mantente hidratado. Verifica que el aire acondicionado funcione correctamente.',
			'weatherWidget.recommendations.freezing' => '⚠️ Temperatura bajo cero. Calienta el motor antes de conducir y verifica anticongelante.',
			'weatherWidget.recommendations.coldWeather' => 'Abrígate bien. Verifica la batería y calienta el motor brevemente.',
			'weatherWidget.recommendations.rainyConditions' => 'Reduce velocidad un 30% y aumenta la distancia de seguimiento. Enciende las luces.',
			'weatherWidget.recommendations.thunderstorm' => '⚠️ Tormenta eléctrica. Evita conducir si es posible. Mantente dentro del vehículo.',
			'weatherWidget.recommendations.snowConditions' => '⚠️ Condiciones de nieve. Usa cadenas y reduce drásticamente la velocidad.',
			'weatherWidget.recommendations.foggyConditions' => 'Usa luces bajas. Reduce la velocidad y mantén distancia extra.',
			'weatherWidget.recommendations.strongWind' => 'Viento fuerte detectado. Sujeta bien el volante, especialmente en puentes.',
			'weatherWidget.recommendations.extremeWeather' => '⚠️ Condiciones extremas. Evita conducir y busca refugio seguro.',
			'weatherWidget.recommendations.kDefault' => 'Condiciones estables para conducir. ¡Buen viaje!',
			'currency.title' => 'Convertidor de Divisas',
			'currency.refreshTooltip' => 'Actualizar Tasa',
			'currency.amountLabel' => 'Monto ({code})',
			'currency.swapTooltip' => 'Intercambiar Divisas',
			'currency.convertedAmount' => 'Monto convertido',
			'currency.rateLabel' => 'Tasa: 1 {from} = {rate} {to}',
			'currency.errorLoad' => 'Error al cargar tasas de cambio',
			'currency.tryAgain' => 'Intentar de nuevo',
			'currency.converterLabel' => 'CONVERTIDOR DE DIVISAS',
			'currency.refreshRate' => 'Actualizar tasa',
			'currency.swapCurrencies' => 'Intercambiar divisas',
			'currency.rateDesc' => 'Tasa: 1 {from} = {rate} {to}',
			'currency.errorLoadingRates' => 'Error al cargar tasas de cambio',
			'validators.requiredParams' => '{field} es requerido',
			'validators.notEmptyParams' => 'El campo {field} no puede estar vacío',
			'validators.minParams' => '{field} debe ser al menos {min}',
			'validators.maxParams' => '{field} no puede exceder {max}',
			'validators.plateRequired' => 'La matrícula es obligatoria',
			'validators.plateTooShort' => 'La matrícula es muy corta',
			'validators.plateTooLong' => 'La matrícula es muy larga',
			'validators.numberRequired' => 'Debe ser un número válido',
			'validators.emailRequired' => 'El correo es obligatorio',
			'validators.emailInvalid' => 'Ingresa un correo electrónico válido',
			'validators.passwordRequired' => 'La contraseña es obligatoria',
			'validators.passwordLength' => 'La contraseña debe tener al menos 8 caracteres',
			'validators.passwordUppercase' => 'Debe contener al menos una letra mayúscula',
			'validators.passwordNumber' => 'Debe contener al menos un número',
			'validators.nameRequired' => 'El nombre completo es obligatorio',
			'validators.nameLength' => 'El nombre debe tener al menos 3 caracteres',
			'validators.phoneRequired' => 'El número de teléfono es obligatorio',
			'validators.phoneLength' => 'El teléfono debe tener entre 10 y 15 dígitos',
			'validators.dateRequired' => 'La fecha es requerida',
			'validators.ageRequirement' => 'Debes tener al menos 16 años',
			'validators.invalidDateFormat' => 'Formato de fecha inválido',
			'weather.alert' => 'ALERTA CLIMÁTICA',
			'weather.unavailable' => 'Clima no disponible',
			'weather.tapToRetry' => 'Toca para reintentar',
			'weather.conditions.clear' => 'Despejado',
			'weather.conditions.cloudy' => 'Nublado',
			'weather.conditions.rainy' => 'Lluvioso',
			'weather.conditions.drizzle' => 'Llovizna',
			'weather.conditions.storm' => 'Tormenta',
			'weather.conditions.snow' => 'Nieve',
			'weather.conditions.foggy' => 'Niebla',
			'weather.conditions.extreme' => 'Extremo',
			'weather.conditions.variable' => 'Variable',
			'weather.recommendations.extremeHeat' => 'Calor extremo. Mantente hidratado y revisa el sistema de enfriamiento del motor.',
			'weather.recommendations.stayHydrated' => 'Mantente hidratado. Asegúrate de que el aire acondicionado funcione correctamente.',
			'weather.recommendations.freezing' => 'Temperaturas bajo cero. Calienta el motor antes de conducir y revisa el anticongelante.',
			'weather.recommendations.coldWeather' => 'Abrígate bien. Revisa el estado de la batería y calienta el motor brevemente.',
			'weather.recommendations.rainyConditions' => 'Reduce la velocidad un 30% y aumenta la distancia de seguridad. Enciende las luces.',
			'weather.recommendations.thunderstorm' => 'Alerta de tormenta eléctrica. Evita conducir si es posible. Quédate dentro del vehículo.',
			'weather.recommendations.snowConditions' => 'Condiciones de nieve. Usa cadenas y reduce drásticamente la velocidad.',
			'weather.recommendations.foggyConditions' => 'Usa luces bajas. Reduce la velocidad y mantén una mayor distancia de seguridad.',
			'weather.recommendations.strongWind' => 'Vientos fuertes detectados. Sujeta el volante con firmeza, especialmente en puentes.',
			'weather.recommendations.extremeWeather' => 'Condiciones extremas. Evita conducir y busca un refugio seguro.',
			'weather.recommendations.stable' => 'Condiciones de conducción estables. ¡Buen viaje!',
			'time.now' => 'Ahora',
			'time.today' => 'Hoy',
			'time.minutesAgo' => 'Hace {n} min',
			'time.hoursAgo' => 'Hace {n}h',
			'time.daysAgo' => 'Hace {n}d',
			'time.monthsAgo' => 'Hace {n}m',
			'time.yearsAgo' => 'Hace {n}a',
			_ => null,
		};
	}
}
