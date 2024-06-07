
import 'package:coonch/features/profile/controllers/profile_controller.dart';
import 'package:coonch/utils/constants/colors.dart';
import 'package:coonch/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ChoiceSelectionProfile extends StatelessWidget {
  const ChoiceSelectionProfile({
    super.key,
    required this.profileController,
  });

  final ProfileController profileController;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: profileController.choiceItem
          .map((currChoice) => Obx(() {
        bool isSelected =
            profileController.currIndex == currChoice['value'];
        return GestureDetector(
          onTap: () => profileController.changeTab(currChoice['value']),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: MSizes.sm),
            margin: const EdgeInsets.only(right: 10),
            alignment: Alignment.center,
            height: 30,
            width: 76,
            decoration: BoxDecoration(
              color: isSelected
                  ? MColors.buttonPrimary
                  : MColors.white,
              borderRadius:
              BorderRadius.circular(MSizes.borderRadiusLg),
            ),
            child: Text(
              currChoice['name'],
              style: TextStyle(
                color: isSelected ? MColors.white : MColors.darkGrey,
              ),
            ),
          ),
        );
      }))
          .toList(),
    );
  }
}
