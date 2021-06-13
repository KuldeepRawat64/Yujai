import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../style.dart';

class SkillEvent {
  const SkillEvent({
    @required this.skill,
    @required this.level,
  });

  final String skill;

  final double level;
}

@immutable
class SkillEventRow extends StatelessWidget {
  const SkillEventRow(this.event);

  final SkillEvent event;

  convertDate(int timeinMilis) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeinMilis);
    var formattedDate = DateFormat.yMMM().format(date);
    return formattedDate;
  }

  getPercent() {
    if (event.level.toDouble() == 0) {
      return 0.0;
    } else {
      return event.level / 10 * 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color dimColor = const Color(0xFFC5C5C5);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Row(
            //   children: <Widget>[
            //     Expanded(
            //       child: Text(
            //         'test',
            //         style: TextStyle(
            //           fontSize: 13,
            //           color: dimColor,
            //         ),
            //       ),
            //     ),
            //     Text('10'
            //         // levelU
            //         //tils.formatDay(event.level,
            //         // withHms: true),
            //         // style: Theme.of(context)
            //         //     .textTheme
            //         //     .caption
            //         //     .copyWith(color: dimColor),
            //         )
            //   ],
            // ),
            // SizedBox(
            //   height: 4,
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                event.skill,
                style: TextStyle(
                    //     fontStyle: FontStyle.italic,
                    fontFamily: FontNameDefault,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: textBody1(context)),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            LinearPercentIndicator(
              width: MediaQuery.of(context).size.width * 0.8,
              backgroundColor: Colors.grey[100],
              //    lineHeight: 10.0,
              animation: true,
              animationDuration: 500,
              progressColor: Theme.of(context).primaryColor,
              linearStrokeCap: LinearStrokeCap.roundAll,
              //   fillColor: Theme.of(context).primaryColor,
              percent: getPercent(),
            ),
          ],
        ),
      ),
    );
  }
}
