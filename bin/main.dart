import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  print('==============Bienvenido al conversor de monedas==============');

  String apiKey = '93abc27d05a9e9c2369317a7';
  String baseMoneda = 'COP';
  String objetivoMoneda = 'USD';
  print('Ingrese la cantidad en $baseMoneda:');
  double cantidad = double.parse(stdin.readLineSync() ?? '0');

  double? montoConvertido =
      await convertirMoneda(apiKey, baseMoneda, objetivoMoneda, cantidad);
  if (montoConvertido != null) {
    print('Monto convertido: $montoConvertido $objetivoMoneda');
  } else {
    print('No se pudo realizar la conversión.');
  }
}

Future<double?> convertirMoneda(String apiKey, String baseMoneda,
    String objetivoMoneda, double cantidad) async {
  // Construye la URL de la API
  String url = 'https://v6.exchangerate-api.com/v6/$apiKey/latest/$baseMoneda';

  try {
    // Realiza la solicitud HTTP
    final respuesta = await http.get(Uri.parse(url));

    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body);

      final tasas = datos['conversion_rates'];
      if (tasas != null && tasas[objetivoMoneda] != null) {
        final tasaObjetivo = tasas[objetivoMoneda];

        return cantidad * tasaObjetivo;
      } else {
        print('La moneda no está disponible en la tasa de cambio');
        return null;
      }
    } else {
      print('Error en la solicitud: ${respuesta.statusCode}');
      return null;
    }
  } catch (e) {
    print('Ocurrió un error: $e');
    return null;
  }
}
