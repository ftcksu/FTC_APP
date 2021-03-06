# FTC App
[FTC](https://www.ftcksu.com/) App made with [Flutter](https://flutter.dev/). 💜
### FTC App Backend:
[FTC KSU Mobile Application Backend Built Using Spring Boot.](https://github.com/FerasAloudah/ftc-app-backend)
## FTC points
Remember to list any work you do (making contributions, writing issues, etc) in the app for points. 🔥
## Contributing:
If you'd like to contribute to the app:
1. Fork the project *(fork to contribute)*.
2. Create a new branch to work on.
3. Send a pull request.
## Issues
If you **notice a bug**, **have a new feature to suggest**, or **just want to discuss something about the app** be sure to post an issue about it.
## Packages being used in project:
* [characters](https://pub.dev/packages/characters)
* [dio](https://pub.dev/packages/dio)
* [equatable](https://pub.dev/packages/equatable)
* [firebase_dynamic_links](https://pub.dev/packages/firebase_dynamic_links)
* [firebase_messaging](https://pub.dev/packages/firebase_messaging)
* [flushbar](https://pub.dev/packages/flushbar)
* [flutter_bloc](https://pub.dev/packages/flutter_bloc)
* [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
* [flutter_speed_dial](https://pub.dev/packages/flutter_speed_dial)
* [google_maps_flutter](https://pub.dev/packages/google_maps_flutter)
* [place_picker](https://pub.dev/packages/place_picker)
* [image_crop](https://pub.dev/packages/image_crop)
* [image_picker](https://pub.dev/packages/image_picker)
* [json_annotation](https://pub.dev/packages/json_annotation)
* [meta](https://pub.dev/packages/meta)
* [rflutter_alert](https://pub.dev/packages/rflutter_alert)
* [share](https://pub.dev/packages/share)
* [swipe_stack](https://pub.dev/packages/swipe_stack)
* [url_launcher](https://pub.dev/packages/url_launcher)
* [flutter_config](https://pub.dev/packages/flutter_config)
* [get_it ](https://pub.dev/packages/get_it)
* [flutter_native_splash](https://pub.dev/packages/flutter_native_splash)
## Release build note:
Make sure to remove `application android:usesCleartextTraffic="true"` from AndroidManifest.xml for the release build.
## Troubleshooting:
- When first opening the project, if you get `dart(uri_does_not_exist)` (lots of red .dart files), use the `flutter pub get` command. In VScode, you could also click "Get packages" when receiving the following notification:
![image](https://user-images.githubusercontent.com/68731244/110935437-76404080-8340-11eb-8c4e-47417cf734db.png)
- (Seen in VScode) If you get `DioError [DioErrorType.RESPONSE]: Http status error [500]`, make sure to **debug code only** and **rebuild the app**.
- Some used packages have yet to update and use null-safty, to run the app with them use "flutter run --no-sound-null-safety"
