# StudBud

En app for å hjelpe studenter med å finne nye venner, både i og utenfor studiene.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What you need to install the software
```
General
  Flutter SDK: https://flutter.dev/docs/get-started/install
  IDE (I used Visual Studio Code)
  Flutter & Dart extensions in IDE

Android
  Android Studio: https://developer.android.com/studio
  Flutter & Dart extensions in android Studio.
  Android SDK(Can download from Android studio)
  If using android device: Google USB drivers(Can download from Android studio) and Android device with USB debugging enabled
  If using android emulator: Android Emulator(Can download from Android studio) 

iOS
  iPhone Emulator
```

### Installing

A step by step instruction on how to install and run the app

```
Open project folder in your IDE(This readme is based on Visual Studio Code)
Install flutter and dart extensions to VS Code

Open pubspec.yaml file

If on iOS make sure these lines are correct:
  cloud_firestore: 0.8.2+3 should be commented out like this #cloud_firestore: 0.8.2+3

  cloud_firestore:
      git:
     url: git://github.com/koyachi/flutter_plugins.git
      ref: temporary-fix/specify-firestore-5.1.0
       path: packages/cloud_firestore
  These lines should NOT be commented out
  
If on android do the opposite of this

SAVE FILE

Top navigation bar > Debug > Start Without Debugging
Choose Flutter & Dart if prompted
If using emulator, choose emulated device
Wait

//ONLY FOR ANDROID
After a short amount of time you will probably get alot of errors
Open Android Studio
Open only the android folder from the project folder(don't open the project folder)
Top navigation bar > Refactor > Migrate to AndroidX
If it succeeds try to build project again
If that succeeds try to run project in VS code
If it still fails, open android studio again
Try to build project
When building, there is a navigation meny in the bottom left, click it
Here you will see the errors
Double click errors
Migrate these lines to AndroidX manually with help from this sheet:
https://developer.android.com/jetpack/androidx/migrate

build and repeat this until all errors are gone.

Try to run in VS Code again
```
