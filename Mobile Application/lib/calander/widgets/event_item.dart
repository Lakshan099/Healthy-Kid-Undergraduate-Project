import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/event.dart';

class EventItem extends StatelessWidget {
  final Event event;
  final Function() onDelete;
  final Function()? onTap;
  const EventItem({
    Key? key,
    required this.event,
    required this.onDelete,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        event.title,
      ),
      subtitle: Text(DateFormat("EEEE, dd MMMM, yyyy").format(event.date),
      ),
      onTap: onTap,
    );
  }
}
