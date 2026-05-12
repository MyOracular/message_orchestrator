# Flutter Message Orchestrator

A production-grade Flutter package for orchestrating in-app messages, bottom sheets, alerts, toasts, and overlays with persistence, prioritization, and display rules.

This is NOT just a UI package. It is a complete orchestration framework that prevents multiple dialogs from stacking, controls cooldowns between messages, and limits impressions using intelligent policies.

## Features

- **Queue Management**: Safely queue messages. Only one is shown at a time.
- **Priority-based Display**: High priority messages jump to the front of the queue.
- **Display Rules (Dismiss Policy)**:
  - `showOnceEver`
  - `showOncePerSession`
  - `repeatAfterDuration`
  - `alwaysShow`
- **Cooldown Logic**: Prevent spamming users.
- **Agnostic State Management**: Pure Dart/ValueNotifier architecture, perfectly compatible with Riverpod or Provider.

## Getting Started

Check out the `/doc` folder for detailed documentation or the `/example` folder for a working Flutter app demonstrating the features.
