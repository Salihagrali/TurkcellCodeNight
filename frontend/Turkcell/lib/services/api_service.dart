import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_state.dart';

class ApiService {
  // Java ekibinden gelen güncel URL
  final String apiUrl = "https://awnless-majorie-unspending.ngrok-free.dev/api/v1/dashboard/users";

  Future<List<UserStateModel>> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        // NGROK tarayıcı uyarısını atlamak için bu header şarttır
        headers: {
          "ngrok-skip-browser-warning": "true",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        // Türkçe karakterleri korumak için utf8.decode kullanıyoruz
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        
        // JSON listesini UserStateModel listesine dönüştür
        return data.map((json) => UserStateModel.fromJson(json)).toList();
      } else {
        throw Exception("Sunucu hatası: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Bağlantı sağlanamadı: $e");
    }
  }
}