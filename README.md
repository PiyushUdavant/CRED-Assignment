# CRED Application - Bill Cards Stacked Widget

A Flutter application that displays bills with carousel auto-scroll and smooth animations using Clean Architecture and BLoC pattern. 

## Overview

The app fetches bills data from the REST APIs provided and then displays them with an interactive carousel. 
Features : 
-> Carousel View with Deck-style placeholder
-> State Management using BLoC pattern
-> Error handling with retry functionality
-> Toggle between two mock endpoints (Mock1/Mock2)

## Architecture

The application follows **Clean Architecture** with three layers : 

1. Presentation Layer (UI, Widgets, BLoC)
2. Domain Layer (Use Cases, Repository, Interfaces)
3. Data Layer (Repository, Data Sources, Models)

**State Management** : BLoC pattern has been used reactive UI updates with clear separation of business logic.

## Tech Stack : 
`flutter_bloc` : State Management
`equatable` : Value Equality
`http` : HTTP Client
`cached_network_image` : Image Caching
`google_fonts` : Typography

**Testing**: `mockito`, `bloc_test`, `build_runner`

## Project Structure

```
lib/
├── core/              # Constants, colors, text styles
├── data/              # Data sources, models, repository impl
├── domain/            # Use cases, repository interfaces
└── presentation/      # BLoC, screens, widgets

test/                  # Mirrors lib structure
```

## Architecture Decisions
1. **Clean Architecture** : Layer separataion for testability and maintainabilty.
2. **BLoC Pattern**: Unidirectional data flow, testable state management
3. **Repository Pattern**: Abstraction for flexible data sources
4. **Use Cases**: Single responsibility business logic
5. **Error Handling**: Centralized in BLoC with user-friendly states

## Testing Strategy
1. **Unit Tests** : API data source, model parsing, BLoC state transitions
2. **Widget Tests** : Screen rendering for loading or success or error states

**Test Files:**
1. `test/data/datasources/bills_remote_datasource_test.dart` - API & parsing
2. `test/data/models/bill_section_model_test.dart` - Model validation
3. `test/presentation/bloc/bills_bloc_test.dart` - State management
4. `test/presentation/screens/bills_page_test.dart` - UI rendering

**Testing Tools**: `flutter_test`, `mockito`, `bloc_test`, `build_runner`

**Endpoints**: Configured in `lib/core/strings.dart` (mock1Endpoint, mock2Endpoint)

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
