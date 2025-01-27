import 'package:flutter/material.dart';

class BlockDetail extends StatelessWidget {
  final String blockName;
  final String blockImage; // Made blockImage nullable
  final VoidCallback? onTap; // Added onTap callback

  const BlockDetail({
    super.key,
    required this.blockName,
    required this.blockImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                width: 165,
                height: 221,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                  color: Color.fromRGBO(240, 240, 240, 1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(blockImage),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 165,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(125, 1, 1, 1),
                      borderRadius: BorderRadius.only(
                        // topLeft: Radius.circular(0),
                        // topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Text(
                      blockName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
