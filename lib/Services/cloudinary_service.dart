import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName = '';
  final String apiKey = '';
  final String apiSecret = '';

  Future<String?> uploadImage(Uint8List imageBytes) async {
    final String url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
    final String base64Image = base64Encode(imageBytes);
    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final Map<String, dynamic> body = {
      'file': 'data:image/jpeg;base64,$base64Image',
      'upload_preset': 'uotzhan1',
    };

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['secure_url'];
    } else {
      print('Failed to upload image: ${response.statusCode}');
      return null;
    }
  }
}
