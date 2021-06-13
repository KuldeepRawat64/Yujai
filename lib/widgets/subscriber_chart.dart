// import 'package:Yujai/models/subscriber_series.dart';
// import 'package:charts_flutter/flutter.dart' as charts;

// import 'package:flutter/material.dart';

// class SubscriberChart extends StatelessWidget {
//   final List<SubscriberSeries> data;

//   SubscriberChart({@required this.data});

//   @override
//   Widget build(BuildContext context) {
//     List<charts.Series<SubscriberSeries, String>> series = [
//       charts.Series(
//           id: "Subscribers",
//           data: data,
//           domainFn: (SubscriberSeries series, _) => series.year,
//           measureFn: (SubscriberSeries series, _) => series.subscribers,
//           colorFn: (SubscriberSeries series, _) => series.barColor)
//     ];

//     return Container(
//       height: 110,
//       padding: EdgeInsets.all(0),
//       child: Padding(
//         padding: const EdgeInsets.all(2.0),
//         child: charts.BarChart(series, animate: true),
//       ),
//     );
//   }
// }