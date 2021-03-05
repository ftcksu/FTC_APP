import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ShareEventWidget extends StatelessWidget {
  final String eventTitle;
  final String description;
  final int eventId;
  ShareEventWidget({this.eventTitle, this.eventId, this.description});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.share,
        size: 20,
      ),
      onPressed: () => shareEvent(),
    );
  }

  Future<void> shareEvent() async {
    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://ftcksu.xyz',
      link: Uri.parse('https://www.ftcksu.com/?eventId=$eventId'),
      androidParameters: AndroidParameters(
        packageName: 'com.ftcapp_androidx',
      ),
      iosParameters: IosParameters(
          bundleId: 'com.ftcappAndroidx', appStoreId: '1501670449'),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: eventTitle,
          description: description,
          imageUrl: Uri.parse(
              "https://firebasestorage.googleapis.com/v0/b/ftc-app-e7cfc.appspot.com/o/ios_app_logo.png?alt=media&token=a20f778d-cb3d-4997-b24c-ccfba3e04f15")),
    );

    final Uri dynamicUrl = await parameters.buildUrl();
    final ShortDynamicLink shortenedLink =
        await DynamicLinkParameters.shortenUrl(
      Uri.parse(dynamicUrl.toString() + "&efr=1"),
    );

    String path = 'https://ftcksu.xyz' + shortenedLink.shortUrl.path;
    print(path);
    Share.share(path);
  }
}
