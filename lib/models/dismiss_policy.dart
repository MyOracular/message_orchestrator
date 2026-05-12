enum DismissPolicy {
  /// Show only once ever, never again after it has been dismissed/viewed.
  showOnceEver,
  
  /// Show once per app session (resets on app restart).
  showOncePerSession,
  
  /// Repeat the message after a certain duration has passed since last view.
  repeatAfterDuration,
  
  /// Always show whenever requested (subject to cooldowns).
  alwaysShow,
}
