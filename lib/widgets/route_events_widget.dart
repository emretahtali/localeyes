import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RouteEventsWidget extends StatelessWidget {
  final List<String> events;
  final double height, width;
  const RouteEventsWidget(
      {super.key,
      required this.events,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
      child: Column(
        children:
            events.map((event) => _buildEventCard(event, context)).toList(),
      ),
    );
  }

  Widget _buildEventCard(String event, BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 50, minHeight: 20),
      child: Row(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.blueAccent,
                  ),
                ),
                Container(
                  width: 25,
                  height: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.blueAccent),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            );
          }),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
            child: Text(
              event,
              maxLines: 10,
              style: TextTheme.of(context).bodyMedium,
            ),
          ))
        ],
      ),
    );
  }
}
