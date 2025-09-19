import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineChart extends StatefulWidget {
  final Map<String, int> data;

  const CustomLineChart({super.key, required this.data});

  @override
    State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  var baselineX = 0.0;
  var baselineY = 0.0;
  late final List<String> formattedDates;
  late final List<FlSpot> allSpots;

  FlLine getHorizontalVerticalLine(double value) {
    if ((value - baselineY).abs() <= 0.1) {
      return FlLine(
          color: Theme.of(context).colorScheme.primary,
          strokeWidth: 1,
          dashArray: [8, 4],
          );
    } else {
      return const FlLine(
          strokeWidth: 0.4,
          dashArray: [8, 4],
          );
    }
  }

FlLine getVerticalVerticalLine(double value) {
  if (value % 7 != 0) return FlLine(strokeWidth: 0); // every 5th line only
  return FlLine(
    color: Theme.of(context).colorScheme.primary,
    strokeWidth: 0.5,
    dashArray: [4, 2],
  );
}


  Widget getVerticalTitles(double value, TitleMeta meta) {
    TextStyle style;
    if ((value - baselineY).abs() <= 0.1) {
      style = const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = const TextStyle(
        color: Colors.white60,
        fontSize: 14,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(meta.formattedValue, style: style),
    );
  }
Widget getHorizontalTitles(double value, TitleMeta meta) {
    if (value % 1 != 0) return const SizedBox.shrink();
    TextStyle style;
    if ((value - baselineX).abs() <= 0.1) {
      style = const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = const TextStyle(
        color: Colors.white60,
        fontSize: 14,
        );
    }
    final index = value.toInt();
    if (index >= 0 && index < widget.data.entries.length) {
      return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(formattedDates[index], style: style),
          );
    } else {
      return const SizedBox.shrink();
    }
  }


  @override
    void initState() {
      super.initState();
      final now = DateTime.now();
      formattedDates = widget.data.keys.map((key) {
          final date = DateTime.parse(key);
          String text = '${date.day}';
          if (date.month != now.month || date.year != now.year) {
          text += '/${date.month}';
          }
          if (date.year != now.year && date.day %5 == 0) {
          text += '/${date.year.toString().substring(2,4)}';
          }
          return text;
          }).toList();
          
          final entries = widget.data.entries.toList();

        allSpots = List<FlSpot>.generate(entries.length, (i) {
            return FlSpot(i.toDouble(), entries[i].value.toDouble());
            });

    }

    @override
      Widget build(BuildContext context) {
        const double entryWidth = 50;

        final all = widget.data.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final double maxY = all.first.value.toDouble()+1;
        final theme = Theme.of(context);
        final primaryColor = theme.colorScheme.primary;

        double width = widget.data.entries.length * entryWidth;
        double deviceHeight = MediaQuery.of(context).size.height *.8;
        if(deviceHeight > width) width = deviceHeight;

        final scrollController = ScrollController();
        final List<FlSpot> spots = allSpots;
        return ListView(
            scrollDirection: Axis.horizontal,
            controller: scrollController,
          children:[ SizedBox(
          height: MediaQuery.of(context).size.width,
          width: width,
            child: LineChart(
                LineChartData(
                  lineBarsData: [
                  LineChartBarData(
                    spots: spots,
            color: primaryColor,
            barWidth: 2,
            dotData: FlDotData(
              show: false,
//              getDotPainter: (spot, percent, barData, index) {
//              final double scrollPercent = scrollController.position.maxScrollExtent / scrollController.position.pixels; if(scrollPercent + 5 > percent && scrollPercent -5 < percent){
//              return FlDotCirclePainter(
//                  strokeColor: primaryColor,
//                  radius: 4,
//                  color: primaryColor,
//                  strokeWidth: 1.5,
//                  );
//              }
//              return FlDotCirclePainter(
//                  radius: 0,
//                  color: Colors.transparent,
//                  strokeWidth: 0,
//                  strokeColor: Colors.transparent,
//                  );
//              },
              ),
            ),
              ],           titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: getVerticalTitles,
                      reservedSize: 36,
                      ),
                    ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false
                      ),
                    ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      ),
                    ),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: getHorizontalTitles,
                        reservedSize: 32),
                      ),
                  ),
                  gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: getHorizontalVerticalLine,
                getDrawingVerticalLine: getVerticalVerticalLine,
                ),
            minY: 0,
            maxY: maxY,
            baselineY: baselineY,
            minX: 0,
            maxX: widget.data.entries.length.toDouble(),
            baselineX: baselineX,
            ),
            duration: Duration.zero,
            ),
          ),
          ]
        );
    }
}
