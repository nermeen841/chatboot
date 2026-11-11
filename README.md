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
    config/
      config.dart                  # Reads flavor and compile-time API settings
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

Android and iOS have `staging` and `production` flavors. Each flavor has its
own application ID/bundle ID so both apps can be installed side by side.
Staging is labeled "Chatboot (Staging)" on Android and "Chatboot Staging" on
iOS; production is labeled "Chatboot". Without a flavor, the app uses the
`development` environment.

Pass the API key as a compile-time define when running or building. Replace
`YOUR_API_KEY` with your Gemini API key:

```powershell
flutter run --flavor staging --dart-define="GEMINI_API_KEY=YOUR_API_KEY"
flutter run --flavor production --dart-define="GEMINI_API_KEY=YOUR_API_KEY"
```

Build Android APKs:

```powershell
flutter build apk --flavor staging --dart-define="GEMINI_API_KEY=YOUR_API_KEY"
flutter build apk --flavor production --dart-define="GEMINI_API_KEY=YOUR_API_KEY"
```

On macOS with Xcode installed, the iOS flavors are available as shared
`staging` and `production` schemes. Run or build an IPA using the same Flutter
commands, for example:

```powershell
flutter run --flavor staging --dart-define="GEMINI_API_KEY=YOUR_API_KEY"
flutter build ipa --flavor production --dart-define="GEMINI_API_KEY=YOUR_API_KEY"
```

`Config` reads `GEMINI_API_KEY` and the optional `GEMINI_BASE_URL` compile-time
defines. If the key is missing or blank, the app displays a configuration
message. All flavors use
`https://generativelanguage.googleapis.com/v1beta/` by default; override it
when needed with `--dart-define="GEMINI_BASE_URL=https://your-api.example/"`.

**Security:** Values passed with `--dart-define` are bundled into the app and
can be extracted. Do not ship a private API key in a production app; keep it on
a backend and have the app call that backend. Use only restricted,
replaceable keys for local development, and revoke any key that has been
shared publicly.

## Validate

Run static analysis and all tests:

```powershell
flutter analyze
flutter test
```

Tests cover the API client, Interactions request/response handling, dependency
wiring, chat conversation behavior, Cubit states, and chat UI.

## CI

GitHub Actions runs on pull requests and pushes to `main`. The Android job
installs dependencies, runs analysis and tests, then builds debug APKs for both
flavors. The iOS job builds simulator apps for both flavors on macOS.

To create signed iOS IPAs, configure the following in the GitHub repository
settings under **Settings > Secrets and variables > Actions**:

- Variable `IOS_TEAM_ID`: your Apple Developer Team ID.
- Secret `IOS_CERTIFICATE_BASE64`: base64-encoded Apple Distribution `.p12`.
- Secret `IOS_CERTIFICATE_PASSWORD`: password for that `.p12`.
- Secrets `IOS_STAGING_PROFILE_BASE64` and `IOS_PRODUCTION_PROFILE_BASE64`:
  base64-encoded App Store provisioning profiles matching the iOS flavor bundle
  IDs (`com.example.chatboot.staging` and `com.example.chatboot.production`).
- Optional secret `GEMINI_API_KEY`: included in the app at build time. Any key
  embedded in a mobile app can be extracted; a backend is recommended instead.

Then open **Actions > CI > Run workflow** and run it from `main`.
The `Sign iOS IPAs` job builds both flavors and uploads
`chatboot-staging.ipa` and `chatboot-production.ipa` as the
`ios-ipas-<run number>` artifact for 14 days. The workflow does not upload to
TestFlight or the App Store. iOS signing is only configured for this release
job; routine CI builds do not need signing credentials.
