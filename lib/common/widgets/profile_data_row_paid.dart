import 'package:coonch/features/purchase_content/controller/purchase_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';

class ProfileDataRowPaid extends StatelessWidget {
  ProfileDataRowPaid({
    super.key,
    required this.profileUrl,
    required this.username,
    required this.userCategory,
  });

  final String profileUrl;
  final String username;
  final String userCategory;

  final PurchaseController purchaseController = Get.find<PurchaseController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(MSizes.sm),
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: MColors.borderStatus, width: 2),
            color: Colors.white,
          ),
          // child: Image.asset(profileUrl),
          child: Image.network(
            profileUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(profileUrl);
            },
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: const TextStyle(fontSize: MSizes.fontSizeMd),
            ),
            Text(
              userCategory,
              style: const TextStyle(fontSize: MSizes.fontSizeSm),
            )
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                Widget cancelButton = TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Get.back(),
                );
                Widget continueButton = TextButton(
                  child: Text("Continue"),
                  onPressed: () async {
                    // await purchaseController.purchaseContentAPI(
                    //   creatorId,
                    //   subscriberId,
                    //   planType,
                    //   contentId,
                    //   contentType,
                    // );
                  },
                );
                return AlertDialog(
                  title: Text("Purchase Content!"),
                  content:
                      Text("Are you sure you want to purchase this content."),
                  actions: [
                    cancelButton,
                    continueButton,
                  ],
                );
              },
            );
          },
          icon: Image.asset(
            MIcons.iconSelectionProfileRow,
            height: 18,
            width: 18,
          ),
        ),
      ],
    );
  }
}
