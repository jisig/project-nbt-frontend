import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatMessage {
  final String text;
  final bool isSender;
  final String time;

  ChatMessage({required this.text, required this.isSender, required this.time});
}

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hey Sofia! How are you doing today?",
      isSender: true,
      time: "10:00 AM",
    ),
    ChatMessage(
      text: "I'm great! Just working on some new designs for our project.",
      isSender: false,
      time: "10:02 AM",
    ),
    ChatMessage(
      text: "That sounds exciting! Can't wait to see them.",
      isSender: true,
      time: "10:05 AM",
    ),
    ChatMessage(
      text: "I'll share the preview with you soon ✨",
      isSender: false,
      time: "10:06 AM",
    ),
    ChatMessage(
      text: "Great things made by great ones, as they say!",
      isSender: false,
      time: "10:07 AM",
    ),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: _messageController.text.trim(),
            isSender: true,
            time: TimeOfDay.now().format(context),
          ),
        );
        _messageController.clear();
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final weight = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: theme.inversePrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: ClipOval(
                child: Image.network(
                  "https://api.a0.dev/assets/image?text=cute%20pink%20bunny%20rabbit%20portrait&aspect=1:1",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sofia Ramirez",
                    style: GoogleFonts.k2d(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: theme.inversePrimary,
                    ),
                  ),
                  Text(
                    "Online",
                    style: GoogleFonts.k2d(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.phone,
                color: theme.inversePrimary,
                size: 20,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.video_camera_solid,
                color: theme.inversePrimary,
                size: 24,
              ),
            ),
          ],
        ),
        backgroundColor: theme.onInverseSurface,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index], theme);
              },
            ),
          ),
          _buildMessageInput(theme),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, ColorScheme theme) {
    return Align(
      alignment: message.isSender
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isSender ? theme.primary : theme.onInverseSurface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isSender ? 16 : 0),
            bottomRight: Radius.circular(message.isSender ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: GoogleFonts.k2d(
                fontSize: 14,
                color: message.isSender ? Colors.white : theme.inversePrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.time,
              style: GoogleFonts.k2d(
                fontSize: 10,
                color: message.isSender
                    ? Colors.white.withOpacity(0.7)
                    : theme.tertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(ColorScheme theme) {
    final theme = Theme.of(context).colorScheme;
    final height = MediaQuery.of(context).size.height;
    final weight = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: theme.onInverseSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.surface,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(CupertinoIcons.add, color: theme.primary, size: 20),
              onPressed: () {
                showBottomSheet(
                  context: context,
                  builder: (context) => StatefulBuilder(
                    builder: (context, setModalState) {
                      return Container(
                        height: height * 0.46,
                        decoration: BoxDecoration(
                          color: theme.surface,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 32,
                          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 7.5,
                              width: 50,
                              decoration: BoxDecoration(
                                color: theme.tertiary,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            Spacer(),
                            Text(
                              "Create New",
                              style: GoogleFonts.k2d(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.inversePrimary,
                              ),
                            ),
                            Text(
                              "What would you like to create?",
                              style: GoogleFonts.k2d(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: theme.tertiary,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                style: GoogleFonts.k2d(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: GoogleFonts.k2d(color: theme.tertiary),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                CupertinoIcons.paperplane_fill,
                color: Colors.white,
                size: 20,
              ),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
