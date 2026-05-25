import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_ui_demo/widgets/booking_page.dart';
import 'package:project_ui_demo/widgets/search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng? _currentLocation;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 0 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 0 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      return;
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> parkingSpots = [
      'Bindu Chowk Parking Area - Mahalaxmi Mandir',
      'Kolhapur Airport Parking Area',
      'KMC Pay and Park Area',
      'Rajaramian Parking Area',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: _isScrolled ? Colors.white : Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Find Parking',
                style: TextStyle(
                  color: _isScrolled ? Colors.black87 : Color(0xFFFFC107),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _currentLocation == null
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFFC107),
                          ),
                        )
                      : FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            center: _currentLocation,
                            zoom: 15.0,
                            interactiveFlags: InteractiveFlag.all,
                            enableMultiFingerGestureRace: true,
                            onTap: (tapPosition, point) {
                              print('Map tapped at $point');
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: ['a', 'b', 'c'],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  width: 80.0,
                                  height: 80.0,
                                  point: _currentLocation!,
                                  builder: (ctx) => GestureDetector(
                                    onTap: () {
                                      print('Current location marker tapped');
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFC107),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 8,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: SearchBar1(onSearch: (query) {
                      print('Search query: $query');
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Available Parking Spots',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'See All',
                            style: TextStyle(
                              color: Color(0xFFFFC107),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final displayIndex = index + 1;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BookingsPage(),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFFFC107).withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Image.asset(
                              'assets/images/parking_image_$displayIndex.png',
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  parkingSpots[index],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    _buildInfoChip(
                                      Icons.location_on,
                                      '2.5 km away',
                                    ),
                                    SizedBox(width: 16),
                                    _buildInfoChip(
                                      Icons.local_parking,
                                      '15 spots available',
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '₹50/hour',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFC107),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const BookingsPage(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFFFC107),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                      ),
                                      child: Text(
                                        'Book Now',
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: parkingSpots.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFFFC107).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Color(0xFFFFC107),
          ),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
