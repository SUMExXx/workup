import 'package:flutter/material.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/design_styles.dart';
import 'package:workup/utils/strings.dart';
import 'package:workup/utils/text_styles.dart';

class ServiceProviderListScreen extends StatefulWidget {
  const ServiceProviderListScreen({super.key});

  @override
  State<ServiceProviderListScreen> createState() => _ServiceProviderListScreenState();
}

class _ServiceProviderListScreenState extends State<ServiceProviderListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, String>> jsonData = [
    {
      'imageURL': 'https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg',
      'text': 'Electrician',
    },
    {
      'imageURL': 'https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg',
      'text': 'Electrician',
    },
    {
      'imageURL': 'https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg',
      'text': 'Electrician',
    },
    {
      'imageURL': 'https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg',
      'text': 'Electrician',
    },
    {
      'imageURL': 'https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg',
      'text': 'Electrician',
    },
    {
      'imageURL': 'https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg',
      'text': 'Electrician',
    },
    {
      'imageURL': 'https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg',
      'text': 'Electrician',
    },
    {
      'imageURL': 'https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg',
      'text': 'Electrician',
    },
    {
      'imageURL': 'https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg',
      'text': 'Electrician',
    },
    {
      'imageURL': 'https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg',
      'text': 'Electrician',
    },
    {
      'imageURL': 'https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg',
      'text': 'Electrician',
    },
    {
      'imageURL': 'https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg',
      'text': 'Electrician',
    },
  ];

  handleBackClick() {
    Navigator.pop(context);
  }

  handleChatClick() {

  }

  handleSubcategoryClick(String subcategory) {

  }

  handleFilterClick(){

  }

  handleServiceProviderInfoBoxClick(String serviceProvider){

  }

  Future<void> fetchData() async {
    try {
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
          title: Expanded(
              child: Center(
                  child: Text(
                    AppStrings.appTitle,
                    style: AppTextStyles.title.merge(AppTextStyles.textWhite),
                  )
              )
          ),
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
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(jsonData.length * 2 - 1, (index) {
                                      if (index.isEven) {
                                        int itemIndex = index ~/ 2;
                                        return subcategoryButton(itemIndex);
                                      } else {
                                        return const SizedBox(width: 10.0); // Spacing between items
                                      }
                                    }),
                                  )
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            GestureDetector(
                              onTap: handleFilterClick,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white, // Background color of the container
                                  borderRadius: BorderRadius.circular(10.0), // Radius for rounded corners
                                  border: Border.all(
                                    color: AppColors.grey, // Outline color
                                    width: 1.0, // Outline width
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
                                  child: Center(
                                      child: Icon(Icons.filter_list_rounded)
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Flexible(
                          child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: List.generate(jsonData.length * 2 - 1, (index) {
                                  if (index.isEven) {
                                    int itemIndex = index ~/ 2;
                                    return serviceProviderInfoBox(itemIndex);
                                  } else {
                                    return const SizedBox(height: 20.0); // Spacing between items
                                  }
                                }),
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        ),
      ),
    );
  }

  Widget subcategoryButton(int itemIndex){
    return GestureDetector(
      onTap: handleSubcategoryClick(jsonData[itemIndex]['text']!),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white, // Background color of the container
          borderRadius: BorderRadius.circular(10.0), // Radius for rounded corners
          border: Border.all(
            color: AppColors.grey, // Outline color
            width: 1.0, // Outline width
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          child: Center(
              child: Text(
                jsonData[itemIndex]['text']!,
                style: AppTextStyles.text2,
              )
          ),
        ),
      ),
    );
  }

  Widget serviceProviderInfoBox(int itemIndex){
    return GestureDetector(
      onTap: handleServiceProviderInfoBoxClick(jsonData[itemIndex]['text']!),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white, // Background color of the container
          borderRadius: BorderRadius.circular(10.0), // Radius for rounded corners
          boxShadow: const [
            AppShadowStyles.largeShadow
          ]
        ),
        height: 90.0,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(10.0)),
              child: SizedBox(
                width: 120.0,
                height: 90.0,
                child: FittedBox(
                  fit: BoxFit.cover,
                    child: Image.network(jsonData[itemIndex]['imageURL']!)
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  Widget categoryElement(String imageURL, String text) {
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacementNamed(
            context,
            '/',
          // arguments: {
          //     'category': category
          // }
        );
      },
      child: Container()
    );
  }
}

