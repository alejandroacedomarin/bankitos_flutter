import 'package:bankitos_flutter/Models/PlaceModel.dart';
import 'package:dio/dio.dart'; // Usa un prefijo 'Dio' para importar la clase Response desde Dio
import 'package:get_storage/get_storage.dart';

class PlaceService {
  final String baseUrl = "http://localhost:3000"; // URL de tu backend
  final Dio dio = Dio(); // Usa el prefijo 'Dio' para referenciar la clase Dio
  var statusCode;
  var data;

  void saveToken(String token) {
    final box = GetStorage();
    box.write('token', token);
  }

  String? getToken() {
    final box = GetStorage();
    return box.read('token');
  }

  void savePlaceId(String placeId) {
    final box = GetStorage();
    box.write('id', placeId);
  }

  String getPlaceId() {
    final box = GetStorage();
    if (box.read('id').isEmpty) {
      return '';
    } else {
      return box.read('id');
    }
  }

  Future<int> createPlace(Place newPlace) async {
    print('createPlace');

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Obtener el token guardado
        final token = getToken();

        print('token: ${token}');

        if (token != null) {
          options.headers['x-access-token'] = token;
        }
        // Si el token está disponible, agregarlo a la cabecera 'x-access-token'
        return handler.next(options);
      },
    ));

    print('URL: $baseUrl/place');
    Response response =
        await dio.post('$baseUrl/place', data: newPlace.toJson());

    data = response.data.toString();
    print('Data: $data');
    statusCode = response.statusCode;
    print('Status code: $statusCode');

    if (statusCode == 201) {
      print('201');
      return 201;
    } else if (statusCode == 400) {
      print('400');
      return 400;
    } else if (statusCode == 500) {
      print('500');
      return 500;
    } else {
      print('-1');
      return -1;
    }
  }

  Future<List<Place>> getPlaces(String id) async {
    print('getData');
    // Interceptor para agregar el token a la cabecera 'x-access-token'
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Obtener el token guardado
        final token = getToken();

        print(token);

        // Si el token está disponible, agregarlo a la cabecera 'x-access-token'
        if (token != null) {
          options.headers['x-access-token'] = token;
        }
        return handler.next(options);
      },
    ));

    try {
      var res = await dio.get('$baseUrl/placebyuser/$id');
      List<dynamic> responseData =
          res.data; // Obtener los datos de la respuesta

      // Convertir los datos en una lista de objetos Place
      List<Place> places =
          responseData.map((data) => Place.fromJson(data)).toList();

      return places; // Devolver la lista de lugares
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir durante la solicitud
      print('Error fetching data: $e');
      throw e; // Relanzar el error para que el llamador pueda manejarlo
    }
  }

  Future<List<Place>> getData(String id) async {
    print('getData');
    // Interceptor para agregar el token a la cabecera 'x-access-token'
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Obtener el token guardado
        final token = getToken();

        print(token);

        if (token != null) {
          options.headers['x-access-token'] = token;
        }
        return handler.next(options);
      },
    ));
    try {
      print('URL: $baseUrl/placebyuser/$id');
      var res = await dio.get('$baseUrl/placebyuser/$id');

      List<dynamic> responseData =
          res.data; // Obtener los datos de la respuesta

      // Convertir los datos en una lista de objetos Place
      List<Place> places =
          responseData.map((data) => Place.fromJson(data)).toList();

      return places; // Devolver la lista de lugares
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir durante la solicitud
      print('Error fetching data: $e');
      throw e; // Relanzar el error para que el llamador pueda manejarlo
    }
  }

  Future<int> updatePlace(Place newPlace, String id) async {
    print('updatePlace');

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Obtener el token guardado
        final token = getToken();

        print('token: ${token}');

        // Si el token está disponible, agregarlo a la cabecera 'x-access-token'
        if (token != null) {
          options.headers['x-access-token'] = token;
        }
        return handler.next(options);
      },
    ));

    print("URL: $baseUrl/place/$id");
    Response response =
        await dio.put('$baseUrl/place/$id', data: newPlace.toJson());

    data = response.data.toString();
    print('Data: $data');
    statusCode = response.statusCode;
    print('Status code: $statusCode');

    if (statusCode == 201) {
      print('201');
      return 201;
    } else if (statusCode == 400) {
      print('400');
      return 400;
    } else if (statusCode == 500) {
      print('500');
      return 500;
    } else {
      print('-1');
      return -1;
    }
  }

  Future<int> deletePlace(String id) async {
    print('deletePlace');

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Obtener el token guardado
        final token = getToken();

        print('token: ${token}');

        // Si el token está disponible, agregarlo a la cabecera 'x-access-token'
        if (token != null) {
          options.headers['x-access-token'] = token;
        }
        return handler.next(options);
      },
    ));

    print("URL: $baseUrl/place/$id");
    Response response = await dio.delete('$baseUrl/place/$id');

    data = response.data.toString();
    print('Data: $data');
    statusCode = response.statusCode;
    print('Status code: $statusCode');

    if (statusCode == 201) {
      print('201');
      return 201;
    } else if (statusCode == 400) {
      print('400');
      return 400;
    } else if (statusCode == 500) {
      print('500');
      return 500;
    } else {
      print('-1');
      return -1;
    }
  }
}
