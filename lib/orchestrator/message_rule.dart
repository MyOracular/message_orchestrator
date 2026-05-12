import '../models/app_message.dart';
import '../models/dismiss_policy.dart';
import '../storage/storage_adapter.dart';

class MessageRuleEvaluator {
  final StorageAdapter storage;
  
  // Tracks session-level show count
  final Set<String> _sessionShown = {};

  MessageRuleEvaluator(this.storage);

  /// Evaluate if a message should be shown based on rules.
  Future<bool> canShow(AppMessage message) async {
    final hasShown = await storage.hasBeenShown(message.id);
    
    switch (message.dismissPolicy) {
      case DismissPolicy.showOnceEver:
        if (hasShown) return false;
        break;
        
      case DismissPolicy.showOncePerSession:
        if (_sessionShown.contains(message.id)) return false;
        break;
        
      case DismissPolicy.repeatAfterDuration:
        if (message.cooldown != null) {
          final lastShown = await storage.getLastShownTime(message.id);
          if (lastShown != null) {
            final now = DateTime.now();
            if (now.difference(lastShown) < message.cooldown!) {
              return false; // Still in cooldown
            }
          }
        }
        break;
        
      case DismissPolicy.alwaysShow:
        // Always allowed, subject to cooldown if specified.
        if (message.cooldown != null) {
          final lastShown = await storage.getLastShownTime(message.id);
          if (lastShown != null) {
            final now = DateTime.now();
            if (now.difference(lastShown) < message.cooldown!) {
              return false; // Still in cooldown
            }
          }
        }
        break;
    }
    
    return true;
  }

  /// Mark a message as shown, updating storage and session state.
  Future<void> markShown(AppMessage message) async {
    await storage.markAsShown(message.id);
    await storage.setLastShownTime(message.id, DateTime.now());
    _sessionShown.add(message.id);
  }
}
