import 'package:flutter/material.dart';
import 'package:Yujai/pages/new_post_form.dart';

class NewPostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.95,
        child: Column(
          //shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, top: 12, left: 12, right: 12),
                  child: Text(
                    'New Post',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, top: 12, left: 12, right: 12),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            NewTaskForm()
          ],
        ),
      ),
    );
  }
}
