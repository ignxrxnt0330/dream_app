// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get about => 'sobre';

  @override
  String get aboutTheApp => 'sobre la app';

  @override
  String get allData => 'todos los datos';

  @override
  String get allTime => 'siempre';

  @override
  String get appLang => 'idioma de la app';

  @override
  String get appLangDesc => 'cambia el idioma de la app';

  @override
  String get appTitle => 'dream_app';

  @override
  String get areYouSure => '¿estás seguro?';

  @override
  String get asc => 'asc';

  @override
  String get bad => 'malo';

  @override
  String get badChoide => 'estás cometiendo una muy mala decisión';

  @override
  String get calendar => 'calendario';

  @override
  String get cancel => 'cancelar';

  @override
  String get changeColors => 'cambiar los colores de la app';

  @override
  String get characters => 'carácteres';

  @override
  String get close => 'cerrar';

  @override
  String get colors => 'colores';

  @override
  String get config => 'configuración';

  @override
  String get confirm => 'confirmar';

  @override
  String confirmAction(Object action) {
    return '¿seguro que quieres $action?';
  }

  @override
  String get consolas => 'Consolas';

  @override
  String get currentStreak => 'racha actual';

  @override
  String get darkMode => 'modo oscuro';

  @override
  String get date => 'fecha';

  @override
  String get dateFormat => 'dd-MM-yyyy HH:mm';

  @override
  String get defaultTitle => 'titulo por defecto';

  @override
  String get deleteAll => 'borrar todos los sueños';

  @override
  String get deleteAllDesc => 'borra todos tus sueños';

  @override
  String get deleteThisDream => 'borrar este sueño';

  @override
  String get desc => 'desc';

  @override
  String get descLength => 'long. desc';

  @override
  String get description => 'descripción';

  @override
  String get descriptionHint => 'asdasdasd...';

  @override
  String get dmY => 'dd/MM/yyyy';

  @override
  String get dream => 'sueño';

  @override
  String get dreamJournalingApp => 'aplicación de dream journaling';

  @override
  String get dreamLucidness => 'lucidez del sueño';

  @override
  String get dreamMood => 'mood del sueño';

  @override
  String get dreamRating => 'puntuación del sueño';

  @override
  String get dreamType => 'tipo de sueño';

  @override
  String get dreams => 'sueños';

  @override
  String get dreamsPerDay => 'sueños al día';

  @override
  String get editDream => 'editar sueño';

  @override
  String get empty => 'vacío';

  @override
  String get es => 'es';

  @override
  String get exportDreams => 'exportar sueños';

  @override
  String get exportDreamsDesc =>
      'descarga tus sueños en un archivo json para poder mantenerlos a salvo';

  @override
  String get extreme => 'extrema';

  @override
  String get fav => 'fav';

  @override
  String get filterDreams => 'filtrar sueños';

  @override
  String get good => 'bueno';

  @override
  String get great => 'genial';

  @override
  String get hidden => 'ocultos';

  @override
  String get high => 'alta';

  @override
  String get home => 'home';

  @override
  String get importDreams => 'importar sueños';

  @override
  String get importDreamsDesc => 'importa tus sueños previamente exportados';

  @override
  String lastExportedDate(Object date) {
    return 'exportado por última vez $date';
  }

  @override
  String get longestStreak => 'racha más larga';

  @override
  String get lucidness => 'lucidez';

  @override
  String get meh => 'meh';

  @override
  String get mild => 'leve';

  @override
  String get monthly => 'mensual';

  @override
  String get mood => 'mood';

  @override
  String get nameCount => 'nº pax';

  @override
  String get names => 'nombres';

  @override
  String get neutral => 'neutral';

  @override
  String get newDream => 'nuevo sueño';

  @override
  String get nightmare => 'pesadilla';

  @override
  String get no => 'no';

  @override
  String get noDataAvailable => 'no hay datos disponibles';

  @override
  String get noExportData => 'no hay datos sobre exportaciones previas';

  @override
  String get none => 'ninguna';

  @override
  String get paralysis => 'parálisis';

  @override
  String get rating => 'puntuación';

  @override
  String get reopen => 'cierra y vuelve a abrir la app';

  @override
  String get required => 'requerido';

  @override
  String get resetDefault => 'resetear por defecto';

  @override
  String get restart => 'reiniciar app';

  @override
  String get setAppLang => 'establece el idioma de la app';

  @override
  String get setDefaultTitle => 'establecer título por defecto';

  @override
  String get stats => 'estadísticas';

  @override
  String get title => 'título';

  @override
  String get toggleDarkMode => 'alternar modo claro y oscuro';

  @override
  String get types => 'tipos';

  @override
  String get weekly => 'semanal';

  @override
  String get words => 'palabras';

  @override
  String xNames(Object namecount) {
    return '$namecount personas';
  }

  @override
  String xNamesMore(Object namecount) {
    return '$namecount más';
  }

  @override
  String get yearly => 'anual';

  @override
  String get yes => 'si';
}
