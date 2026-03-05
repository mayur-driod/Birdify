# Birdify

A Flutter mobile app for bird identification and education, built in a single day as a personal challenge to learn Flutter fast.

Snap a photo of a bird, get an AI-powered identification with species info and conservation status, chat with "Birdy" (an AI ornithologist), and log your sightings — all in one place.

---

## Features

### Bird Identification
- Upload a photo from your camera or gallery
- Powered by **Google Gemini 2.5 Flash** (Vision)
- Returns common name, scientific name, physical description, habitat, fun facts, and IUCN conservation status
- Save identified birds to your personal observation log

### AI Chat — "Birdy"
- Conversational AI chatbot with an expert ornithologist persona
- Multi-turn chat with full message history
- Voice-to-text input support
- Suggested conversation starters
- Markdown-rendered responses

### Observation Log
- Save bird sightings with photo, date/time, and species metadata
- Swipe to delete entries
- In-memory session storage (fast, no database overhead)

### Learn
- Curated educational articles on bird habitats, diets, behaviors, and conservation
- Organized by category (Forests, Wetlands, Urban Areas, Insectivores, Seed Eaters, and more)

### Settings & Appearance
- Light / Dark mode toggle (Material 3, green seed color)
- App version and model info

---

## Tech Stack

| Category | Technology |
|---|---|
| Framework | Flutter (SDK ^3.11.0) |
| Language | Dart |
| UI | Material Design 3 |
| State Management | BLoC (`bloc` + `flutter_bloc`) |
| AI / Vision | Google Gemini 2.5 Flash API |
| HTTP | `http` |
| Image Picker | `image_picker` |
| Voice Input | `speech_to_text` |
| Markdown | `flutter_markdown_plus` |
| Environment | `flutter_dotenv` |
| Date Formatting | `intl` |

---

## Project Structure

```
lib/
├── main.dart                      # Entry point, bottom navigation shell
├── bloc/
│   ├── chatbloc_bloc.dart         # Chat BLoC logic
│   ├── chatbloc_event.dart        # Events: SendMessage, ClearChat
│   └── chatbloc_state.dart        # States: Initial, Loading, Loaded, Error
├── models/
│   ├── chat_message.dart          # ChatMessage model
│   └── observation.dart           # Observation model
├── pages/
│   ├── home_page.dart             # Bird identification screen
│   ├── chat_page.dart             # AI chatbot screen
│   ├── observations_page.dart     # Saved sightings log
│   ├── learn_page.dart            # Educational content
│   ├── about_page.dart            # Developer portfolio
│   └── settings_page.dart         # Theme and app info
└── repos/
    ├── gemini_service.dart         # Gemini API integration
    └── observations_service.dart   # In-memory observations store
```

---

## Getting Started

### Prerequisites

- Flutter SDK ^3.11.0
- A Google Gemini API key — get one at [aistudio.google.com](https://aistudio.google.com/app/apikey)

### Setup

1. Clone the repo:
   ```bash
   git clone https://github.com/mayur-driod/birdify.git
   cd birdify
   ```

2. Create a `.env` file in the project root:
   ```
   GEMINI_API_KEY=your_google_gemini_api_key_here
   ```
   Use `.env.example` as a reference.

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

---

## Architecture

State is managed with the **BLoC pattern** for the chat feature:

```
ChatblocBloc
├── Events:  SendMessageEvent(message), ClearChatEvent()
└── States:  ChatblocInitial, ChatLoading, ChatLoaded, ChatError
```

Observations use a lightweight `ValueNotifier` reactive store — no database, session-only, instant updates via `ValueListenableBuilder`.

---

## Background

Built in **24 hours** as a self-imposed challenge to learn Flutter from scratch. Developed with help from Microsoft Copilot and a week of prior tutorial study. Part of a mobile dev track that required Flutter.

---

## Author

**Mayur K Setty**

---

## License

This project is open source. See [LICENSE](LICENSE) for details.
