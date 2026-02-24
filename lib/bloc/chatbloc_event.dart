part of 'chatbloc_bloc.dart';

@immutable
sealed class ChatblocEvent {
  const ChatblocEvent();
}

/// User typed and submitted a message.
final class SendMessageEvent extends ChatblocEvent {
  const SendMessageEvent(this.message);
  final String message;
}

/// User cleared the chat history.
final class ClearChatEvent extends ChatblocEvent {
  const ClearChatEvent();
}
