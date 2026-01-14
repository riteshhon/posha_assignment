# Test Suite Documentation

This directory contains comprehensive unit and widget tests for the Posha recipe application.

## Test Structure

```
test/
├── unit/
│   ├── models/
│   │   └── recipe_model_test.dart          # Model serialization/deserialization tests
│   ├── repository/
│   │   └── recipe_repository_test.dart     # Repository/API service method tests
│   ├── bloc/
│   │   ├── recipe_list_bloc_test.dart      # Recipe list BLoC tests
│   │   └── favorites_bloc_test.dart        # Favorites BLoC tests
│   └── services/
│       └── favorites_service_test.dart     # Utility function tests
├── widget/
│   ├── recipe_card_test.dart               # Recipe card widget tests
│   ├── search_bar_test.dart                # Search bar widget tests
│   └── favorite_button_test.dart           # Favorite button widget tests
└── widget_test.dart                         # Main app widget test
```

## Running Tests

### Run All Tests

```bash
flutter test
```

## Coverage Goals

- Unit Test Coverage: > 80%
- Widget Test Coverage: > 70%
- Overall Coverage: > 75%
