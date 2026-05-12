import '../models/app_message.dart';

class MessageQueue {
  final List<AppMessage> _queue = [];

  List<AppMessage> get items => List.unmodifiable(_queue);

  bool get isEmpty => _queue.isEmpty;
  bool get isNotEmpty => _queue.isNotEmpty;

  /// Add a message to the queue based on priority.
  /// If a message with the same ID already exists, it is ignored or updated.
  void enqueue(AppMessage message) {
    // Avoid exact duplicate IDs in queue
    _queue.removeWhere((m) => m.id == message.id);
    
    _queue.add(message);
    
    // Sort descending by priority
    _queue.sort((a, b) => b.priority.compareTo(a.priority));
  }

  /// Remove and return the highest priority message.
  AppMessage? dequeue() {
    if (_queue.isEmpty) return null;
    return _queue.removeAt(0);
  }

  /// Remove a specific message by ID.
  void remove(String id) {
    _queue.removeWhere((m) => m.id == id);
  }

  /// Clear the queue.
  void clear() {
    _queue.clear();
  }
}
