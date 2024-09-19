import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/design_styles.dart';
import 'package:workup/utils/strings.dart';
import 'package:workup/utils/text_styles.dart';

class ServiceProviderProfileScreen extends StatefulWidget {
  const ServiceProviderProfileScreen({super.key});

  @override
  State<ServiceProviderProfileScreen> createState() => _ServiceProviderProfileScreenState();
}

class _ServiceProviderProfileScreenState extends State<ServiceProviderProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ServiceProviderInfo serviceProviderData;
  late List<Subcategory> serviceProviderSubcategoryData;

  String? sID;

  String jsonString = '''
    {
      "imgURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
      "sID": "suman",
      "sName": "Suman Debnath",
      "rating": 4.5,
      "reviews": 20,
      "newSProvider": true,
      "info": "lorem ipsum dolor sit ahfdj cjbcj jjkdcdjc jsvjdj jsdvj jdvjd sjbvjdv jsdbjd sjdcvjdv jcjdv",
      "away": 3.5,
      "startingPrice": 150,
      "saved": true,
      "ordersCompleted": 50,
      "category": "Electrician"
    }''';

  String jsonString2 = '''[
    {
      "name": "Light",
      "tasks": [
        {
          "task_name": "Light replacement",
          "price": 100
        },
        {
          "task_name": "Light installation",
          "price": 80
        }
      ]
    },
    {
      "name": "Light",
      "tasks": [
        {
          "task_name": "Light replacement",
          "price": 100
        },
        {
          "task_name": "Light installation",
          "price": 80
        }
      ]
    },
    {
      "name": "Light",
      "tasks": [
        {
          "task_name": "Light replacement",
          "price": 100
        },
        {
          "task_name": "Light installation",
          "price": 80
        }
      ]
    },
    {
      "name": "Light",
      "tasks": [
        {
          "task_name": "Light replacement",
          "price": 100
        },
        {
          "task_name": "Light installation",
          "price": 80
        }
      ]
    },
    {
      "name": "Light",
      "tasks": [
        {
          "task_name": "Light replacement",
          "price": 100
        },
        {
          "task_name": "Light installation",
          "price": 80
        }
      ]
    }
  ]''';

  handleBackClick() {
    Navigator.pop(context);
  }

  handleChatClick() {

  }

  handleFilterClick(){

  }

  handleServiceProviderViewProfileClick(String sID){
    Navigator.pushNamed(
      context,
      '/serviceProviderFullProfileScreen',
      arguments: sID
    );
  }

  saveClickHandler(bool saved, String sID){

  }

  Future<void> fetchData() async {
    try {
      //
      // FETCH DATA HERE
      //
      // Simulate a network request delay
      final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null && args.containsKey("sID")) {
        sID = args["sID"];
      }

      Map<String,dynamic> jsonData = jsonDecode(jsonString);
      serviceProviderData = ServiceProviderInfo.fromJson(jsonData);

      List<dynamic> jsonData2 = jsonDecode(jsonString2);

      serviceProviderSubcategoryData = jsonData2.map((item) => Subcategory.make(item['name'], (item['tasks'] as List).map((task) => Task.make(task['task_name'], task['price'].toDouble())).toList())).toList();

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
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      serviceProviderInfo(serviceProviderData.imgURL, serviceProviderData.sID, serviceProviderData.sName, serviceProviderData.category, serviceProviderData.newSProvider, serviceProviderData.rating, serviceProviderData.reviews, serviceProviderData.ordersCompleted, serviceProviderData.away),
                      const SizedBox(height: 20.0),
                      Column(
                        children: List.generate(serviceProviderSubcategoryData.length * 2 - 1, (index) {
                          if (index.isEven) {
                            int itemIndex = index ~/ 2;
                            return serviceProviderSubcategoryBox(serviceProviderSubcategoryData[itemIndex].name, serviceProviderSubcategoryData[itemIndex].tasks);
                          } else {
                            return const SizedBox(height: 20.0); // Spacing between items
                          }
                        }),
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

  Widget serviceProviderInfo(String imgURL, String sID, String sName, String category, bool newSProvider, double rating, int reviews, int ordersCompleted, double away) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: SizedBox(
                width: 80,
                height: 80,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.network(imgURL),
                ),
              ),
            )
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    sName,
                    style: AppTextStyles.text2,
                  ),
                  const SizedBox(width: 4),
                  Container(
                    decoration: ShapeDecoration(
                      color: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (newSProvider)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            child: Text(
                              AppStrings.newSeller,
                              style: AppTextStyles.textSmallBold
                                  .merge(AppTextStyles.textWhite),
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: AppTextStyles.textSmall
                        .merge(AppTextStyles.textMediumGrey),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              FittedBox(
                child: GestureDetector(
                  onTap: (){
                    handleServiceProviderViewProfileClick(sID);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),  // Rounded corners with radius of 12
                    ),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      child: Row(
                        children: [
                          Text(
                            AppStrings.viewProfile,
                            style: AppTextStyles.text2.merge(AppTextStyles.textWhite),
                          ),
                          const SizedBox(width: 10,),
                          const Icon(
                              Icons.arrow_right,
                            color: AppColors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: AppColors.primary, size: 16.0),
                const SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: AppTextStyles.text2.merge(AppTextStyles.textPrimary),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${reviews.toString()})',
                  style: AppTextStyles.textExtraSmall
                      .merge(AppTextStyles.textMediumGrey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  ordersCompleted.toString(),
                  style: AppTextStyles.text2.merge(AppTextStyles.textPrimary),
                ),
                const SizedBox(width: 4),
                Text(
                  AppStrings.orders,
                  style: AppTextStyles.textExtraSmall
                      .merge(AppTextStyles.textMediumGrey),
                )
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  away.toString(),
                  style: AppTextStyles.text2.merge(AppTextStyles.textPrimary),
                ),
                const SizedBox(width: 4),
                Text(
                  AppStrings.km,
                  style: AppTextStyles.textExtraSmall
                      .merge(AppTextStyles.textMediumGrey),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget serviceProviderSubcategoryBox(String name, List<Task> tasks){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(10),  // Rounded corners with radius of 12
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: AppTextStyles.textExtraBold.merge(AppTextStyles.textWhite),
          ),
          const SizedBox(height: 20.0,),
          Column(
            children: List.generate(tasks.length * 2 - 1, (index) {
              if (index.isEven) {
                int itemIndex = index ~/ 2;
                return TaskBox(name:tasks[itemIndex].name, price:tasks[itemIndex].price, initialQty: 0);
              } else {
                return const SizedBox(height: 10.0); // Spacing between items
              }
            }),
          )
        ],
      ),
    );
  }

  Widget getNewTag(bool newSProvider){
    if(newSProvider){
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: ShapeDecoration(
          color: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Center(
          child: Text(
              AppStrings.newSeller,
              style: AppTextStyles.textSmallBold.merge(AppTextStyles.textWhite)
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget getSaveIcon(bool saved, String sID){
    if(saved){
      return IconButton(
          onPressed: saveClickHandler(saved, sID),
          icon: const Icon(
            Icons.bookmark_rounded,
            color: AppColors.mediumGrey,
          )
      );
    } else {
      return IconButton(
          onPressed: saveClickHandler(saved, sID),
          icon: const Icon(
            Icons.bookmark_add_outlined,
            color: AppColors.mediumGrey,
          )
      );
    }
  }
}

class Task{
  final String name;
  final double price;

  Task({
    required this.name,
    required this.price
  });

  // Factory method to create a Service object from JSON
  factory Task.make(String name, double price) {
    return Task(
      name: name,
      price: price,
    );
  }
}

class Subcategory{
  final String name;
  final List<Task> tasks;

  Subcategory({
    required this.name,
    required this.tasks
  });

  // Factory method to create a Service object from JSON
  factory Subcategory.make(String name, List<Task> tasks) {
    return Subcategory(
      name: name,
      tasks: tasks,
    );
  }
}

class ServiceProviderInfo {
  final String imgURL;
  final String sID;
  final String sName;
  final String category;
  final bool newSProvider;
  final double rating;
  final int reviews;
  final int ordersCompleted;
  final double away;
  ServiceProviderInfo({
    required this.imgURL,
    required this.sID,
    required this.sName,
    required this.category,
    required this.newSProvider,
    required this.rating,
    required this.reviews,
    required this.ordersCompleted,
    required this.away,
  });
  factory ServiceProviderInfo.fromJson(Map<String, dynamic> json) {
    return ServiceProviderInfo(
      imgURL: json['imgURL'],
      sID: json['sID'],
      sName: json['sName'],
      category: json['category'],
      newSProvider: json['newSProvider'],
      rating: json['rating'].toDouble(),
      reviews: json['reviews'],
      ordersCompleted: json['ordersCompleted'],
      away: json['away'].toDouble(),
    );
  }
}

class TaskBox extends StatefulWidget {
  final String name;
  final double price;
  final int initialQty;

  const TaskBox({
    super.key,
    required this.name,
    required this.price,
    this.initialQty = 0,
  });

  @override
  State<TaskBox> createState() => _TaskBoxState();
}

class _TaskBoxState extends State<TaskBox> {
  late int qty;

  @override
  void initState() {
    super.initState();
    qty = widget.initialQty;  // Initialize the qty with the initial value
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.name,
            style: AppTextStyles.text1.merge(AppTextStyles.textWhite),
          ),
        ),
        const SizedBox(height: 10.0,),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),  // Rounded corners
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (qty > 0) qty--;  // Decrease qty
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.remove,
                    color: AppColors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 32,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Center(
                    child: Text(
                      "$qty",
                      style: AppTextStyles.text1.merge(AppTextStyles.textWhite),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    qty++;  // Increase qty
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.add,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}