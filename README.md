# RTW CLI Tool

The `rtw` CLI tool is a Dart-based utility for generating boilerplate code for Flutter projects. It supports generating widgets, services, repositories, and API endpoints, following SOLID principles and a modular directory structure.

## Installation

To use the RTW CLI, activate it globally from the public GitHub repository:

```
dart pub global activate --source git https://github.com/Aashish-Dahal/rtw_cli.git
```

This makes the `rtw` command available on your system.

## Directory Structure

```
rtw_cli/
├── 📁 bin/
│   └── 📄 rtw.dart
├── 📁 lib/
│   ├── 📁 commands/
│   ├── 📁 subcommands/
│   ├── 📁 generators/
│   ├── 📁 models/
│   ├── 📁 services/
│   ├── 📁 utils/
├── 📄 main.dart
├─ 📄 rtw_cli.dart
└─📄 README.md
```

## Available Commands

The rtw CLI tool provides the following subcommands under the generate command. Run these commands from the project root using dart bin/rtw.dart.

### Generate Page

- Command:

  ```
  rtw generate page <name> [--type stateless|stateful] [--feature <feature_name>]
  ```

- Description: Generates a Flutter widget (either stateless or stateful) with the specified name and optional feature name.
- Example.
  ```
  rtw generate page user_profile --type stateless --feature user
  ```

### Generate Service

- Command:

  ```
  rtw generate service <name> [--feature <feature_name>]
  ```

- Description: Generates a service class with the specified name and optional feature name, and updates the dependency injector.
- Example.
  ```
  rtw generate service user_profile --feature user
  ```

### Generate Repository

- Command:

  ```
  rtw generate repository <name> [--feature <feature_name>]
  ```

- Description: Generates a repository class with the specified name and optional feature name, and updates the dependency injector.
- Example.
  ```
  rtw generate repository user_profile --feature user
  ```

### Generate Endpoint

- Command:

  ```
  rtw generate endpoint <name> [--feature <feature_name>]
  ```

- Description: Generates an API endpoint constant with the specified name and optional feature name, appending it to `api_endpoints.dart`.
- Example.
  ```
  rtw generate endpoint user_profile --feature user
  ```

### Generate All

- Command:

  ```
  rtw generate all <name> [--type stateless|stateful] [--feature <feature_name>]
  ```

- Description: Generates a widget, service, repository, and endpoint all at once with the specified name and optional feature name.
- Example.
  ```
  rtw generate all user_profile --type stateful --feature user
  ```

# Usage Notes

- Feature Option: The --feature option is optional and specifies the feature name for a modular structure (e.g., placing files in `lib/app/<feature_name>/`).

- Widget Type: The --type option applies only to the widget and all subcommands, allowing you to specify whether the widget should be stateless (default) or stateful.

- Error Handling: If no subcommand matches, or if the command structure is incorrect, the CLI will display usage information and exit with an error.
