# Pooler Flutter 
![img][pooler_logo]
Unofficial Pooler Flutter SDK

[![style: flutterlints][flutter_lints_badge]][flutter_lints] [![License: MIT][license_badge]][license_link]

## Introduction

`PoolerCheckoutView` is a Flutter widget designed to facilitate the integration of Pooler payment services into your mobile applications. This widget streamlines the checkout process by providing a pre-built UI for payment transactions.

## Installation

To use `PoolerCheckoutView` in your Flutter project, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  pooler_flutter: ^1.0.0 # Replace with the latest version
```

Then run:

```bash
flutter pub get
```

## Usage

Import the package in your Dart file:

```dart
import 'package:pooler_flutter/pooler_flutter.dart';
```

### Example

```dart
await PoolerCheckoutView(
  config: PoolerConfig(
    publicKey: "pb_test_40291a0c6bbc66f64875de067c8fb05b4c5c2c544cd3af9ee730ba947407df21",
    amount: 400,
    transactionReference: "73f03de5-1043-${Random().nextInt(100000000)}",
    redirectLink: 'https://google.com',
    email: 'anita@gmail.com',
  ),
  showLogs: true,
  onClosed: () {
    print('closed');
    Navigator.pop(context);
  },
  onSuccess: (v) {
    print(v.toString());
    Navigator.pop(context);
  },
  onError: print,
).show(context);
```

### Parameters

- **config (required):** An instance of `PoolerConfig` containing the necessary information for the payment transaction.

- **showLogs (optional):** A boolean flag indicating whether to show logs during the checkout process. Default is `false`.

- **onClosed (optional):** A callback function that gets triggered when the checkout view is closed.

- **onSuccess (optional):** A callback function that gets triggered when the payment transaction is successful. It receives a dynamic parameter representing the success response.

- **onError (optional):** A callback function that gets triggered when an error occurs during the checkout process. It receives an error message as a parameter.

## Conclusion

With `PoolerCheckoutView`, you can easily integrate Pooler payments into your Flutter application, providing a seamless and secure payment experience for your users.

Make sure to replace the version number in the installation section with the latest version available. Additionally, always refer to the official documentation of the `pooler_flutter` package for any updates or changes.


Feel free to modify the formatting or content according to your specific needs.

[flutter_install_link]: https://docs.flutter.dev/get-started/install
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[pooler_logo]: https://res.cloudinary.com/woodcore/image/upload/v1691788847/assets/css/bootstrap/dist/js/poolerlogo_g05bg6.svg
[mason_link]: https://github.com/felangel/mason
[flutter_lints_badge]: https://img.shields.io/badge/style-flutter_lints-green
[flutter_lints]: https://pub.dev/packages/flutter_lints

