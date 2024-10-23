import 'dart:convert';
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../api/api_connection.dart';
import '../model/booking.dart';


class BookingController extends GetxController {

  // Observable for loading state
  var isLoading = true.obs;

  // Observable for bookings
  var bookings = <Booking>[].obs;



  // Fetch bookings for a specific day
  List<Booking> getBookingsForDay(DateTime day) {

    return bookings.where((booking) =>
    booking.startTime!.year == day.year &&
        booking.startTime!.month == day.month &&
        booking.startTime!.day == day.day
    ).toList();
  }

  //get booking data form api
  Future<List<Booking>> getBookingData(String userId) async {
    List<Booking> bookingList = [];

    //check internet connection
    bool isConnected = await InternetConnectionChecker().hasConnection;

    if(isConnected)
    {
      try {

        isLoading(true); // Set loading to true

        var res = await http.get(
            Uri.parse("${API.getAssignedServiceBooking}?user_id=$userId"));

        if (res.statusCode == 200) {
          var responseBodyOfSearchItems = jsonDecode(res.body);

        log("Response: $responseBodyOfSearchItems");

          isLoading(false);

          if (responseBodyOfSearchItems['success'] == true) {
            for (var eachItemData in (responseBodyOfSearchItems['bookingData'] as List)) {
        bookingList.add(Booking.fromJson(eachItemData));

              addBooking(Booking.fromJson(eachItemData));
            }


          }
        } else {
          Fluttertoast.showToast(msg: "Error");
          isLoading(false); // Set loading to false once done
        }
      } catch (errorMsg) {
        Fluttertoast.showToast(msg: errorMsg.toString());
        // Set loading to false once done
        isLoading(false);
      }

    }
    else
    {
      Fluttertoast.showToast(msg: "No internet connection");
      isLoading(false);


    }


    return bookingList;
  }



  // Add a booking
  void addBooking(Booking booking) {
    bookings.add(booking);
  }

}