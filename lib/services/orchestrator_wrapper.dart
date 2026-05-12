import 'dart:async';
import 'package:flutter/material.dart';
import '../models/app_message.dart';
import '../models/message_type.dart';
import '../orchestrator/message_controller.dart';

/// A wrapper widget that listens to the MessageOrchestrator
/// and handles the physical displaying of messages in the app.
/// Place this high up in your widget tree (e.g., wrapping MaterialApp's builder or home).
///
/// When placed in `MaterialApp.builder` (or `ShadcnApp.router`'s builder), the
/// context is above the Navigator, so `showModalBottomSheet` / `showDialog` will
/// fail. Supply [navigatorKey] (e.g. your router's `navigatorKey`) so that the
/// wrapper can obtain a valid below-Navigator context at display time.
class OrchestratorWrapper extends StatefulWidget {
  final Widget child;

  /// Optional navigator key. When provided, its [GlobalKey.currentContext] is
  /// used for presenting modals instead of the wrapper's own context, which
  /// may be above the Navigator in the widget tree.
  final GlobalKey<NavigatorState>? navigatorKey;

  const OrchestratorWrapper({
    super.key,
    required this.child,
    this.navigatorKey,
  });

  @override
  State<OrchestratorWrapper> createState() => _OrchestratorWrapperState();
}

class _OrchestratorWrapperState extends State<OrchestratorWrapper> {
  @override
  void initState() {
    super.initState();
    // Provide the display handler to the orchestrator
    MessageOrchestrator.instance.displayHandler = _handleDisplayMessage;
  }

  Future<void> _handleDisplayMessage(AppMessage message) async {
    // This callback is executed when a message needs to be shown.
    if (!mounted) return;

    // Prefer the navigatorKey's context so this works when the wrapper is
    // placed above the Navigator in the widget tree (e.g. in app builder).
    final context = widget.navigatorKey?.currentContext ?? this.context;

    try {
      switch (message.type) {
        case MessageType.alert:
          await showDialog(
            context: context,
            barrierDismissible:
                false, // Ensure they interact with it if required, or handle via widget
            builder: (ctx) => message.builder(ctx),
          );
          break;

        case MessageType.bottomSheet:
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (ctx) => message.builder(ctx),
          );
          break;

        case MessageType.toast:
        case MessageType.banner:
          // For Toasts and Banners, we can use ScaffoldMessenger
          // To ensure this works globally, we might need a GlobalKey<ScaffoldMessengerState>
          // or rely on the local context if inside a Scaffold.
          // For a true global approach without context, Overlay is better.
          await _showOverlay(context, message);
          break;

        case MessageType.fullScreenOverlay:
          await showGeneralDialog(
            context: context,
            pageBuilder: (ctx, anim1, anim2) => message.builder(ctx),
          );
          break;
      }
    } finally {
      // Notify orchestrator that it was dismissed
      MessageOrchestrator.instance.onMessageDismissed(message.id);
    }
  }

  Future<void> _showOverlay(BuildContext context, AppMessage message) async {
    final overlayState = Overlay.of(context);
    late OverlayEntry entry;
    final completer = Completer<void>();

    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: message.type == MessageType.banner ? 50 : null,
          bottom: message.type == MessageType.toast ? 50 : null,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: message.builder(context),
          ),
        );
      },
    );

    overlayState.insert(entry);

    // Auto dismiss for toasts/banners after some time, or let the widget call dismiss.
    // For simplicity in this base package, we'll auto dismiss after 3 seconds,
    // though a real robust package would let the widget handle its own dismiss.
    Future.delayed(const Duration(seconds: 4), () {
      if (entry.mounted) {
        entry.remove();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
