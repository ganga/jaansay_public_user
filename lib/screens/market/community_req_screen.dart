import 'package:flutter/material.dart';
import 'package:jaansay_public_user/screens/market/community_req_detail_screen.dart';

class CommunityReqScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Container(
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CommunityReqDetailScreen(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.only(right: _mediaQuery.width * 0.05),
              child: Row(
                children: [
                  Container(
                    width: _mediaQuery.width * 0.4,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: _mediaQuery.width * 0.05, vertical: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Missing dog, Gooffy",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "12th Oct 2020",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w300,
                              fontSize: 13),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Description of lost pet including: general height/weight, nature of pet (friendly/timid/etc.), detailed coloring, any distinguishing markings or characteristics. Also include where the pet was lost and phone numbers whereyou can be reached at. Make sure all phone numbers are correct and current and number is bolded.",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
