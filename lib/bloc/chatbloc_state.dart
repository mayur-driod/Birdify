part of 'chatbloc_bloc.dart';

@immutable
sealed class ChatblocState {
  const ChatblocState();
}

/// No messages yet — show the welcome / suggestion screen.
final class ChatblocInitial extends ChatblocState {
  const ChatblocInitial();
}

/// User message sent; awaiting the AI reply.
final class ChatLoading extends ChatblocState {
  const ChatLoading(this.messages);
  final List<ChatMessage> messages;
}

/// AI reply received successfully.
final class ChatLoaded extends ChatblocState {
  const ChatLoaded(this.messages);
  final List<ChatMessage> messages;
}

/// Network or API error while fetching AI reply.
final class ChatError extends ChatblocState {
  const ChatError(this.error, this.messages);
  final String error;
  final List<ChatMessage> messages;
}
