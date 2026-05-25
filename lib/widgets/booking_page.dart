import 'package:flutter/material.dart';
import 'dart:async';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  int selectedFloor = 2;
  List<bool> bookedSlots = List.generate(8, (index) => false);
  List<int> countdownTimers = List.generate(8, (index) => 40);
  List<Timer?> timers = List.generate(8, (index) => null);
  static const int warningTime = 10;
  bool showWarning = false;
  int warningSlotIndex = -1;
  int selectedSlot = -1;
  int selectedPriceIndex = -1;

  final List<String> floors = [
    'Floor 1',
    'Floor 2',
    'Floor 3',
    'Floor 4',
    'Floor 5'
  ];

  void startTimer(int index) {
    countdownTimers[index] = 40;
    timers[index] = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownTimers[index] > 0) {
        setState(() {
          countdownTimers[index]--;
        });
        if (countdownTimers[index] <= warningTime &&
            countdownTimers[index] > 0 &&
            !showWarning) {
          showWarningDialog(index);
        }
      } else {
        unbookSlot(index);
        timer.cancel();
      }
    });
  }

  void showWarningDialog(int index) {
    setState(() {
      showWarning = true;
      warningSlotIndex = index;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.white,
          title: Text(
            'Time Warning',
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Slot ${index + 1} will be unbooked in $warningTime seconds!',
            style: TextStyle(color: Colors.black54),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  showWarning = false;
                });
              },
              child: Text('OK', style: TextStyle(color: Color(0xFFFFC107))),
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {
        showWarning = false;
      });
    });
  }

  void unbookSlot(int index) {
    setState(() {
      bookedSlots[index] = false;
      countdownTimers[index] = 40;
    });
    timers[index]?.cancel();
  }

  @override
  void dispose() {
    for (var timer in timers) {
      timer?.cancel();
    }
    super.dispose();
  }

  void showPricingOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Select Duration & Price',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    int rate = 50 * (index + 1);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPriceIndex = index;
                        });
                        Navigator.of(context).pop();
                        showConfirmBookingDialog();
                      },
                      child: Container(
                        width: 100,
                        margin: EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Color(0xFFFFC107),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${index + 1}hr',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '₹$rate',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFFFC107),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void showConfirmBookingDialog() {
    if (bookedSlots[selectedSlot]) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.white,
          title: Text(
            'Confirm Booking',
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              _buildDetailRow('Slot', 'F${selectedFloor}-${selectedSlot + 1}'),
              _buildDetailRow('Duration', '${selectedPriceIndex + 1} hour(s)'),
              _buildDetailRow('Amount', '₹${50 * (selectedPriceIndex + 1)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedSlot != -1) {
                  setState(() {
                    bookedSlots[selectedSlot] = true;
                  });
                  Navigator.of(context).pop();
                  startTimer(selectedSlot);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Confirm Booking'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.black54),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black87),
        title: Text(
          'Pick your spot',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: floors.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedFloor == (index + 1);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFloor = index + 1;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? Color(0xFFFFC107) : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color:
                            isSelected ? Color(0xFFFFC107) : Colors.grey[300]!,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        floors[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300]!,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildParkingColumn(0, 4),
                              ),
                              Container(
                                width: 30,
                                color: Color(0xFFFFC107).withOpacity(0.1),
                                child: const Center(
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Text(
                                      'DRIVING LANE',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: _buildParkingColumn(4, 8),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (selectedSlot != -1)
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: showPricingOptions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFC107),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Proceed with spot (F$selectedFloor-${selectedSlot + 1})',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildParkingColumn(int start, int end) {
    return Column(
      children: List.generate(end - start, (index) {
        int slotIndex = start + index;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedSlot = slotIndex;
              });
            },
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bookedSlots[slotIndex]
                    ? Colors.grey[200]
                    : selectedSlot == slotIndex
                        ? Color(0xFFFFC107).withOpacity(0.2)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey[300]!,
                  style: BorderStyle.solid,
                ),
              ),
              child: Stack(
                children: [
                  if (bookedSlots[slotIndex])
                    Center(
                      child: Icon(
                        Icons.directions_car,
                        color: Color(0xFF90EE90),
                        size: 40,
                      ),
                    ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Text(
                      'F$selectedFloor-${slotIndex + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  if (bookedSlots[slotIndex])
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Text(
                        '${countdownTimers[slotIndex]}s',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
