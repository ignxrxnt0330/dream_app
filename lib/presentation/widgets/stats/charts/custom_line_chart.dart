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
    if (value != value.round()) return FlLine(strokeWidth: 0);
    if ((value - baselineX).abs() <= 0.1) {
      return const FlLine(
          color: Colors.white70,
          strokeWidth: 1,
          dashArray: [8, 4],
          );
    } else {
      return FlLine(
          color: Theme.of(context).colorScheme.primary,
          strokeWidth: 0.4,
          dashArray: [8, 4],
          );
    }
  }



  Widget getVerticalTitles(value, TitleMeta meta) {
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
Widget getHorizontalTitles(value, TitleMeta meta) {
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
      String key = widget.data.entries.toList()[index].key;
      DateTime? date = DateTime.parse(key);
      bool sameMonth = date.month == DateTime.now().month && date.year == DateTime.now().year;
      bool sameYear = date.year == DateTime.now().year;

      String text = date.day.toString();
      if(!sameMonth) text+= "/${date.month.toString()}";
      if(!sameYear) text+= "/${date.year.toString()}";
      return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(text, style: style),
          );
    } else {
      return const SizedBox.shrink();
    }
  }

    @override
      Widget build(BuildContext context) {
        final entries = widget.data.entries.toList();

        final all = widget.data.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final double maxY = all.first.value.toDouble()+1;
        final theme = Theme.of(context);
        final primaryColor = theme.colorScheme.primary;

        return LineChart(
            LineChartData(
              lineBarsData: [
              LineChartBarData(
                spots: List.generate(entries.length, (i) {
                  final entry = entries[i];
                  return FlSpot(i.toDouble(), entry.value.toDouble());
                  }),
color: primaryColor,
barWidth: 2,
dotData: FlDotData(
  show: true,
  getDotPainter: (spot, percent, barData, index) {
  return FlDotCirclePainter(
      radius: 4,
      color: primaryColor,
      strokeWidth: 1.5,
      strokeColor: theme.colorScheme.onPrimary,
      );
  },
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
        );
    }
}
