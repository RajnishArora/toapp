# webtoapp

Website to App 

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

In terminal
1. go to home dir c:/xampp/htdocs/try_rest_api
2. run php –S 0.0.0.0:3000
(& let it run )

Use ipconfig or ifconfig(mac) to get your ip4 address which is the baseIp

Choose the name for app
& Choose the name for application Id. Application Id must be of the for
com.rajnisharora.webtoapp
(the first to words can be your website name & the third name can be your app name , not compulsory but has to be unique for both playstore & appstore)

Change the app name & applicationId
Open Android Studio
Towards the bottom find Terminal . Click it. It would show the path of your project directory.
Type
1. flutter pub global activate rename
Press Enter & Wait for a few seconds & let it run
2. flutter pub global run rename --bundleId com.yourwebsite.yourappname
(Replace yourwebsite with any name of your site & replace yourappname with name you wish to keep as app-name)
  3. flutter pub global run rename --aapname com.yourwebsite.yourappname  ( replace yourappname with name you wish to keep as app-name)

To change app Package name
Use rename
Flutter pub global activate rename

Flutter pub global run rename --bundleId com.onatcipli.networkUpp
Flutter pub global run rename --appname "Network Upp"



Change App Launcher Name
By default, the name on the launcher is your Flutter project name. To change the name displayed on Android or iOS application launcher, you need to change AndroidManifest.xml and Info.plist respectively.
Inside AndroidManifest.xml, find <application> tag. Change its android:label property with your desired app name.
android/app/src/main/AndroidManifest.xml
	<application
	android:name="io.flutter.app.FlutterApplication"
	android:label="Woolha App"
	android:icon="@mipmap/launcher_icon">
Inside Info.plist, find CFBundleName key and change its value which is inside string tag on the next line.
ios/Runner/Info.plist
	<key>CFBundleName</key>
	<string>Woolha App</string>


Firebase Notifications

The app is made as such to receive the notification. But you will have to send it through firebase. To do so do the following
1. Create a google account if not available already. Please note that if u have a gmail account it is your google account also.
2. Create an account in firebase console using the google account and your
     application id.

          Google for firebase console & Open it
	Click on Add Project
	Write the project name ( Any unique name) & click next
	Choose Analytics ,if you want & provide your account name(gmail id)
	Click create project
	It takes sometime for the project to be created .
	Check if the project is opened. You would see the project name in top
            towards left side
	Choose Android or Ios & Click on add firebase to your app
	Enter the application id ( which you kept at top of the top
          com.something.something) & app name & click next
	Download the json file. & move it to the dir as specified in the image at
           site
           No need to add lines to files build.gradle as they already are added
	Click Sync & wait for sometime for firebase to sync with your project



3.You can send messages from the configuration utility provided or firebase console itself

4. To send it from firebase console
a. Click Grow in the dashboard’s left column and select Cloud Messaging
b. Click on create your first message(or new notification , next time)
    1. Enter Notification Title
    2. Enter Notification Text

For sending images you have to choose the Blaze plan(not Free) of Firebase
Click Next, You reach Target , Select the App on left Column & on Right Select Your application Id

 Click Next & choose Schedule Now,
Don’t Change optional 4 & 5th points ,just click on Next
Click Review On the right bottom & Select Publish , to send the Message to all devices that have the app with your application id (the emulator app does not receive messages)








5. To send if from the configuration utility, click on Push Notification in the utility. Get your server key from firebase.
	Google firebase.
Open firbase.google.com & sign-in using your gmail user-name and password.
Click on console (somewhere top right) and click on your project.
On the left side of your dashboard Click on a gear sign (next to project overview), then click on Project Settings in pop-up.
Click on tab Cloud Messaging.
Copy whatever is written in front of Server Key. ( Donot copy server key but what is in front under the Token Column)
	Paste the server key in the configuration utility under Server key.
	Add the title & body of Push Message
	Click Send to send it to all users of the app

For ads
https://codelabs.developers.google.com/codelabs/admob-ads-in-flutter#0









Change Icons
From Terminal Type & press Enter
Change assets/icon/icon.png
Icon.png is your icon for the app
flutter packages pub run flutter_launcher_icons:main

adaptive_icon_background: "assets/images/background.png"
adaptive_icon_foreground: "assets/images/foreground.png"

To change splash screen
in native android change
/android/app/src/main/res/drawable/splash_image :  change the image to change the splash screen , the image is shown full screen

