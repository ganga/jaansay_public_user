// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:jaansay_public_user/models/catalog.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/screens/catalog/order_detail_screen.dart';
import 'package:jaansay_public_user/service/catalog_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'file:///C:/Users/Deepak/FlutterProjects/jaansay_public_user/lib/widgets/general/custom_network_image.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isLoad = true;

  List<Order> orders = [];

  CatalogService catalogService = CatalogService();
  getAllOrders() async {
    await catalogService.getAllOrders(orders);
    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Your Orders",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: isLoad
          ? CustomLoading()
          : orders.length == 0
              ? CustomErrorWidget(
                  iconData: Icons.shopping_cart_outlined,
                  title: "You have no orders",
                )
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return _OrderItem(orders[index]);
                  },
                ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  final Order order;

  _OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Get.to(() => OrderDetailScreen(order),
              transition: Transition.rightToLeft);
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Seller Information:"),
                        _OfficialTile(Official(
                            photo: order.officialPhoto,
                            officialsName: order.officialsName,
                            officialDisplayPhone: order.officialDisplayPhone)),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.9),
                            children: <TextSpan>[
                              TextSpan(text: 'Order ID - '),
                              TextSpan(
                                  text: '${order.orderId.toUpperCase()}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.9),
                            children: <TextSpan>[
                              TextSpan(text: 'Cost: '),
                              TextSpan(
                                  text: '₹${order.discountCost}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.9),
                            children: <TextSpan>[
                              TextSpan(text: 'Ordered on: '),
                              TextSpan(
                                  text:
                                      '${DateFormat("dd MMMM yyyy").format(order.createdAt)}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.9),
                            children: <TextSpan>[
                              TextSpan(text: 'Delivery Type: '),
                              TextSpan(
                                  text: order.deliveryTypeName,
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.navigate_next)
                ],
              ),
            ),
            Container(
              color: Colors.black26,
              width: double.infinity,
              height: 0.5,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.9),
                  children: <TextSpan>[
                    TextSpan(text: 'Status: '),
                    TextSpan(
                        text: '${order.statusName.toUpperCase()}',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfficialTile extends StatelessWidget {
  final Official official;

  _OfficialTile(this.official);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(child: CustomNetWorkImage(official.photo)),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${official.officialsName}",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "+91 ${official.officialDisplayPhone}",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
