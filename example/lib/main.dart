import 'package:flutter/material.dart';
import 'package:flutter_message_orchestrator/flutter_message_orchestrator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the orchestrator
  await MessageOrchestrator.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orchestrator Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Wrap the app to enable overlays/dialogs
      builder: (context, child) => OrchestratorWrapper(child: child!),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  void initState() {
    super.initState();
    _registerStartupMessages();
  }

  void _registerStartupMessages() {
    MessageOrchestrator.instance.registerAll([
      AppMessage(
        id: 'welcome_toast',
        type: MessageType.toast,
        priority: 10,
        dismissPolicy: DismissPolicy.showOncePerSession,
        builder: (context) => const BaseToastWidget(
          message: 'Welcome to the Orchestrator Demo!',
          icon: Icons.waving_hand,
        ),
      ),
      AppMessage(
        id: 'premium_offer',
        type: MessageType.bottomSheet,
        priority: 100, // Highest priority, shows first
        dismissPolicy: DismissPolicy.repeatAfterDuration,
        cooldown: const Duration(hours: 24),
        builder: (context) => BaseBottomSheetWidget(
          title: 'Premium Offer',
          content: 'Upgrade to Premium today to unlock all features! This sheet will only show once every 24 hours.',
          primaryButtonText: 'Upgrade Now',
        ),
      ),
    ]);
  }

  void _triggerAlert() {
    MessageOrchestrator.instance.register(
      AppMessage(
        id: 'manual_alert',
        type: MessageType.alert,
        dismissPolicy: DismissPolicy.alwaysShow, // Always show when tapped
        builder: (context) => const BaseAlertWidget(
          title: 'Manual Alert',
          message: 'You clicked the trigger button. This has lower priority than the premium offer if queued together.',
        ),
      )
    );
  }

  void _triggerBanner() {
    MessageOrchestrator.instance.register(
      AppMessage(
        id: 'promo_banner',
        type: MessageType.banner,
        dismissPolicy: DismissPolicy.showOnceEver,
        builder: (context) => BaseBannerWidget(
          title: 'One-Time Promo',
          message: 'This banner will only EVER be shown once per install!',
          onDismiss: () {
            // Because it's a generic widget we just trigger a rebuild or similar.
            // A more robust implementation would hook this directly.
          },
        ),
      )
    );
  }
  
  void _resetData() async {
    // Need access to storage. In a real app you'd expose a method on the orchestrator.
    // For now we'll just instantiate the default storage to clear it.
    final storage = PrefsStorage();
    await storage.clearAll();
    
    MessageOrchestrator.instance.register(
      AppMessage(
        id: 'reset_toast',
        type: MessageType.toast,
        builder: (context) => const BaseToastWidget(message: 'Storage cleared! Restart app to see session messages.'),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orchestrator Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _triggerAlert,
              child: const Text('Queue Alert (Always)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _triggerBanner,
              child: const Text('Queue Banner (Once Ever)'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _resetData,
              child: const Text('Clear Storage Data'),
            ),
          ],
        ),
      ),
    );
  }
}
