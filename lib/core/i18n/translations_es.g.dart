///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEs = Translations; // ignore: unused_element
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
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsCommonEs common = TranslationsCommonEs._(_root);
	late final TranslationsAuthEs auth = TranslationsAuthEs._(_root);
	late final TranslationsRegistrationEs registration = TranslationsRegistrationEs._(_root);
	late final TranslationsNavEs nav = TranslationsNavEs._(_root);
	late final TranslationsGarageEs garage = TranslationsGarageEs._(_root);
	late final TranslationsMaintenanceEs maintenance = TranslationsMaintenanceEs._(_root);
	late final TranslationsProfileEs profile = TranslationsProfileEs._(_root);
	late final TranslationsNotificationsEs notifications = TranslationsNotificationsEs._(_root);
	late final TranslationsMapEs map = TranslationsMapEs._(_root);
	late final TranslationsWeatherWidgetEs weatherWidget = TranslationsWeatherWidgetEs._(_root);
	late final TranslationsCurrencyEs currency = TranslationsCurrencyEs._(_root);
	late final TranslationsValidatorsEs validators = TranslationsValidatorsEs._(_root);
	late final TranslationsWeatherEs weather = TranslationsWeatherEs._(_root);
	late final TranslationsTimeEs time = TranslationsTimeEs._(_root);
}

// Path: common
class TranslationsCommonEs {
	TranslationsCommonEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'DriveTrack'
	String get appName => 'DriveTrack';

	/// es: 'Aceptar'
	String get ok => 'Aceptar';

	/// es: 'Cancelar'
	String get cancel => 'Cancelar';

	/// es: 'Cargando...'
	String get loading => 'Cargando...';

	/// es: 'Ocurrió un error inesperado'
	String get error => 'Ocurrió un error inesperado';

	/// es: 'Reintentar'
	String get retry => 'Reintentar';

	/// es: 'Guardar'
	String get save => 'Guardar';

	/// es: 'Eliminar'
	String get delete => 'Eliminar';

	/// es: 'Editar'
	String get edit => 'Editar';

	/// es: 'Cerrar'
	String get close => 'Cerrar';

	/// es: 'Confirmar'
	String get confirm => 'Confirmar';

	/// es: 'Vehículo desconocido'
	String get unknownVehicle => 'Vehículo desconocido';

	/// es: 'Gratis'
	String get free => 'Gratis';

	/// es: 'Ninguno'
	String get none => 'Ninguno';

	/// es: 'Volver'
	String get back => 'Volver';

	/// es: 'Configuración y Unidades'
	String get settingsAndUnits => 'Configuración y Unidades';

	/// es: 'Ejemplos en tiempo real'
	String get realTimeExamples => 'Ejemplos en tiempo real';

	/// es: 'Distancia total'
	String get totalDistance => 'Distancia total';

	/// es: 'Temperatura de operación'
	String get operatingTemperature => 'Temperatura de operación';

	/// es: 'Sin conexión. Verifica tu internet e intenta de nuevo.'
	String get networkError => 'Sin conexión. Verifica tu internet e intenta de nuevo.';

	/// es: 'La solicitud tardó demasiado. Intenta de nuevo.'
	String get timeoutError => 'La solicitud tardó demasiado. Intenta de nuevo.';

	/// es: 'Correo o contraseña incorrectos.'
	String get unauthorizedError => 'Correo o contraseña incorrectos.';

	/// es: 'El recurso solicitado no fue encontrado.'
	String get notFoundError => 'El recurso solicitado no fue encontrado.';

	/// es: 'Los datos ingresados no son válidos. Revísalos e intenta de nuevo.'
	String get validationError => 'Los datos ingresados no son válidos. Revísalos e intenta de nuevo.';

	/// es: 'El servidor no está disponible. Intenta más tarde.'
	String get serverError => 'El servidor no está disponible. Intenta más tarde.';

	/// es: 'No pudimos completar la solicitud. Intenta de nuevo.'
	String get requestError => 'No pudimos completar la solicitud. Intenta de nuevo.';
}

// Path: auth
class TranslationsAuthEs {
	TranslationsAuthEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Bienvenido de vuelta'
	String get welcomeBack => 'Bienvenido de vuelta';

	/// es: 'Inicia sesión para continuar rastreando tus vehículos'
	String get signInSubtitle => 'Inicia sesión para continuar rastreando tus vehículos';

	/// es: 'CORREO ELECTRÓNICO'
	String get emailAddress => 'CORREO ELECTRÓNICO';

	/// es: 'juan@ejemplo.com'
	String get emailPlaceholder => 'juan@ejemplo.com';

	/// es: 'CONTRASEÑA'
	String get password => 'CONTRASEÑA';

	/// es: '¿Olvidaste tu contraseña?'
	String get forgotPassword => '¿Olvidaste tu contraseña?';

	/// es: 'Iniciar sesión'
	String get signIn => 'Iniciar sesión';

	/// es: '¿No tienes una cuenta? '
	String get noAccount => '¿No tienes una cuenta? ';

	/// es: 'Regístrate'
	String get signUp => 'Regístrate';

	/// es: 'Sesión expirada'
	String get sessionExpiredTitle => 'Sesión expirada';

	/// es: 'Tu sesión expiró. Por favor inicia sesión de nuevo.'
	String get sessionExpiredMessage => 'Tu sesión expiró. Por favor inicia sesión de nuevo.';

	/// es: 'Tu sesión expiró, inicia sesión de nuevo.'
	String get sessionExpiredSnackbar => 'Tu sesión expiró, inicia sesión de nuevo.';
}

// Path: registration
class TranslationsRegistrationEs {
	TranslationsRegistrationEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Crear cuenta'
	String get title => 'Crear cuenta';

	/// es: 'Completa tus datos para comenzar'
	String get subtitle => 'Completa tus datos para comenzar';

	/// es: 'Tu compañero inteligente de vehículos'
	String get appTagline => 'Tu compañero inteligente de vehículos';

	/// es: 'NOMBRE COMPLETO'
	String get fullName => 'NOMBRE COMPLETO';

	/// es: 'Juan Pérez'
	String get fullNamePlaceholder => 'Juan Pérez';

	/// es: 'NÚMERO DE TELÉFONO'
	String get phoneNumber => 'NÚMERO DE TELÉFONO';

	/// es: '+52 55 1234 5678'
	String get phonePlaceholder => '+52 55 1234 5678';

	/// es: '10–15 dígitos, incluyendo código de país'
	String get phoneHint => '10–15 dígitos, incluyendo código de país';

	/// es: 'FECHA DE NACIMIENTO'
	String get dateOfBirth => 'FECHA DE NACIMIENTO';

	/// es: 'YYYY-MM-DD'
	String get datePlaceholder => 'YYYY-MM-DD';

	/// es: 'Mín. 8 caracteres'
	String get passwordPlaceholder => 'Mín. 8 caracteres';

	/// es: 'Crear cuenta'
	String get createAccount => 'Crear cuenta';

	/// es: '¡Bienvenido a DriveTrack!'
	String get welcomeSuccess => '¡Bienvenido a DriveTrack!';

	/// es: '¿Ya tienes cuenta? '
	String get alreadyHaveAccount => '¿Ya tienes cuenta? ';

	/// es: 'Débil'
	String get passwordWeak => 'Débil';

	/// es: 'Regular'
	String get passwordFair => 'Regular';

	/// es: 'Fuerte'
	String get passwordStrong => 'Fuerte';

	/// es: '8+ caracteres'
	String get passwordCheck8Chars => '8+ caracteres';

	/// es: 'Mayúscula'
	String get passwordCheckUppercase => 'Mayúscula';

	/// es: 'Número'
	String get passwordCheckNumber => 'Número';
}

// Path: nav
class TranslationsNavEs {
	TranslationsNavEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Garaje'
	String get garage => 'Garaje';

	/// es: 'Historial'
	String get history => 'Historial';

	/// es: 'Mapa'
	String get map => 'Mapa';

	/// es: 'Perfil'
	String get profile => 'Perfil';
}

// Path: garage
class TranslationsGarageEs {
	TranslationsGarageEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Tus vehículos'
	String get yourVehicles => 'Tus vehículos';

	/// es: 'Agregar vehículo'
	String get addVehicle => 'Agregar vehículo';

	/// es: 'Vehículo agregado exitosamente'
	String get vehicleAdded => 'Vehículo agregado exitosamente';

	/// es: 'Vehículo actualizado exitosamente'
	String get vehicleUpdated => 'Vehículo actualizado exitosamente';

	/// es: 'Vehículo eliminado'
	String get vehicleRemoved => 'Vehículo eliminado';

	/// es: 'No se pudo agregar el vehículo. Intenta de nuevo.'
	String get errorAddingVehicle => 'No se pudo agregar el vehículo. Intenta de nuevo.';

	/// es: 'No se pudo actualizar el vehículo. Intenta de nuevo.'
	String get errorUpdatingVehicle => 'No se pudo actualizar el vehículo. Intenta de nuevo.';

	/// es: 'No se pudo eliminar el vehículo. Intenta de nuevo.'
	String get errorRemovingVehicle => 'No se pudo eliminar el vehículo. Intenta de nuevo.';

	/// es: 'Servicio registrado para {vehicleName}'
	String get serviceLogged => 'Servicio registrado para {vehicleName}';

	/// es: 'Registro de servicio actualizado'
	String get serviceRecordUpdated => 'Registro de servicio actualizado';

	/// es: '¿Eliminar vehículo?'
	String get removeVehicleTitle => '¿Eliminar vehículo?';

	/// es: '¿Estás seguro de que quieres eliminar "{vehicleName}" de tu garaje? Esta acción también eliminará todos los registros de mantenimiento asociados.'
	String get removeVehicleMessage => '¿Estás seguro de que quieres eliminar "{vehicleName}" de tu garaje? Esta acción también eliminará todos los registros de mantenimiento asociados.';

	/// es: '¡Error de sincronización!'
	String get errorSyncFailed => '¡Error de sincronización!';

	/// es: 'No pudimos cargar tus vehículos. Por favor verifica tu conexión.'
	String get errorSyncMessage => 'No pudimos cargar tus vehículos. Por favor verifica tu conexión.';

	/// es: '(one) {Vehículo} (other) {Vehículos}'
	String vehicleCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: 'Vehículo',
		other: 'Vehículos',
	);

	/// es: 'Tu vehículo'
	String get yourVehicle => 'Tu vehículo';

	/// es: 'Matrícula no configurada'
	String get plateNotSet => 'Matrícula no configurada';

	/// es: 'Salud general'
	String get overallHealth => 'Salud general';

	/// es: 'Total gastado'
	String get totalSpent => 'Total gastado';

	/// es: 'Servicios'
	String get services => 'Servicios';

	/// es: 'Último: {title} ({time})'
	String get lastService => 'Último: {title} ({time})';

	/// es: 'Servicios pendientes'
	String get servicesDue => 'Servicios pendientes';

	/// es: 'No se encontraron registros'
	String get noRecordsFound => 'No se encontraron registros';

	/// es: 'Lleva el control de tu vehículo registrando tu primer servicio.'
	String get noRecordsMessage => 'Lleva el control de tu vehículo\nregistrando tu primer servicio.';

	/// es: 'Tu garaje está vacío'
	String get emptyGarageTitle => 'Tu garaje está vacío';

	/// es: 'Toca el botón de abajo para agregar tu primer vehículo y comenzar a rastrear su rendimiento.'
	String get emptyGarageMessage => 'Toca el botón de abajo para agregar tu primer vehículo y comenzar a rastrear su rendimiento.';

	/// es: '¿Eliminar registro de servicio?'
	String get deleteServiceTitle => '¿Eliminar registro de servicio?';

	/// es: '¿Estás seguro de que quieres eliminar este registro de "{title}"? Esta acción no se puede deshacer.'
	String get deleteServiceMessage => '¿Estás seguro de que quieres eliminar este registro de "{title}"? Esta acción no se puede deshacer.';

	/// es: 'Editar vehículo'
	String get editVehicle => 'Editar vehículo';

	/// es: 'Eliminar vehículo'
	String get removeVehicle => 'Eliminar vehículo';

	/// es: 'Tipo de vehículo'
	String get vehicleType => 'Tipo de vehículo';

	/// es: 'Vehículos'
	String get vehicles => 'Vehículos';

	/// es: 'Buenos días,'
	String get goodMorning => 'Buenos días,';

	/// es: 'Mi garaje'
	String get myGarage => 'Mi garaje';

	/// es: 'Salud prom.'
	String get avgHealth => 'Salud prom.';

	/// es: 'Millas totales'
	String get totalMiles => 'Millas totales';

	/// es: 'Alertas'
	String get alerts => 'Alertas';

	late final TranslationsGarageAddVehicleFormEs addVehicleForm = TranslationsGarageAddVehicleFormEs._(_root);
	late final TranslationsGarageVehicleTypesEs vehicleTypes = TranslationsGarageVehicleTypesEs._(_root);

	/// es: 'Salud del Vehículo'
	String get vehicleHealth => 'Salud del Vehículo';

	/// es: 'Límite: {mileage} mi'
	String get limitMileage => 'Límite: {mileage} mi';

	/// es: 'Saludable'
	String get statusHealthy => 'Saludable';

	/// es: 'Requiere Servicio'
	String get statusNeedsService => 'Requiere Servicio';

	/// es: 'Crítico'
	String get statusCritical => 'Crítico';

	/// es: 'ÚLTIMO'
	String get recentServiceLabel => 'ÚLTIMO';

	/// es: 'MANTENIMIENTO RECIENTE'
	String get recentMaintenance => 'MANTENIMIENTO RECIENTE';

	/// es: '(one) {1 registro} (zero) {0 registros} (other) {{count} registros}'
	String recordsCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: '1 registro',
		zero: '0 registros',
		other: '{count} registros',
	);

	/// es: 'Millas totales'
	String get totalDistanceMiles => 'Millas totales';

	/// es: 'Kilómetros totales'
	String get totalDistanceKm => 'Kilómetros totales';

	/// es: 'Kilómetros'
	String get unitKilometers => 'Kilómetros';

	/// es: 'mi'
	String get unitMiShort => 'mi';

	/// es: 'km'
	String get unitKmShort => 'km';

	/// es: 'Notificaciones, {count} no leídas'
	String get notificationsUnread => 'Notificaciones, {count} no leídas';

	/// es: 'Notificaciones, sin novedades'
	String get notificationsNone => 'Notificaciones, sin novedades';

	/// es: 'Buenas tardes'
	String get goodAfternoon => 'Buenas tardes';

	/// es: 'Buenas noches'
	String get goodEvening => 'Buenas noches';
}

// Path: maintenance
class TranslationsMaintenanceEs {
	TranslationsMaintenanceEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Mantenimiento'
	String get title => 'Mantenimiento';

	/// es: 'Registro de mantenimiento'
	String get logTitle => 'Registro de mantenimiento';

	/// es: 'Historial completo de servicio para tus vehículos'
	String get logSubtitle => 'Historial completo de servicio para tus vehículos';

	/// es: 'Todos los vehículos'
	String get allVehicles => 'Todos los vehículos';

	/// es: 'Agregar servicio'
	String get addService => 'Agregar servicio';

	/// es: 'Servicio agregado exitosamente'
	String get serviceAdded => 'Servicio agregado exitosamente';

	/// es: 'Registro de servicio actualizado'
	String get serviceUpdated => 'Registro de servicio actualizado';

	/// es: 'Registro de servicio eliminado'
	String get serviceRemoved => 'Registro de servicio eliminado';

	/// es: 'Error al agregar servicio: {error}'
	String get errorAddingService => 'Error al agregar servicio: {error}';

	/// es: 'Error al actualizar registro: {error}'
	String get errorUpdatingService => 'Error al actualizar registro: {error}';

	/// es: 'No se pudo eliminar el servicio. Intenta de nuevo.'
	String get errorRemovingService => 'No se pudo eliminar el servicio. Intenta de nuevo.';

	/// es: '¿Eliminar registro?'
	String get removeEntryTitle => '¿Eliminar registro?';

	/// es: '¿Estás seguro de que quieres eliminar el registro de "{title}"? Esta acción no se puede deshacer.'
	String get removeEntryMessage => '¿Estás seguro de que quieres eliminar el registro de "{title}"? Esta acción no se puede deshacer.';

	/// es: 'Algo salió mal'
	String get errorTitle => 'Algo salió mal';

	/// es: 'Tuvimos problemas al obtener tus datos. Por favor verifica tu conexión o intenta de nuevo.'
	String get errorMessage => 'Tuvimos problemas al obtener tus datos. Por favor verifica tu conexión o intenta de nuevo.';

	/// es: 'Total gastado'
	String get totalSpent => 'Total gastado';

	/// es: 'Servicios'
	String get servicesLabel => 'Servicios';

	/// es: 'Vehículos'
	String get vehiclesLabel => 'Vehículos';

	/// es: 'No se encontraron registros'
	String get noRecordsTitle => 'No se encontraron registros';

	/// es: 'Intenta ajustar tus filtros o búsqueda para encontrar lo que buscas.'
	String get noRecordsFiltering => 'Intenta ajustar tus filtros o búsqueda para encontrar lo que buscas.';

	/// es: 'Comienza a rastrear el historial de mantenimiento de tu vehículo para mantenerlo en máximo rendimiento.'
	String get noRecordsEmpty => 'Comienza a rastrear el historial de mantenimiento de tu vehículo para mantenerlo en máximo rendimiento.';

	/// es: 'Aún no hay registros de servicio'
	String get noServiceRecords => 'Aún no hay registros de servicio';

	/// es: 'Agregar registro de servicio'
	String get addServiceRecord => 'Agregar registro de servicio';

	/// es: 'Registrar una actividad de mantenimiento'
	String get logActivity => 'Registrar una actividad de mantenimiento';

	/// es: 'Vehículo'
	String get vehicle => 'Vehículo';

	/// es: 'Descripción del servicio'
	String get serviceDescription => 'Descripción del servicio';

	/// es: 'Fecha'
	String get date => 'Fecha';

	/// es: 'Costo (USD)'
	String get costUsd => 'Costo (USD)';

	/// es: 'Kilometraje'
	String get mileage => 'Kilometraje';

	/// es: 'Categoría'
	String get category => 'Categoría';

	/// es: 'Notas'
	String get notes => 'Notas';

	/// es: 'Notas adicionales (opcional)'
	String get notesHint => 'Notas adicionales (opcional)';

	/// es: 'Servicio'
	String get service => 'Servicio';

	/// es: 'Editar registro'
	String get editEntry => 'Editar registro';

	/// es: 'Eliminar registro'
	String get deleteEntry => 'Eliminar registro';

	/// es: 'Inversión total'
	String get totalInvestment => 'Inversión total';

	/// es: 'Servicio profesional'
	String get professionalService => 'Servicio profesional';

	/// es: 'No se proporcionaron notas adicionales para esta entrada de servicio.'
	String get noNotes => 'No se proporcionaron notas adicionales para esta entrada de servicio.';

	/// es: 'ej. Cambio de aceite, Rotación...'
	String get servicePlaceholder => 'ej. Cambio de aceite, Rotación...';

	/// es: 'ej. 42000'
	String get mileagePlaceholder => 'ej. 42000';

	/// es: 'Detalles adicionales...'
	String get detailsPlaceholder => 'Detalles adicionales...';

	/// es: 'Actualizar Registro'
	String get btnUpdate => 'Actualizar Registro';

	/// es: 'Guardar Registro'
	String get btnSave => 'Guardar Registro';

	/// es: 'Registro Actualizado'
	String get btnUpdated => 'Registro Actualizado';

	/// es: 'Registro Guardado'
	String get btnSaved => 'Registro Guardado';

	/// es: 'VISTA PREVIA'
	String get recordPreview => 'VISTA PREVIA';

	/// es: 'Servicio sin título'
	String get untitledService => 'Servicio sin título';

	/// es: 'Desconocido'
	String get unknownVehicle => 'Desconocido';

	/// es: 'COSTO'
	String get costLabel => 'COSTO';

	/// es: 'Gratis'
	String get costFree => 'Gratis';

	/// es: 'KILOMETRAJE'
	String get mileageLabel => 'KILOMETRAJE';

	/// es: 'NOTAS DEL SERVICIO'
	String get serviceNotesLabel => 'NOTAS DEL SERVICIO';

	/// es: 'General'
	String get categoryGeneral => 'General';

	/// es: 'Historial'
	String get historyLabel => 'Historial';

	late final TranslationsMaintenanceCategoriesEs categories = TranslationsMaintenanceCategoriesEs._(_root);
}

// Path: profile
class TranslationsProfileEs {
	TranslationsProfileEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Preferencias de vehículo'
	String get vehiclePreferences => 'Preferencias de vehículo';

	/// es: 'Vehículos favoritos'
	String get favoriteVehicles => 'Vehículos favoritos';

	/// es: '(one) {1 favorito guardado} (zero) {Sin favoritos guardados} (other) {{n} favoritos guardados}'
	String favoritesSaved({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: '1 favorito guardado',
		zero: 'Sin favoritos guardados',
		other: '{n} favoritos guardados',
	);

	/// es: 'Aún no tienes vehículos favoritos'
	String get noFavorites => 'Aún no tienes vehículos favoritos';

	/// es: 'Notificaciones'
	String get notifications => 'Notificaciones';

	/// es: 'Configura tus alertas'
	String get configureAlerts => 'Configura tus alertas';

	/// es: 'Notificaciones push'
	String get pushNotifications => 'Notificaciones push';

	/// es: 'Recordatorios de servicio'
	String get serviceReminders => 'Recordatorios de servicio';

	/// es: 'Alertas críticas'
	String get criticalAlerts => 'Alertas críticas';

	/// es: 'Privacidad y seguridad'
	String get privacySecurity => 'Privacidad y seguridad';

	/// es: '2FA activo · Protegido'
	String get securitySubtitleActive => '2FA activo · Protegido';

	/// es: 'Contraseña y privacidad'
	String get securitySubtitleDefault => 'Contraseña y privacidad';

	/// es: 'Restablecer contraseña'
	String get passwordReset => 'Restablecer contraseña';

	/// es: 'Último cambio hace 30 días'
	String get passwordLastChanged => 'Último cambio hace 30 días';

	/// es: 'Restablecer'
	String get reset => 'Restablecer';

	/// es: 'Autenticación en dos pasos (2FA)'
	String get twoFactor => 'Autenticación en dos pasos (2FA)';

	/// es: '● Activo'
	String get twoFactorEnabled => '● Activo';

	/// es: '○ Inactivo — toca para activar'
	String get twoFactorDisabled => '○ Inactivo — toca para activar';

	/// es: 'Configuración de la app'
	String get appSettings => 'Configuración de la app';

	/// es: 'Tema: {theme} · Idioma: {language}'
	String get appSettingsSubtitle => 'Tema: {theme} · Idioma: {language}';

	/// es: 'Oscuro'
	String get themeDark => 'Oscuro';

	/// es: 'Claro'
	String get themeLight => 'Claro';

	/// es: 'Tema'
	String get theme => 'Tema';

	/// es: 'Idioma'
	String get language => 'Idioma';

	/// es: 'Soporte'
	String get feedbackSupport => 'Soporte';

	/// es: 'Calificar DriveTrack'
	String get rateDriveTrack => 'Calificar DriveTrack';

	/// es: 'Comparte tu experiencia'
	String get shareExperience => 'Comparte tu experiencia';

	/// es: 'Ayuda y soporte'
	String get helpSupport => 'Ayuda y soporte';

	/// es: 'Preguntas frecuentes, Contáctanos'
	String get faqsContact => 'Preguntas frecuentes, Contáctanos';

	/// es: 'Preguntas frecuentes'
	String get faqs => 'Preguntas frecuentes';

	/// es: 'Soporte por chat'
	String get chatSupport => 'Soporte por chat';

	/// es: 'Cerrar sesión'
	String get signOut => 'Cerrar sesión';

	/// es: 'Hecho con ❤️ para conductores en todo el mundo'
	String get footerTagline => 'Hecho con ❤️ para conductores en todo el mundo';

	/// es: 'Conductor'
	String get driver => 'Conductor';

	/// es: 'Estado activo'
	String get activeStatus => 'Estado activo';

	/// es: 'Miembro desde {year}'
	String get memberSince => 'Miembro desde {year}';

	/// es: 'Vehículos'
	String get statsVehicles => 'Vehículos';

	/// es: 'vinculados'
	String get statsVehiclesSub => 'vinculados';

	/// es: 'Servicios'
	String get statsServices => 'Servicios';

	/// es: 'registrados'
	String get statsServicesSub => 'registrados';

	/// es: 'Ahorros'
	String get statsSaved => 'Ahorros';

	/// es: 'en costos'
	String get statsSavedSub => 'en costos';

	/// es: 'Sistema de Unidades'
	String get systemOfUnits => 'Sistema de Unidades';

	/// es: 'Métrico'
	String get metric => 'Métrico';

	/// es: 'Imperial'
	String get imperial => 'Imperial';

	/// es: 'Editar Perfil'
	String get editProfile => 'Editar Perfil';

	/// es: 'Nombre Completo'
	String get editProfileName => 'Nombre Completo';

	/// es: 'Guardar Cambios'
	String get editProfileSave => 'Guardar Cambios';

	/// es: 'Perfil actualizado exitosamente'
	String get editProfileSuccess => 'Perfil actualizado exitosamente';

	/// es: 'Cambiar Contraseña'
	String get changePassword => 'Cambiar Contraseña';

	/// es: 'Contraseña Actual'
	String get currentPassword => 'Contraseña Actual';

	/// es: 'Nueva Contraseña'
	String get newPassword => 'Nueva Contraseña';

	/// es: 'Confirmar Contraseña'
	String get confirmNewPassword => 'Confirmar Contraseña';

	/// es: 'Contraseña actualizada exitosamente'
	String get changePasswordSuccess => 'Contraseña actualizada exitosamente';

	/// es: 'La contraseña actual es incorrecta'
	String get changePasswordError => 'La contraseña actual es incorrecta';

	/// es: 'Las contraseñas no coinciden'
	String get passwordsMismatch => 'Las contraseñas no coinciden';

	/// es: 'Llamar a Soporte'
	String get callSupport => 'Llamar a Soporte';

	/// es: '+52 664 536 7724'
	String get supportPhone => '+52 664 536 7724';

	/// es: 'Cargando preferencias...'
	String get loadingPreferences => 'Cargando preferencias...';

	/// es: 'No se pudieron cargar las preferencias'
	String get errorLoadingPreferences => 'No se pudieron cargar las preferencias';

	/// es: 'No se pudieron cargar las estadísticas'
	String get errorLoadingStats => 'No se pudieron cargar las estadísticas';

	/// es: 'Cambiar foto'
	String get changePhoto => 'Cambiar foto';

	/// es: 'Cámara'
	String get camera => 'Cámara';

	/// es: 'Galería'
	String get gallery => 'Galería';

	/// es: 'Subiendo foto...'
	String get uploadingPhoto => 'Subiendo foto...';
}

// Path: notifications
class TranslationsNotificationsEs {
	TranslationsNotificationsEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Notificaciones'
	String get title => 'Notificaciones';

	/// es: '{unread} sin leer · {total} en total'
	String get unreadSummary => '{unread} sin leer · {total} en total';

	/// es: 'Marcar todo como leído'
	String get markAllRead => 'Marcar todo como leído';

	/// es: 'Todos'
	String get filterAll => 'Todos';

	/// es: 'No leídos'
	String get filterUnread => 'No leídos';

	/// es: 'Advertencias'
	String get filterWarnings => 'Advertencias';

	/// es: 'Exitosos'
	String get filterSuccess => 'Exitosos';

	/// es: 'Clima'
	String get filterWeather => 'Clima';

	/// es: 'Todos'
	String get summaryAll => 'Todos';

	/// es: 'Advertencias'
	String get summaryWarnings => 'Advertencias';

	/// es: 'Exitosos'
	String get summarySuccess => 'Exitosos';

	/// es: 'Clima'
	String get summaryWeather => 'Clima';

	/// es: '¡Todo al día!'
	String get emptyTitle => '¡Todo al día!';

	/// es: 'No hay notificaciones en esta categoría'
	String get emptySubtitle => 'No hay notificaciones en esta categoría';

	/// es: 'Error al cargar notificaciones'
	String get errorLoading => 'Error al cargar notificaciones';

	/// es: 'Verifica tu conexión y vuelve a intentarlo.'
	String get errorHint => 'Verifica tu conexión y vuelve a intentarlo.';

	/// es: 'Reintentar'
	String get retryButton => 'Reintentar';

	/// es: 'Leer todas'
	String get markAllReadButton => 'Leer todas';

	/// es: 'Sin notificaciones'
	String get emptyPageTitle => 'Sin notificaciones';

	/// es: 'Cuando recibas notificaciones aparecerán aquí.'
	String get emptyPageSubtitle => 'Cuando recibas notificaciones aparecerán aquí.';

	/// es: 'Advertencia'
	String get typeWarning => 'Advertencia';

	/// es: 'Exitoso'
	String get typeSuccess => 'Exitoso';

	/// es: 'Clima'
	String get typeWeather => 'Clima';

	/// es: 'Información'
	String get typeInfo => 'Información';

	/// es: 'Error'
	String get typeError => 'Error';

	/// es: 'Info'
	String get filterInfo => 'Info';

	/// es: 'Info'
	String get summaryInfo => 'Info';

	late final TranslationsNotificationsMocksEs mocks = TranslationsNotificationsMocksEs._(_root);
}

// Path: map
class TranslationsMapEs {
	TranslationsMapEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Explorar cercano'
	String get exploreNearby => 'Explorar cercano';

	/// es: 'Mapa de servicios'
	String get title => 'Mapa de servicios';

	/// es: 'En vivo'
	String get live => 'En vivo';

	/// es: 'Buscar talleres, gasolineras...'
	String get searchHint => 'Buscar talleres, gasolineras...';

	/// es: 'Todos'
	String get filterAll => 'Todos';

	/// es: 'Talleres'
	String get filterWorkshops => 'Talleres';

	/// es: 'Gasolineras'
	String get filterGasStations => 'Gasolineras';

	/// es: 'Tú'
	String get you => 'Tú';

	/// es: 'PARQUE CENTRAL'
	String get cityPark => 'PARQUE CENTRAL';

	/// es: 'Resultados cercanos'
	String get nearbyResults => 'Resultados cercanos';

	/// es: 'Desliza hacia arriba para ver todas las opciones'
	String get swipeUp => 'Desliza hacia arriba para ver todas las opciones';

	/// es: 'Abierto ahora'
	String get openNow => 'Abierto ahora';

	/// es: 'Cerrado'
	String get closed => 'Cerrado';

	/// es: 'Navegar'
	String get navigate => 'Navegar';

	/// es: 'Navegando a {name}...'
	String get navigatingTo => 'Navegando a {name}...';

	/// es: 'Llamando a {phone}...'
	String get calling => 'Llamando a {phone}...';

	/// es: '{count} ubicaciones encontradas'
	String get locationsFound => '{count} ubicaciones encontradas';

	/// es: 'Especialidades'
	String get specialties => 'Especialidades';

	/// es: 'Mi Ubicación'
	String get myLocation => 'Mi Ubicación';

	/// es: 'Cargando mapa...'
	String get loadingMap => 'Cargando mapa...';

	/// es: 'No se pudieron cargar las ubicaciones'
	String get errorLoadingMap => 'No se pudieron cargar las ubicaciones';

	/// es: 'No se encontraron resultados'
	String get noResults => 'No se encontraron resultados';

	/// es: 'Acercar'
	String get zoomIn => 'Acercar';

	/// es: 'Alejar'
	String get zoomOut => 'Alejar';

	/// es: 'El servidor de mapas está saturado. Reintenta en unos segundos.'
	String get overpassError => 'El servidor de mapas está saturado. Reintenta en unos segundos.';

	/// es: 'Buscar en esta zona'
	String get searchThisArea => 'Buscar en esta zona';

	/// es: 'Buscando ubicación GPS... Asegúrate de tener la ubicación activada en tu dispositivo.'
	String get gpsSearching => 'Buscando ubicación GPS... Asegúrate de tener la ubicación activada en tu dispositivo.';
}

// Path: weatherWidget
class TranslationsWeatherWidgetEs {
	TranslationsWeatherWidgetEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'ALERTA DEL CLIMA'
	String get alert => 'ALERTA DEL CLIMA';

	/// es: '{weather} · {temp}'
	String get condition => '{weather} · {temp}';

	/// es: '{value}%'
	String get humidity => '{value}%';

	/// es: 'Obteniendo clima...'
	String get loading => 'Obteniendo clima...';

	/// es: 'Clima no disponible'
	String get errorTitle => 'Clima no disponible';

	/// es: 'Toca para reintentar'
	String get errorRetry => 'Toca para reintentar';

	/// es: 'Ubicación aproximada'
	String get fallbackLocation => 'Ubicación aproximada';

	/// es: 'Actualizado {time}'
	String get lastUpdated => 'Actualizado {time}';

	late final TranslationsWeatherWidgetConditionsEs conditions = TranslationsWeatherWidgetConditionsEs._(_root);
	late final TranslationsWeatherWidgetRecommendationsEs recommendations = TranslationsWeatherWidgetRecommendationsEs._(_root);
}

// Path: currency
class TranslationsCurrencyEs {
	TranslationsCurrencyEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Convertidor de Divisas'
	String get title => 'Convertidor de Divisas';

	/// es: 'Actualizar Tasa'
	String get refreshTooltip => 'Actualizar Tasa';

	/// es: 'Monto ({code})'
	String get amountLabel => 'Monto ({code})';

	/// es: 'Intercambiar Divisas'
	String get swapTooltip => 'Intercambiar Divisas';

	/// es: 'Monto convertido'
	String get convertedAmount => 'Monto convertido';

	/// es: 'Tasa: 1 {from} = {rate} {to}'
	String get rateLabel => 'Tasa: 1 {from} = {rate} {to}';

	/// es: 'Error al cargar tasas de cambio'
	String get errorLoad => 'Error al cargar tasas de cambio';

	/// es: 'Intentar de nuevo'
	String get tryAgain => 'Intentar de nuevo';

	/// es: 'CONVERTIDOR DE DIVISAS'
	String get converterLabel => 'CONVERTIDOR DE DIVISAS';

	/// es: 'Actualizar tasa'
	String get refreshRate => 'Actualizar tasa';

	/// es: 'Intercambiar divisas'
	String get swapCurrencies => 'Intercambiar divisas';

	/// es: 'Tasa: 1 {from} = {rate} {to}'
	String get rateDesc => 'Tasa: 1 {from} = {rate} {to}';

	/// es: 'Error al cargar tasas de cambio'
	String get errorLoadingRates => 'Error al cargar tasas de cambio';
}

// Path: validators
class TranslationsValidatorsEs {
	TranslationsValidatorsEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: '{field} es requerido'
	String get requiredParams => '{field} es requerido';

	/// es: 'El campo {field} no puede estar vacío'
	String get notEmptyParams => 'El campo {field} no puede estar vacío';

	/// es: '{field} debe ser al menos {min}'
	String get minParams => '{field} debe ser al menos {min}';

	/// es: '{field} no puede exceder {max}'
	String get maxParams => '{field} no puede exceder {max}';

	/// es: 'La matrícula es obligatoria'
	String get plateRequired => 'La matrícula es obligatoria';

	/// es: 'La matrícula es muy corta'
	String get plateTooShort => 'La matrícula es muy corta';

	/// es: 'La matrícula es muy larga'
	String get plateTooLong => 'La matrícula es muy larga';

	/// es: 'Debe ser un número válido'
	String get numberRequired => 'Debe ser un número válido';

	/// es: 'El correo es obligatorio'
	String get emailRequired => 'El correo es obligatorio';

	/// es: 'Ingresa un correo electrónico válido'
	String get emailInvalid => 'Ingresa un correo electrónico válido';

	/// es: 'La contraseña es obligatoria'
	String get passwordRequired => 'La contraseña es obligatoria';

	/// es: 'La contraseña debe tener al menos 8 caracteres'
	String get passwordLength => 'La contraseña debe tener al menos 8 caracteres';

	/// es: 'Debe contener al menos una letra mayúscula'
	String get passwordUppercase => 'Debe contener al menos una letra mayúscula';

	/// es: 'Debe contener al menos un número'
	String get passwordNumber => 'Debe contener al menos un número';

	/// es: 'El nombre completo es obligatorio'
	String get nameRequired => 'El nombre completo es obligatorio';

	/// es: 'El nombre debe tener al menos 3 caracteres'
	String get nameLength => 'El nombre debe tener al menos 3 caracteres';

	/// es: 'El número de teléfono es obligatorio'
	String get phoneRequired => 'El número de teléfono es obligatorio';

	/// es: 'El teléfono debe tener entre 10 y 15 dígitos'
	String get phoneLength => 'El teléfono debe tener entre 10 y 15 dígitos';

	/// es: 'La fecha es requerida'
	String get dateRequired => 'La fecha es requerida';

	/// es: 'Debes tener al menos 16 años'
	String get ageRequirement => 'Debes tener al menos 16 años';

	/// es: 'Formato de fecha inválido'
	String get invalidDateFormat => 'Formato de fecha inválido';
}

// Path: weather
class TranslationsWeatherEs {
	TranslationsWeatherEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'ALERTA CLIMÁTICA'
	String get alert => 'ALERTA CLIMÁTICA';

	/// es: 'Clima no disponible'
	String get unavailable => 'Clima no disponible';

	/// es: 'Toca para reintentar'
	String get tapToRetry => 'Toca para reintentar';

	late final TranslationsWeatherConditionsEs conditions = TranslationsWeatherConditionsEs._(_root);
	late final TranslationsWeatherRecommendationsEs recommendations = TranslationsWeatherRecommendationsEs._(_root);

	/// es: 'Cambiar ciudad'
	String get changeCity => 'Cambiar ciudad';

	/// es: 'Ej. Monterrey, MX'
	String get changeCityHint => 'Ej. Monterrey, MX';

	/// es: 'Clima por ciudad'
	String get changeCityTitle => 'Clima por ciudad';

	/// es: 'Usar GPS'
	String get useGps => 'Usar GPS';

	/// es: 'Buscar'
	String get search => 'Buscar';

	/// es: 'Ciudad no encontrada. Intenta con «Ciudad, País»'
	String get cityNotFound => 'Ciudad no encontrada. Intenta con «Ciudad, País»';
}

// Path: time
class TranslationsTimeEs {
	TranslationsTimeEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Ahora'
	String get now => 'Ahora';

	/// es: 'Hoy'
	String get today => 'Hoy';

	/// es: 'Hace {n} min'
	String get minutesAgo => 'Hace {n} min';

	/// es: 'Hace {n}h'
	String get hoursAgo => 'Hace {n}h';

	/// es: 'Hace {n}d'
	String get daysAgo => 'Hace {n}d';

	/// es: 'Hace {n}m'
	String get monthsAgo => 'Hace {n}m';

	/// es: 'Hace {n}a'
	String get yearsAgo => 'Hace {n}a';
}

// Path: garage.addVehicleForm
class TranslationsGarageAddVehicleFormEs {
	TranslationsGarageAddVehicleFormEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Añadir Vehículo'
	String get titleAdd => 'Añadir Vehículo';

	/// es: 'Actualizar Vehículo'
	String get titleUpdate => 'Actualizar Vehículo';

	/// es: 'Vincula un nuevo vehículo a tu garaje'
	String get subtitle => 'Vincula un nuevo vehículo a tu garaje';

	/// es: 'Marca'
	String get brandLabel => 'Marca';

	/// es: 'Seleccionar marca...'
	String get brandHint => 'Seleccionar marca...';

	/// es: 'Modelo'
	String get modelLabel => 'Modelo';

	/// es: 'ej., Camry, Civic, F-150'
	String get modelHintCar => 'ej., Camry, Civic, F-150';

	/// es: 'ej., CBR 600RR, R1, Ninja'
	String get modelHintMoto => 'ej., CBR 600RR, R1, Ninja';

	/// es: 'Año'
	String get yearLabel => 'Año';

	/// es: 'Seleccionar año...'
	String get yearHint => 'Seleccionar año...';

	/// es: 'Matrícula'
	String get plateLabel => 'Matrícula';

	/// es: 'ej., ABC-1234'
	String get plateHint => 'ej., ABC-1234';

	/// es: 'Solo letras y números (y guiones)'
	String get plateSubHint => 'Solo letras y números (y guiones)';

	/// es: 'Kilometraje inicial (mi)'
	String get mileageLabel => 'Kilometraje inicial (mi)';

	/// es: 'ej., 25000'
	String get mileageHint => 'ej., 25000';

	/// es: 'Lectura actual del odómetro'
	String get mileageSubHint => 'Lectura actual del odómetro';

	/// es: 'Guardar Vehículo'
	String get btnSave => 'Guardar Vehículo';

	/// es: 'Guardar Coche'
	String get btnSaveCar => 'Guardar Coche';

	/// es: 'Guardar Motocicleta'
	String get btnSaveMoto => 'Guardar Motocicleta';

	/// es: 'Actualizar Vehículo'
	String get btnUpdate => 'Actualizar Vehículo';

	/// es: 'Vehículo Guardado'
	String get btnSaved => 'Vehículo Guardado';

	/// es: 'Coche Guardado'
	String get btnSavedCar => 'Coche Guardado';

	/// es: 'Motocicleta Guardada'
	String get btnSavedMoto => 'Motocicleta Guardada';

	/// es: 'Vehículo Actualizado'
	String get btnUpdated => 'Vehículo Actualizado';

	/// es: 'Cancelar'
	String get btnCancel => 'Cancelar';
}

// Path: garage.vehicleTypes
class TranslationsGarageVehicleTypesEs {
	TranslationsGarageVehicleTypesEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Coche'
	String get car => 'Coche';

	/// es: 'Motocicleta'
	String get motorcycle => 'Motocicleta';
}

// Path: maintenance.categories
class TranslationsMaintenanceCategoriesEs {
	TranslationsMaintenanceCategoriesEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'General'
	String get general => 'General';

	/// es: 'Fluidos'
	String get fluidService => 'Fluidos';

	/// es: 'Desgaste'
	String get wearAndTear => 'Desgaste';

	/// es: 'Inspección'
	String get inspection => 'Inspección';

	/// es: 'Estética'
	String get cosmetic => 'Estética';

	/// es: 'Eléctrico'
	String get electrical => 'Eléctrico';
}

// Path: notifications.mocks
class TranslationsNotificationsMocksEs {
	TranslationsNotificationsMocksEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsNotificationsMocksN1Es n1 = TranslationsNotificationsMocksN1Es._(_root);
	late final TranslationsNotificationsMocksN2Es n2 = TranslationsNotificationsMocksN2Es._(_root);
	late final TranslationsNotificationsMocksN3Es n3 = TranslationsNotificationsMocksN3Es._(_root);
	late final TranslationsNotificationsMocksN4Es n4 = TranslationsNotificationsMocksN4Es._(_root);
	late final TranslationsNotificationsMocksN5Es n5 = TranslationsNotificationsMocksN5Es._(_root);
	late final TranslationsNotificationsMocksN6Es n6 = TranslationsNotificationsMocksN6Es._(_root);
	late final TranslationsNotificationsMocksN7Es n7 = TranslationsNotificationsMocksN7Es._(_root);
	late final TranslationsNotificationsMocksN8Es n8 = TranslationsNotificationsMocksN8Es._(_root);
}

// Path: weatherWidget.conditions
class TranslationsWeatherWidgetConditionsEs {
	TranslationsWeatherWidgetConditionsEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Despejado'
	String get clear => 'Despejado';

	/// es: 'Nublado'
	String get clouds => 'Nublado';

	/// es: 'Lluvioso'
	String get rain => 'Lluvioso';

	/// es: 'Llovizna'
	String get drizzle => 'Llovizna';

	/// es: 'Tormenta'
	String get thunderstorm => 'Tormenta';

	/// es: 'Nevando'
	String get snow => 'Nevando';

	/// es: 'Neblina'
	String get fog => 'Neblina';

	/// es: 'Clima extremo'
	String get extreme => 'Clima extremo';

	/// es: 'Clima variable'
	String get unknown => 'Clima variable';
}

// Path: weatherWidget.recommendations
class TranslationsWeatherWidgetRecommendationsEs {
	TranslationsWeatherWidgetRecommendationsEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: '⚠️ Calor extremo. Mantén hidratación constante y verifica el enfriamiento del motor.'
	String get extremeHeat => '⚠️ Calor extremo. Mantén hidratación constante y verifica el enfriamiento del motor.';

	/// es: 'Mantente hidratado. Verifica que el aire acondicionado funcione correctamente.'
	String get stayHydrated => 'Mantente hidratado. Verifica que el aire acondicionado funcione correctamente.';

	/// es: '⚠️ Temperatura bajo cero. Calienta el motor antes de conducir y verifica anticongelante.'
	String get freezing => '⚠️ Temperatura bajo cero. Calienta el motor antes de conducir y verifica anticongelante.';

	/// es: 'Abrígate bien. Verifica la batería y calienta el motor brevemente.'
	String get coldWeather => 'Abrígate bien. Verifica la batería y calienta el motor brevemente.';

	/// es: 'Reduce velocidad un 30% y aumenta la distancia de seguimiento. Enciende las luces.'
	String get rainyConditions => 'Reduce velocidad un 30% y aumenta la distancia de seguimiento. Enciende las luces.';

	/// es: '⚠️ Tormenta eléctrica. Evita conducir si es posible. Mantente dentro del vehículo.'
	String get thunderstorm => '⚠️ Tormenta eléctrica. Evita conducir si es posible. Mantente dentro del vehículo.';

	/// es: '⚠️ Condiciones de nieve. Usa cadenas y reduce drásticamente la velocidad.'
	String get snowConditions => '⚠️ Condiciones de nieve. Usa cadenas y reduce drásticamente la velocidad.';

	/// es: 'Usa luces bajas. Reduce la velocidad y mantén distancia extra.'
	String get foggyConditions => 'Usa luces bajas. Reduce la velocidad y mantén distancia extra.';

	/// es: 'Viento fuerte detectado. Sujeta bien el volante, especialmente en puentes.'
	String get strongWind => 'Viento fuerte detectado. Sujeta bien el volante, especialmente en puentes.';

	/// es: '⚠️ Condiciones extremas. Evita conducir y busca refugio seguro.'
	String get extremeWeather => '⚠️ Condiciones extremas. Evita conducir y busca refugio seguro.';

	/// es: 'Condiciones estables para conducir. ¡Buen viaje!'
	String get kDefault => 'Condiciones estables para conducir. ¡Buen viaje!';
}

// Path: weather.conditions
class TranslationsWeatherConditionsEs {
	TranslationsWeatherConditionsEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Despejado'
	String get clear => 'Despejado';

	/// es: 'Nublado'
	String get cloudy => 'Nublado';

	/// es: 'Lluvioso'
	String get rainy => 'Lluvioso';

	/// es: 'Llovizna'
	String get drizzle => 'Llovizna';

	/// es: 'Tormenta'
	String get storm => 'Tormenta';

	/// es: 'Nieve'
	String get snow => 'Nieve';

	/// es: 'Niebla'
	String get foggy => 'Niebla';

	/// es: 'Extremo'
	String get extreme => 'Extremo';

	/// es: 'Variable'
	String get variable => 'Variable';
}

// Path: weather.recommendations
class TranslationsWeatherRecommendationsEs {
	TranslationsWeatherRecommendationsEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Calor extremo. Mantente hidratado y revisa el sistema de enfriamiento del motor.'
	String get extremeHeat => 'Calor extremo. Mantente hidratado y revisa el sistema de enfriamiento del motor.';

	/// es: 'Mantente hidratado. Asegúrate de que el aire acondicionado funcione correctamente.'
	String get stayHydrated => 'Mantente hidratado. Asegúrate de que el aire acondicionado funcione correctamente.';

	/// es: 'Temperaturas bajo cero. Calienta el motor antes de conducir y revisa el anticongelante.'
	String get freezing => 'Temperaturas bajo cero. Calienta el motor antes de conducir y revisa el anticongelante.';

	/// es: 'Abrígate bien. Revisa el estado de la batería y calienta el motor brevemente.'
	String get coldWeather => 'Abrígate bien. Revisa el estado de la batería y calienta el motor brevemente.';

	/// es: 'Reduce la velocidad un 30% y aumenta la distancia de seguridad. Enciende las luces.'
	String get rainyConditions => 'Reduce la velocidad un 30% y aumenta la distancia de seguridad. Enciende las luces.';

	/// es: 'Alerta de tormenta eléctrica. Evita conducir si es posible. Quédate dentro del vehículo.'
	String get thunderstorm => 'Alerta de tormenta eléctrica. Evita conducir si es posible. Quédate dentro del vehículo.';

	/// es: 'Condiciones de nieve. Usa cadenas y reduce drásticamente la velocidad.'
	String get snowConditions => 'Condiciones de nieve. Usa cadenas y reduce drásticamente la velocidad.';

	/// es: 'Usa luces bajas. Reduce la velocidad y mantén una mayor distancia de seguridad.'
	String get foggyConditions => 'Usa luces bajas. Reduce la velocidad y mantén una mayor distancia de seguridad.';

	/// es: 'Vientos fuertes detectados. Sujeta el volante con firmeza, especialmente en puentes.'
	String get strongWind => 'Vientos fuertes detectados. Sujeta el volante con firmeza, especialmente en puentes.';

	/// es: 'Condiciones extremas. Evita conducir y busca un refugio seguro.'
	String get extremeWeather => 'Condiciones extremas. Evita conducir y busca un refugio seguro.';

	/// es: 'Condiciones de conducción estables. ¡Buen viaje!'
	String get stable => 'Condiciones de conducción estables. ¡Buen viaje!';
}

// Path: notifications.mocks.n1
class TranslationsNotificationsMocksN1Es {
	TranslationsNotificationsMocksN1Es._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Presión de neumáticos baja'
	String get title => 'Presión de neumáticos baja';

	/// es: 'El neumático trasero izquierdo está a 28 PSI. Recomendado: 32 PSI.'
	String get body => 'El neumático trasero izquierdo está a 28 PSI. Recomendado: 32 PSI.';

	/// es: 'hace 2 min'
	String get time => 'hace 2 min';

	/// es: 'Revisar Neumáticos'
	String get action => 'Revisar Neumáticos';
}

// Path: notifications.mocks.n2
class TranslationsNotificationsMocksN2Es {
	TranslationsNotificationsMocksN2Es._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Se espera lluvia fuerte'
	String get title => 'Se espera lluvia fuerte';

	/// es: 'Alerta de tormenta severa en tu área. Evita conducir si es posible.'
	String get body => 'Alerta de tormenta severa en tu área. Evita conducir si es posible.';

	/// es: 'hace 1 hora'
	String get time => 'hace 1 hora';

	/// es: 'Ver Mapa'
	String get action => 'Ver Mapa';
}

// Path: notifications.mocks.n3
class TranslationsNotificationsMocksN3Es {
	TranslationsNotificationsMocksN3Es._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Cambio de aceite pronto'
	String get title => 'Cambio de aceite pronto';

	/// es: 'Tu Honda CBR 600RR está a 300 km de su próximo cambio de aceite.'
	String get body => 'Tu Honda CBR 600RR está a 300 km de su próximo cambio de aceite.';

	/// es: 'hace 5 horas'
	String get time => 'hace 5 horas';

	/// es: 'Programar'
	String get action => 'Programar';
}

// Path: notifications.mocks.n4
class TranslationsNotificationsMocksN4Es {
	TranslationsNotificationsMocksN4Es._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Rotación de neumáticos'
	String get title => 'Rotación de neumáticos';

	/// es: 'La rotación de neumáticos del Ford Explorer está 800 km retrasada.'
	String get body => 'La rotación de neumáticos del Ford Explorer está 800 km retrasada.';

	/// es: 'Ayer'
	String get time => 'Ayer';

	/// es: 'Programar'
	String get action => 'Programar';
}

// Path: notifications.mocks.n5
class TranslationsNotificationsMocksN5Es {
	TranslationsNotificationsMocksN5Es._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Servicio completado'
	String get title => 'Servicio completado';

	/// es: 'Reemplazo de filtro de aire en Honda CBR 600RR marcado como completo. ¡Buen trabajo!'
	String get body => 'Reemplazo de filtro de aire en Honda CBR 600RR marcado como completo. ¡Buen trabajo!';

	/// es: 'hace 2 días'
	String get time => 'hace 2 días';
}

// Path: notifications.mocks.n6
class TranslationsNotificationsMocksN6Es {
	TranslationsNotificationsMocksN6Es._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Consejo DriveTrack'
	String get title => 'Consejo DriveTrack';

	/// es: 'Las revisiones regulares de refrigerante extienden la vida de tu motor un 40%.'
	String get body => 'Las revisiones regulares de refrigerante extienden la vida de tu motor un 40%.';

	/// es: 'hace 3 días'
	String get time => 'hace 3 días';
}

// Path: notifications.mocks.n7
class TranslationsNotificationsMocksN7Es {
	TranslationsNotificationsMocksN7Es._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Batería baja'
	String get title => 'Batería baja';

	/// es: 'La batería del Toyota Camry muestra signos de degradación. El frío puede causar problemas.'
	String get body => 'La batería del Toyota Camry muestra signos de degradación. El frío puede causar problemas.';

	/// es: 'hace 4 días'
	String get time => 'hace 4 días';

	/// es: 'Revisar Batería'
	String get action => 'Revisar Batería';
}

// Path: notifications.mocks.n8
class TranslationsNotificationsMocksN8Es {
	TranslationsNotificationsMocksN8Es._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Hito de kilometraje'
	String get title => 'Hito de kilometraje';

	/// es: 'Tu Honda CBR 600RR ha alcanzado los 12,500 km. Hora de una inspección completa!'
	String get body => 'Tu Honda CBR 600RR ha alcanzado los 12,500 km. Hora de una inspección completa!';

	/// es: 'hace 1 semana'
	String get time => 'hace 1 semana';
}

/// The flat map containing all translations for locale <es>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
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
			'auth.sessionExpiredTitle' => 'Sesión expirada',
			'auth.sessionExpiredMessage' => 'Tu sesión expiró. Por favor inicia sesión de nuevo.',
			'auth.sessionExpiredSnackbar' => 'Tu sesión expiró, inicia sesión de nuevo.',
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
			'garage.errorAddingVehicle' => 'No se pudo agregar el vehículo. Intenta de nuevo.',
			'garage.errorUpdatingVehicle' => 'No se pudo actualizar el vehículo. Intenta de nuevo.',
			'garage.errorRemovingVehicle' => 'No se pudo eliminar el vehículo. Intenta de nuevo.',
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
			'garage.goodAfternoon' => 'Buenas tardes',
			'garage.goodEvening' => 'Buenas noches',
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
			'maintenance.errorRemovingService' => 'No se pudo eliminar el servicio. Intenta de nuevo.',
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
			'profile.securitySubtitleDefault' => 'Contraseña y privacidad',
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
			'profile.feedbackSupport' => 'Soporte',
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
			'profile.editProfile' => 'Editar Perfil',
			'profile.editProfileName' => 'Nombre Completo',
			'profile.editProfileSave' => 'Guardar Cambios',
			'profile.editProfileSuccess' => 'Perfil actualizado exitosamente',
			'profile.changePassword' => 'Cambiar Contraseña',
			'profile.currentPassword' => 'Contraseña Actual',
			'profile.newPassword' => 'Nueva Contraseña',
			'profile.confirmNewPassword' => 'Confirmar Contraseña',
			'profile.changePasswordSuccess' => 'Contraseña actualizada exitosamente',
			'profile.changePasswordError' => 'La contraseña actual es incorrecta',
			'profile.passwordsMismatch' => 'Las contraseñas no coinciden',
			'profile.callSupport' => 'Llamar a Soporte',
			'profile.supportPhone' => '+52 664 536 7724',
			'profile.loadingPreferences' => 'Cargando preferencias...',
			'profile.errorLoadingPreferences' => 'No se pudieron cargar las preferencias',
			'profile.errorLoadingStats' => 'No se pudieron cargar las estadísticas',
			'profile.changePhoto' => 'Cambiar foto',
			'profile.camera' => 'Cámara',
			'profile.gallery' => 'Galería',
			'profile.uploadingPhoto' => 'Subiendo foto...',
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
			'weather.changeCity' => 'Cambiar ciudad',
			'weather.changeCityHint' => 'Ej. Monterrey, MX',
			'weather.changeCityTitle' => 'Clima por ciudad',
			'weather.useGps' => 'Usar GPS',
			'weather.search' => 'Buscar',
			'weather.cityNotFound' => 'Ciudad no encontrada. Intenta con «Ciudad, País»',
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
