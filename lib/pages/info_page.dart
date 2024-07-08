import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tentang Aplikasi',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF758694), 
        iconTheme: const IconThemeData(
            color: Colors.white), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'ASEP RC',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Image.asset('assets/images/logo.png', height: 200),
            const SizedBox(height: 10),
            const Text(
              'Aplikasi ini dirancang untuk membantu pemasok suku cadang mobil RC dalam mengelola stok spare part',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            const Text(
              'Pembuat Aplikasi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Image.asset('assets/images/profil.png', height: 100),
            const SizedBox(height: 10),
            const Text(
              'Rifal Arif Rahman',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            const Text(
              'Saya seorang mahasiswa yang memili ketertarikan terhadap dunia IT, Sosial, dan Budaya. Saya mengikuti seputar AI, Film, dan.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
