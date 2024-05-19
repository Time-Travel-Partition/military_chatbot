import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  Future<String> post(String message) async {
    var url = Uri.parse('http://127.0.0.1:8000/receive-data'); // 엔드포인트로 지정해야 함
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'message': message,
        }),
      );
      final data = json.decode(response.body);
      return data['your_data'] as String;
    } catch (e) {
      return e.toString();
    }
  }
}
