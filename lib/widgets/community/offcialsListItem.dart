import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class BusinessListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              "https://www.avcj.com/IMG/805/22805/kirana-store-india-580x358.jpeg?1560398647",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          AutoSizeText(
            "Justin General and Kirana stores",
            minFontSize: 14,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
