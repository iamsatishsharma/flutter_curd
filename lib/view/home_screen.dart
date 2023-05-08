
import 'package:flutter/material.dart';
import '../main.dart';
import '../sql_helper.dart';
import '../model/Persons.dart';

/*
//This class created by Satish Sharma
//Date: 07-05-2023
//Flutter Sqlite CRUD Operation works with Example code
 */

class MyHomePageState extends State<MyHomePage> {

  //Initialize the text fields for the operations
  var id = "";
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  List<Person> _journals = []; // Save the persons data
  bool _isLoading = true;

  // This function is used to fetch all data from the database
  void _refreshPersonLists() async {
    final data = await SQLHelper.getAllPersons();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  // Loading the data when the app starts
  @override
  void initState() {
    super.initState();
    _refreshPersonLists(); // Loading the data when the app starts
  }


//Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
          child: Text(
            widget.title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[_form(), _listTitle(), _personList()],
        ),
      ),
    );
  }

  //other state properties and Start Form filling
  final _formKey = GlobalKey<FormState>();

  _form() => Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
    child: Form(
      key: _formKey,
      child: Column(
        children: <Widget>[

          TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name';
                }}
          ),

          TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter age';
                }}
          ),

          TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter address';
                }}
          ),

          Container(
            margin: EdgeInsets.all(10.0),
            child: ElevatedButton (
              onPressed:() async {
                FocusManager.instance.primaryFocus?.unfocus();
                // Save new journal
                if (_formKey.currentState!.validate()) {
                  if( id == ""){
                    _addItem();
                  }else {
                    _updateItem(id);
                    id = "";
                  }
                }

                // Clear the text fields
                _nameController.text = '';
                _ageController.text = '';
                _addressController.text = '';
              }, child:Text('Submit'),
            ),

          ),
        ],
      ),
    ),
  );


//Person list title display here
  _listTitle() => Container( //apply margin and padding using Container Widget.
      padding: const EdgeInsets.all(10), //You can use EdgeInsets like above
      margin: const EdgeInsets.all(0),
      child: const Text('Person list display here',  style: TextStyle(
          color: darkBlueColor, fontWeight: FontWeight.bold, fontSize: 20))
  );

//Person list goes here
  _personList() => Expanded(
    child: Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      shape: const RoundedRectangleBorder( //<-- SEE HERE
        side: BorderSide(
          color: Colors.grey,
        ),
      ),

      child: Scrollbar(
        child: ListView.builder(
          padding: const EdgeInsets.all(5),
          itemBuilder: (context, index) {

            //List view title
            if(index == 0) {
              return Column(
                // The header
                children: <Widget> [ListTile(
                  leading: const Text('ID', style: TextStyle(fontWeight: FontWeight.bold),),
                  title: const Text('Name-(Age)', style: TextStyle(fontWeight: FontWeight.bold),),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: const [
                        Text('  Edit       ', style: TextStyle(fontWeight: FontWeight.bold),),
                        Text('Delete', style: TextStyle(fontWeight: FontWeight.bold),) ],),
                  ),
                ),
                  const Divider(height: 10.0, color: Colors.grey,),
                  _listItemDisplay(index)
                ],
              );
            }

            return Column(
              children: <Widget>[
                _listItemDisplay(index),
                Divider(height: 10.0,),
              ],
            );

          },
          itemCount: _journals.length,
        ),
      ),

    ),
  );

  // Item of the ListView
  Widget _listItemDisplay(index) {
    return Container(
      padding: const EdgeInsets.all(0),

      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black26))),
      child: ListTile(
        leading: Text(
          _journals[index].id.toString(),
          textAlign: TextAlign.left,
          style: const TextStyle(
              color: darkBlueColor, fontWeight: FontWeight.bold),
        ),

        title: Text(
          "${_journals[index].name} - (${_journals[index].age})",
          style: const TextStyle(
              color: darkBlueColor, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(_journals[index].address.toString()),

        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    //update the details
                    _nameController.text = _journals[index].name.toString();
                    _ageController.text = _journals[index].age.toString();
                    _addressController.text = _journals[index].address.toString();
                    id = _journals[index].id.toString();
                  }
              ),

              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () =>
                    _deleteItem(_journals[index].id.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Insert a new Person to the database
  Future<void> _addItem() async {

    Person person = Person(id:  (_journals.length + 1).toString(), name:  _nameController.text, age: _ageController.text, address: _addressController.text);

    await SQLHelper.insertPerson(person);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully added a record!'),
    ));

    _refreshPersonLists();
  }

  // Update an existing journal
  Future<void> _updateItem(String id) async {
    await SQLHelper.updatePerson(
        id, _nameController.text, _ageController.text, _addressController.text);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully updated a record!'),
    ));

    //Refresh the person list
    _refreshPersonLists();
  }


  // Delete an item
  void _deleteItem(String id) async {
    await SQLHelper.deletePerson(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));

    //Refresh the person list
    _refreshPersonLists();
  }
//=======================================END----------------------------------
}
