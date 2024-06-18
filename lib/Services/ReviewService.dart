import 'package:bankitos_flutter/Models/ReviewModel.dart';
import 'package:dio/dio.dart'; // Usa un prefijo 'Dio' para importar la clase Response desde Dio
import 'package:get_storage/get_storage.dart';

class ReviewService {
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
  String? getId() {
    final box = GetStorage();
    return box.read('id');
  }

  Future<int> createReview(Review newReview) async {
    print('createReview');

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Obtener el token guardado
        final token = getToken();

        if (token != null) {
          options.headers['x-access-token'] = token;
        }
        // Si el token está disponible, agregarlo a la cabecera 'x-access-token'
        return handler.next(options);
      },
    ));

    print('URL: $baseUrl/review');
    Response response =
        await dio.post('$baseUrl/review', data: newReview.toJson());
    data = response.data.toString();
    print('Response: $data');
    statusCode = response.statusCode;

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

  Future<List<Review>> getReviewsById(String id) async {
    print('getData');
    // Interceptor para agregar el token a la cabecera 'x-access-token'
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Obtener el token guardado
        final token = getToken();
        if (token != null) {
          options.headers['x-access-token'] = token;
        }
        return handler.next(options);
      },
    ));
    try {
      print('URL: $baseUrl/review/byPlace/$id');
      var res = await dio.get('$baseUrl/review/byPlace/$id');
      List<dynamic> responseData =
          res.data; // Obtener los datos de la respuesta
      // Convertir los datos en una lista de objetos Place
      List<Review> reviews =
          responseData.map((data) => Review.fromJson(data)).toList();
      return reviews; // Devolver la lista de lugares
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir durante la solicitud
      print('Error fetching data: $e');
      throw e; // Relanzar el error para que el llamador pueda manejarlo
    }
  }
  Future<List<Review>> getReviews() async {
    print('getData');
    // Interceptor para agregar el token a la cabecera 'x-access-token'
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Obtener el token guardado
        final token = getToken();
        if (token != null) {
          options.headers['x-access-token'] = token;
        }
        return handler.next(options);
      },
    ));
    try {
      print('URL: $baseUrl/reviews');
      var res = await dio.get('$baseUrl/reviews');
      List<dynamic> responseData =
          res.data; // Obtener los datos de la respuesta
      // Convertir los datos en una lista de objetos Place
      List<Review> reviews =
          responseData.map((data) => Review.fromJson(data)).toList();
          print(reviews);
      return reviews; // Devolver la lista de lugares
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir durante la solicitud
      print('Error fetching data: $e');
      throw e; // Relanzar el error para que el llamador pueda manejarlo
    }
}
Future<List<Review>> getReviewsByAuthor() async {
    print('getData');
    // Interceptor para agregar el token a la cabecera 'x-access-token'
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Obtener el token guardado
        final token = getToken();
        if (token != null) {
          options.headers['x-access-token'] = token;
        }
        return handler.next(options);
      },
    ));
    try {
      var id = getId();
      print('URL: $baseUrl/review/byAuthor/$id');
      var res = await dio.get('$baseUrl/review/byAuthor/$id');
      List<dynamic> responseData =
          res.data; // Obtener los datos de la respuesta
      // Convertir los datos en una lista de objetos Place
      List<Review> reviews =
          responseData.map((data) => Review.fromJson(data)).toList();
      return reviews; // Devolver la lista de lugares
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir durante la solicitud
      print('Error fetching data: $e');
      throw e; // Relanzar el error para que el llamador pueda manejarlo
    }
  }
  Future<int> updateReview(Review newReview, String id) async {
    print('updateReview');

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Obtener el token guardado
        final token = getToken();
        // Si el token está disponible, agregarlo a la cabecera 'x-access-token'
        if (token != null) {
          options.headers['x-access-token'] = token;
        }
        return handler.next(options);
      },
    ));

    print("URL: $baseUrl/review/$id");
    Response response =
        await dio.put('$baseUrl/review/$id', data: newReview.toJson());

    data = response.data.toString();
    print('Data: $data');
    statusCode = response.statusCode;
    print('Status code: $statusCode');

    if (statusCode == 200) {
      print('200');
      return 200;
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

  Future<int> deleteReview(String id) async {
    print('deleteReview');

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Obtener el token guardado
        final token = getToken();
        // Si el token está disponible, agregarlo a la cabecera 'x-access-token'
        if (token != null) {
          options.headers['x-access-token'] = token;
        }
        return handler.next(options);
      },
    ));

    print("URL: $baseUrl/review/$id");
    Response response = await dio.delete('$baseUrl/review/$id');

    data = response.data.toString();
    print('Data: $data');
    statusCode = response.statusCode;
    print('Status code: $statusCode');

    if (statusCode == 200) {
      print('200');
      return 200;
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
