import 'package:simple_chat_app/data_model/user_model.dart';
import 'package:simple_chat_app/data_provider/user_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:simple_chat_app/data_model/message_model.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String? chatId;
  const ChatPage({super.key, this.chatId});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  late IO.Socket socket;
  List<Message> messages = [];
  @override
  void initState() {
    super.initState();
    _setupSocket();
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  void _setupSocket() {
    socket = IO.io('http://10.0.2.2:2000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to socket');
      socket.emit('joinChat', widget.chatId);
    });

    socket.on('newMessage', (data) {
      setState(() {
        messages.add(
          Message(
            type: MessageType.values.firstWhere(
              (e) => e.name == data['type'],
              orElse: () => MessageType.text,
            ),
            content: data['content'],
            timestamp: DateTime.parse(data['timestamp']),
            senderId: data['senderId'],
            senderName: data['senderName'], // backend sends this
          ),
        );
        print('New message received: ${data['content']}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Page')),
      body: ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, i) {
          final index = messages.length - 1 - i;
          final message = messages[index];
          final isMe = message.senderId == currentUser.id; // Placeholder
          return Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isMe ? Colors.blueAccent : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _buildMessageContent(message),
              ),
              Text(
                '${message.senderName}, ${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildInput(currentUser),
    );
  }

  Widget _buildMessageContent(Message message) {
    switch (message.type) {
      case MessageType.text:
        return Text(message.content);
      case MessageType.image:
        return Image.network(message.content);
      case MessageType.video:
        return Text('Video message: ${message.content}'); // Placeholder
    }
  }

  Widget _buildInput(User currentUser) {
    final TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final content = controller.text.trim();
              if (content.isNotEmpty) {
                socket.emit('sendMessage', {
                  'chatId': widget.chatId,
                  'type': 'text',
                  'content': content,
                  'timestamp': DateTime.now().toIso8601String(),
                  'senderId': currentUser.id,
                  'senderName': currentUser.name,
                });
                controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
