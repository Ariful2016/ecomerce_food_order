import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/utils/app_colors.dart';
import 'package:food_delivery_flutter/utils/dimention.dart';
import 'package:food_delivery_flutter/widgets/big_text.dart';
import 'package:food_delivery_flutter/widgets/small_text.dart';

import 'icon_and_text.dart';

class AppColumn extends StatelessWidget {
  final String text;
  const AppColumn({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BigText(text: text, size: Dimensions.font24,),
        SizedBox(height: Dimensions.height10,),
        Row(
          children: [
            Wrap(
              children: List.generate(5, (index) {return Icon(Icons.star, color: AppColors.MainColor, size: 15,);}),
            ),
            SizedBox(width: Dimensions.width10,),
            SmallText(text: '4.5'),
            SizedBox(width: Dimensions.width10,),
            SmallText(text: '1287'),
            SizedBox(width: Dimensions.width10,),
            SmallText(text: 'comments',),
          ],
        ),
        SizedBox(height: Dimensions.height10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconAndText(
                icon: Icons.circle_sharp,
                text: 'Normal',
                iconColor: AppColors.iconColor1
            ),
            IconAndText(
                icon: Icons.location_on,
                text: '1.4km',
                iconColor: AppColors.MainColor
            ),
            IconAndText(
                icon: Icons.access_time_rounded,
                text: '24min',
                iconColor: AppColors.iconColor2
            ),
          ],
        )
      ],
    );
  }
}
