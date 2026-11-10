# Gemini Chat

A Flutter chat app that sends prompts to Google's Gemini Interactions API and
displays the conversation in a chat interface.

## Features

- Send messages to Gemini and display user and assistant messages.
- Continue a conversation using Gemini's previous interaction ID.
- Start a new chat to reset the conversation context.
- Show loading and request-error states.
- Offer suggested prompts on the welcome screen.

## Technologies

- **Flutter and Dart** for the cross-platform application and UI.
- **Material 3** for the application theme and widgets.
- **`http`** for JSON HTTP requests to the Gemini API.
- **`flutter_bloc` / Cubit** for chat presentation state and request handling.
- **Flutter Test** and **`flutter_lints`** for tests and static analysis.

## Architecture

The code is organized by feature and separates presentation, domain, and data
responsibilities:

```text
lib/
  core/
    di/
      app_dependencies.dart       # Builds and wires application dependencies
  features/
    chat/
      data/services/               # Gemini chat service and conversation context
      domain/
        entities/                  # Chat message entity
        services/                  # Chat service contract
      presentation/
        cubit/                     # ChatCubit and ChatState
        screens/                   # Chat screen and layout
        widgets/                   # Reusable chat UI components
    interactions/
      data/
        datasources/               # Gemini Interactions HTTP calls
        models/                    # API request and response models
        repositories/              # Interaction repository implementation
      domain/
        entities/                  # Interaction entities
        repositories/              # Repository contract
        usecases/                  # Create interaction use case
  services/
    api_client.dart                # Shared JSON HTTP client
```

`AppDependencies` is the composition root. It constructs and injects the API
client, remote data source, repository, use case, and Gemini chat service.
`ChatCubit` calls the chat service and exposes messages, loading status, and
errors to the UI. The UI is split into reusable widgets under
`features/chat/presentation/widgets`.

## Run locally

Install Flutter, then fetch packages:

```powershell
flutter pub get
```

Provide a Gemini API key at build time:

```powershell
flutter run --dart-define="GEMINI_API_KEY=YOUR_API_KEY"
```

The app reads the `GEMINI_API_KEY` compile-time variable. If it is missing, the
app displays a configuration message.

**Security:** A key passed with `--dart-define` is bundled into the application
and can be extracted. Use this only for local development with a restricted,
replaceable key. For production, keep the Gemini key on a backend and have the
app call that backend. Revoke any key that has been shared publicly.

## Validate

Run static analysis and all tests:

```powershell
flutter analyze
flutter test
```

Tests cover the API client, Interactions request/response handling, dependency
wiring, chat conversation behavior, Cubit states, and chat UI.
