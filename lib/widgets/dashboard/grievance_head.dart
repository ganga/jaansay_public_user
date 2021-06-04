// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:jaansay_public_user/constants/constants.dart';
import 'package:jaansay_public_user/models/grievance.dart';
import 'package:jaansay_public_user/screens/feed/image_view_screen.dart';
import 'package:jaansay_public_user/widgets/dashboard/grievance_status.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';

class GrievanceHead extends StatelessWidget {
  final GrievanceMaster grievanceMaster;
  final Function onTap;

  GrievanceHead(this.grievanceMaster, this.onTap);

  messageText() {
    return Text(
      grievanceMaster.message,
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      maxLines: onTap == null ? 1500 : 5,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.flag_sharp,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "TICKET #${grievanceMaster.ticketNumber}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withAlpha(155),
                            letterSpacing: 0.7),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 21,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        DateFormat("dd MMMM yyyy")
                            .format(grievanceMaster.createdAt),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withAlpha(155),
                            letterSpacing: 0.7),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                height: 0.5,
                width: double.infinity,
                color: Colors.black.withAlpha(155),
              ),
              onTap == null
                  ? messageText()
                  : Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              messageText(),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Icon(Icons.navigate_next)
                      ],
                    ),
              const SizedBox(
                height: 8,
              ),
              if (grievanceMaster.medias.length > 0)
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 16),
                  height: 80,
                  child: ListView.builder(
                    padding: EdgeInsets.only(right: 16),
                    itemBuilder: (context, index) {
                      return ImageHolder(grievanceMaster.medias[index]);
                    },
                    itemCount: grievanceMaster.medias.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              GrievanceStatus(grievanceMaster.isClosed)
            ],
          ),
        ),
      ),
    );
  }
}

class ImageHolder extends StatelessWidget {
  final String url;

  ImageHolder(this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        child: InkWell(
          onTap: () {
            Get.to(
              () => ImageViewScreen(url),
            );
          },
          child: CustomNetWorkImage(
            url,
            assetLink: Constants.productHolderURL,
          ),
        ),
      ),
    );
  }
}
