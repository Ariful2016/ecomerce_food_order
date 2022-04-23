import 'package:flutter/cupertino.dart';


class SmallText extends StatelessWidget {
  final Color color;
  final String text;
  double size;
  double height;
  SmallText({Key? key,
    this.color = const Color(0xff9e9d9c),
    required this.text,
    this.size =14,
    this.height =1.2
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Roboto',
        color: color,
        fontSize: size,
        height: height
      ),
    );
  }
}
