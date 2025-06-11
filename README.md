# flutter_template_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Basic folder structure
<pre> 
```.
└── app/
    ├── .env/
    │   ├── development.env
    │   └── ...
    └── lib/
        ├── config/
        │   ├── constants/
        │   ├── router/
        │   ├── theme_config/
        │   └── environment/
        │       └── environment.dart
        ├── core/
        │   ├── data/
        │   │   ├── api_services/
        │   │   │   ├── auth_api_service.dart
        │   │   │   └── ...
        │   │   └── external_services/
        │   │       ├── geocoding/
        │   │       └── amplitude/
        │   ├── view/
        │   │   ├── authorized_view/
        │   │   │   └── home_page/
        │   │   │       ├── widgets/...
        │   │   │       ├── cubits/
        │   │   │       │   ├── home_page_cubit.dart
        │   │   │       │   └── ...
        │   │   │       ├── home_page.dart
        │   │   │       └── ...
        │   │   └── unauthorized_view/
        │   │       └── login_page/
        │   │           ├── widgets/...
        │   │           ├── cubits/...
        │   │           └── login_page.dart
        │   ├── l10n/
        │   │   ├── app_en.arb
        │   │   └── ...
        │   ├── shared/
        │   │   ├── cubits/
        │   │   ├── enums/
        │   │   ├── models/
        │   │   ├── services/
        │   │   ├── widgets/
        │   │   │   ├── buttons/
        │   │   │   ├── dropdowns/
        │   │   │   ├── input_fields/
        │   │   │   └── ...
        │   │   └── theme/
        │   │       ├── themes.dart
        │   │       ├── input_styles.dart
        │   │       └── ...
        │   └── utils/
        │       ├── api/
        │       │   ├── app_interceptor.dart
        │       │   └── api_response.dart
        │       ├── helpers/
        │       ├── toast_message.dart
        │       └── ...
        └── main.dart ``` </pre>

