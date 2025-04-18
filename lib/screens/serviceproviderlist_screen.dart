import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/design_styles.dart';
import 'package:workup/utils/strings.dart';
import 'package:workup/utils/text_styles.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workup/widgets/bottom_navigation_bar.dart';

class ServiceProviderListScreen extends StatefulWidget {
  const ServiceProviderListScreen({super.key});

  @override
  State<ServiceProviderListScreen> createState() =>
      _ServiceProviderListScreenState();
}

class _ServiceProviderListScreenState extends State<ServiceProviderListScreen> {
  late Future<void> _future;
  bool _isInit = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<ServiceProviderInfoBox> serviceProviderData;
  List<ServiceProviderInfoBox> allServiceProviders = [];

  late List<Subcategory> subcategoryData;
  String? selectedSortOption;

  final String? apiUrl = dotenv.env['API_BASE_URL'];

  // String jsonString = '''[
  //   {
  //     "imgURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
  //     "sID": "suman",
  //     "sName": "Suman Debnath",
  //     "rating": 4.5,
  //     "reviews": 20,
  //     "newSProvider": true,
  //     "info": "lorem ipsum dolor sit ahfdj cjbcj jjkdcdjc jsvjdj jsdvj jdvjd sjbvjdv jsdbjd sjdcvjdv jcjdv",
  //     "away": 3.5,
  //     "startingPrice": 150,
  //     "saved": true
  //   },
  //   {
  //     "imgURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
  //     "sID": "suman",
  //     "sName": "Aniket Bandi",
  //     "rating": 4.5,
  //     "reviews": 20,
  //     "newSProvider": false,
  //     "info": "lorem ipsum dolor sit ahfdj cjbcj jjkdcdjc jsvjdj jsdvj jdvjd sjbvjdv jsdbjd sjdcvjdv jcjdv",
  //     "away": 3.5,
  //     "startingPrice": 150,
  //     "saved": false
  //   },
  //   {
  //     "imgURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
  //     "sID": "suman",
  //     "sName": "Suman Debnath",
  //     "rating": 4.5,
  //     "reviews": 20,
  //     "newSProvider": true,
  //     "info": "lorem ipsum dolor sit ahfdj cjbcj jjkdcdjc jsvjdj jsdvj jdvjd sjbvjdv jsdbjd sjdcvjdv jcjdv chvch jbscjbc jascjc jascjc jscjc",
  //     "away": 3.5,
  //     "startingPrice": 150,
  //     "saved": true
  //   },
  //   {
  //     "imgURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
  //     "sID": "suman",
  //     "sName": "Suman Debnath",
  //     "rating": 4.5,
  //     "reviews": 20,
  //     "newSProvider": false,
  //     "info": "lorem ipsum dolor sit ahfdj cjbcj jjkdcdjc jsvjdj jsdvj jdvjd sjbvjdv jsdbjd sjdcvjdv jcjdv",
  //     "away": 3.5,
  //     "startingPrice": 150,
  //     "saved": true
  //   },
  //   {
  //     "imgURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
  //     "sID": "suman",
  //     "sName": "Suman Debnath",
  //     "rating": 4.5,
  //     "reviews": 20,
  //     "newSProvider": true,
  //     "info": "lorem ipsum dolor sit ahfdj cjbcj jjkdcdjc jsvjdj jsdvj jdvjd sjbvjdv jsdbjd sjdcvjdv jcjdv",
  //     "away": 3.5,
  //     "startingPrice": 150,
  //     "saved": false
  //   },
  //   {
  //     "imgURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
  //     "sID": "suman",
  //     "sName": "Suman Debnath",
  //     "rating": 4.5,
  //     "reviews": 20,
  //     "newSProvider": false,
  //     "info": "lorem ipsum dolor sit ahfdj cjbcj jjkdcdjc jsvjdj jsdvj jdvjd sjbvjdv jsdbjd sjdcvjdv jcjdv",
  //     "away": 3.5,
  //     "startingPrice": 150,
  //     "saved": true
  //   }
  // ]''';

  String jsonString = "";

  // String jsonString2 = '''[
  //   {
  //     "text": "Light",
  //     "subcategory": "light"
  //   },
  //   {
  //     "text": "Fan",
  //     "subcategory": "fan"
  //   },
  //   {
  //     "text": "Wiring",
  //     "subcategory": "wiring"
  //   },
  //   {
  //     "text": "Switch Board",
  //     "subcategory": "switch_board"
  //   },
  //   {
  //     "text": "Appliances",
  //     "subcategory": "appliances"
  //   },
  //   {
  //     "text": "Light",
  //     "subcategory": "light"
  //   },
  //   {
  //     "text": "Fan",
  //     "subcategory": "fan"
  //   }
  // ]''';

  String jsonString2 = "";

  double? selectedMinRating;
  RangeValues priceRange = const RangeValues(50, 1000);
  bool? isActive;
  int selectedMinReviews = 0;

  handleBackClick() {
    Navigator.pop(context);
  }

  handleChatClick() {

  }

  handleSubcategoryClick(String subcategory) {

  }

  void applyFilters() {
    // print('Before filter: ${serviceProviderData.length}');
    final filtered = allServiceProviders.where((provider){
      final matchesRating = selectedMinRating == null || provider.rating >= selectedMinRating!;
      final matchesPrice = provider.startingPrice >= priceRange.start && provider.startingPrice <= priceRange.end;
      final matchesReviews = provider.reviews >= selectedMinReviews;
      final matchesAvailability = isActive == null || !isActive! ;

      return matchesRating && matchesPrice && matchesAvailability && matchesReviews;
    }).toList();

    setState(() {
      serviceProviderData = filtered;
      });
    // print('After filter: ${serviceProviderData.length}');
    // print("Filtered List: $serviceProviderData");
  }

  void applySorting() {
    if (selectedSortOption == 'PriceLowToHigh') {
      serviceProviderData.sort((a, b) => a.startingPrice.compareTo(b.startingPrice));
    } else if (selectedSortOption == 'PriceHighToLow') {
      serviceProviderData.sort((a, b) => b.startingPrice.compareTo(a.startingPrice));
    } else if (selectedSortOption == 'Rating') {
      serviceProviderData.sort((a, b) => b.rating.compareTo(a.rating));
    }
    setState(() {}); // To reflect the changes
  }

  handleFilterClick() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                runSpacing: 16,
                children: [
                  // ⭐ Rating Filter
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Minimum Rating', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<double>(
                        value: selectedMinRating,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.star),
                          border: OutlineInputBorder(),
                        ),
                        items: [5.0, 4.0, 3.0, 2.0].map((rating) {
                          return DropdownMenuItem(
                            value: rating,
                            child: Text('$rating ⭐'),
                          );
                        }).toList(),
                        onChanged: (value) => setModalState(() {
                          selectedMinRating = value;
                        }),
                      ),
                    ],
                  ),

                  // 💰 Price Range Filter
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Price Range (₹)', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      RangeSlider(
                        values: priceRange,
                        min: 0,
                        max: 5000,
                        divisions: 100,
                        labels: RangeLabels(
                          '₹${priceRange.start.round()}',
                          '₹${priceRange.end.round()}',
                        ),
                        onChanged: (values) => setModalState(() {
                          priceRange = values;
                        }),
                      ),
                    ],
                  ),

                  // 📝 Minimum Reviews Filter
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Minimum Reviews', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: selectedMinReviews,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.reviews),
                          border: OutlineInputBorder(),
                        ),
                        items: [0, 10, 25, 50, 100].map((count) {
                          return DropdownMenuItem(
                            value: count,
                            child: Text('$count+ reviews'),
                          );
                        }).toList(),
                        onChanged: (value) => setModalState(() {
                          selectedMinReviews = value!;
                        }),
                      ),
                    ],
                  ),

                  // ✅ Availability Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Only show available", style: TextStyle(fontWeight: FontWeight.bold)),
                      Switch(
                        value: isActive ?? false,
                        onChanged: (val) => setModalState(() {
                          isActive = val;
                        }),
                      ),
                    ],
                  ),

                  // 🎯 Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          applyFilters();
                        });
                      },
                      icon: const Icon(Icons.filter_alt),
                      label: const Text("Apply Filters"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  handleSortClick(){
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Price: Low to High'),
              onTap: () {
                selectedSortOption = 'PriceLowToHigh';
                applySorting();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Price: High to Low'),
              onTap: () {
                selectedSortOption = 'PriceHighToLow';
                applySorting();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Rating'),
              onTap: () {
                selectedSortOption = 'Rating';
                applySorting();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  handleServiceProviderInfoBoxClick(String sID) {
    Navigator.pushNamed(context, '/serviceProviderProfileScreen',
        arguments: {"sID": sID});
  }

  saveClickHandler(bool saved, String sID) {

  }

  Future<void> fetchData(Map<String, dynamic> args) async {
    try {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      final url1 = Uri.parse(
          '$apiUrl/customers/getServiceProviders'); // Replace with your URL

      final url2 = Uri.parse('$apiUrl/customers/getSubcategories');

      try {
        final response = await http.post(
          url1,
          headers: {'Content-Type': 'application/json'}, // Optional headers
          body:
              '{"email": "sumexxx666@gmail.com", "category": "${args["category"]}"}',
        );

        if (response.statusCode == 200) {
          // Decode the JSON response
          jsonString = response.body; // Get JSON as a raw string
        } else {
          print('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        print('Error occurred: $e');
      }

      try {
        final response = await http.post(
          url2,
          headers: {'Content-Type': 'application/json'}, // Optional headers
          body: '{"category_id": "${args["category"]}"}',
        );

        if (response.statusCode == 200) {
          // Decode the JSON response
          jsonString2 = response.body; // Get JSON as a raw string
        } else {
          print('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        print('Error occurred: $e');
      }

      List<dynamic> jsonData2 = jsonDecode(jsonString2);
      subcategoryData =
          jsonData2.map((item) => Subcategory.fromJson(item)).toList();

      List<dynamic> jsonData = jsonDecode(jsonString);
      allServiceProviders = jsonData
          .map((item) => ServiceProviderInfoBox.fromJson(item))
          .toList();

      serviceProviderData = List.from(allServiceProviders); // Shallow copy

      // await Future.delayed(const Duration(seconds: 3));
      // Simulate fetching data
      // You can replace this with actual data-fetching logic
      // e.g., var response = await http.get('https://api.example.com/data');
      // if (response.statusCode == 200) {
      //   return jsonDecode(response.body);
      // } else {
      //   throw Exception('Failed to load data');
      // }

      // For demonstration purposes, we'll just print a message
      // print('Content loaded successfully');
    } catch (e) {
      rethrow; // Rethrow the exception to let FutureBuilder handle it
    }
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final args =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      _future = fetchData(args); // pass args to fetchData
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Center(
              child: Text(
            AppStrings.appTitle,
            style: AppTextStyles.title.merge(AppTextStyles.textWhite),
          )),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.white,
            ),
            onPressed: handleBackClick,
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.chat_rounded,
                color: AppColors.white,
              ),
              onPressed: handleChatClick,
            )
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
        resizeToAvoidBottomInset: false,
        body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: AppColors.primary,
                ));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                // print('Service Providers: $serviceProviderData');

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(
                                        subcategoryData.length * 2 - 1,
                                        (index) {
                                      if (index.isEven) {
                                        int itemIndex = index ~/ 2;
                                        return subcategoryButton(
                                            subcategoryData[itemIndex].text,
                                            subcategoryData[itemIndex]
                                                .subcategory);
                                      } else {
                                        return const SizedBox(
                                            width:
                                                10.0); // Spacing between items
                                      }
                                    }),
                                  )),
                            ),
                            const SizedBox(width: 10.0),
                            GestureDetector(
                              onTap: handleFilterClick,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors
                                      .white, // Background color of the container
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Radius for rounded corners
                                  border: Border.all(
                                    color: AppColors.grey, // Outline color
                                    width: 1.0, // Outline width
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 6.0),
                                  child: Center(
                                      child: Icon(Icons.filter_alt_rounded)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            GestureDetector(
                              onTap: handleSortClick,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors
                                      .white, // Background color of the container
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Radius for rounded corners
                                  border: Border.all(
                                    color: AppColors.grey, // Outline color
                                    width: 1.0, // Outline width
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 6.0),
                                  child: Center(
                                      child: Icon(Icons.filter_list_rounded)),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Flexible(
                          child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: List.generate(
                                    serviceProviderData.length * 2 - 1,
                                    (index) {
                                  if (index.isEven) {
                                    int itemIndex = index ~/ 2;
                                    return serviceProviderInfoBox(
                                        serviceProviderData[itemIndex].imgURL,
                                        serviceProviderData[itemIndex].sID,
                                        serviceProviderData[itemIndex].sName,
                                        serviceProviderData[itemIndex].rating,
                                        serviceProviderData[itemIndex].reviews,
                                        serviceProviderData[itemIndex]
                                            .newSProvider,
                                        serviceProviderData[itemIndex].info,
                                        serviceProviderData[itemIndex].away,
                                        serviceProviderData[itemIndex]
                                            .startingPrice,
                                        serviceProviderData[itemIndex].saved);
                                  } else {
                                    return const SizedBox(
                                        height: 20.0); // Spacing between items
                                  }
                                }),
                              )),
                        )
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }

  Widget subcategoryButton(String text, String subcategory) {
    return GestureDetector(
      onTap: handleSubcategoryClick(subcategory),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white, // Background color of the container
          borderRadius:
              BorderRadius.circular(10.0), // Radius for rounded corners
          border: Border.all(
            color: AppColors.grey, // Outline color
            width: 1.0, // Outline width
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          child: Center(
              child: Text(
            text,
            style: AppTextStyles.text2,
          )),
        ),
      ),
    );
  }

  Widget serviceProviderInfoBox(
      String imgURL,
      String sID,
      String sName,
      double rating,
      int reviews,
      bool newSProvider,
      String info,
      double away,
      int startingPrice,
      bool saved) {
    return GestureDetector(
      onTap: () {
        handleServiceProviderInfoBoxClick(sID);
      },
      child: Container(
          decoration: BoxDecoration(
              color: AppColors.white, // Background color of the container
              borderRadius:
                  BorderRadius.circular(10.0), // Radius for rounded corners
              boxShadow: const [AppShadowStyles.largeShadow]),
          height: 110.0,
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(10.0)),
                child: SizedBox(
                  width: 120.0,
                  height: 110.0,
                  child: FittedBox(
                      fit: BoxFit.cover, child: Image.network(imgURL)),
                ),
              ),
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text(
                                  sName,
                                  style: AppTextStyles.text2,
                                ),
                                const SizedBox(width: 4.0),
                                getNewTag(newSProvider)
                              ]),
                              const SizedBox(height: 2.0),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: AppColors.primary,
                                    size: 16.0,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    rating.toString(),
                                    style: AppTextStyles.text2
                                        .merge(AppTextStyles.textPrimary),
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    '(${reviews.toString()})',
                                    style: AppTextStyles.textExtraSmall
                                        .merge(AppTextStyles.textMediumGrey),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const Spacer(),
                          getSaveIcon(saved, sID)
                        ],
                      ),
                      const SizedBox(height: 2.0),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              info,
                              style: AppTextStyles.textSmall
                                  .merge(AppTextStyles.textMediumGrey),
                              maxLines: 2, // Limit the text to two lines
                              overflow: TextOverflow
                                  .ellipsis, // Show "..." at the end if the text exceeds
                              softWrap: true,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 2.0),
                      Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                AppStrings.away,
                                style: AppTextStyles.textExtraSmall
                                    .merge(AppTextStyles.textMediumGrey),
                              ),
                              const SizedBox(width: 2.0),
                              Text(
                                away.toString(),
                                style: AppTextStyles.text2
                                    .merge(AppTextStyles.textDarkGrey),
                              ),
                              const SizedBox(width: 2.0),
                              Text(
                                AppStrings.km,
                                style: AppTextStyles.textExtraSmall
                                    .merge(AppTextStyles.textMediumGrey),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                AppStrings.from,
                                style: AppTextStyles.textExtraSmall
                                    .merge(AppTextStyles.textMediumGrey),
                              ),
                              const SizedBox(width: 2.0),
                              Text(
                                '₹ ${startingPrice.toString()}',
                                style: AppTextStyles.text2
                                    .merge(AppTextStyles.textDarkGrey),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ))
            ],
          )),
    );
  }

  getNewTag(bool newSProvider) {
    if (newSProvider) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: ShapeDecoration(
          color: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Center(
          child: Text(AppStrings.newSeller,
              style:
                  AppTextStyles.textSmallBold.merge(AppTextStyles.textWhite)),
        ),
      );
    } else {
      return Container();
    }
  }

  getSaveIcon(bool saved, String sID) {
    if (saved) {
      return AbsorbPointer(
        absorbing: true,
        child: IconButton(
            onPressed: saveClickHandler(saved, sID),
            icon: const Icon(
              Icons.bookmark_rounded,
              color: AppColors.mediumGrey,
            )),
      );
    } else {
      return IconButton(
          onPressed: saveClickHandler(saved, sID),
          icon: const Icon(
            Icons.bookmark_add_outlined,
            color: AppColors.mediumGrey,
          ));
    }
  }
}

class Subcategory {
  final String text;
  final String subcategory;

  Subcategory({required this.text, required this.subcategory});

  // Factory method to create a Service object from JSON
  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      text: json['subcategory_name'],
      subcategory: json['subcategory_id'],
    );
  }
}

class ServiceProviderInfoBox {
  final String imgURL;
  final String sID;
  final String sName;
  final double rating;
  final int reviews;
  final bool newSProvider;
  final String info;
  final double away;
  final int startingPrice;
  final bool saved;

  ServiceProviderInfoBox({
    required this.imgURL,
      required this.sID,
      required this.sName,
      required this.rating,
      required this.reviews,
      required this.newSProvider,
      required this.info,
      required this.away,
      required this.startingPrice,
      required this.saved});

  // Factory method to create a Service object from JSON
  factory ServiceProviderInfoBox.fromJson(Map<String, dynamic> json) {
    String createFullName(
        String firstName, String? middleName, String lastName) {
      // Join the non-null values with a space
      return [firstName, middleName, lastName]
          .where((name) => name != null && name.isNotEmpty)
          .join(' ');
    }
      return ServiceProviderInfoBox(
        imgURL: json['imgURL'] ?? '',
        sID: json['uuid'],
        sName: createFullName(
            json['firstName'], json['middleName'], json['lastName']),
        rating: json['rating'].toDouble(),
        reviews: json['reviewCount'],
        newSProvider: json['newSProvider'],
        info: json['info'],
        // away: json['away'].toDouble(),
        away: 12.2,
        startingPrice: json['startingPrice'],
        // saved: json['saved'],
        saved: false,
      );
  }
}
