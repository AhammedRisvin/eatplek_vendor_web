import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../common_widget.dart';
import '../../extensions.dart';
import '../controller/country_controller.dart';
import '../model/country_model.dart';

class CountryPicker extends StatefulWidget {
  const CountryPicker({super.key});

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  List<String> countryNames = [];
  List<String> filteredCountryNames = [];
  TextEditingController searchController = TextEditingController();
  String serviceId = "";
  String serviceName = "";

  @override
  void initState() {
    super.initState();
    countryNames = countryMap.keys.toList();
    filteredCountryNames = countryNames;
  }

  void filterCountries(String query) {
    if (query.isEmpty) {
      filteredCountryNames = countryNames;
    } else {
      filteredCountryNames = countryNames
          .where(
            (country) => country.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        title: const Text(
          'Choose Country',
          style: TextStyle(color: AppColor.black),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: Responsive.height * 6,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColor.white,
              border: Border.all(color: AppColor.black10),
            ),
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => filterCountries(value),
              cursorColor: AppColor.black,
              style: const TextStyle(color: AppColor.black, fontSize: 18),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: AppColor.black),
                hintText: 'Search country...',
                hintStyle: TextStyle(
                  color: AppColor.black,
                  fontFamily: GoogleFonts.urbanist().fontFamily,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: filteredCountryNames.length,
              itemBuilder: (context, index) {
                final data = countryMap[filteredCountryNames[index]] ?? {};
                return ListTile(
                  onTap: () {
                    context.read<CountryController>().countryChanged(
                      data,
                      filteredCountryNames[index],
                    );
                    context.pop();
                  },
                  leading: CachedNetworkImage(
                    imageUrl: "${data['flag']}",
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    height: 30,
                    width: 30,
                  ),
                  title: text(
                    text: filteredCountryNames[index],
                    size: 16,
                    color: AppColor.black,
                    fontFamily: GoogleFonts.urbanist().fontFamily,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
