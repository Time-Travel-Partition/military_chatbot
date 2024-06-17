import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  Future<String> post(String message) async {
    // var url = Uri.parse('http://0.0.0.0:8000/receive-data');
    var url = Uri.parse('http://165.246.229.36:8000/receive-data'); // 엔드포인트
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'message': message,
        }),
      );
      final data = json.decode(utf8.decode(response.bodyBytes));
      return data['your_data'] as String;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
