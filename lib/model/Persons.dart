
///created the Modal Class of Person and their respective functions as shown below
class Person {

   final String? id;
   final String? name;
   final String? age;
   final String? address;

   const Person({ this.id,  this.name, this.age, this.address});

  //Alternate way to use model by const.
  //const Person({ this.id,  this.name, this.age, this.address,  this.description});

  factory Person.fromMap(Map<String, dynamic> json) =>
      Person(id: json["id"], name: json["name"], age: json["age"], address: json["address"]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'address': address,
    };
  }
}

