import 'dart:async';
import 'package:flutter/widgets.dart';

import '../models/app_message.dart';
import '../storage/storage_adapter.dart';
import '../storage/prefs_storage.dart';
import 'message_rule.dart';
import 'message_queue.dart';
import 'message_state.dart';

/// The central controller for message orchestration.
class MessageOrchestrator extends ChangeNotifier {
  static MessageOrchestrator? _instance;
  
  /// Singleton instance. Must call `init()` before using.
  static MessageOrchestrator get instance {
    assert(_instance != null, 'Call MessageOrchestrator.init() first.');
    return _instance!;
  }

  final StorageAdapter _storage;
  final MessageRuleEvaluator _ruleEvaluator;
  final MessageQueue _queue = MessageQueue();
  
  MessageState _state = const MessageState();
  MessageState get state => _state;

  /// Function to actually display the overlay/dialog/etc.
  /// Should be injected by the app or overlay service.
  Future<void> Function(AppMessage message)? displayHandler;

  bool _isProcessing = false;

  MessageOrchestrator._(this._storage) 
      : _ruleEvaluator = MessageRuleEvaluator(_storage);

  /// Initialize the orchestrator singleton.
  static Future<void> init({StorageAdapter? storage}) async {
    final storageAdapter = storage ?? PrefsStorage();
    await storageAdapter.init();
    _instance = MessageOrchestrator._(storageAdapter);
  }

  /// Register a message to be evaluated and potentially shown.
  Future<void> register(AppMessage message) async {
    final canShow = await _ruleEvaluator.canShow(message);
    if (canShow) {
      _queue.enqueue(message);
      _updateState();
      _processQueue();
    }
  }

  /// Register multiple messages at once.
  Future<void> registerAll(List<AppMessage> messages) async {
    for (final msg in messages) {
      final canShow = await _ruleEvaluator.canShow(msg);
      if (canShow) {
        _queue.enqueue(msg);
      }
    }
    _updateState();
    _processQueue();
  }

  /// Request to show a message by ID if it's currently registered or in queue.
  /// (Useful for manual triggering).
  void show(String id) {
    // If we want to show specifically by ID, we prioritize it if it exists in queue.
    final index = _queue.items.indexWhere((m) => m.id == id);
    if (index != -1) {
      final msg = _queue.items[index];
      _queue.remove(id);
      
      // Temporarily bypass priority to show immediately
      _queue.enqueue(
        AppMessage(
          id: msg.id,
          type: msg.type,
          builder: msg.builder,
          priority: 999999, // Max priority
          dismissPolicy: msg.dismissPolicy,
          cooldown: msg.cooldown,
        )
      );
      _processQueue();
    }
  }

  /// Notification from the UI that a message was dismissed.
  Future<void> onMessageDismissed(String id) async {
    if (_state.currentlyShowing?.id == id) {
      _state = _state.copyWith(clearCurrentlyShowing: true);
      notifyListeners();
      
      // Give a small delay between messages so UI can clear
      await Future.delayed(const Duration(milliseconds: 300));
      _isProcessing = false;
      _processQueue();
    }
  }

  Future<void> _processQueue() async {
    if (_isProcessing || displayHandler == null) return;
    if (_queue.isEmpty) return;

    _isProcessing = true;
    final nextMessage = _queue.dequeue();
    
    if (nextMessage != null) {
      // Final check in case rules changed (e.g. session resets)
      final canShow = await _ruleEvaluator.canShow(nextMessage);
      if (!canShow) {
        _isProcessing = false;
        _processQueue();
        return;
      }

      _state = _state.copyWith(currentlyShowing: nextMessage);
      _updateState();

      // Mark as shown in rules
      await _ruleEvaluator.markShown(nextMessage);

      // Call UI handler
      try {
        await displayHandler!(nextMessage);
      } catch (e) {
        debugPrint('Error displaying message: $e');
        // If display fails, allow next message
        onMessageDismissed(nextMessage.id);
      }
    } else {
      _isProcessing = false;
    }
  }

  void _updateState() {
    _state = _state.copyWith(queuedMessages: _queue.items);
    notifyListeners();
  }
}
