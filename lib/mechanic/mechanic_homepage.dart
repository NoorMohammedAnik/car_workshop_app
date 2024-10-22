import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controller/booking_controller.dart';

class MechanicHomepage extends StatefulWidget {
  const MechanicHomepage({super.key});

  @override
  State<MechanicHomepage> createState() => _MechanicHomepageState();
}

class _MechanicHomepageState extends State<MechanicHomepage> {

  GetStorage box = GetStorage();
  String get userId => box.read("userId") ?? "";

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;


  final BookingController bookingController = Get.put(BookingController());




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookingController.getBookingData(_focusedDay);

  }


  @override
  Widget build(BuildContext context) {

    print("state=${bookingController.isLoading.value}");

    return Scaffold(
      appBar: AppBar(
        title: Text('Service Bookings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [



          Obx(() {
            return  !bookingController.isLoading.value ?
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;

                  print("Date: ${_selectedDay?.toString()?? _focusedDay.toString()}");
                });
              },
              eventLoader: (day) {
                return bookingController.getBookingsForDay(day);


              },
            ) :
            Center(child: CircularProgressIndicator());
          }),




          const SizedBox(height: 8.0),
          Expanded(
            child: Obx(() {
              var bookingsForSelectedDay = bookingController.getBookingsForDay(_selectedDay ?? _focusedDay);
              return bookingsForSelectedDay.isEmpty
                  ? Center(child: Text('No bookings for this day'))
                  : ListView.builder(
                itemCount: bookingsForSelectedDay.length,
                itemBuilder: (context, index) {
                  final booking = bookingsForSelectedDay[index];
                  return ListTile(
                    title: Text(booking.customerName!),
                    subtitle: Text('Customer: ${booking.customerName}'),
                    onTap: () {
                      // Get.to(() => BookingDetailsScreen(booking: booking));
                    },
                  );
                },
              );
            }),
          ),



        ],
      ),
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
