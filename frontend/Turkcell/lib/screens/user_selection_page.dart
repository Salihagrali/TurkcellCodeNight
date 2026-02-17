import 'package:flutter/material.dart';
import 'package:turkcell_code_night/screens/main_navigation.dart';
import 'package:turkcell_code_night/services/api_service.dart'; // ApiService import edildi
import '../models/user_state.dart';

class UserSelectionPage extends StatelessWidget {
  UserSelectionPage({super.key});

  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("TV+ Kullanıcı Seçimi"), 
        backgroundColor: const Color(0xFF0038A8), 
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<List<UserStateModel>>(
        future: _apiService.fetchUsers(),
        builder: (context, snapshot) {
          // 1. Veri yüklenirken dönen çark
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF0038A8)));
          } 
          
          // 2. Hata oluşursa gösterilecek ekran
          else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 10),
                  Text("Hata: ${snapshot.error}"),
                ],
              ),
            );
          } 
          
          // 3. Veri boş gelirse
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Henüz kullanıcı tanımlanmamış."));
          }

          // 4. Başarılı durum: Listeyi çiz
          final users = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF0038A8), 
                    child: Text(user.name[0], style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  // Java'dan gelen city ve segment bilgilerini alt bilgiye ekledik
                  subtitle: Text("Puan: ${user.totalPoints} | ${user.city}"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => MainNavigation(user: user))
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}