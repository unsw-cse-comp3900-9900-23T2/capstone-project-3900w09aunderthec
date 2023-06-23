# capstone-project-3900w09aunderthec
Event management system featuring a flutter frontend app and dotnet backend api

## Flutter Setup Windows
The downloads are huge and installation could take a while

- Download flutter and follow installation instructions from https://docs.flutter.dev/get-started/install
    - Extract flutter to C:\src\flutter
    - Set windows environment variable
- Download and install Android Studio from https://developer.android.com/studio
    - Open Android Studio -> SDK Manager -> SDK Tools -> Check Android SDK Command-line Tools
    - From terminal run flutter doctor --android-licenses and accept all licenses
    - To run a virtual device install Intel HAXM, might need to change BIOS Settings to enable CPU Virtualisation
        - If you are having trouble, disable Hyper V too
- Install flutter/dart plugin in VS Code

## Running Flutter
CD into the under_the_c_app folder and run the command flutter run --enable-software-rendering