import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:car_workshop_app/mechanic/job_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../authentication/login_screen.dart';
import '../controller/booking_controller.dart';

class MechanicHomepage extends StatefulWidget {
  const MechanicHomepage({super.key});

  @override
  State<MechanicHomepage> createState() => _MechanicHomepageState();
}

class _MechanicHomepageState extends State<MechanicHomepage> {

  //local storage
  GetStorage box = GetStorage();
  String get userId => box.read("userId") ?? "";

  //date and time
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  //getx controller
  final BookingController bookingController = Get.put(BookingController());

  //logout dialog
  void showLogoutDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      title: 'Logout',
      desc: 'Want to logout from app ?'.tr,
      buttonsTextStyle:
      const TextStyle(color: Colors.white),
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
  void initState() {
    super.initState();
    // Load data from api
    bookingController.getBookingData(userId);

  }


  @override
  Widget build(BuildContext context) {

    print("state=${bookingController.isLoading.value}");

    return PopScope(
      canPop:false,
      onPopInvoked: (didPop) {
        //Logout dialog
        showLogoutDialog();


      },

      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
              tooltip: "Logout",
              color: Colors.white,
              onPressed: (){
                showLogoutDialog();
              },
              icon: Icon(Icons.logout),
            ),



          ],

          backgroundColor: Colors.redAccent,
          title: const Text('Assigned Service List',style: TextStyle(
            color: Colors.white
          ),),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Obx(() {
              return  !bookingController.isLoading.value ?
              TableCalendar(
                availableCalendarFormats: const {
                  CalendarFormat.month : 'Month'
                },
                //
                headerStyle: HeaderStyle(
                    titleCentered: true,
                    titleTextStyle: GoogleFonts.acme(
                    color: Colors.redAccent,
                    fontSize: 20
                  ),

                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.redAccent
                  )
                ),
                headerVisible: true,

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

                    print("Date: ${selectedDay?.toString()?? focusedDay.toString()}");
                  });
                },
                eventLoader: (day) {
                  return bookingController.getBookingsForDay(day);


                },
              ) : Column(
                children: [

                  getShimmerLoading(),
                  getShimmerLoading(),
                  getShimmerLoading(),
                  getShimmerLoading(),
                ],
              );




            }),




            const SizedBox(height: 8.0),
            Expanded(
              child: Obx(() {
                var bookingsForSelectedDay = bookingController.getBookingsForDay(_selectedDay ?? _focusedDay);
                return bookingsForSelectedDay.isEmpty
                    ? Center(child: Text('No jobs for this day'))
                    : ListView.builder(
                  itemCount: bookingsForSelectedDay.length,
                  itemBuilder: (context, index) {
                    final booking = bookingsForSelectedDay[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(

                        contentPadding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          side:const BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),

                        leading: Icon(Icons.car_rental_sharp,
                        size: 50,

                        ),
                        title: Text(booking.customerName!,style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),),
                        subtitle: Text('Car Registration Plate: ${booking.carRegistrationPlate}'),
                        onTap: () {

                          Get.to(() => JobDetails(booking));
                        },
                      ),
                    );
                  },


                );
              }),
            ),



          ],
        ),
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
