class PreferencesListPages {
  String title;
  String subtitle;

  PreferencesListPages(
    this.title,
    this.subtitle,
  );
}

var listPages = [
  new PreferencesListPages('Que objetivo persigues?',
      'Si entendemos que buscas podremos ayudarte mejor'),
  new PreferencesListPages('Padeces alguna alergia o intolerancia?',
      'Procuraremos filtrar en tus busquedas las recetas que contengan estos ingredientes'),
  new PreferencesListPages('Selecciona Tus alergias o intolerancias',
      'La aplicación generará recetas basadas en tus gustos'),
  new PreferencesListPages(
      'Listo!', 'Ahora te mostraremos como usar la aplicación'),
];
