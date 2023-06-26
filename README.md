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

## MySQL Setup Windows
 - Download MySQL Installer
 - Use the Installer to download MySQL Server, MySQL Workbench, and Connector/NET, all most recent releases.
 - Run MySQL Workbench. On the Welcome page there should be an entry under MySQL Connections called Local instance.
    - Click on the local instance, and it should ask you to set a root password. Make it >>   mysql123456
    - Once you are logged into the Local instance, up the top of the screen there is a cylinder looking button.
    - Click on the cylinder to add a new Schema. Call it >>   underthec
- The database is instantiated. Go to a powershell terminal and CD into the \EventManagementAPI\ folder

 - Run:
 -  dotnet tool install --global dotnet-ef
 -  dotnet ef migrations add InitialCreate
 -  dotnet ef database update

 - You should be good to go.

 - When the database is changed in future code updates, or if you want to clean it out:
    - Visit the underthec schema in MySQL Workbench and drop every table
    - Delete the EventManagementAPI/Migrations folder in the project directory
    - Then, run the last two lines of code above.