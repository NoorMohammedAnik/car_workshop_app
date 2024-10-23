import 'dart:convert';
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:car_workshop_app/admin/add_booking.dart';
import 'package:car_workshop_app/admin/booking_details.dart';
import 'package:car_workshop_app/authentication/login_screen.dart';
import 'package:car_workshop_app/model/booking.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shimmer/shimmer.dart';

import '../api/api_connection.dart';
class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key});

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {

 var searchController = TextEditingController();


  Future<List<Booking>> getCustomerData() async {
    List<Booking> customerSearchList = [];


    bool isConnected = await InternetConnectionChecker().hasConnection;

    if(isConnected)
    {
      try {
        var res = await http.post(Uri.parse(API.serviceBooking), body: {
          "search_text": searchController.text,
        });

        if (res.statusCode == 200) {
          var responseBodyOfSearchItems = jsonDecode(res.body);

          log(responseBodyOfSearchItems.toString());

          if (responseBodyOfSearchItems['success'] == true) {
            for (var eachItemData in (responseBodyOfSearchItems['bookingData'] as List)) {
              customerSearchList.add(Booking.fromJson(eachItemData));
            }
          }
        } else {
          Fluttertoast.showToast(msg: "Error");
        }
      } catch (errorMsg) {
        Fluttertoast.showToast(msg: errorMsg.toString());
      }

    }
    else
    {

      Fluttertoast.showToast(msg: "no_internet_connection".tr);



    }



    return customerSearchList;
  }

  //for swipe refresh
  Future refresh() async {
    setState(() {
      getCustomerData();
    });
  }
  //for search customer
  onSearch(String search) {
    setState(() {
      searchController.text = search;
      getCustomerData();
    });
  }

  //logout dialog
  void showLogoutDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      title: 'Logout',
      desc: 'Want to logout from app ?'.tr,
      buttonsTextStyle: const TextStyle(color: Colors.white),
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkText: 'YES',
      btnCancelText: 'NO',
      btnOkOnPress: () {
        Get.offAll(() => const LoginScreen());
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:false,
      onPopInvoked: (didPop) {
        //logout confirmation dialog
        showLogoutDialog();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        //for render overflow flutter when open keyboard
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white
            ),
            actions: [
              IconButton(
                tooltip: "Logout",
                color: Colors.white,
                onPressed: () {
                  showLogoutDialog();
                },
                icon: Icon(Icons.logout),
              ),
            ],
            title: Text(
              "Booking List",
              style: const TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.redAccent,


          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  onChanged: (value) => onSearch(value),
                  style: const TextStyle(color: Colors.black, decorationThickness: 0),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide.none),
                      hintText: "Search here",
                      prefixIcon: const Icon(Icons.search),
                      prefixIconColor: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                FutureBuilder(
                  future: getCustomerData(),
                  builder: (context, AsyncSnapshot<List<Booking>> dataSnapShot) {
                    if (dataSnapShot.connectionState == ConnectionState.waiting) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getShimmerLoading(),
                            getShimmerLoading(),
                            getShimmerLoading(),
                            getShimmerLoading(),
                          ],
                        ),
                      );
                    }
                    if (dataSnapShot.data == null) {
                      return  Center(
                        child: Column(
                          children: [

                            Image.asset("assets/images/no_data.png",
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,),
                            Text("No data found"),

                          ],
                        ),
                      );
                    }

                    if (dataSnapShot.data!.isNotEmpty) {
                      return Expanded(
                        child: RefreshIndicator(
                          color: Colors.redAccent,
                          onRefresh: refresh,
                          child: ListView.builder(
                            itemCount: dataSnapShot.data!.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.all(10),
                            itemBuilder: (context, index) {
                              Booking bookingRecords =
                              dataSnapShot.data![index];

                              return GestureDetector(
                                onTap: () {


                                  Get.to(BookingDetails(bookingRecords));

                                },
                                child: Card(
                                  elevation: 2,
                                  color: Colors.grey[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          child: FadeInImage(
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.contain,
                                            placeholder: const AssetImage(
                                                "assets/images/car.png"),
                                            image: const AssetImage(
                                              "assets/images/car.png",
                                            ),

                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              //name
                                              Text(
                                                bookingRecords
                                                    .customerName!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                              //size + color

                                              //price
                                              Text(
                                                bookingRecords
                                                    .customerEmail!,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),

                                              Text(
                                                bookingRecords
                                                    .customerPhone!,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                bookingRecords
                                                    .carRegistrationPlate!,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      return  Center(
                        child: Column(


                          children: [

                            Image.asset("assets/images/no_data.png",
                              width: 100,
                              height: 100,
                              fit: BoxFit.contain,),
                            SizedBox(height: 10,),
                            Text("No data found",style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,

                            ),),

                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.redAccent,
            tooltip: 'add_customer'.tr,
            onPressed: () {
              Get.to(const AddBooking());
            },
            child: const Icon(Icons.add, color: Colors.white),
          )),
    );
  }

  //shimmer effects
  Shimmer getShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 100,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 18.0,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 200.0,
                    height: 14.0,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 150.0,
                    height: 14.0,
                    color: Colors.white,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
