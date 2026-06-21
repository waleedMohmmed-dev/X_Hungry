# 🍔 Hungry App

A Flutter food delivery application with a clean architecture, BLoC state management, and a rich set of features for browsing products, customizing orders, managing a cart, and tracking favorites.

## 🚀 Features

- **Authentication** — Login, signup, auto-login, and guest mode
- **Home** — Browse products, search by name, filter by categories
- **Product Details** — Customize burgers with toppings, side options, and spice level
- **Cart** — Add/remove items, adjust quantities, view total price
- **Favorites** — Toggle favorites from anywhere, dedicated favorites tab
- **Checkout** — Order summary with payment method selection
- **Order History** — View past orders
- **Profile** — Edit name, email, address, upload avatar, manage VISA card

## 🏗️ Architecture

Clean Architecture with 3 layers:

```
lib/
├── core/                  # Shared infrastructure
│   ├── constants/
│   ├── extensions/
│   ├── imports/           # Barrel exports
│   ├── injection/         # GetIt DI registration
│   ├── network/           # Dio client, API service, error handling
│   ├── shared/widgets/    # Reusable UI components
│   ├── theme/             # AppColors, AppTheme
│   └── utils/             # PrefHelper (SharedPreferences)
├── features/
│   ├── auth/              # Login, signup, profile
│   ├── cart/              # Shopping cart
│   ├── checkout/          # Order checkout
│   ├── favorites/         # Product favorites
│   ├── home/              # Product listing, search
│   ├── orderHistory/      # Past orders
│   ├── products/          # Product details, toppings, options
│   └── profile/           # User profile management
└── main.dart              # App entry point
```

Each feature follows:

```
feature/
├── data/
│   ├── datasources/       # API calls
│   ├── models/            # JSON serialization
│   └── repositories/      # Repository implementations
├── domain/
│   ├── entities/          # Business objects
│   ├── repositories/      # Abstract interfaces
│   └── usecases/          # Business logic
└── presentation/
    ├── bloc/              # State management (BLoC)
    ├── pages/             # Screens
    └── widgets/           # Feature-specific widgets
```

## 🧰 Tech Stack

| Package | Purpose |
|---------|---------|
| `flutter_bloc` + `equatable` | State management |
| `get_it` | Dependency injection |
| `dartz` | Either type for error handling |
| `dio` | HTTP client |
| `flutter_screenutil` | Responsive sizing |
| `shared_preferences` | Local token storage |
| `skeletonizer` | Loading skeletons |
| `image_picker` | Profile avatar upload |
| `gap` | Spacing widgets |
| `pretty_dio_logger` | API request logging |

## 🚦 Getting Started

### Prerequisites

- Flutter SDK ^3.9.2
- An API backend (default: `https://sonic-zdi0.onrender.com/api`)

### Installation

```bash
git clone https://github.com/waleedMohmmed-dev/X_Hungry.git
cd hungry_app
flutter pub get
flutter run
```

### Build

```bash
# Android APK
flutter build apk

# iOS
flutter build ios
```

## 🌐 API

Base URL: `https://sonic-zdi0.onrender.com/api`

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/login` | POST | User login |
| `/register` | POST | User registration |
| `/profile` | GET | Get user profile |
| `/update-profile` | POST | Update profile |
| `/logout` | POST | Logout |
| `/products` | GET | List products |
| `/products?name=` | GET | Search products |
| `/toppings` | GET | Topping options |
| `/side-options` | GET | Side dish options |
| `/cart` | GET | Get cart contents |
| `/cart/add` | POST | Add item to cart |
| `/cart/remove/{id}` | DELETE | Remove cart item |
| `/favorites` | GET | Get user favorites |
| `/favorites` | POST | Toggle favorite |

Authentication is handled via Bearer token stored in SharedPreferences.
