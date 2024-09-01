import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'flutter_flow/flutter_flow_theme.dart';
import 'model/qanda_history_model.dart';

class SplineCharts extends StatefulWidget {
  double height;
  double width;

  SplineCharts({
    super.key,
    required this.height,
    required this.width
  });

  @override
  State<SplineCharts> createState() => _SplineChartsState();
}

class _SplineChartsState extends State<SplineCharts> {
  @override
  Widget build(BuildContext context) {
    var bx = Provider.of<QandaHistoryModel>(context, listen: false);
    List<int> a = bx.answers;
    List<int> b = bx.total_questions;
    List<DateTime> c = bx.days;

    List<ChartData> chartData = [];

    for (int i = 0; i < c.length; i++) {
      chartData.add(ChartData('Day ${i + 1}', a[i] / b[i]));
    }

    return Scaffold(
      body: Consumer<QandaHistoryModel>(
        builder: (context, bx, child) {
        return Stack(
          children: [
            Container(
              width: widget.width,// MediaQuery.of(context).size.width * 0.92,
              height: widget.height,//MediaQuery.of(context).size.height * .20,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 6.0,
                    color: Color(0x4B1A1F24),
                    offset: Offset(0.0, 2.0),
                  ),
                ],
                color: Color(0xFF00968A),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      labelStyle: TextStyle(color: Colors.white),
                      majorGridLines: MajorGridLines(width: 0),
                      axisLine: AxisLine(color: Colors.white),
                    ),
                    primaryYAxis: NumericAxis(
                      labelStyle: TextStyle(color: Colors.white),
                      majorGridLines: MajorGridLines(width: 0),
                      axisLine: AxisLine(color: Colors.white),
                    ),
                    series: <CartesianSeries>[
                      SplineAreaSeries<ChartData, String>(
                        color: Colors.white.withOpacity(.7),
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.day,
                        yValueMapper: (ChartData data, _) => data.ratio,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 55,
              right: 0,
              top: 18,
              child: Container(
                child: Text(
                  'Track your performance',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Lexend',
                      color: FlutterFlowTheme.of(context).textColor,
                      letterSpacing: 0.0,
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ],
        );
        }
      ),
    );
  }
}

class ChartData {
  ChartData(this.day, this.ratio);
  final String day;
  final double ratio;
}