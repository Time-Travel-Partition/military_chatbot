import 'package:flutter/material.dart';
import 'package:military_chatbot/services/api.dart';

class ChatScreen extends StatefulWidget {
  final int emotion;

  const ChatScreen({Key? key, required this.emotion}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final APIService _apiService = APIService();
  final TextEditingController _messageController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();

    // Automatically scrolls down when keyboard is shown
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), scrollDown);
      }
    });

    Future.delayed(const Duration(milliseconds: 500), scrollDown);
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  Future<void> sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({
          'content': _messageController.text,
          'isCurrentUser': true,
        });
        _messageController.clear();
      });
      receiveMessage();
      scrollDown();
    }
  }

  void receiveMessage() async {
    // API 엔드포인트로 POST 요청
    String response = await _apiService.post(_messageController.text);
    setState(() {
      _messages.add({
        'content': response,
        'isCurrentUser': false,
      });
    });
    scrollDown();
  }

  String getSelectedService(int index) {
    if (index == 0) return '군 판 례';
    if (index == 1) return '군 사 법';
    if (index == 2) return '군 용 어';
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getSelectedService(widget.emotion),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        foregroundColor: Theme.of(context).colorScheme.background,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Column(
        children: [
          // Display all messages
          Expanded(child: _buildMessageList()),

          // User input
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isCurrentUser = message['isCurrentUser'] as bool;
        return Container(
          alignment:
              isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: isCurrentUser ? Colors.blue[200] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(message['content'] as String),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 40, left: 15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: myFocusNode,
              decoration: const InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(left: 20, right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
