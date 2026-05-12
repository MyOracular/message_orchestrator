I want to build a production-grade Flutter package for orchestrating in-app messages and overlays.

The package should support:
- Toasts
- Notification cards/banners
- Bottom sheets
- Alerts/dialogs
- Full-screen overlays (optional)

Core requirement:
This is NOT just a UI package. It is a message orchestration framework with persistence and display rules.

Main features:
1. Show only once until dismissed
2. Show once ever
3. Show once per session
4. Repeat after Duration()
5. Cooldown logic
6. Queue management
7. Priority-based display
8. Persistence using shared_preferences
9. Dismiss tracking
10. Impression tracking
11. Overlay deduplication
12. Centralized orchestration

Architecture requirements:
- Clean architecture
- Scalable
- Extensible
- Null-safe
- Flutter >= 3.x
- Dart >= 3.x

Suggested folder structure:

lib/
 ├── orchestrator/
 │    ├── message_controller.dart
 │    ├── message_queue.dart
 │    ├── message_rule.dart
 │    ├── message_state.dart
 │
 ├── widgets/
 │    ├── toast_widget.dart
 │    ├── banner_widget.dart
 │    ├── bottom_sheet_widget.dart
 │    ├── alert_widget.dart
 │
 ├── storage/
 │    ├── storage_adapter.dart
 │    ├── prefs_storage.dart
 │
 ├── models/
 │    ├── app_message.dart
 │    ├── dismiss_policy.dart
 │    ├── message_type.dart
 │
 ├── services/
 │    ├── overlay_service.dart
 │    ├── lifecycle_service.dart
 │
 └── flutter_message_orchestrator.dart

I want:
- Full package architecture
- Production-ready code
- Complete Dart implementation
- Example usage
- Queue system
- Overlay manager
- Persistent state manager
- Message eligibility engine
- Cooldown engine
- Rule evaluation engine
- Widget APIs
- Public APIs
- Extension methods if useful
- Riverpod-friendly design
- Minimal rebuilds
- Proper async handling
- Memory-safe overlay cleanup

Core APIs should look like this:

MessageOrchestrator.instance.register(
  AppMessage(
    id: "premium_offer",
    type: MessageType.bottomSheet,
    priority: 100,
    dismissPolicy: DismissPolicy.repeatAfterDuration,
    cooldown: Duration(days: 7),
    builder: (context) => PremiumOfferSheet(),
  ),
);

MessageOrchestrator.instance.show("premium_offer");

Need:
- Full implementation
- Best practices
- Avoid anti-patterns
- Proper overlay handling
- Prevent multiple simultaneous dialogs
- Prevent duplicate overlays
- Ensure queue consistency

Also provide:
- pubspec.yaml dependencies
- package export structure
- example app
- README draft
- testing strategy
- future extensibility ideas

The package should feel like a serious production-grade Flutter ecosystem package, not a demo.