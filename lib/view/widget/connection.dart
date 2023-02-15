import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class ConnectionWidget extends StatelessWidget {
  final Widget widget;

  ConnectionWidget({required this.widget});

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder:
          (BuildContext context, ConnectivityResult connection, Widget child) {
        final bool connected = connection!= ConnectivityResult.none;
        print(connected);
        return connected?  widget : Center(child: Text('no internet'),);
      },
      child: Container(),
    );
  }
}
