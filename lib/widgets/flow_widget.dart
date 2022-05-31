import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../style.dart';

class FlowEvent {
  const FlowEvent(
      {@required this.company,
      @required this.designation,
      @required this.employmentType,
      @required this.industry,
      @required this.isPresent,
      @required this.startDate,
      @required this.endDate});

  final String company;
  final String designation;
  final String employmentType;
  final String industry;
  final bool isPresent;
  final int startDate;
  final int endDate;
}

@immutable
class FlowEventRow extends StatelessWidget {
  const FlowEventRow(this.event);

  final FlowEvent event;

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
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.0 - 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: 8.0,
              child: Container(
                margin: EdgeInsets.all(6.0),
                width: 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                // child: CircleAvatar(
                //   backgroundColor: Colors.white,
                //   radius: 2.0,
                // )
              ),
            ),
          ),
          Expanded(
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
                    event.designation,
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
                    event.company ?? '',
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
          ),
        ],
      ),
    );
  }
}
