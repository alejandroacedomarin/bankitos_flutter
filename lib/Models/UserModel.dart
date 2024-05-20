class User {
  final String id;
  final String first_name;
  final String middle_name;
  final String last_name;
  final String gender;
  final String role;
  final String password;
  final String email;
  final String phone_number;
  final String birth_date;
  final List<String> places; // places es una lista de IDs, por lo que lo definimos como List<String>
  final List<String> reviews; // reviews es una lista de IDs, por lo definimos como List<String>
  final List<String> conversations; // conversations es una lista de IDs, por lo que lo definimos como List<String>
  final double user_rating; // user_rating es un double
  final String photo; // photo es una String
  final String description; // description es una String
  final String dni; // dni es una String
  final String personality; // personality es una String
  final String address; // address es una String
  final List<String> housing_offered; // housing_offered es una lista de IDs, por lo que lo definimos como List<String>
  final Map<String, String> emergency_contact; // emergency_contact es un mapa de full_name y telephone, por lo que lo definimos como Map<String, String>
  final bool? user_deactivated; // user_deactivated es un booleano
  final DateTime? creation_date; // creation_date es una fecha y hora
  final DateTime? modified_date; // modified_date es una fecha y hora

  User({
    required this.id,
    required this.first_name,
    required this.middle_name,
    required this.last_name,
    required this.gender,
    required this.role,
    required this.password,
    required this.email,
    required this.phone_number,
    required this.birth_date,
    required this.places,
    required this.reviews,
    required this.conversations,
    required this.user_rating,
    required this.photo,
    required this.description,
    required this.dni,
    required this.personality,
    required this.address,
    required this.housing_offered,
    required this.emergency_contact,
     this.user_deactivated,
     this.creation_date,
    this.modified_date,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      gender: json['gender'],
      role: json['role'],
      password: json['password'],
      email: json['email'],
      phone_number: json['phone_number'],
      birth_date: json['birth_date'],
      middle_name: json['middle_name'] ?? '', // Si middle_name no está presente, establecemos una cadena vacía como valor predeterminado
      places: List<String>.from(json['places'] ?? []), // Si places no está presente, establecemos una lista vacía como valor predeterminado
      reviews: List<String>.from(json['reviews'] ?? []), // Si reviews no está presente, establecemos una lista vacía como valor predeterminado
      conversations: List<String>.from(json['conversations'] ?? []), // Si conversations no está presente, establecemos una lista vacía como valor predeterminado
      user_rating: json['user_rating'] ?? 0.0, // Si user_rating no está presente, establecemos 0.0 como valor predeterminado
      photo: json['photo'] ?? '', // Si photo no está presente, establecemos una cadena vacía como valor predeterminado
      description: json['description'] ?? '', // Si description no está presente, establecemos una cadena vacía como valor predeterminado
      dni: json['dni'] ?? '', // Si dni no está presente, establecemos una cadena vacía como valor predeterminado
      personality: json['personality'] ?? '', // Si personality no está presente, establecemos una cadena vacía como valor predeterminado
      address: json['address'] ?? '', // Si address no está presente, establecemos una cadena vacía como valor predeterminado
      housing_offered: List<String>.from(json['housing_offered'] ?? []), // Si housing_offered no está presente, establecemos una lista vacía como valor predeterminado
      emergency_contact: Map<String, String>.from(json['emergency_contact'] ?? {}), // Si emergency_contact no está presente, establecemos un mapa vacío como valor predeterminado
      user_deactivated: json['user_deactivated'] ?? false, // Si user_deactivated no está presente, establecemos false como valor predeterminado
      creation_date: DateTime.parse(json['creation_date']), // Si creation_date no está presente, se lanzará una excepción ya que es obligatorio
      modified_date: DateTime.parse(json['modified_date']), // Si modified_date no está presente, se lanzará una excepción ya que es obligatorio
    );
  }

  Map<String, dynamic> toJson() {
    return{
      '_id': id,
      'first_name': first_name,
      'last_name': last_name,
      'gender': gender,
      'role': role,
      'password': password,
      'email': email,
      'phone_number': phone_number,
      'birth_date': birth_date,
      'middle_name': middle_name,
      'places': places,
      'reviews': reviews,
      'conversations': conversations,
      'user_rating': user_rating,
      'photo': photo,
      'description': description,
      'dni': dni,
      'personality': personality,
      'address': address,
      'housing_offered': housing_offered,
      'emergency_contact': emergency_contact,
    };
  }
  
}

