import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:my_drona/webApp/main_screen_web.dart';
import 'package:provider/provider.dart';

import '../drona_service.dart';
import '../model/subject.dart';
import '../model/user_model.dart';

class SpiderChartWidget extends StatefulWidget {
  final double height;
  final double width;

  SpiderChartWidget({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  State<SpiderChartWidget> createState() => _SpiderChartWidgetState();
}

class _SpiderChartWidgetState extends State<SpiderChartWidget> {
  late Future<List<String>> futureSubjects;

  bool useSides = true;
  double numberOfFeatures = 6;

  Future<List<String>> getsubs() async {
    var model = context.read<UserModel>();
    return await DronaService('web').getTopicsForSubject(model.subject);
  }

  @override
  void initState() {
    super.initState();
    futureSubjects = getsubs();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: FutureBuilder<List<String>>(
        future: futureSubjects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var subjects = snapshot.data!;
            const ticks = [7, 14, 21, 28, 35];

            // Extract feature names from Subject objects
            var features = subjects.map((subject) => subject).toList();

            // Adjust the number of features if it exceeds the list size
            int featureCount = numberOfFeatures.floor().clamp(0, features.length);

            // Sample data for the radar chart
            var data = [
              [20.0, 25, 30, 25, 20, 15, 10, 15],
              [15.0, 20, 35, 30, 25, 20, 15, 10],
              [10.0, 15, 25, 20, 15, 10, 20, 25],
              [25.0, 30, 20, 15, 10, 25, 30, 35],
              [30.0, 35, 40, 45, 35, 30, 25, 20],
            ];

            // Limit the features and data based on the adjusted number of features
            features = features.sublist(0, featureCount);
            data = data.map((graph) => graph.sublist(0, featureCount)).toList();

            // Calculate a font size that scales with the widget size
            double fontSize = (widget.width + widget.height) * 0.01;

            return Center(
              child: Container(

                decoration: BoxDecoration(
                    color: Color(0xFF00968A).withOpacity(.2),
                  borderRadius: BorderRadius.circular(25)
                ),
                width: widget.width,
                child: Stack(
                  children: [

                    Positioned(
                      top: 20,
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Container(
                        height: widget.height * 0.8, // Scale the chart to fit within the container
                        width: widget.width * 0.8,
                        child: dark_mode
                            ? RadarChart.dark(
                          ticks: ticks,
                          features: features,
                          data: data,
                          reverseAxis: true,
                          useSides: useSides,

                        )
                            : RadarChart.light(
                          ticks: ticks,
                          features: features,
                          data: data,
                          reverseAxis: true,
                          useSides: useSides,

                        ),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),topLeft: Radius.circular(7)),
                          color: dark_mode ? Colors.white10 : Color(0xFF00968A).withOpacity(0.2),),

                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text("Topic-Wise preparation   ",
                          style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: Color(0xFF00968A)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
