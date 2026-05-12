# Flutter Message Orchestrator Documentation

Please see the root `README.md` for an overview, or `examples.md` for specific implementations.

This directory is intended for extended documentation such as architectural diagrams, advanced rule evaluations, and custom integrations.

## Core Concepts

- `MessageOrchestrator`: The central controller.
- `AppMessage`: Represents the message intent, priority, rules, and UI builder.
- `DismissPolicy`: Dictates whether a message can be shown again (ever, per session, or after a duration).
- `StorageAdapter`: An interface for persisting message display history. `PrefsStorage` is provided by default.
