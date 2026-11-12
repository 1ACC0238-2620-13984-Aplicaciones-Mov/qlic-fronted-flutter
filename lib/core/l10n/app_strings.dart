import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppStrings {
  AppStrings(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('es')];
  static const LocalizationsDelegate<AppStrings> delegate = _AppStringsDelegate();

  static AppStrings of(BuildContext context) =>
      Localizations.of<AppStrings>(context, AppStrings)!;

  String t(String key) =>
      _values[locale.languageCode]?[key] ?? _values['en']![key] ?? key;

  static const Map<String, Map<String, String>> _values = {
    'en': {
      'appName': 'Qlic',
      'signInTitle': 'Sign in',
      'signInButton': 'Sign in',
      'goToSignUp': "Don't have an account? Sign up",
      'signUpTitle': 'Create your account',
      'signUpButton': 'Create account',
      'goToSignIn': 'Already have an account? Sign in',
      'fieldEmail': 'Email',
      'fieldPassword': 'Password',
      'fieldFullName': 'Full name',
      'fieldPhoneOptional': 'Phone (optional)',
      'acceptTerms': 'I accept the terms and conditions of service',
      'errInvalidEmail': 'Enter a valid email address.',
      'errPasswordRequired': 'Enter your password.',
      'errPasswordShort': 'The password must have at least 8 characters.',
      'errNameRequired': 'Enter your full name.',
      'errTermsRequired': 'You must accept the terms and conditions to continue.',
      'errNetwork': 'Could not connect to the server. Check your connection and try again.',
      'errGeneric': 'Something went wrong. Please try again.',
      'navDashboard': 'Home',
      'navDevices': 'Devices',
      'navAlerts': 'Alerts',
      'navReports': 'Reports',
      'navProfile': 'Profile',
      'dashboardGreeting': 'Hello, {name}',
      'comingSoon': 'Coming soon',
      'signOut': 'Sign out',
    },
    'es': {
      'appName': 'Qlic',
      'signInTitle': 'Iniciar sesión',
      'signInButton': 'Iniciar sesión',
      'goToSignUp': '¿No tienes cuenta? Regístrate',
      'signUpTitle': 'Crea tu cuenta',
      'signUpButton': 'Crear cuenta',
      'goToSignIn': '¿Ya tienes cuenta? Inicia sesión',
      'fieldEmail': 'Correo electrónico',
      'fieldPassword': 'Contraseña',
      'fieldFullName': 'Nombre completo',
      'fieldPhoneOptional': 'Teléfono (opcional)',
      'acceptTerms': 'Acepto los términos y condiciones del servicio',
      'errInvalidEmail': 'Ingresa un correo electrónico válido.',
      'errPasswordRequired': 'Ingresa tu contraseña.',
      'errPasswordShort': 'La contraseña debe tener al menos 8 caracteres.',
      'errNameRequired': 'Ingresa tu nombre completo.',
      'errTermsRequired': 'Debes aceptar los términos y condiciones para continuar.',
      'errNetwork': 'No se pudo conectar con el servidor. Revisa tu conexión e inténtalo de nuevo.',
      'errGeneric': 'Algo salió mal. Inténtalo de nuevo.',
      'navDashboard': 'Inicio',
      'navDevices': 'Dispositivos',
      'navAlerts': 'Alertas',
      'navReports': 'Reportes',
      'navProfile': 'Perfil',
      'dashboardGreeting': 'Hola, {name}',
      'comingSoon': 'Próximamente',
      'signOut': 'Cerrar sesión',
    },
  };
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'es'].contains(locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) =>
      SynchronousFuture<AppStrings>(AppStrings(locale));

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppStrings> old) => false;
}