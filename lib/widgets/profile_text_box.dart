import 'package:flutter/material.dart';

class ProfileTextBox extends StatefulWidget {
  final String text;
  final String sectionName;
  void Function()? onPressed;
  ProfileTextBox(
      {super.key,
      required this.text,
      required this.sectionName,
      required this.onPressed});

  @override
  State<ProfileTextBox> createState() => _ProfileTextBoxState();
}

class _ProfileTextBoxState extends State<ProfileTextBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 15, bottom: 15),
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade200,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // section name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.sectionName,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey)),
                // edit button
                IconButton(
                    onPressed: widget.onPressed,
                    icon: const Icon(Icons.edit, color: Colors.grey)),
              ],
            ),

            // text
            Text(widget.text),
          ],
        ));
  }
}
