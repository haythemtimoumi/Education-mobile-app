import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the package
import '../../services/api_service.dart';
import 'consts.dart';

class EmploiPage extends StatefulWidget {
  final String className;

  const EmploiPage({super.key, required this.className});

  @override
  State<EmploiPage> createState() => _EmploiPageState();
}

class _EmploiPageState extends State<EmploiPage> with SingleTickerProviderStateMixin {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  final ApiService apiService = ApiService();

  Weather? _weather;
  List<Map<String, String>> _emploiList = []; // Mock data for schedule
  List<List<dynamic>> emploiData = [];
  bool isLoading = false;
  DateTime? selectedDate;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _fetchEmploiList();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    )..addListener(() {
      setState(() {});
    });
    _animationController.forward();
  }

  Future<void> _fetchWeather() async {
    final weather = await _wf.currentWeatherByCityName("Gouvernorat de l’Ariana");
    setState(() {
      _weather = weather;
    });
  }

  Future<void> _fetchEmploiList() async {
    // Replace with actual data fetching from your database
    setState(() {
      _emploiList = [
        {'date': '2024-08-25', 'link': 'http://example.com/emploi1.pdf'},
        {'date': '2024-08-26', 'link': 'http://example.com/emploi2.pdf'},
      ];
    });
  }

  void _fetchEmploiData() async {
    if (selectedDate == null) return;

    setState(() {
      isLoading = true;
      emploiData = [];
    });

    try {
      String date = DateFormat('yyyy-MM-dd').format(selectedDate!);
      List<List<dynamic>> data = await apiService.fetchEmploiByClasseAndDate(widget.className, date: date);

      setState(() {
        emploiData = data;
      });
    } catch (e) {
      print('Error fetching emploi data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load emploi data')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule '),
        backgroundColor: Colors.red.shade700,
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade700, Colors.red.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FadeTransition(
            opacity: _animation,
            child: _weatherCard(),
          ),
          SizedBox(height: 32),
          _buildDateSelector(),
          SizedBox(height: 32),
          _buildEmploiDataList(),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'YYYY-MM-DD',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today, color: Colors.red.shade700),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024, 1),
                  lastDate: DateTime(2024, 12, 31),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                    _fetchEmploiData(); // Fetch data after date selection
                  });
                }
              },
              controller: TextEditingController(
                text: selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                    : '',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmploiDataList() {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : emploiData.isEmpty
        ? Center(child: Text('No data available', style: TextStyle(fontSize: 18)))
        : ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: emploiData.length,
      itemBuilder: (context, index) {
        final item = emploiData[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Module: ${item[5]}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Enseignant: ${item[1]}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Time: ${item[6]} - ${item[7]}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _weatherCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _weather?.areaName ?? "",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            SizedBox(height: 16),
            Text(
              DateFormat("h:mm a").format(_weather!.date!),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              DateFormat("EEEE, d MMM yyyy").format(_weather!.date!),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(70),
                border: Border.all(color: Colors.red.shade700, width: 2),
              ),
            ),
            SizedBox(height: 8),
            Text(
              _weather?.weatherDescription ?? "",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _weatherDetail("Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C"),
                _weatherDetail("Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C"),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _weatherDetail("Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s"),
                _weatherDetail("Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _weatherDetail(String detail) {
    return Text(
      detail,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black54,
      ),
    );
  }

  Widget _emploiListWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emploi List',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.red.shade700,
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: MediaQuery.of(context).size.height * 0.4, // Adjust height as needed
          child: ListView.builder(
            itemCount: _emploiList.length,
            itemBuilder: (context, index) {
              final emploi = _emploiList[index];
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      index / _emploiList.length,
                      (index + 1) / _emploiList.length,
                      curve: Curves.easeInOut,
                    ),
                  ),
                ),
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    title: Text(
                      DateFormat("EEEE, d MMM yyyy").format(DateTime.parse(emploi['date']!)),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.download, color: Colors.red.shade700),
                      onPressed: () async {
                        final url = emploi['link']!;
                        await _launchURL(url);
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
