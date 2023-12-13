import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pi_dash/models/cpu_stat_model.dart';

class CPUStatView extends StatelessWidget {
  final CPUStatModel cpuData;
  final double cpuAvg;
  const CPUStatView({super.key, required this.cpuAvg, required this.cpuData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff5b8e7d),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.025,
        vertical: MediaQuery.of(context).size.height * 0.005,
      ),
      width: MediaQuery.of(context).size.width * 0.45,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CPU',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.04,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffecf39e),
                ),
              ),
              Text(
                '${cpuAvg.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.04,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffecf39e),
                ),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.4,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: 100,
                barTouchData: BarTouchData(
                  enabled: false,
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                    show: true,
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          var style = TextStyle(
                            color: const Color(0xffecf39e),
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025,
                          );
                          Widget text;
                          text = Text(value.toInt().toString(), style: style);
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 0,
                            child: text,
                          );
                        },
                      ),
                    )),
                barGroups: [
                  for (int i = 0; i < cpuData.cpuCount; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          width: MediaQuery.of(context).size.width *
                              0.25 /
                              cpuData.cpuCount,
                          toY: cpuData.loads[i] * 1.0,
                          color: const Color(0xffecf39e),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 100,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
