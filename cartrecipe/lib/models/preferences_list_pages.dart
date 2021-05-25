class PreferencesListPages {
  String title;
  String subtitle;

  PreferencesListPages(
    this.title,
    this.subtitle,
  );
}

var listPages = [
  new PreferencesListPages('¿Que tipo de dieta sigues?',
      'Si entendemos que buscas podremos ayudarte mejor'),
  new PreferencesListPages('¿Cual es tu nivel de cocina?',
      'Asi podemos recomendarte recetas de tu nivel'),
  new PreferencesListPages('¿Padeces alguna alergia o intolerancia?',
      'Procuraremos filtrar en tus busquedas las recetas que contengan estos ingredientes'),
  new PreferencesListPages('¿Que tipo de recetas buscas?',
      'Intentaremos recomendarte recetas de estos tipos'),
  new PreferencesListPages('¿No te gusta algun ingrediente?',
      'Dinoslo y evitaremos las recetas que lo contengan!'),
  new PreferencesListPages(
      'Listo!', 'Ahora te mostraremos como usar la aplicación'),
];
