import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_kid_app/calander/screens/edit_event.dart';
import 'package:healthy_kid_app/components/NavBar.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/event.dart';
import '../widgets/event_item.dart';
import 'add_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Calander extends StatefulWidget {
  const Calander({super.key});

  @override
  State<Calander> createState() => _CalanderState();
}

class _CalanderState extends State<Calander> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List<Event>> _events;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _loadFirestoreEvents();
  }

  _loadFirestoreEvents() async {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    _events = {};

    final snap = await FirebaseFirestore.instance
        .collection('events')
        .where('date', isGreaterThanOrEqualTo: firstDay)
        .where('date', isLessThanOrEqualTo: lastDay)
        .withConverter(
            fromFirestore: Event.fromFirestore,
            toFirestore: (event, options) => event.toFirestore())
        .get();
    for (var doc in snap.docs) {
      final event = doc.data();
      final day =
          DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (_events[day] == null) {
        _events[day] = [];
      }
      _events[day]!.add(event);
    }
    setState(() {});
  }

  List<Event> _getEventsForTheDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          AppLocalizations.of(context)!.upcome,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 205, 130),
      ),
      body: ListView(
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.all(8.0),
            child: TableCalendar(
              eventLoader: _getEventsForTheDay,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              focusedDay: _focusedDay,
              firstDay: _firstDay,
              lastDay: _lastDay,
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
                _loadFirestoreEvents();
              },
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              onDaySelected: (selectedDay, focusedDay) {
                print(_events[selectedDay]);
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: const CalendarStyle(
                weekendTextStyle: TextStyle(
                  color: Colors.red,
                ),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.red,
                ),
              ),
              headerStyle: HeaderStyle(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 205, 130),
                  ),
                  headerMargin: const EdgeInsets.only(bottom: 8.0)),
            ),
          ),
          ..._getEventsForTheDay(_selectedDay).map(
            (event) => EventItem(
                event: event,
                onTap: () async {
                  final res = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditEvent(
                          firstDate: _firstDay,
                          lastDate: _lastDay,
                          event: event),
                    ),
                  );
                  if (res ?? false) {
                    _loadFirestoreEvents();
                  }
                },
                onDelete: () async {
                  final delete = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Delete Event?"),
                      content: const Text("Are you sure you want to delete?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                          child: const Text("No"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  );
                  if (delete ?? false) {
                    await FirebaseFirestore.instance
                        .collection('events')
                        .doc(event.id)
                        .delete();
                    _loadFirestoreEvents();
                  }
                }),
          ),
        ],
      ),
    );
  }
}
