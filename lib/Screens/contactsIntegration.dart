import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsIntegration extends StatefulWidget {
  const ContactsIntegration({super.key});

  @override
  State<ContactsIntegration> createState() => _ContactsIntegrationState();
}

class _ContactsIntegrationState extends State<ContactsIntegration> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  TextEditingController searchContactController = TextEditingController();
  void initState() {
    super.initState();
    _getPermisionsData();
  }

  _getPermisionsData() async {
    bool isAllowed = await _getPermisions();
    if (isAllowed) {
      _getContacts();
    }
  }

  Future<bool> _getPermisions() async {
    PermissionStatus permissionStatus = await Permission.contacts.status;
    if (permissionStatus.isGranted) {
      return true;
    } else {
      permissionStatus = await Permission.contacts.request();
      if (permissionStatus.isGranted) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<void> _getContacts() async {
    final contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts.toList();
    });
  }

  void _onSearchTextChanged(String searchText) {
    _filteredContacts = _contacts.where((contact) {
      return contact.displayName!
          .toLowerCase()
          .contains(searchText.toLowerCase());
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts Integration"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchContactController,
              onChanged: _onSearchTextChanged,
              decoration: InputDecoration(
                hintText: 'Search contacts',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                return ListTile(
                  title: Text(contact.displayName!),
                  subtitle: Text(contact.phones!.first.value!),
                  leading: CircleAvatar(
                    child: Text(contact.initials()),
                  ),
                  onTap: () {
                    searchContactController.text =
                        _filteredContacts[index].displayName!;
                    print(_filteredContacts[index].displayName);
                    _filteredContacts.clear();
                    setState(() {});
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
