# White-Label Finance App

A Flutter white-label demo application that generates branded versions for different clients (tenants) from a single codebase. Each tenant has its own app name, colors, launcher icon, splash screen, and package name.

## Architecture

```
Tenant config (Firestore) ──> trigger_builds.sh ──> Codemagic API
                                                         │
Tenant assets (Firebase Storage) ──> set_tenant_branding.sh <───┘
                                          │
                                    ┌─────┴─────┐
                              flutter_launcher   flutter_native
                              _icons:create      _splash:create
                                    │                 │
                                    └────────┬────────┘
                                        fvm flutter build
                                             │
                                      Branded APK/AAB
```

### Three layers:
1. **Firebase Firestore** - tenant configuration (name, colors, package, API URL)
2. **Firebase Storage** - tenant assets (logo, app icon, splash logo)
3. **TenantConfig singleton** - reads dart-defines at compile time and provides values to the theme system

## Prerequisites

- Flutter SDK (using FVM - Flutter Version Manager)
- `jq` (for JSON parsing in shell scripts): `brew install jq`
- Codemagic account with a configured project
- Firebase project with Firestore and Storage enabled

## Local Development

### 1. Install dependencies

```bash
fvm flutter pub get
```

### 2. Run the app

Each tenant has its own `.env` file in the `.env/` folder:

```bash
# WhiteBank (green theme)
fvm flutter run --dart-define-from-file=.env/whitebank.env

# BluBank (blue theme)
fvm flutter run --dart-define-from-file=.env/blubank.env

# RedBank (red theme)
fvm flutter run --dart-define-from-file=.env/redbank.env

# YellowBank (yellow theme)
fvm flutter run --dart-define-from-file=.env/yellowbank.env
```

Or use the **VS Code Run & Debug** panel - all tenants are configured in `.vscode/launch.json`.

### 3. Env file structure

```env
ENVIRONMENT=DEVELOPMENT
SERVER_ADDRESS=https://api.whitebank.example.com
TENANT_ID=whitebank
APP_NAME=White Bank
PRIMARY_COLOR=FF1B5E20
ACCENT_COLOR=FFFFD600
ERROR_COLOR=FFEB2E25
PACKAGE_NAME=com.bokidev.whitebank
```

## Deployment (Codemagic CI/CD)

### 1. Set up credentials

Create `.env.local` in the project root (already in .gitignore):

```env
CM_API_TOKEN="your-codemagic-api-token"
CM_APP_ID="your-codemagic-app-id"
```

- **CM_API_TOKEN**: Codemagic > Settings > Integrations > Codemagic API > Show
- **CM_APP_ID**: From the project URL on Codemagic: `codemagic.io/app/THIS_PART/...`

### 2. Trigger a build

```bash
# Build a single tenant
./scripts/trigger_builds.sh whitebank

# Build multiple tenants
./scripts/trigger_builds.sh whitebank blubank redbank

# Build all tenants
./scripts/trigger_builds.sh --all

# List available tenants
./scripts/trigger_builds.sh
```

The script reads tenant configuration from Firebase Firestore and triggers a build on Codemagic. If Firestore is unavailable, build will fail.

### 3. What happens during a build

1. `fvm flutter pub get` - install dependencies
2. `fvm flutter analyze` - lint check
3. `set_tenant_branding.sh` - downloads assets from Firebase Storage and:
   - Updates app name in AndroidManifest.xml and Info.plist
   - Generates launcher icons (`flutter_launcher_icons`)
   - Generates native splash screen (`flutter_native_splash`)
   - Updates iOS bundle identifier
4. Generates `.env/tenant.env` from environment variables
5. `fvm flutter build apk` with `--dart-define-from-file=.env/tenant.env`

## Firebase Setup

### Firestore structure

Collection `tenants`, one document per tenant:

```
tenants/
  whitebank/
    APP_NAME: "White Bank"
    PACKAGE_NAME: "com.bokidev.whitebank"
    SERVER_ADDRESS: "https://api.whitebank.example.com"
    PRIMARY_COLOR: "FF1B5E20"
    ACCENT_COLOR: "FFFFD600"
    ERROR_COLOR: "FFEB2E25"
```

### Storage structure

```
tenants/
  whitebank/
    logo.svg              # Runtime logo (displayed in the app)
    app_icon.png          # 1024x1024 PNG for launcher icon
    splash_logo.png       # 1152x1152 PNG for splash screen
  blubank/
    ...
```

## Adding a New Tenant

1. **Firestore**: Add a new document to the `tenants` collection with all required fields
2. **Storage**: Upload `logo.svg`, `app_icon.png` (1024x1024) and `splash_logo.png` (1152x1152)
3. **Local dev**: Create `.env/{tenant}.env` and add configuration to `.vscode/launch.json`
4. **pubspec.yaml**: Add `- assets/tenants/{tenant}/` to the assets section
5. **Build**: Run `./scripts/trigger_builds.sh {tenant}`

## Project Structure

```
.
├── .env/                          # Tenant env files (local dev)
│   ├── whitebank.env
│   ├── blubank.env
│   ├── redbank.env
│   └── yellowbank.env
├── .env.local                     # Codemagic API credentials (gitignored)
├── assets/
|   └── tenants/                    # Tenant assets (local dev)
|       ├── whitebank/
        |       logo.svg              # Runtime logo (displayed in the app)
                app_icon.png          # 1024x1024 PNG for launcher icon
                splash_logo.png       # 1152x1152 PNG for splash screen
|       └── blubank/
│   ├── whitebank/logo.svg
│   └── blubank/logo.svg
├── scripts/
│   ├── trigger_builds.sh          # Triggers Codemagic builds via API
│   └── set_tenant_branding.sh     # Patches native files on CI
├── codemagic.yaml                 # CI/CD workflow configuration
├── lib/
│   ├── config/tenant/
│   │   └── tenant_config.dart     # Singleton - reads dart-defines
│   ├── theme/
│   │   ├── theme_color.dart       # Brand colors from TenantConfig
│   │   └── themes.dart            # Light/dark themes with tenant colors
│   └── ...
└── android/app/build.gradle       # Dynamic applicationId from env variable
```

## Useful Commands

```bash
fvm flutter pub get                     # Install dependencies
fvm flutter analyze                     # Lint check
fvm flutter test                        # Run tests
fvm flutter build apk --release \       # Manual release build
  --dart-define-from-file=.env/whitebank.env
```

## Basic folder structure
<pre>
.
└── app/
    ├── .env/
    │   ├── whitebank.env
    │   ├── blubank.env
    │   ├── redbank.env
    │   └── yellowbank.env
    │   └── ...
    ├── .env.local                     # Codemagic API credentials (gitignored)
    ├── scripts/
    │   ├── trigger_builds.sh          # Triggers Codemagic builds via API
    │   └── set_tenant_branding.sh     # Patches native files on CI
    ├── codemagic.yaml                 # CI/CD workflow configuration
    └── lib/
        ├── config/
        │   ├── constants/
        │   ├── router/
        │   ├── theme_config/
        │   └── tenant/
        │       └── tenant_config.dart
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
