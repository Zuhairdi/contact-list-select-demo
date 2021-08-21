import 'package:contact_list_demo/ContactListDialog.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contact> mList = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView.builder(
            itemCount: mList.length,
            itemBuilder: (_, index) {
              Contact data = mList[index];
              return ListTile(
                title: Text('${data.displayName}'),
                subtitle: Text('${data.phones?.first.value}'),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            //check for permission
            bool permission = await Permission.contacts.isGranted;
            if (!permission) {
              PermissionStatus status = await Permission.contacts.request();
              if (status.isDenied) return;
            }
            //if permission is granted, retrieve contact list from the phone and put it in displayed dialog
            Iterable<Contact> myContacts = await ContactsService.getContacts();
            showContactDialog(
              context: context,
              mContacts: myContacts,
              //onSelectContact is to retrieve the item of choice to the current page
              onSelectContact: (selection) {
                setState(() {
                  //add the contact to the list
                  mList.add(selection);
                });
              },
            );
          },
          child: Icon(
            Icons.contact_phone,
            color: Colors.black45,
          ),
        ),
      ),
    );
  }
}
