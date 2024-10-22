import 'dart:convert';
import 'dart:developer';

import 'package:car_workshop_app/admin/admin_homepage.dart';
import 'package:car_workshop_app/model/booking.dart';
import 'package:car_workshop_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:http/http.dart' as http;

import '../api/api_connection.dart';
import '../widgets/progress_dialog.dart';

class BookingDetails extends StatefulWidget {
  final Booking bookingRecords;
  const BookingDetails(this.bookingRecords,{super.key});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {

  List<MyUser> userList = [];
  String selectedMechanicId = "";

  //controller declarations
  var makeController = TextEditingController();
  var modelController = TextEditingController();
  var yearController = TextEditingController();
  var timeController = TextEditingController();
  var registrationPlateController = TextEditingController();


  var customerNameController = TextEditingController();
  var customerPhoneController = TextEditingController();
  var customerEmailController = TextEditingController();

  var bookingTitleController = TextEditingController();
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();
  var mechanicController = TextEditingController();



  final GlobalKey<FormState> bookingFormKey = GlobalKey();


  Future<List<MyUser>> getMechanicList() async {
    bool isConnected = await InternetConnectionChecker().hasConnection;

    if (isConnected) {
      try {
        var res = await http.get(Uri.parse(API.mechanicList));

        if (res.statusCode == 200) {
          var responseBodyOfSearchItems = jsonDecode(res.body);

          log(responseBodyOfSearchItems.toString());

          if (responseBodyOfSearchItems['success'] == true) {
            for (var eachItemData in (responseBodyOfSearchItems['userData'] as List)) {
              userList.add(MyUser.fromJson(eachItemData));
            }
          }
        } else {
          Fluttertoast.showToast(msg: "error");
        }
      } catch (errorMsg) {
        Fluttertoast.showToast(msg: errorMsg.toString());
      }
    } else {
      Fluttertoast.showToast(msg: "No network connection");
    }

    return userList;
  }


  //function for save booking
  saveBooking() async {
    bool isConnected = await InternetConnectionChecker().hasConnection;

    if (isConnected) {
      if (mounted) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext c) {
              return const ProgressDialog();
            });
      }

      try {
        var res = await http.post(
          Uri.parse(API.saveServiceBooking),
          body: {
            "make": makeController.text.trim(),
            "model": modelController.text.trim(),
            "year": yearController.text.trim(),
            "registration_plate": registrationPlateController.text.trim(),

            "customer_name": customerNameController.text.trim(),
            "customer_phone": customerPhoneController.text.trim(),
            "customer_email": customerEmailController.text.trim(),

            "booking_title": bookingTitleController.text.trim(),
            "start_time": startDateController.text.trim(),
            "end_time": endDateController.text.trim(),
            "mechanic_id": selectedMechanicId,

          },
        );

        if (res.statusCode == 200) {
          var responseData = jsonDecode(res.body);
          if (responseData['success'] == true) {
            Get.off(() => const AdminHomepage());
            Fluttertoast.showToast(msg: "Booking added successfully");
          } else {
            Fluttertoast.showToast(msg: "Error");

            if (mounted) {
              Navigator.pop(context);
            }
          }
        }
      } catch (e) {
        log(e.toString());
      }
    } else {
      Fluttertoast.showToast(msg: "No network connection");
    }
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   getMechanicList();

  }


  @override
  Widget build(BuildContext context) {

    makeController.text = widget.bookingRecords.carMake!;
    modelController.text = widget.bookingRecords.carModel!;
    yearController.text = widget.bookingRecords.carYear!;
    registrationPlateController.text = widget.bookingRecords.carRegistrationPlate!;


    customerNameController.text = widget.bookingRecords.customerName!;
    customerPhoneController.text = widget.bookingRecords.customerPhone!;
    customerEmailController.text = widget.bookingRecords.customerEmail!;

    bookingTitleController.text = widget.bookingRecords.carMake!;
    startDateController.text = widget.bookingRecords.startTime.toString();
    endDateController.text = widget.bookingRecords.endTime.toString();
    mechanicController.text = widget.bookingRecords.mechanicId!;

    return   Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text(

          "Booking Details",
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,

        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: bookingFormKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [

              Image.asset("assets/images/car.png",height: 80,width: 100,fit: BoxFit.contain,),
              Text(
                "Car Details",
                style: GoogleFonts.acme(
                  fontSize: 20,

                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: makeController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Make",
                  hintText: "Make",
                  prefixIcon: const Icon(Icons.car_rental_sharp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter make";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: modelController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Model",
                  hintText: "Model",
                  prefixIcon: const Icon(Icons.car_crash),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter model";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: yearController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Year",
                  hintText: "Year",
                  prefixIcon: const Icon(Icons.date_range),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter year";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 10),
              TextFormField(
                controller: registrationPlateController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Registration Plate",
                  hintText: "Registration Plate",
                  prefixIcon: const Icon(Icons.format_list_numbered),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter registration plate";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              Image.asset("assets/images/customer.png",height: 80,width: 100,fit: BoxFit.contain,),
              Text(
                "Customer Details",
                style:
                GoogleFonts.acme(
                  fontSize: 20,

                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: customerNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Customer Name",
                  hintText: "Customer Name",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter customer name";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: customerPhoneController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Customer Phone",
                  hintText: "Customer Phone",
                  prefixIcon: const Icon(Icons.call),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter customer phone number";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: customerEmailController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Customer Email",
                  hintText: "Customer Email",
                  prefixIcon: const Icon(Icons.mail),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter customer email";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              Image.asset("assets/images/booking.png",height: 80,width: 100,fit: BoxFit.contain,),
              Text(
                "Booking Details",
                style:
                GoogleFonts.acme(
                  fontSize: 20,

                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: bookingTitleController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Booking Title",
                  hintText: "Booking Title",
                  prefixIcon: const Icon(Icons.book),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter booking title";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),

              TextFormField(
                readOnly: true,
                onTap: () async {


                  DateTime? dateTime = await showOmniDateTimePicker(context: context);
                  if (dateTime!= null) {
                    startDateController.text =
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
                  }

                },

                controller: startDateController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(

                  labelText: "Start Date",
                  hintText: "Start Date",

                  prefixIcon: const Icon(Icons.date_range),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // onEditingComplete: () => _focusNodePassword.requestFocus(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Enter start date";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 10),

              TextFormField(
                readOnly: true,
                onTap: () async {


                  DateTime? dateTime = await showOmniDateTimePicker(context: context);
                  if (dateTime!= null) {
                    endDateController.text =
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
                  }

                },

                controller: endDateController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(

                  labelText: "End Date",
                  hintText: "End Date",

                  prefixIcon: const Icon(Icons.date_range),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // onEditingComplete: () => _focusNodePassword.requestFocus(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Enter end date";
                  }

                  return null;
                },
              ),


              SizedBox(height: 10,),


              TextFormField(
                readOnly: true,

                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: Center(child: Text("Select Mechanic")),
                        surfaceTintColor: Colors.white,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) {
                                return SimpleDialogOption(
                                  onPressed: () {
                                    String name = userList[index]
                                        .userName
                                        .toString();
                                    selectedMechanicId = userList[index]
                                        .userId
                                        .toString();
                                    mechanicController.text = name;
                                    Navigator.pop(context);
                                  },
                                  child: Card(
                                    elevation: 2,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          userList[index]
                                              .userName
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                );
                              },
                              itemCount: userList.length,
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
                controller: mechanicController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Select Mechanic",
                  hintText: "Select Mechanic",
                  prefixIcon: const Icon(Icons.person_search),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Select Mechanic";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 60),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(

                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    onPressed: () {
                      if(bookingFormKey.currentState!.validate())
                      {
                        bookingFormKey.currentState!.save();

                        saveBooking();
                      }

                    },
                    child:  Text(
                      "Save Booking",
                      style: const TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold),

                    ),
                  ),


                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}
