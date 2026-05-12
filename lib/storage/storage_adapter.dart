abstract class StorageAdapter {
  Future<void> init();
  
  /// Get the last time a message was shown.
  Future<DateTime?> getLastShownTime(String messageId);
  
  /// Set the last time a message was shown.
  Future<void> setLastShownTime(String messageId, DateTime time);
  
  /// Get whether a message has ever been shown.
  Future<bool> hasBeenShown(String messageId);
  
  /// Mark a message as shown.
  Future<void> markAsShown(String messageId);
  
  /// Clear data for a specific message (useful for testing/resetting).
  Future<void> clearMessageData(String messageId);
  
  /// Clear all orchestration data.
  Future<void> clearAll();
}
