import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:proyectos/core/constants/constants.dart';
import 'package:proyectos/data/services/location_service.dart';
import 'package:proyectos/data/models/spacex_model.dart';

class ConstellationService {
  static Future<List<Constelacion>> obtenerTodosLosPlanetas() async {
    try {
      print('📍 Iniciando búsqueda de todos los cuerpos celestes...');

      if (!LocationService.tieneDatosValidos) {
        print('🔄 Usando ubicación por defecto...');
        LocationService.latitud;
        LocationService.longitud;
      }

      final lat = LocationService.latitud!;
      final lng = LocationService.longitud!;

      print('🎯 Ubicación para búsqueda: $lat, $lng');

      try {
        final authString = getAstronomyAuthString();
        return await _obtenerTodosLosCuerposCelestes(authString, lat, lng);
      } catch (e) {
        print('❌ Error con API, usando datos locales: $e');
        return _crearCuerposCelestesLocales();
      }
    } catch (e) {
      print('❌ Error general: $e');
      return _crearCuerposCelestesLocales();
    }
  }

  static Future<List<Constelacion>> _obtenerTodosLosCuerposCelestes(
    String authString,
    double lat,
    double lng,
  ) async {
    final todosLosCuerpos = <Constelacion>[];
    final cuerposParaBuscar = [
      'sun',
      'moon',
      '599',
      '699',
      '499',
      '299',
      '399',
      '199',
      '799',
      '899',
    ];

    for (final cuerpoId in cuerposParaBuscar) {
      try {
        final cuerpo = await _obtenerDatosCuerpoCeleste(
          authString,
          lat,
          lng,
          cuerpoId,
        );
        todosLosCuerpos.add(cuerpo);
        print('✅ Cuerpo celeste obtenido: ${cuerpo.nombre}');
      } catch (e) {
        print('❌ Error obteniendo cuerpo $cuerpoId: $e');
        final cuerpoLocal = _crearCuerpoCelesteLocal(cuerpoId);
        if (cuerpoLocal != null) {
          todosLosCuerpos.add(cuerpoLocal);
        }
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }

    return todosLosCuerpos;
  }

  static Future<Constelacion> _obtenerDatosCuerpoCeleste(
    String authString,
    double lat,
    double lng,
    String cuerpoId,
  ) async {
    try {
      final date = getCurrentDate();
      final time = getCurrentTime();

      final url = Uri.parse(
        '$planetasUrl?'
        'latitude=$lat&'
        'longitude=$lng&'
        'elevation=0&'
        'from_date=$date&'
        'to_date=$date&'
        'time=$time&'
        'body=$cuerpoId',
      );

      final response = await http
          .get(
            url,
            headers: {
              'Authorization': authString,
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return _parseCuerpoCelesteResponse(decodedResponse, cuerpoId, lat, lng);
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      final cuerpoLocal = _crearCuerpoCelesteLocal(cuerpoId);
      if (cuerpoLocal != null) {
        return cuerpoLocal;
      }
      rethrow;
    }
  }

  static Constelacion _parseCuerpoCelesteResponse(
    dynamic response,
    String cuerpoId,
    double lat,
    double lng,
  ) {
    final cuerpoInfo = planetasInfo[cuerpoId];

    if (cuerpoInfo == null) {
      throw Exception('Cuerpo celeste no encontrado');
    }
    String nombreEnIngles = cuerpoInfo['en']!;
    try {
      if (response is Map<String, dynamic> && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        if (data['name'] != null) {
          nombreEnIngles = data['name'].toString();
        }
      }
    } catch (e) {
      print('⚠️ No se pudo extraer nombre inglés: $e');
    }

    return _crearConstelacionDesdeCuerpoCeleste(
      cuerpoInfo['es']!,
      nombreEnIngles,
      cuerpoId,
      lat,
      lng,
    );
  }

  static Constelacion _crearConstelacionDesdeCuerpoCeleste(
    String nombreEspanol,
    String nombreIngles,
    String cuerpoId,
    double lat,
    double lng,
  ) {
    final visible = _esCuerpoCelesteVisible(nombreEspanol);
    final magnitud = _calcularMagnitudCuerpoCeleste(nombreEspanol);
    final horario = _calcularMejorHorarioCuerpoCeleste(nombreEspanol);
    final familia = _obtenerFamiliaCuerpoCeleste(nombreEspanol);
    final tipo = _obtenerTipoCuerpoCeleste(nombreEspanol);

    return Constelacion(
      nombre: '$nombreEspanol ($nombreIngles)',
      visibilidad: visible ? 'Visible ahora' : 'No visible actualmente',
      mejorhorario: horario,
      descripcion: _generarDescripcionCuerpoCeleste(
        nombreEspanol,
        nombreIngles,
        magnitud,
        visible,
        lat,
        lng,
      ),
      magnitud: magnitud,
      familia: familia,
      imagenUrl: _generarUrlImagenCuerpoCeleste(nombreEspanol),
      id: cuerpoId,
      tipo: tipo,
    );
  }

  static String _obtenerFamiliaCuerpoCeleste(String nombre) {
    if (nombre == 'Sol') return 'Estrella';
    if (nombre == 'Luna') return 'Satélite Natural';
    return 'Planeta';
  }

  static String _obtenerTipoCuerpoCeleste(String nombre) {
    if (nombre == 'Sol') return 'estrella';
    if (nombre == 'Luna') return 'satelite';
    if (nombre == 'Mercurio' ||
        nombre == 'Venus' ||
        nombre == 'Tierra' ||
        nombre == 'Marte') {
      return 'planeta_rocoso';
    }
    if (nombre == 'Júpiter' || nombre == 'Saturno') {
      return 'planeta_gaseoso';
    }
    return 'planeta_helado';
  }

  static bool _esCuerpoCelesteVisible(String nombre) {
    final horaActual = DateTime.now().hour;

    if (nombre == 'Sol') {
      return horaActual >= 6 && horaActual <= 18;
    }
    return horaActual >= 18 || horaActual <= 6;
  }

  static double _calcularMagnitudCuerpoCeleste(String nombre) {
    final magnitudes = {
      'Sol': -26.74,
      'Luna': -12.74,
      'Mercurio': 0.23,
      'Venus': -4.14,
      'Tierra': 0.0,
      'Marte': 0.71,
      'Júpiter': -2.20,
      'Saturno': 0.46,
      'Urano': 5.68,
      'Neptuno': 7.78,
    };

    return magnitudes[nombre] ?? 0.0;
  }

  static String _calcularMejorHorarioCuerpoCeleste(String nombre) {
    final horarios = {
      'Sol': '06:00 - 18:00 (Horario diurno)',
      'Luna': 'Depende de la fase lunar',
      'Mercurio': 'Al amanecer o atardecer',
      'Venus': '18:00 - 22:00 (Lucero del Alba/Tarde)',
      'Marte': '20:00 - 02:00',
      'Júpiter': '19:00 - 01:00',
      'Saturno': '20:00 - 02:00',
      'Urano': '21:00 - 03:00 (requiere telescopio)',
      'Neptuno': '22:00 - 04:00 (requiere telescopio)',
    };

    return horarios[nombre] ?? '20:00 - 23:00';
  }

  static String _generarDescripcionCuerpoCeleste(
    String nombreEspanol,
    String nombreIngles,
    double magnitud,
    bool visible,
    double lat,
    double lng,
  ) {
    final descripciones = _obtenerDescripcionesCuerposCelestes();
    final baseDescripcion =
        descripciones[nombreEspanol] ??
        '$nombreEspanol ($nombreIngles) es un cuerpo celeste del Sistema Solar.';

    final estadoVisibilidad = visible
        ? 'Actualmente visible desde tu ubicación.'
        : 'Actualmente no visible. Mejor horario: ${_calcularMejorHorarioCuerpoCeleste(nombreEspanol)}';

    return '$baseDescripcion\n\n'
        '$estadoVisibilidad\n'
        'Magnitud: ${magnitud.toStringAsFixed(2)}\n'
        'Coordenadas: ${lat.toStringAsFixed(4)}°, ${lng.toStringAsFixed(4)}°\n'
        'Fuente: Astronomy API + datos locales';
  }

  static Map<String, String> _obtenerDescripcionesCuerposCelestes() {
    return {
      'Sol':
          'El Sol es la estrella en el centro de nuestro Sistema Solar. Es una esfera casi perfecta de plasma caliente, calentada hasta la incandescencia por reacciones de fusión nuclear en su núcleo.',
      'Luna':
          'La Luna es el único satélite natural de la Tierra. Es el quinto satélite más grande del Sistema Solar y el más grande en relación con su planeta. Su influencia gravitatoria produce las mareas.',
      'Mercurio':
          'Mercurio (Mercury) es el planeta más cercano al Sol y el más pequeño del Sistema Solar. Completa una órbita alrededor del Sol cada 88 días terrestres.',
      'Venus':
          'Venus (Venus) es el segundo planeta del Sistema Solar y el más caliente, con temperaturas superficiales que derretirían el plomo. Conocido como el "Lucero del Alba".',
      'Tierra':
          'La Tierra (Earth) es nuestro hogar, el tercer planeta del Sistema Solar y el único conocido que alberga vida. Tiene un satélite natural: la Luna.',
      'Marte':
          'Marte (Mars), el "Planeta Rojo", es el cuarto planeta del Sistema Solar. Tiene dos lunas: Fobos y Deimos, y es el objetivo principal de la exploración espacial.',
      'Júpiter':
          'Júpiter (Jupiter) es el planeta más grande del Sistema Solar, un gigante gaseoso con una famosa Gran Mancha Roja. Tiene al menos 79 lunas conocidas.',
      'Saturno':
          'Saturno (Saturn) es famoso por sus espectaculares anillos de hielo y roca. Es el segundo planeta más grande del Sistema Solar.',
      'Urano':
          'Urano (Uranus) es un gigante de hielo con un característico color azul-verdoso. Su eje de rotación está inclinado casi 90 grados.',
      'Neptuno':
          'Neptuno (Neptune) es el planeta más lejano del Sol, un gigante de hielo con los vientos más fuertes del Sistema Solar.',
    };
  }

  static String? _generarUrlImagenCuerpoCeleste(String nombre) {
    final imagenes = {
      'Sol':
          'https://images.unsplash.com/photo-1614642264762-d0a3b8bf9880?w=300&h=200&fit=crop',
      'Luna':
          'https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3?w=300&h=200&fit=crop',
      'Mercurio':
          'https://images.unsplash.com/photo-1614313913007-2b4ae8ce32d6?w=300&h=200&fit=crop',
      'Venus':
          'https://images.unsplash.com/photo-1614314107768-6018062cda20?w=300&h=200&fit=crop',
      'Tierra':
          'https://images.unsplash.com/photo-1446776877081-d282a0f896e2?w=300&h=200&fit=crop',
      'Marte':
          'https://images.unsplash.com/photo-1614728894747-a83421e2b9c9?w=300&h=200&fit=crop',
      'Júpiter':
          'https://images.unsplash.com/photo-1630459063998-0aacb5e8b388?w=300&h=200&fit=crop',
      'Saturno':
          'https://images.unsplash.com/photo-1614315156589-8a0a36cf47c4?w=300&h=200&fit=crop',
      'Urano': 'https://via.placeholder.com/300x200/4FC3F7/000000?text=Urano',
      'Neptuno':
          'https://via.placeholder.com/300x200/2196F3/FFFFFF?text=Neptuno',
    };

    return imagenes[nombre];
  }

  static Constelacion? _crearCuerpoCelesteLocal(String cuerpoId) {
    final cuerposLocales = _crearCuerposCelestesLocales();
    try {
      return cuerposLocales.firstWhere((cuerpo) => cuerpo.id == cuerpoId);
    } catch (e) {
      return null;
    }
  }

  static List<Constelacion> _crearCuerposCelestesLocales() {
    final locationData = LocationService.currentLocationData;
    String ubicacionInfo = '';
    if (locationData != null && locationData.ciudad.isNotEmpty) {
      ubicacionInfo = ' desde ${locationData.ciudad}';
    }

    return [
      Constelacion(
        nombre: 'Sol (Sun)',
        visibilidad: 'Visible durante el día$ubicacionInfo',
        mejorhorario: '06:00 - 18:00 (Horario diurno)',
        descripcion:
            'El Sol es la estrella en el centro de nuestro Sistema Solar. Es una esfera casi perfecta de plasma caliente. ¡No mires directamente al Sol! Datos de respaldo locales.',
        magnitud: -26.74,
        familia: 'Estrella',
        imagenUrl:
            'https://images.unsplash.com/photo-1614642264762-d0a3b8bf9880?w=300&h=200&fit=crop',
        id: 'sun',
        tipo: 'estrella',
      ),
      Constelacion(
        nombre: 'Luna (Moon)',
        visibilidad: 'Visible según fase lunar$ubicacionInfo',
        mejorhorario: 'Depende de la fase lunar',
        descripcion:
            'La Luna es el único satélite natural de la Tierra. Su influencia gravitatoria produce las mareas. Las fases lunares afectan su visibilidad. Datos de respaldo locales.',
        magnitud: -12.74,
        familia: 'Satélite Natural',
        imagenUrl:
            'https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3?w=300&h=200&fit=crop',
        id: 'moon',
        tipo: 'satelite',
      ),
      Constelacion(
        nombre: 'Mercurio (Mercury)',
        visibilidad: 'Visible al amanecer/atardecer$ubicacionInfo',
        mejorhorario: 'Al amanecer o atardecer',
        descripcion:
            'Mercurio (Mercury) es el planeta más cercano al Sol y el más pequeño del Sistema Solar. Completa una órbita alrededor del Sol cada 88 días terrestres. Datos de respaldo locales.',
        magnitud: 0.23,
        familia: 'Planeta',
        imagenUrl:
            'https://images.unsplash.com/photo-1614313913007-2b4ae8ce32d6?w=300&h=200&fit=crop',
        id: '199',
        tipo: 'planeta_rocoso',
      ),
      Constelacion(
        nombre: 'Venus (Venus)',
        visibilidad: 'Visible$ubicacionInfo',
        mejorhorario: '18:00 - 22:00 (Lucero del Alba/Tarde)',
        descripcion:
            'Venus (Venus) es el planeta más brillante en el cielo nocturno, conocido como el "Lucero del Alba" o "Estrella de la Tarde". Su brillo intenso lo hace fácilmente identificable. Datos de respaldo locales.',
        magnitud: -4.14,
        familia: 'Planeta',
        imagenUrl:
            'https://images.unsplash.com/photo-1614314107768-6018062cda20?w=300&h=200&fit=crop',
        id: '299',
        tipo: 'planeta_rocoso',
      ),
      Constelacion(
        nombre: 'Tierra (Earth)',
        visibilidad: 'Siempre visible$ubicacionInfo',
        mejorhorario: 'Todo el día',
        descripcion:
            'La Tierra (Earth) es nuestro hogar, el tercer planeta del Sistema Solar y el único conocido que alberga vida. Tiene un satélite natural: la Luna. Datos de respaldo locales.',
        magnitud: 0.0,
        familia: 'Planeta',
        imagenUrl:
            'https://images.unsplash.com/photo-1446776877081-d282a0f896e2?w=300&h=200&fit=crop',
        id: '399',
        tipo: 'planeta_rocoso',
      ),
      Constelacion(
        nombre: 'Marte (Mars)',
        visibilidad: 'Visible$ubicacionInfo',
        mejorhorario: '20:00 - 02:00',
        descripcion:
            'Marte (Mars), el "Planeta Rojo", es conocido por su color característico. Es el cuarto planeta del Sistema Solar y tiene dos pequeñas lunas: Fobos y Deimos. Datos de respaldo locales.',
        magnitud: 0.71,
        familia: 'Planeta',
        imagenUrl:
            'https://images.unsplash.com/photo-1614728894747-a83421e2b9c9?w=300&h=200&fit=crop',
        id: '499',
        tipo: 'planeta_rocoso',
      ),
      Constelacion(
        nombre: 'Júpiter (Jupiter)',
        visibilidad: 'Visible$ubicacionInfo',
        mejorhorario: '19:00 - 01:00',
        descripcion:
            'Júpiter (Jupiter) es el planeta más grande del Sistema Solar, un gigante gaseoso con una famosa Gran Mancha Roja. Tiene al menos 79 lunas conocidas. Datos de respaldo locales.',
        magnitud: -2.20,
        familia: 'Planeta',
        imagenUrl:
            'https://images.unsplash.com/photo-1630459063998-0aacb5e8b388?w=300&h=200&fit=crop',
        id: '599',
        tipo: 'planeta_gaseoso',
      ),
      Constelacion(
        nombre: 'Saturno (Saturn)',
        visibilidad: 'Visible$ubicacionInfo',
        mejorhorario: '20:00 - 02:00',
        descripcion:
            'Saturno (Saturn) es famoso por sus espectaculares anillos de hielo y roca. Es el segundo planeta más grande del Sistema Solar. Datos de respaldo locales.',
        magnitud: 0.46,
        familia: 'Planeta',
        imagenUrl:
            'https://images.unsplash.com/photo-1614315156589-8a0a36cf47c4?w=300&h=200&fit=crop',
        id: '699',
        tipo: 'planeta_gaseoso',
      ),
      Constelacion(
        nombre: 'Urano (Uranus)',
        visibilidad: 'Requiere telescopio$ubicacionInfo',
        mejorhorario: '21:00 - 03:00 (requiere telescopio)',
        descripcion:
            'Urano (Uranus) es un gigante de hielo con un característico color azul-verdoso. Su eje de rotación está inclinado casi 90 grados. Datos de respaldo locales.',
        magnitud: 5.68,
        familia: 'Planeta',
        imagenUrl:
            'https://via.placeholder.com/300x200/4FC3F7/000000?text=Urano',
        id: '799',
        tipo: 'planeta_helado',
      ),
      Constelacion(
        nombre: 'Neptuno (Neptune)',
        visibilidad: 'Requiere telescopio$ubicacionInfo',
        mejorhorario: '22:00 - 04:00 (requiere telescopio)',
        descripcion:
            'Neptuno (Neptune) es el planeta más lejano del Sol, un gigante de hielo con los vientos más fuertes del Sistema Solar. Datos de respaldo locales.',
        magnitud: 7.78,
        familia: 'Planeta',
        imagenUrl:
            'https://via.placeholder.com/300x200/2196F3/FFFFFF?text=Neptuno',
        id: '899',
        tipo: 'planeta_helado',
      ),
    ];
  }
}

Future<Constelacion> getConstelacion(double lat, double lng) async {
  final planetas = await ConstellationService.obtenerTodosLosPlanetas();
  return planetas.first;
}

