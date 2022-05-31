import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../style.dart';

class FlowEducation {
  const FlowEducation(
      {@required this.university,
      @required this.degree,
      @required this.field,
      @required this.isPresent,
      @required this.startDate,
      @required this.endDate});

  final String university;
  final String degree;
  final String field;
  final bool isPresent;
  final int startDate;
  final int endDate;
}

@immutable
class FlowEducationRow extends StatelessWidget {
  const FlowEducationRow(this.event);

  final FlowEducation event;

  convertDate(int timeinMilis) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeinMilis);
    var formattedDate = DateFormat.yMMM().format(date);
    return formattedDate;
  }

  checkPresentDate(bool isPresent, int milis) {
    if (isPresent) {
      return 'Present';
    } else {
      return convertDate(milis);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 15),
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
            //         // startDateU
            //         //tils.formatDay(event.startDate,
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
            Text(
              event.degree,
              style: TextStyle(
                  //     fontStyle: FontStyle.italic,
                  fontFamily: FontNameDefault,
                  //      color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: textBody1(context)),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              event.university ?? '',
              style: TextStyle(
                  // fontStyle: FontStyle.italic,
                  fontFamily: FontNameDefault,
                  // color: Colors.grey,
                  fontSize: textBody1(context)),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              '${convertDate(event.startDate)} - ${checkPresentDate(event.isPresent, event.endDate)}',
              style: TextStyle(
                //     fontStyle: FontStyle.italic,
                fontFamily: FontNameDefault,
                color: Colors.grey,
                //fontSize: textBody1(context)
              ),
            )
          ],
        ),
      ),
    );
  }
}
