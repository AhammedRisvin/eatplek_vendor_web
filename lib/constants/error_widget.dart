import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'common_widget.dart';
import 'extensions.dart';
import 'sized_box.dart';

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Responsive.width * 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          text(
            color: AppColor.black,
            text: "Oops Something went wrong!!!",
            size: 16,
            fontWeight: FontWeight.w500,
          ),
          const SizeBoxH(20),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xff042E60),
                borderRadius: BorderRadius.circular(6),
              ),
              child: text(
                text: 'Go Back!',
                size: 12,
                fontFamily: GoogleFonts.urbanist().fontFamily,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class NoInternetScreen extends StatefulWidget {
  void Function()? onPressed;
  NoInternetScreen({super.key, required void Function()? onPressed});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Responsive.width * 100,
        height: Responsive.height * 100,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 300,
                width: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('asset/images/404error.png'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "No internet connection!",
                style: GoogleFonts.urbanist().copyWith(
                  // color: const Color.fromARGB(255, 31, 31, 31),
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Please check your internet connect and try again",
                style: GoogleFonts.urbanist().copyWith(
                  // color: const Color.fromARGB(255, 31, 31, 31),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              button(
                width: Responsive.width * 100,

                height: 60,
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                name: "Try Again",
                fontSize: 18,
              ),
              // SizedBox(
              //   width: Responsive.width * 100,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(backgroundColor: AppColor.darkBlue),
              //     onPressed:
              //         widget.onPressed ??
              //         () {
              //           context.pop();
              //         },
              //     child: Text(
              //       "Go Back",
              //       style: Theme.of(
              //         context,
              //       ).textTheme.bodyMedium!.copyWith(color: AppColor.white, fontWeight: FontWeight.w600, fontSize: 16),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
