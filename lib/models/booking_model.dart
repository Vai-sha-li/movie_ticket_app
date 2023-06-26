class Booking {
  final int id;
  final String customerName;
  final String customerEmail;
  final String customerID;
  final String contactNo;
  final String movieTitle;
  final int tickets;
  final String dateTime;
  final String timeSlot;
  final String customerId;

  Booking({
    required this.id,
    required this.customerName,
    required this.customerEmail,
    required this.customerID,
    required this.contactNo,
    required this.movieTitle,
    required this.tickets,
    required this.dateTime,
    required this.timeSlot,
    required this.customerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerID': customerID,
      'contactNo': contactNo,
      'movieTitle': movieTitle,
      'tickets': tickets,
      'dateTime': dateTime,
      'timeSlot': timeSlot,
      'customerId': customerId,
    };
  }

  static Booking fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      customerName: map['customerName'],
      customerEmail: map['customerEmail'],
      customerID: map['customerID'],
      contactNo: map['contactNo'],
      movieTitle: map['movieTitle'],
      tickets: map['tickets'],
      dateTime: map['dateTime'],
      timeSlot: map['timeSlot'],
      customerId: map['customerId'],
    );
  }
}
