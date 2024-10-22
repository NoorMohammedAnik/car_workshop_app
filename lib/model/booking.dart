//model class for car service booking
class Booking {
  String? bookingId;
  String? customerName;
  String? customerEmail;
  String? customerPhone;
  String? carMake;
  String? carModel;
  String? carYear;
  String? carRegistrationPlate;
  String? bookingTitle;
  DateTime? startTime;
  DateTime? endTime;
  String? mechanicId;




  Booking({
    this.bookingId,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.carMake,
    this.carModel,
    this.carYear,
    this.carRegistrationPlate,
    this.bookingTitle,
    this.startTime,
    this.endTime,
    this.mechanicId,

  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        bookingId: json["booking_id"],
        customerName: json['customer_name'],
        customerEmail: json["customer_email"],
        customerPhone: json["customer_phone"],
        carMake: json["car_make"],
        carModel: json["car_model"],
        carYear: json["car_year"],
        carRegistrationPlate: json["car_registration_plate"],
        bookingTitle: json["booking_title"],
        startTime:  DateTime.parse(json["start_time"]),
        endTime:  DateTime.parse(json["end_time"]),
        mechanicId: json["user_id"],

      );
}
