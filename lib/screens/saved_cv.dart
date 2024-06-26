import 'dart:convert';
import 'package:crewdog_cv_lab/custom_widgets/rotating_image.dart';
import 'package:crewdog_cv_lab/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';
import '../routes/app_routes.dart';
import 'package:http/http.dart' as http;

import 'cv_templates/controllers/temp_controller.dart';

List<int> tappedIndexes = [];
List<dynamic> responseDataInFavouriteCV = [];
List<Map<String, dynamic>> cvList = [];

///TODO: add to fav cv
Future<bool> callFavoriteApi(int index, String token) async {
  const String apiEndpoint = '$baseUrl/api/favorite/';

  final Map<String, dynamic> payload = {
    'template_id': 'v10${index + 1}',
  };

  try {
    final response = await http.post(
      Uri.parse(apiEndpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('API call successful: ${response.body}');
      return true; // CV added successfully
    } else if (response.statusCode == 422) {
      print('CV is already in favourites');
      return false; // CV is already in favourites
    } else {
      print(
          'Failed API call. Status code: ${response.statusCode} data: $payload');
      print('Response: ${response.body}');
      return false; // Failed to add CV
    }
  } catch (e) {
    print('Error making API call: $e');
    return false; // Error in API call
  }
}

///TODO: fetch fav cv
Future<List<String>> fetchFavoriteCVs(String token) async {
  final String apiEndpoint = '$baseUrl/api/favorite/';

  try {
    final response = await http.get(
      Uri.parse(apiEndpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    //print('Raw response body: ${response.body}');

    if (response.statusCode == 200) {
      responseDataInFavouriteCV = jsonDecode(response.body);

      // Use a Set to store unique CV IDs
      final Set<int> uniqueCVIds = Set();

      final List<String> favoriteCVs = responseDataInFavouriteCV
          .map((template) {
            final int cvId = template['id'];

            // Check if the CV ID is unique
            if (!uniqueCVIds.contains(cvId)) {
              uniqueCVIds.add(cvId);
              return template['template']['name'].toString();
            } else {
              return null; // Skip duplicate CV IDs
            }
          })
          .whereType<String>() // Filter out null values and keep only strings
          .toList();
      // print('favurite : $favoriteCVs');
      return favoriteCVs;
    } else {
      print(
          'Failed to fetch favorite CVs. Status code: ${response.statusCode}');
      //print('Response: ${response.body}');
      return []; // Return an empty list or handle the error as needed
    }
  } catch (e) {
    print('Error fetching favorite CVs: $e');
    return []; // Return an empty list or handle the error as needed
  }
}

///TODO: del fav cv
Future<void> removeFromFavorites(int templateId, String token) async {
  final String apiEndpoint = 'https://api-cvlab.crewdog.ai/api/favorite/';
  print('template id:::::: $templateId');
  try {
    final response = await http.delete(
      Uri.parse(apiEndpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'id': templateId}),
    );

    if (response.statusCode == 200) {
      // Success: Handle the successful removal
      print('CV removed from favorites successfully');
    } else {
      // Error: Handle the error case
      print(
          'Failed to remove CV from favorites. Status code: ${response.statusCode}');
      // print('Response: ${response.body}');
    }
  } catch (e) {
    // Exception: Handle any exceptions that occur during the request
    print('Error removing CV from favorites: $e');
  }
}

///TODO: fetch my cvs
Future<List<Map<String, dynamic>>> fetchMyCVsData(String token) async {
  final String apiEndpoint = 'https://api-cvlab.crewdog.ai/api/mycvs/?name=' '';

  try {
    final response = await http.get(
      Uri.parse(apiEndpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic>? responseData =
          jsonDecode(response.body) as Map<String, dynamic>?;

      if (responseData != null) {
        cvList = List<Map<String, dynamic>>.from(responseData['results'] ?? [])
            .map((cv) {
          final Map<String, dynamic> templateData = cv['template'];
          cv['templateName'] = templateData['name'];
          print('cv  : $cv\n');
          return cv;
        }).toList();

        //print('Success: Response data is not null');
        const JsonEncoder encoder = JsonEncoder.withIndent('');
        final String formattedJson = encoder.convert(responseData);
        //print(formattedJson);
        print('cv List : $cvList\n');
        return cvList;
      } else {
        print('Error: Response data is null');
        return [];
      }
    } else {
      print('Failed to fetch My CVs data. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
      return [];
    }
  } catch (e) {
    print('Error fetching My CVs data: $e');
    return [];
  }
}

///Todo: delete cv
Future<void> removeFromMyCVs(int cvId, String templateId, String token) async {
  final String apiEndpoint = 'https://api-cvlab.crewdog.ai/api/deleteCV/';
  print('template id :::: $templateId cv ID ::::::::::::::::: $cvId');
  try {
    final response = await http.delete(
      Uri.parse(apiEndpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body:
          // {
          //   'template_id': templateId,
          //   'cv_id':cvId,
          // }
          jsonEncode({'cv_id': cvId, 'template_id': templateId}),
    );

    if (response.statusCode == 200) {
      // Success: Handle the successful removal
      print('CV removed from My CVs successfully');
    } else {
      // Error: Handle the error case
      print(
          'Failed to remove CV from My CVs. Status code: ${response.statusCode}');
      //print('Response: ${response.body}');
    }
  } catch (e) {
    // Exception: Handle any exceptions that occur during the request
    print('Error removing CV from My CVs: $e');
  }
}

///Todo: update my cv
Future<void> updateCV(int cvId, String templateId, String token) async {
  final String apiEndpoint =
      'https://api-cvlab.crewdog.ai/api/getCv/?cv_id=$cvId&template_id=$templateId';

  try {
    final response = await http.get(
      Uri.parse(apiEndpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('response :::: ${response.body}');
      print('CV updated successfully');
    } else {
      print('Failed to update CV. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('Error updating CV: $e');
  }
}

class SavedCvScreen extends StatefulWidget {
  const SavedCvScreen({Key? key}) : super(key: key);

  @override
  State<SavedCvScreen> createState() => _SavedCvScreenState();
}

class _SavedCvScreenState extends State<SavedCvScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();

  late TabController _tabController;
  bool isFavourite = false;
  int? tappedIndex;
  int? tappedMyCVIndex;
  int? tappedFavCVIndex;
  final controller = Get.put(TempController());

  List<String> pdfImages = [
    'assets/images/template/v101.png',
    'assets/images/template/v102.png',
    'assets/images/template/v103.png',
    'assets/images/template/v104.png',
    'assets/images/template/v105.png',
    'assets/images/template/v106.png',
  ];

  List<String> pdfFiles = [
    AppRoutes.v101,
    AppRoutes.v102,
    AppRoutes.v103,
    AppRoutes.v104,
    AppRoutes.v105,
    AppRoutes.v106,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    controller.refreshController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      tappedIndex = null;
      tappedMyCVIndex = null;
      tappedFavCVIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_paws.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(4),
                  child: TabBar(
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    controller: _tabController,
                    labelColor: Colors.white,
                    indicatorColor: kHighlightedColor,
                    tabs: [
                      Tab(
                        child: Text(
                          'Templates',
                          style: TextStyle(
                            fontSize: 20,
                            color: _tabController.index == 0
                                ? kHighlightedColor
                                : Colors.black,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'My CV\'s',
                          style: TextStyle(
                            fontSize: 20,
                            color: _tabController.index == 1
                                ? kHighlightedColor
                                : Colors.black,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Favourites',
                          style: TextStyle(
                            fontSize: 20,
                            color: _tabController.index == 2
                                ? kHighlightedColor
                                : Colors.black,
                          ),
                        ),
                      ),
                      // Tab(
                      //   child: Text(
                      //     'Uploaded CV\'s',
                      //     style: TextStyle(
                      //       fontSize: 20,
                      //       color: _tabController.index == 3
                      //           ? kHighlightedColor
                      //           : Colors.black,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      buildTemplateTab(),
                      buildMyCVsTab(),
                      buildFavouritesTab(),
                      // buildUploadedCVsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTemplateTab() {
    return FutureBuilder<List<String>>(
      future: fetchFavoriteCVs(token),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const RotatingImage();
        // } else
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<String> favoriteCVs = snapshot.data!;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.70,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: pdfFiles.length,
            itemBuilder: (context, index) {
              bool isFavorite = favoriteCVs.contains("v10${index + 1}");
              return buildGridItem(index, isFavorite);
            },
          );
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.70,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: pdfFiles.length,
            itemBuilder: (context, index) {
              return buildGridItem(index, false);
            },
          );
        }
      },
    );
  }

  Widget buildMyCVsTab() {
    Set<int> usedIndices = Set<int>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              cursorColor: Colors.black54,
              decoration: InputDecoration(
                hintText: 'Search here',
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          searchController.clear();
                        },
                        child: const Icon(Icons.clear, size: 20.0),
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchMyCVsData(token),
            builder: (context, snapshot) {
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return const RotatingImage();
              // } else
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                List<Map<String, dynamic>> filteredData =
                    snapshot.data!.where((cvData) {
                  String title = cvData['username'].toLowerCase();
                  String searchQuery = searchController.text.toLowerCase();
                  return title.contains(searchQuery);
                }).toList();

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.70,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    final cvData = filteredData[index];
                    final templateId = cvData['template']['name'];
                    final title = filteredData[index]['username'];
                    final cvId = cvData['cv']['id'];
                    final templateName = cvData['template']['name'];
                    final lastDigit = int.tryParse(
                            templateName.substring(templateName.length - 1)) ??
                        1;
                    final currentIndex = lastDigit;

                    if (currentIndex >= 1 && currentIndex <= pdfImages.length) {
                      usedIndices.add(currentIndex);
                      return buildGridItemForMyCVs(
                          currentIndex - 1, index, title);
                    }
                  },
                );
              } else {
                print('Empty data or no template names found');
                print('Snapshot data: ${snapshot.data}');
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/sleepy_dog.png',
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'No Collection',
                      style: kFont24.copyWith(color: kHighlightedColor),
                    ),
                    Text(
                      'You have not saved any CV yet',
                      style: kFont12.copyWith(color: const Color(0xFF4E4949)),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildGridItemForMyCVs(int indexOfMyCV, int mainIndex, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, right: 10, left: 2),
      child: Container(
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 0.545,
            offset: Offset(-5, 2),
            spreadRadius: -3,
          )
        ]),
        child: GestureDetector(
          onTap: () {
            setState(() {
              tappedMyCVIndex = mainIndex;
            });
          },
          child: Stack(
            children: [
              Image.asset(pdfImages[indexOfMyCV]),
              if (tappedMyCVIndex == mainIndex)
                Center(
                  child: ElevatedButton(
                    style: kElevatedButtonPrimaryBG,
                    onPressed: () async {
                      int cvId = cvList[mainIndex]['cv']['id'];
                      String templateName =
                          cvList[mainIndex]['template']['name'];

                      await controller.fetchDataFromBackend(cvId, templateName);
                      Navigator.pushNamed(context, templateName);
                    },
                    child: const Text(
                      'Update',
                      style: kFont20White,
                    ),
                  ),
                ),
              Align(
                alignment: const Alignment(1.35, -1.2),
                child: IconButton(
                  onPressed: () {
                    int cvId = cvList[mainIndex]['cv']['id'];
                    String templateName = cvList[mainIndex]['template']['name'];

                    print(
                        'index of previous ::: $indexOfMyCV:::$cvId:::$templateName mainIndex:::$mainIndex');
                    removeFromMyCVs(cvId, templateName, token);
                    setState(() {
                      tappedMyCVIndex = null;
                    });
                  },
                  icon: Image.asset(
                    'assets/images/cancelCV.png',
                    height: 25,
                    width: 25,
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.0, 1.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Title: ',
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFavouritesTab() {
    return FutureBuilder<List<String>>(
      future: fetchFavoriteCVs(token),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const RotatingImage();
        // } else
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.70,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final cvFileName = snapshot.data![index];

              int currentIndex;
              if (cvFileName.contains("v10+")) {
                final templateNumber = cvFileName.split("v10+")[1];
                currentIndex = int.tryParse(templateNumber) ?? 0;
              } else {
                final lastChar = cvFileName.substring(cvFileName.length - 1);
                currentIndex = (int.tryParse(lastChar) ?? 0) - 1;
              }

              if (currentIndex >= 0 && currentIndex < pdfFiles.length) {
                return buildGridItemForFavourites(currentIndex, index);
              } else {
                return Container();
              }
            },
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/sleepy_dog.png',
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text('No Collection',
                  style: kFont24.copyWith(color: kHighlightedColor)),
              Text(
                'Go to templates to add favorite CV',
                style: kFont12.copyWith(color: const Color(0xFF4E4949)),
              ),
            ],
          );
        }
      },
    );
  }

  Widget buildGridItemForFavourites(int index, int mainIndex) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, right: 8, left: 2),
      child: Container(
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 0.545,
            offset: Offset(-5, 2),
            spreadRadius: -3,
          )
        ]),
        child: GestureDetector(
          onTap: () {
            setState(() {
              tappedFavCVIndex = index;
            });
          },
          child: Stack(
            children: [
              Image.asset(pdfImages[index]),
              if (tappedFavCVIndex == index)
                Center(
                  child: ElevatedButton(
                    style: kElevatedButtonPrimaryBG,
                    onPressed: () async {
                      await fetchMyCVsData(token);
                      controller.refreshController();
                      Navigator.pushNamed(context, pdfFiles[index]);
                    },
                    child: const Text(
                      'Select',
                      style: kFont20White,
                    ),
                  ),
                ),
              Align(
                alignment: const Alignment(1.25, -1.2),
                child: IconButton(
                  onPressed: () {
                    String templateId = 'v10${index + 1}';
                    int favoriteId = responseDataInFavouriteCV[mainIndex]['id'];

                    removeFromFavorites(favoriteId, token);

                    setState(() {
                      tappedIndexes.remove(index);
                    });
                  },
                  icon: Image.asset(
                    'assets/images/cancelCV.png',
                    height: 25,
                    width: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget buildUploadedCVsTab() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Image.asset(
  //         'assets/images/sleepy_dog.png',
  //       ),
  //       const SizedBox(
  //         height: 10.0,
  //       ),
  //       ElevatedButton(
  //           onPressed: () {
  //             // Get.to(
  //             //     DisplayControllersScreen()); // Navigate to DisplayControllersScreen
  //           },
  //           child: Text('Press me')),
  //       Text('No CV uploaded',
  //           style: kFont24.copyWith(color: kHighlightedColor)),
  //       Text(
  //         'Go upload CV',
  //         style: kFont12.copyWith(color: const Color(0xFF4E4949)),
  //       ),
  //     ],
  //   );
  // }

  Widget buildGridItem(int index, bool isFavouriteItem) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, right: 8, left: 2),
      child: Container(
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 0.545,
            offset: Offset(-5, 2),
            spreadRadius: -3,
          )
        ]),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  tappedIndex = index;
                });
              },
              child: Image.asset(pdfImages[index]),
            ),
            if (tappedIndex == index)
              Center(
                child: ElevatedButton(
                  style: kElevatedButtonPrimaryBG,
                  onPressed: () {
                    controller.refreshController();
                    Navigator.pushNamed(context, pdfFiles[index]);
                  },
                  child: const Text(
                    'Select',
                    style: kFont20White,
                  ),
                ),
              ),
            Align(
              alignment: const Alignment(1.25, -1.2),
              child: IconButton(
                icon: Image.asset(
                  isFavouriteItem
                      ? 'assets/images/favourite-red.png'
                      : 'assets/images/favouriteCV.png',
                  height: 25,
                  width: 25,
                ),
                onPressed: () async {
                  if (!isFavouriteItem) {
                    bool isCVAddedToFav = await callFavoriteApi(index, token);

                    setState(() {
                      if (isCVAddedToFav) {
                        tappedIndexes.add(index);
                        appSuccessSnackBar("Success", 'CV added to favourites');
                      } else {
                        appSuccessSnackBar(
                            "Success", 'CV is already in favourites');
                      }
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// void showRemoveConfirmationDialog(int index) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Remove from Favourites?'),
//         content: const Text(
//             'Are you sure you want to remove this CV from Favourites?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 tappedIndexes.remove(index);
//               });
//
//               saveFavourites();
//               Navigator.of(context).pop();
//             },
//             child: const Text('Remove'),
//           ),
//         ],
//       );
//     },
//   );
// }
