import 'package:flutter/material.dart';
import 'package:jaansay_public_user/screens/market/offer_detail_screen.dart';

class OfferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    Widget offerListItem(int index) {
      return Card(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => OfferDetailScreen()));
          },
          child: Column(
            children: [
              Expanded(
                child: Image.network(
                  "https://images.freekaamaal.com/post_images/1576047645.png",
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Urbane Sensational Men Shirt Fabric: Cotton",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "₹299",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    return Container(
      child: GridView.builder(
        itemCount: 8,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
            horizontal: 5, vertical: _mediaQuery.height * 0.02),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: _mediaQuery.height * 0.02),
        itemBuilder: (context, index) {
          return offerListItem(index);
        },
      ),
    );
  }
}
