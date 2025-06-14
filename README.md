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
.
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
        │   ├── external_services/
        │   │   ├── geocoding/
        │   │   └── amplitude/
        │   ├── features/
        │   │   ├── home_page/
        │   │   │   ├── view/
        │   │   │   │   └── home_page/
        │   │   │   │       ├── widgets/...
        │   │   │   │       └── home_page.dart
        │   │   │   ├── api_services/
        │   │   │   │   └── ....
        │   │   │   ├── models/
        │   │   │   │   └── ...
        │   │   │   └── cubits/
        │   │   │       └── ...
        │   │   └── authentication/
        │   │       ├── view/
        │   │       │   └── login_page/
        │   │       │       ├── widgets/... 
        │   │       │       └── login_page.dart
        │   │       ├── api_services/
        │   │       │   └── auth_api_service.dart
        │   │       ├── models/
        │   │       │   ├── login_response.dart
        │   │       │   └── login_request.dart
        │   │       └── cubits/
        │   │           ├── auth_cubit/
        │   │           └── login_page_cubit/
        │   ├── l10n(ovo su prevodi)/
        │   │   ├── app_en.arb
        │   │   └── ...
        │   ├── shared/
        │   │   ├── cubits/
        │   │   ├── enums/
        │   │   ├── models/
        │   │   ├── services/
        │   │   │   └── api_services/
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
        └── main.dart
</pre>

