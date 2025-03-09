import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Utility {
  static final Utility _singleton = Utility._internal();

  factory Utility() {
    return _singleton;
  }
  Utility._internal();


  static void showDeleteDialog({required BuildContext context, required Function onPositiveClick})  {
    showGeneralDialog(
      context: context,

      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: AlertDialog(
            title: const Center(child: Text(" Logout",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
            content: const Text("Are you want to sure logout ?",textAlign: TextAlign.center),
            actions: [
              TextButton(
                child: const Text("No"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text("Yes"),
                onPressed: () {
                  onPositiveClick.call();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }


}