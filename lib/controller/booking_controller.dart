import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../api/api_connection.dart';

import 'package:http/http.dart' as http;

import '../model/booking.dart';
import '../widgets/progress_dialog.dart';


class BookingController extends GetxController {

  var isLoading = true.obs; // Observable for loading state

  var bookings = <Booking>[].obs;



  // Fetch bookings for a specific day
  List<Booking> getBookingsForDay(DateTime day) {


    return bookings.where((booking) =>
    booking.startTime!.year == day.year &&
        booking.startTime!.month == day.month &&
        booking.startTime!.day == day.day
    ).toList();
  }


  Future<List<Booking>> getBookingData(DateTime day) async {
    List<Booking> customerSearchList = [];



    String formatedDate= DateFormat('yyyy-MM-dd').format(day);

    bool isConnected = await InternetConnectionChecker().hasConnection;

    if(isConnected)
    {


      try {

        isLoading(true); // Set loading to true

        var res = await http.post(Uri.parse(API.assignedServiceBooking), body: {
          "start_time": formatedDate,
          "user_id": "2",
        });

        if (res.statusCode == 200) {
          var responseBodyOfSearchItems = jsonDecode(res.body);

          log("Response: "+responseBodyOfSearchItems.toString());

          isLoading(false);

          if (responseBodyOfSearchItems['success'] == true) {
            for (var eachItemData in (responseBodyOfSearchItems['bookingData'] as List)) {
              customerSearchList.add(Booking.fromJson(eachItemData));

              addBooking(Booking.fromJson(eachItemData));
            }



          }
        } else {
          Fluttertoast.showToast(msg: "Error");
          isLoading(false); // Set loading to false once done
        }
      } catch (errorMsg) {
        Fluttertoast.showToast(msg: errorMsg.toString());
        isLoading(false); // Set loading to false once done
      }

    }
    else
    {

      Fluttertoast.showToast(msg: "no_internet_connection".tr);



    }



    return customerSearchList;
  }



  // Add a booking
  void addBooking(Booking booking) {
    bookings.add(booking);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   // Sample bookings data
  //   addBooking(Booking(
  //     serviceName: 'Haircut',
  //     customerName: 'John Doe',
  //     date: DateTime.now(),
  //     details: 'Basic haircut service',
  //   ));
  //   addBooking(Booking(
  //     serviceName: 'Haircut 2',
  //     customerName: 'Anik',
  //     date: DateTime.now(),
  //     details: 'Basic haircut service',
  //   ));
  //
  //   addBooking(Booking(
  //     serviceName: 'Haircut 5',
  //     customerName: 'Noor',
  //     date: DateTime.now(),
  //     details: 'Basic haircut service',
  //   ));
  //
  //   addBooking(Booking(
  //     serviceName: 'Manicure',
  //     customerName: 'Jane Smith',
  //     date: DateTime.now().add(Duration(days: 1)),
  //     details: 'Deluxe manicure service',
  //   ));
  // }
}