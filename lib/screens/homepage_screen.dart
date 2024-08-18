import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/strings.dart';
import 'package:workup/utils/text_styles.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<Category> categoryData;

  String jsonString = '''[
    {
        "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
        "text": "Electrician",
        "category": "electrician"
    },
    {
        "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
        "text": "Electrician",
        "category": "electrician"
    },
    {
        "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
        "text": "Electrician",
        "category": "electrician"
    },
    {
        "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
        "text": "Electrician",
        "category": "electrician"
    },
    {
        "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
        "text": "Electrician",
        "category": "electrician"
    },
    {
        "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
        "text": "Electrician",
        "category": "electrician"
    },
    {
        "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
        "text": "Electrician",
        "category": "electrician"
    },
    {
        "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
        "text": "Electrician",
        "category": "electrician"
    },
    {
        "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
        "text": "Electrician",
        "category": "electrician"
    },
    {
        "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
        "text": "Electrician",
        "category": "electrician"
    },
    {
        "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
        "text": "Electrician",
        "category": "electrician"
    },
    {
        "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
        "text": "Electrician",
        "category": "electrician"
    }
]''';

  handleMenuClick() {
    _scaffoldKey.currentState?.openDrawer();
  }

  handleChatClick() {

  }

  Future<void> fetchData() async {
    try {
      List<dynamic> jsonData = jsonDecode(jsonString);
      categoryData = jsonData.map((item) => Category.fromJson(item)).toList();
      // Simulate a network request delay
      await Future.delayed(const Duration(seconds: 3));

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
      // Handle exceptions and errors
      // print('Error loading content: $e');
      rethrow; // Rethrow the exception to let FutureBuilder handle it
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
              )
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.menu_rounded,
              color: AppColors.white,
            ),
            onPressed: handleMenuClick,
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
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: AppStrings.home
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_rounded),
                label: AppStrings.bidding
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded),
                label: AppStrings.home
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment_rounded),
                label: AppStrings.home
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded),
                label: AppStrings.home
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.tertiary,
          backgroundColor: AppColors.primary,
          type: BottomNavigationBarType.fixed,
        ),
        resizeToAvoidBottomInset: false,
        drawer: Drawer(
          child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                      color: AppColors.primary,
                  ),
                  child: Text(
                    'Drawer Header',
                    style: AppTextStyles.heading2.merge(AppTextStyles.textWhite),
                  ),
                ),
                ListTile(
                  title: const Text('Item 1'),
                  onTap: () {
                    // Handle item 1 tap
                  },
                ),
                ListTile(
                  title: const Text('Item 2'),
                  onTap: () {
                    // Handle item 2 tap
                  },
                ),
              ],
            ),
          ),
        body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(
                color: AppColors.primary,
              ));
            } else if(snapshot.hasError){
              return Center(child: Text('Error: ${snapshot.error}'));
            } else{
              return Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // Number of columns in the grid
                            crossAxisSpacing: 10.0, // Spacing between columns
                            mainAxisSpacing: 10.0, // Spacing between rows
                            childAspectRatio: 1.0, // Aspect ratio of each item
                          ),
                          itemCount: categoryData.length,
                          itemBuilder: (context, index) {
                            return categoryElement(categoryData[index].imageURL, categoryData[index].text, categoryData[index].category);
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              );
            }
          }
        ),
      ),
    );
  }

  Widget categoryElement(String imageURL, String text, String category) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(
            context,
            '/serviceProviderListScreen',
          arguments: {
              'category': category
          }
        );
      },
      child: Container(
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(10), // Adjust radius as needed
        ),
        width: 100.0,
        height: 100.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
                child: Image.network(imageURL)
            ),
            Expanded(
                child: Center(
                    child: Text(
                        text,
                      style: AppTextStyles.text2.merge(AppTextStyles.textWhite),
                    )
                )
            ),
          ],
        ),
      ),
    );
  }
}

class Category{
  final String imageURL;
  final String text;
  final String category;

  Category({
    required this.imageURL,
    required this.text,
    required this.category,
  });

  // Factory method to create a Service object from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      imageURL: json['imageURL'],
      text: json['text'],
      category: json['category'],
    );
  }
}

