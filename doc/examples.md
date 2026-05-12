# Examples

## Setup

Wrap your application in `OrchestratorWrapper` and initialize the orchestrator:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MessageOrchestrator.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => OrchestratorWrapper(child: child!),
      home: const MyHomePage(),
    );
  }
}
```

## Basic Toast

```dart
MessageOrchestrator.instance.register(
  AppMessage(
    id: 'basic_toast',
    type: MessageType.toast,
    dismissPolicy: DismissPolicy.alwaysShow,
    builder: (context) => const BaseToastWidget(message: 'Hello World!'),
  )
);
```

## Premium Offer (Once every 24 hours)

```dart
MessageOrchestrator.instance.register(
  AppMessage(
    id: 'premium_offer',
    type: MessageType.bottomSheet,
    priority: 100, // High priority
    dismissPolicy: DismissPolicy.repeatAfterDuration,
    cooldown: const Duration(hours: 24),
    builder: (context) => BaseBottomSheetWidget(
      title: 'Premium Offer',
      content: 'Upgrade today!',
      primaryButtonText: 'Upgrade',
    ),
  ),
);
```
