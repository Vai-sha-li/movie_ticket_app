import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../models/database_helper.dart';
import '../models/movie.dart';

class SeatArrangementScreen extends StatefulWidget {
  final Movie movie;

  const SeatArrangementScreen({required this.movie});

  @override
  State<StatefulWidget> createState() => _SeatArrangementScreenState();
}

class _SeatArrangementScreenState extends State<SeatArrangementScreen> {
  List<int> selectedSeats = [];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _idController = TextEditingController();
  final _contactController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String selectedTimeSlot = '9:00 AM';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  final List<String> timeSlots = [
    '9:00 AM',
    '12:00 PM',
    '3:00 PM',
    '6:00 PM',
    '9:00 PM',
  ];

  void _toggleSeatSelection(int seatNumber) {
    setState(() {
      if (selectedSeats.contains(seatNumber)) {
        selectedSeats.remove(seatNumber);
      } else {
        selectedSeats.add(seatNumber);
      }
    });
  }

  Future<void> _bookTickets() async {
    if (_formKey.currentState!.validate()) {
      final dbHelper = DatabaseHelper();
      await dbHelper.initDatabase();

      if (selectedSeats.isEmpty) {
        // Display error message if no seats are selected
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Please select at least one seat.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      final booking = Booking(
        customerName: _nameController.text,
        customerEmail: _emailController.text,
        customerID: _idController.text,
        contactNo: _contactController.text,
        movieTitle: widget.movie.title,
        tickets: selectedSeats.length,
        dateTime: selectedDate.toString(),
        timeSlot: selectedTimeSlot,
        id: 0, customerId: '',
      );

      final existingBooking = await dbHelper.getBookingByDateTime(
        selectedDate.toString(),
        selectedTimeSlot,
      );

      if (existingBooking != null && existingBooking.movieTitle != widget.movie.title) {
        // Display error message if another movie is already booked on the same day and time
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('You have already booked another show at the same date and time.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      await dbHelper.insertBooking(booking.toMap());

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('You have successfully booked the ticket.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _idController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seat Arrangement'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
              // Implement logout functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email.';
                    }
                    // Add email validation logic if required
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    labelText: 'ID',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your ID.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact No.',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your contact number.';
                    }
                    // Add contact number validation logic if required
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    'Date: ${selectedDate.toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: selectedTimeSlot,
                  items: timeSlots.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTimeSlot = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Time Slot',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Movie: ${widget.movie.title}',
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'No. of Tickets: ${selectedSeats.length}',
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Time Slot: $selectedTimeSlot',
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 16.0),
                GridView.count(
                  crossAxisCount: 5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(25, (index) {
                    final seatNumber = index + 1;
                    return GestureDetector(
                      onTap: () => _toggleSeatSelection(seatNumber),
                      child: Container(
                        margin: const EdgeInsets.all(4.0),
                        color: selectedSeats.contains(seatNumber)
                            ? Colors.green
                            : Colors.grey,
                        child: Center(
                          child: Text(
                            seatNumber.toString(),
                            style: const TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: _bookTickets,
                    child: const Text('Book Tickets'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
