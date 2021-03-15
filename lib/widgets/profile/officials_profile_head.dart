import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/official_feed_provider.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/community/contact_screen.dart';
import 'package:jaansay_public_user/screens/community/review_screen.dart';
import 'package:jaansay_public_user/screens/message/mesage_detail_screen.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';
import 'package:jaansay_public_user/widgets/profile/profile_head_button.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class OfficialsProfileHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final officialProfileProvider =
        Provider.of<OfficialProfileProvider>(context);

    final officialFeedProvider =
        Provider.of<OfficialFeedProvider>(context, listen: false);

    Official official = officialProfileProvider
        .officials[officialProfileProvider.selectedOfficialIndex];

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.06, vertical: Get.height * 0.03),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: Get.width * 0.2,
                  width: Get.width * 0.2,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(child: CustomNetWorkImage(official.photo)),
                ),
                SizedBox(
                  width: Get.width * 0.05,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${official.officialsName}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      InkWell(
                        onTap: () {
                          pushNewScreenWithRouteSettings(context,
                              screen: ReviewScreen(),
                              withNavBar: true,
                              settings: RouteSettings(
                                arguments: official,
                              ));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RatingBar(
                              itemSize: 20,
                              initialRating: official.averageRating ?? 5,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              ignoreGestures: true,
                              itemPadding: EdgeInsets.symmetric(horizontal: 0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "(${official.totalRating})",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 13),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      if (official.officialsDescription != null)
                        Text("${official.officialsDescription}"),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: Get.height * 0.015,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ProfileHeadButton(
                    title: official.isFollow == 1 ? "Following" : "Follow",
                    onTap: () {
                      if (official.isFollow == 0) {
                        officialProfileProvider.followOfficial(
                            officialFeedProvider: officialFeedProvider);
                      }
                    },
                    isColor: official.isFollow == 0,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ProfileHeadButton(
                      title: "${tr("Contact")}",
                      onTap: () {
                        pushNewScreenWithRouteSettings(context,
                            screen: ContactScreen(),
                            settings: RouteSettings(arguments: official));
                      }),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ProfileHeadButton(
                    title: "${tr("Reviews")}",
                    onTap: () {
                      pushNewScreenWithRouteSettings(
                        context,
                        screen: ReviewScreen(),
                        withNavBar: true,
                        settings: RouteSettings(
                          arguments: official,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: Get.height * 0.01,
                ),
                ProfileHeadButton(
                    title: "${tr("Click here to know more")}",
                    onTap: () {
                      if (official.isFollow == 1) {
                        pushNewScreenWithRouteSettings(
                          context,
                          screen: MessageDetailScreen(),
                          withNavBar: false,
                          settings: RouteSettings(
                            arguments: [false, official],
                          ),
                        );
                      } else {
                        Get.rawSnackbar(
                            message:
                                "${tr('You need to follow this business to communicate with them')}");
                      }
                    }),
              ],
            ),
            if (official.isFollow == 1)
              _OfficialDocumentSection(official.officialsId)
          ],
        ),
      ),
    );
  }
}

class _OfficialDocumentSection extends StatefulWidget {
  final int officialId;

  _OfficialDocumentSection(this.officialId);

  @override
  __OfficialDocumentSectionState createState() =>
      __OfficialDocumentSectionState();
}

class __OfficialDocumentSectionState extends State<_OfficialDocumentSection> {
  bool isLoad = true;
  List<OfficialDocument> officialDocuments = [];
  OfficialService officialService = OfficialService();

  getAllDocuments() async {
    isLoad = true;
    setState(() {});
    officialDocuments.clear();
    await officialService.getOfficialDocuments(
        officialDocuments, widget.officialId.toString());
    isLoad = false;
    setState(() {});
  }

  pickImage(OfficialDocument officialDocument) async {
    File _image;

    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          maxHeight: 1000,
          maxWidth: 1000,
          compressFormat: ImageCompressFormat.jpg,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (croppedFile != null) {
        _image = File(croppedFile.path);
        sendData(_image, officialDocument);
      } else {
        isLoad = false;
        setState(() {});
      }
    } else {
      isLoad = false;
      setState(() {});
    }
  }

  sendData(File image, OfficialDocument officialDocument) async {
    isLoad = true;
    setState(() {});
    OfficialService officialService = OfficialService();
    await officialService.addUserDocument(
        image,
        officialDocument.officialId.toString(),
        officialDocument.docId.toString());
    getAllDocuments();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? Container()
        : officialDocuments.length == 0
            ? SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Documents requested from business",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ).tr(),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: officialDocuments.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                  child:
                                      Text(officialDocuments[index].docName)),
                              (officialDocuments[index].isVerified == 0)
                                  ? Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: officialDocuments[index]
                                                        .isDocument ==
                                                    0
                                                ? Theme.of(context).primaryColor
                                                : Colors.black,
                                            width: 0.5),
                                        color: officialDocuments[index]
                                                    .isDocument ==
                                                0
                                            ? Theme.of(context).primaryColor
                                            : Colors.black.withOpacity(0.01),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          splashColor: Colors.white,
                                          onTap: () {
                                            if (officialDocuments[index]
                                                    .isDocument ==
                                                0) {
                                              pickImage(
                                                  officialDocuments[index]);
                                            }
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 5),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  officialDocuments[index]
                                                              .isDocument ==
                                                          0
                                                      ? "Upload Document"
                                                      : "Pending Approval",
                                                  style: TextStyle(
                                                      color: officialDocuments[
                                                                      index]
                                                                  .isDocument ==
                                                              0
                                                          ? Colors.white
                                                          : Colors.black),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ).tr(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : (officialDocuments[index].isVerified == 1)
                                      ? Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
  }
}
