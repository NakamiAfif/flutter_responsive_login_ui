import 'package:flutter/cupertino.dart';

class ShapeImagePositioned extends StatelessWidget {
  final double top;
  final String imagePath;

  const ShapeImagePositioned({
    Key? key,
    this.top = -50,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: top,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 450,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
