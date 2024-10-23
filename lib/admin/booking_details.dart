import 'package:car_workshop_app/model/booking.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BookingDetails extends StatefulWidget {
  final Booking bookingRecords;
  const BookingDetails(this.bookingRecords,{super.key});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {

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

  //booking form key
  final GlobalKey<FormState> bookingFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    //initializing form fields
    makeController.text = widget.bookingRecords.carMake!;
    modelController.text = widget.bookingRecords.carModel!;
    yearController.text = widget.bookingRecords.carYear!;
    registrationPlateController.text = widget.bookingRecords.carRegistrationPlate!;
    customerNameController.text = widget.bookingRecords.customerName!;
    customerPhoneController.text = widget.bookingRecords.customerPhone!;
    customerEmailController.text = widget.bookingRecords.customerEmail!;
    bookingTitleController.text = widget.bookingRecords.bookingTitle!;
    startDateController.text = DateFormat('d MMMM , y h:mm a').format(widget.bookingRecords.startTime!);
    endDateController.text = DateFormat('d MMMM , y h:mm a').format(widget.bookingRecords.endTime!);


    mechanicController.text = widget.bookingRecords.mechanicName!;

    return   Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white
        ),
        title: const Text(
          "Booking Details",
          style: TextStyle(
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
                readOnly: true,
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
                readOnly: true,
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
                readOnly: true,
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
                readOnly: true,
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
                readOnly: true,
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

                readOnly: true,
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
                readOnly: true,
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
                readOnly: true,
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
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Enter end date";
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                readOnly: true,

                controller: mechanicController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Assigned Mechanic",
                  hintText: "Assigned Mechanic",
                  prefixIcon: const Icon(Icons.person_search),
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


            ],
          ),
        ),
      ),
    );
  }


}
