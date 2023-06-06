import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/top.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> productActionShare({
  Map<String, dynamic>? fields,
  required BuildContext context,
  String? name,
  required String permalink,
}) async {
  SettingStore settingStore = Provider.of<SettingStore>(context, listen: false);
  bool enableDynamicLink = get(fields, ['enableDynamicLink'], false);

  DynamicLink? dynamicLink;

  if (enableDynamicLink == true) {
    String dynamicLinkType = get(fields, ['dynamicLinkType'], 'long_link');
    String dynamicLinkUriPrefix = get(fields, ['dynamicLinkUriPrefix', settingStore.languageKey], '');
    Uri dynamicLinkFallbackUrl = Uri.parse(get(fields, ['dynamicLinkFallbackUrl'], ''));

    // Data android
    String androidPackageName = get(fields, ['dynamicLinkAndroidPackageName'], '');
    int? androidMinimumVersion = ConvertData.stringToInt(get(fields, ['dynamicLinkAndroidMinimumVersion'], null));

    // Data iOS
    String iosBundleId = get(fields, ['dynamicLinkIosBundleId'], '');
    String? iosAppStoreId = get(fields, ['dynamicLinkIosAppStoreId'], '');
    String? iosMinimumVersion = get(fields, ['dynamicLinkIosMinimumVersion'], null);

    // Model Dynamic Link parameters
    dynamicLink = DynamicLink(
      dynamicLinkUriPrefix: dynamicLinkUriPrefix,
      permalink: permalink,
      dynamicLinkType: dynamicLinkType,
      androidParameters: AndroidParameters(
        packageName: androidPackageName,
        minimumVersion: androidMinimumVersion,
        fallbackUrl: dynamicLinkFallbackUrl,
      ),
      iosParameters: IOSParameters(
        bundleId: iosBundleId,
        appStoreId: iosAppStoreId,
        minimumVersion: iosMinimumVersion,
        fallbackUrl: dynamicLinkFallbackUrl,
      ),
    );
  }
  shareLink(
    permalink: permalink,
    name: name,
    dynamicLink: dynamicLink,
    context: context,
  );
}
