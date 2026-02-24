import 'package:birdify/models/chat_message.dart';
import 'package:birdify/repos/gemini_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'chatbloc_event.dart';
part 'chatbloc_state.dart';

class ChatblocBloc extends Bloc<ChatblocEvent, ChatblocState> {
  final List<ChatMessage> _messages = [];

  ChatblocBloc() : super(const ChatblocInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<ClearChatEvent>(_onClearChat);
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatblocState> emit,
  ) async {
    final userMsg = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: event.message,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);
    emit(ChatLoading(List.from(_messages)));

    try {
      // Build Gemini-compatible history (all messages before this one).
      final history = _messages
          .sublist(0, _messages.length - 1)
          .map(
            (m) => {
              'role': m.isUser ? 'user' : 'model',
              'text': m.text,
            },
          )
          .toList();

      final reply = await GeminiService.chatAboutBirds(event.message, history);

      _messages.add(
        ChatMessage(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          text: reply,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
      emit(ChatLoaded(List.from(_messages)));
    } catch (e) {
      emit(
        ChatError(
          e.toString().replaceFirst('Exception: ', ''),
          List.from(_messages),
        ),
      );
    }
  }

  void _onClearChat(ClearChatEvent event, Emitter<ChatblocState> emit) {
    _messages.clear();
    emit(const ChatblocInitial());
  }
}
