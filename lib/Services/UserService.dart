import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bankitos_flutter/Models/ReviewModel.dart';
import 'package:bankitos_flutter/Models/PlaceModel.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bankitos_flutter/Models/UserModel.dart' as U;

class UserService {
  final String baseUrl = "http://127.0.0.1:3000"; // URL de tu backend
  final Dio dio = Dio(); // Usa el prefijo 'Dio' para referenciar la clase Dio
  var statusCode;
  var data;
  //final GoogleSignIn googleSignIn = GoogleSignIn();

  UserService() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = getToken();
        if (token != null) {
          options.headers['x-access-token'] = token;
        }
        return handler.next(options);
      },
    ));
  }

  void saveToken(String token) {
    final box = GetStorage();
    box.write('token', token);
  }

  String? getToken() {
    final box = GetStorage();
    return box.read('token');
  }

  void saveUserId(String id) {
    final box = GetStorage();
    box.write('id', id);
  }

  String getUserId() {
    final box = GetStorage();
    return box.read('id') ?? '';
  }

  void savePlaceId(String placeId){
    final box = GetStorage();
    box.write('id', placeId);
  }

  String getPlaceId(){
    final box = GetStorage();
    if(box.read('id').isEmpty){
      return '';
    }
    else{
      return box.read('id');
    }
  }

  Future<int> logOut() async{
    print('Log Out');

    try{
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

      print('URL: $baseUrl/login');
      print(logInToJson(logIn));
      
      Response response = await dio.post('$baseUrl/logout');
      Map<String, dynamic> data = response.data;
      print('Data: $data');
      return 0;
    }
    catch(error){
      print('Error with log out: $error');
      return -1;
    }
  }

   Future<int> logIn(logIn) async {
    print('LogIn');
    
    print('URL: $baseUrl/login');
    print(logInToJson(logIn));
    
    Response response = await dio.post('$baseUrl/login', data: logInToJson(logIn));
    Map<String, dynamic> data = response.data;
    print('Data: $data');

    String token = data['token'];
    String userId = data['_id'];

    print('Token: $token');
    print('ID: $userId');

    saveToken(token);
    saveUserId(userId); 

    int statusCode = response.statusCode!;
    print('Status code: $statusCode');

    return statusCode;
  }

  Future<int> logInWithGoogle(String token, String email) async {
    print('LogInWithGoogle');

    print(email);

    String token1 = token;
    String email1 = email;

    try {
      print('URL: $baseUrl/loginWithGoogle');
      Response response = await dio.post('$baseUrl/loginWithGoogle', data: logInToJsonWithGoogle(token1, email1));
      
      Map<String, dynamic> data = response.data;
      print('Data: $data');
      
      String token = data['token'];
      String userId = data['_id'];
      
      print('Token: $token');
      print('ID: $userId');
      
      saveToken(token);
      saveUserId(userId); 

      int statusCode = response.statusCode!;
      print('Status code: $statusCode');

      return statusCode;
    } catch (e) {
      print('Error: $e');
      return -1;
    }
  }

  Future<U.User> getUser() async {
    print('getData');
    var id = getUserId();
    try {
      print('URL: $baseUrl/users/$id');
      var res = await dio.get('$baseUrl/users/$id');
      U.User u = U.User.fromJson(res.data as Map<String, dynamic>);
      print(u.email);
      return u;
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  Map<String, dynamic> logInToJson(logIn) {
    return {
      'email': logIn.email,
      'password': logIn.password,
    };
  }

  Map<String, dynamic> logInToJsonWithGoogle(String token, String email) {
    return {
      'email': email,
      'token': token,
    };
  }


  //Función createUser
  Future<int> createUser(U.User newUser)async{
    print('createUser');
    print('try');
    //Aquí llamamos a la función request
    print('request');
    // Utilizar Dio para enviar la solicitud POST a http://127.0.0.1:3000/users
    Response response = await dio.post('$baseUrl/users', data: newUser.toJson());
    //En response guardamos lo que recibimos como respuesta
    //Printeamos los datos recibidos

    data = response.data.toString();
    print('Data: $data');
    //Printeamos el status code recibido por el backend

    statusCode = response.statusCode;
    print('Status code: $statusCode');

    if (statusCode == 201) {
      // Si el usuario se crea correctamente, retornamos el código 201
      print('201');
      logIn(newUser);
      return 201;
    } else if (statusCode == 400) {
      // Si hay campos faltantes, retornamos el código 400
      print('400');

      return 400;
    } else if (statusCode == 500) {
      // Si hay un error interno del servidor, retornamos el código 500
      print('500');

      return 500;
    } else {
      // Otro caso no manejado
      print('-1');

      return -1;
    }
  }

Future<int> deletePlace(String id)async{
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



Future<int> updatePlace(Place newPlace, String id)async{
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
    Response response = await dio.put('$baseUrl/place/$id', data: newPlace.toJson());

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


Future<U.User> putUser(user) async {
  print('getData');
  var id = getUserId();
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
  Map<String, dynamic> revtoJson(user) {
    return{
      '_id': user.id,
      'first_name': user.first_name,
      'last_name': user.last_name,
      'gender': user.gender,
      'role': user.role,
      'password': user.password,
      'email': user.email,
      'phone_number': user.phone_number,
      'birth_date': user.birth_date,
      'middle_name': user.middle_name,
      'places': user.places,
      'reviews': user.reviews,
      'conversations': user.conversations,
      'user_rating': user.user_rating,
      'photo': user.photo,
      'description': user.description,
      'dni': user.dni,
      'personality': user.personality,
      'address': user.address,
      'housing_offered': user.housing_offered,
      'emergency_contact': user.emergency_contact,
      'user_deactivated': user.user_deactivated,
      'creation_date': user.creation_date.toIso8601String(),
      'modified_date': user.modified_date.toIso8601String(),
    };
  }
  
  try {
    
    var res = await dio.put('$baseUrl/users/$id', data: revtoJson(user));
    print(res.data);
    print('akiiiiiiiiiiiiiiiii');
    U.User responseData = U.User.fromJson(res.data as Map<String, dynamic>); // Obtener los datos de la respuesta
  
    // Convertir los datos en una lista de objetos Place
    //List<Review> reviews = responseData.map((data) => Review.fromJson(data)).toList();
  
    return responseData; // Devolver la lista de lugares
  } catch (e) {
    // Manejar cualquier error que pueda ocurrir durante la solicitud
    print('Error fetching data: $e');
    throw e; // Relanzar el error para que el llamador pueda manejarlo
  }
  
}
Future<String> deleteUser() async {
  
  var id = getUserId();
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
    
    var res = await dio.delete('$baseUrl/users/$id');
    
    print('akiiiiiiiiiiiiiiiii');
    var mesage = res.data.toString(); // Obtener los datos de la respuesta
  
    // Convertir los datos en una lista de objetos Place
    //List<Review> reviews = responseData.map((data) => Review.fromJson(data)).toList();
  
    return mesage; // Devolver la lista de lugares
  } catch (e) {
    // Manejar cualquier error que pueda ocurrir durante la solicitud
    print('Error fetching data: $e');
    throw e; // Relanzar el error para que el llamador pueda manejarlo
  }
  
}
  Future<int> createPlace(Place newPlace)async{
    print('createPlace');
   
   dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Obtener el token guardado
      final token = getToken();

      print('token: ${token}');


      if(token != null){

          options.headers['x-access-token'] = token;
      }
      // Si el token está disponible, agregarlo a la cabecera 'x-access-token'
      return handler.next(options);
    },
  ));

    print('URL: $baseUrl/place');
    Response response = await dio.post('$baseUrl/place', data: newPlace.toJson());

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

  Future<List<Place>> getData(String id) async {
  print('getData');
  // Interceptor para agregar el token a la cabecera 'x-access-token'
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Obtener el token guardado
      final token = getToken();

      print(token);  

      if(token != null){
          
          options.headers['x-access-token'] = token;
      }
      return handler.next(options);
    },
  ));
  try {
    
    print('URL: $baseUrl/placebyuser/$id');
    var res = await dio.get('$baseUrl/placebyuser/$id');
    
    List<dynamic> responseData = res.data; // Obtener los datos de la respuesta
  
    // Convertir los datos en una lista de objetos Place
    List<Place> places = responseData.map((data) => Place.fromJson(data)).toList();
  
    return places; // Devolver la lista de lugares
  } catch (e) {
    // Manejar cualquier error que pueda ocurrir durante la solicitud
    print('Error fetching data: $e');
    throw e; // Relanzar el error para que el llamador pueda manejarlo
  }
}

  
  Future<List<Review>> getReviewsById(String id) async {
  print('getData');
  // Interceptor para agregar el token a la cabecera 'x-access-token'
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Obtener el token guardado
      final token = getToken(); 
      if(token != null){
          options.headers['x-access-token'] = token;
      }
      return handler.next(options);
    },
  ));
  try {
    print('URL: $baseUrl/review/byPlace/$id');
    var res = await dio.get('$baseUrl/review/byPlace/$id');
    List<dynamic> responseData = res.data; // Obtener los datos de la respuesta
    // Convertir los datos en una lista de objetos Place
    List<Review> reviews = responseData.map((data) => Review.fromJson(data)).toList();
    return reviews; // Devolver la lista de lugares
  } catch (e) {
    // Manejar cualquier error que pueda ocurrir durante la solicitud
    print('Error fetching data: $e');
    throw e; // Relanzar el error para que el llamador pueda manejarlo
  }
}

Future<U.User> getSearchedUser(String id) async {
  print('getData');
  
  // Interceptor para agregar el token a la cabecera 'x-access-token'
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Obtener el token guardado
      final token = getToken();

      print(token);  

      if(token != null){
          
          options.headers['x-access-token'] = token;
      }
      return handler.next(options);
    },
  ));
  
  try {
    
    print('URL: $baseUrl/users/$id');
    var res = await dio.get('$baseUrl/users/$id');
    
     // Obtener los datos de la respuesta
  
    // Convertir los datos en una lista de objetos Place
    U.User u = U.User.fromJson(res.data as Map<String, dynamic>);
    print(u.email);
    return u; // Devolver la lista de lugares
  } catch (e) {
    // Manejar cualquier error que pueda ocurrir durante la solicitud
    print('Error fetching data: $e');
    throw e; // Relanzar el error para que el llamador pueda manejarlo
  }
}

Future<int> createReview(Review newReview)async{
    print('createReview');
   
   dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Obtener el token guardado
      final token = getToken();

      if(token != null){
          options.headers['x-access-token'] = token;
      }
      // Si el token está disponible, agregarlo a la cabecera 'x-access-token'
      return handler.next(options);
    },
  ));

    print('URL: $baseUrl/review');
    Response response = await dio.post('$baseUrl/review', data: newReview.toJson());
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

  Future<int> updateReview(Review newReview, String id)async{
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
    Response response = await dio.put('$baseUrl/review/$id', data: newReview.toJson());

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
Future<List<U.User>> getUsers() async {
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
    var res = await dio.get('$baseUrl/users');
    List<dynamic> responseData = res.data; // Obtener los datos de la respuesta
  
    // Convertir los datos en una lista de objetos Place
    List<U.User> users = responseData.map((data) => U.User.fromJson(data)).toList();
  
    return users; // Devolver la lista de lugares
  } catch (e) {
    // Manejar cualquier error que pueda ocurrir durante la solicitud
    print('Error fetching data: $e');
    throw e; // Relanzar el error para que el llamador pueda manejarlo
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
    List<dynamic> responseData = res.data; // Obtener los datos de la respuesta
  
    // Convertir los datos en una lista de objetos Place
    List<Place> places = responseData.map((data) => Place.fromJson(data)).toList();
  
    return places; // Devolver la lista de lugares
  } catch (e) {
    // Manejar cualquier error que pueda ocurrir durante la solicitud
    print('Error fetching data: $e');
    throw e; // Relanzar el error para que el llamador pueda manejarlo
  }
}
Future<List<Review>> getReviewsByUser() async {
  print('getReviewsByUse');
  String id = getUserId();
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
    var res = await dio.get('$baseUrl/review/byAuthor/$id');
    List<dynamic> responseData = res.data; // Obtener los datos de la respuesta
  
    // Convertir los datos en una lista de objetos Place
    List<Review> reviews = responseData.map((data) => Review.fromJson(data)).toList();
  
    return reviews; // Devolver la lista de lugares
  } catch (e) {
    // Manejar cualquier error que pueda ocurrir durante la solicitud
    print('Error fetching data: $e');
    throw e; // Relanzar el error para que el llamador pueda manejarlo
  }
}
  Future<int> deleteReview(String id)async{
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