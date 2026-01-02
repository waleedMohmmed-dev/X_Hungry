// import 'package:flutter/material.dart';
// import 'package:hungry_app/features/home/widget/card_widget.dart';
// import 'package:hungry_app/features/products/view/products_datails_view.dart';

// class GridViewWidget extends StatelessWidget {
//   const GridViewWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       padding: EdgeInsets.zero,
//       itemCount: 6,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 0.75,
//         mainAxisSpacing: 1,
//       ),
//       itemBuilder: (context, index) {
//         return GestureDetector(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (c) {
//                 return ProductsDetailsView(productImage: widget);
//               },
//             ),
//           ),

//           child: CardWidget(
//             image: 'assets/test/test.png',

//             text: 'Cheese Burger',
//             desc: 'Wendy\'s Burger',
//             rate: '4.9',
//           ),
//         );
//       },
//     );
//   }
// }
