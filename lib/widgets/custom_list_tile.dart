import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
ListTile ListTileMethod(
    {required BuildContext context, required String titlee, Widget? sayfa, String? subTitlee, required IconData icon}) {
  return ListTile(
    dense: true,
    leading: Icon(
      icon,
      color: Colors.amber,
    ),
    title: Text(
      titlee,
      style: TextStyle(color: Colors.white, fontSize: 20)
    ),
    subtitle: subTitlee != null
        ? Text(
            subTitlee,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          )
        : null,
    onTap: () {
      sayfa != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => sayfa,
              ))
          : null;
    },
  );
}
