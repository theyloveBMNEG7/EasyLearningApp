import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/utils/local_storage.dart';
import '../../../data/models/chat_message.dart';
import '../../widgets/chat/chat_input_field.dart';
import '../../widgets/chat/chat_message_bubble.dart';
import '../../widgets/chat/chat_reaction_picker.dart';

class CommunityChatScreen extends StatefulWidget {
  const CommunityChatScreen({super.key});

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String currentUser = 'Emmanuel';
  final uuid = const Uuid();
  String? _pendingFileName;
  List<String> _deletedMessageIds = [];

  @override
  void initState() {
    super.initState();
    _loadDeletedMessages();
    _loadInitialMessages();
  }

  Future<void> _loadDeletedMessages() async {
    _deletedMessageIds = await LocalStorage.getDeletedMessages();
    setState(() {});
  }

  void _loadInitialMessages() {
    _messages.addAll([
      ChatMessage(
        id: uuid.v4(),
        sender: 'Alice',
        text: 'Hey everyone! Ready for the live class?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      ChatMessage(
        id: uuid.v4(),
        sender: 'Emmanuel',
        text: 'Yes! Just reviewing yesterday’s notes.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
    ]);
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty && _pendingFileName == null) return;

    final newMessage = ChatMessage(
      id: uuid.v4(),
      sender: currentUser,
      text: _pendingFileName != null
          ? ' $_pendingFileName${text.isNotEmpty ? '\n$text' : ''}'
          : text,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(newMessage);
      _controller.clear();
      _pendingFileName = null;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _deleteMessageForMe(String id) async {
    await LocalStorage.addDeletedMessage(id);
    _deletedMessageIds.add(id);
    setState(() {});
  }

  void _showMessageOptions(ChatMessage msg) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.emoji_emotions),
            title: const Text('React'),
            onTap: () {
              Navigator.pop(context);
              _showReactionPicker(msg);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete for me'),
            onTap: () {
              Navigator.pop(context);
              _deleteMessageForMe(msg.id);
            },
          ),
        ],
      ),
    );
  }

  void _showReactionPicker(ChatMessage msg) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ChatReactionPicker(
        onSelect: (emoji) {
          setState(() {
            msg.reaction = emoji;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleMessages =
        _messages.where((m) => !_deletedMessageIds.contains(m.id)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Community Chat'),
        centerTitle: true,
        backgroundColor: const Color(0xFFB3E5FC),
        elevation: 2,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              itemCount: visibleMessages.length,
              itemBuilder: (context, index) {
                final msg = visibleMessages[index];
                final isMe = msg.sender == currentUser;

                return ChatMessageBubble(
                  message: msg,
                  isMe: isMe,
                  onLongPress: () => _showMessageOptions(msg),
                );
              },
            ),
          ),
          ChatInputField(
            controller: _controller,
            pendingFileName: _pendingFileName,
            onSend: _sendMessage,
            onAttach: () async {
              final result = await FilePicker.platform.pickFiles();
              if (result != null && result.files.isNotEmpty) {
                setState(() {
                  _pendingFileName = result.files.first.name;
                });
              }
            },
            onCancelFile: () => setState(() => _pendingFileName = null),
          ),
        ],
      ),
    );
  }
}
