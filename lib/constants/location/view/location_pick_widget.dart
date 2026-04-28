// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// import '../../../../../../constants/colors.dart';
// import '../../../../../../constants/common_widget.dart';
// import '../../../../../../constants/sized_box.dart';
// import '../../router.dart';
// import '../view_model/location_provider.dart';

// class LocationPickWidget extends StatelessWidget {
//   const LocationPickWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LocationProvider>(
//       builder: (context, value, child) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             text(
//               text: 'Location',
//               color: AppColor.black.withOpacity(.6),
//               size: 14,
//               fontWeight: FontWeight.w400,
//             ),
//             const SizeBoxH(10),
//             GestureDetector(
//               onTap: () {
//                 context.pushNamed(AppRouter.locationView);
//               },
//               child: Container(
//                 width: 388,
//                 height: 48,
//                 padding: const EdgeInsets.only(left: 25, right: 20),
//                 clipBehavior: Clip.antiAlias,
//                 decoration: ShapeDecoration(
//                   color: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     side: const BorderSide(width: 1, color: Color(0xFFE9E9E9)),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     text(
//                       text: value.placeName ?? 'Select location',
//                       color: value.placeName == null
//                           ? AppColor.black60
//                           : AppColor.black,
//                       size: 14,
//                       fontFamily: 'Lufga',
//                       fontWeight: FontWeight.w400,
//                     ),
//                     SvgPicture.asset('asset/images/location.svg', height: 23),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
