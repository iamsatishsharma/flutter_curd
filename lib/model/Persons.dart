
///created the Modal Class of Person and their respective functions as shown below
class Person {

   String? id;
   String? name;
   String? age;
   String? address;

   Person({ this.id,  this.name, this.age, this.address});


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

