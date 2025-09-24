# Shopping List App

A simple and intuitive shopping list application built with Flutter. This app helps you keep track of the items you need to buy, organized by category.

## Features

*   **Add and Manage Items:** Easily add new items to your shopping list.
*   **Categorized Items:** Assign a category to each item (e.g., Dairy, Produce, Meat, etc.) for better organization.
*   **Intuitive UI:** A clean and user-friendly interface for a seamless experience.
*   **Cross-Platform:** Built with Flutter, this app can be compiled for mobile, web, and desktop from a single codebase.

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

You need to have the [Flutter SDK](https://flutter.dev/docs/get-started/install) installed on your system.

### Installation & Running

1.  **Clone the repository:**
    ```sh
    git clone <repository-url>
    cd shopping_list
    ```

2.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

3.  **Run the application:**
    ```sh
    flutter run
    ```
    Select the device or emulator you want to run the app on.

## Project Structure

The `lib` directory contains the core source code for the application, organized as follows:

```
lib/
├── data/
│   └── categories.dart     # Predefined static category data.
├── models/
│   ├── category.dart       # Data model for a Category.
│   └── grocery_item.dart   # Data model for a Grocery Item.
├── widgets/
│   ├── new_item.dart       # Widget for adding a new grocery item.
│   └── shopping_list.dart  # The main widget that displays the list of items.
└── main.dart               # The main entry point of the application.
```

## Dependencies

*   [flutter/material.dart](https://api.flutter.dev/flutter/material/material-library.html): The core Flutter framework library for building Material Design apps.

---

This is a simple project, perfect for beginners learning Flutter. Feel free to fork, modify, and experiment with it.
