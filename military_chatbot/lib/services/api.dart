import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  Future<void> post(String message) async {
    var url = Uri.parse(''); // 엔드포인트로 지정해야 함
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'message': message,
        }),
      );
      final data = json.decode(response.body);
      print(data);
      return data;
    } catch (e) {
      print(e);
    }
  }
}
