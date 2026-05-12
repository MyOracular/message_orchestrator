import 'package:flutter/widgets.dart';
import 'message_type.dart';
import 'dismiss_policy.dart';

class AppMessage {
  /// Unique identifier for this message.
  final String id;
  
  /// The type of message (toast, banner, bottomSheet, alert, fullScreenOverlay).
  final MessageType type;
  
  /// Priority of the message (higher value = higher priority).
  final int priority;
  
  /// How the dismissal of this message affects future displays.
  final DismissPolicy dismissPolicy;
  
  /// The cooldown duration before this message can be shown again (if policy allows).
  final Duration? cooldown;
  
  /// The widget builder for this message.
  final WidgetBuilder builder;

  AppMessage({
    required this.id,
    required this.type,
    required this.builder,
    this.priority = 0,
    this.dismissPolicy = DismissPolicy.alwaysShow,
    this.cooldown,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppMessage &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
