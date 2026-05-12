import '../models/app_message.dart';

class MessageState {
  final List<AppMessage> queuedMessages;
  final AppMessage? currentlyShowing;

  const MessageState({
    this.queuedMessages = const [],
    this.currentlyShowing,
  });

  MessageState copyWith({
    List<AppMessage>? queuedMessages,
    AppMessage? currentlyShowing,
    bool clearCurrentlyShowing = false,
  }) {
    return MessageState(
      queuedMessages: queuedMessages ?? this.queuedMessages,
      currentlyShowing: clearCurrentlyShowing ? null : (currentlyShowing ?? this.currentlyShowing),
    );
  }
}
