import 'package:flutter/material.dart';
import 'package:military_chatbot/chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emotion Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ItemListScreen(),
    );
  }
}

class ItemListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {'title': '군 판 례', 'service': 0},
    {'title': '군 사 법', 'service': 1},
    {'title': '군 용 어', 'service': 2},
  ];

  ItemListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('군 관련 조회 목록'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item['title']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(emotion: item['service']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
