class UserModel {
  final int ?id;                          
  final String ? name;                         
  final String? username;                         
  final String? email;                            
  final Address? address;                         
  final String ?phone;                           
  final String ?website;                          
  final Company ?company;                         

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
  });

  // Convert UserModel instance to a map 
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'address': address!.toMap(),
      'phone': phone,
      'website': website,
      'company': company!.toMap(),
    };
  }

  // Create a UserModel instance from a map 
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      email: map['email'],
      address: Address.fromMap(map['address']),
      phone: map['phone'],
      website: map['website'],
      company: Company.fromMap(map['company']),
    );
  }
}

// Address model to represent user's address details
class Address {
  final String street;     
  final String suite;      
  final String city;       
  final String zipcode;   
  final Geo geo;           

  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'suite': suite,
      'city': city,
      'zipcode': zipcode,
      'geo': geo.toMap(),
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street: map['street'],
      suite: map['suite'],
      city: map['city'],
      zipcode: map['zipcode'],
      geo: Geo.fromMap(map['geo']),
    );
  }
}

// Geo model
class Geo {
  final String lat;    
  final String lng;     

  Geo({
    required this.lat,
    required this.lng,
  });

  // Convert Geo instance to a map
  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }

  factory Geo.fromMap(Map<String, dynamic> map) {
    return Geo(
      lat: map['lat'],
      lng: map['lng'],
    );
  }
}

// Company model
class Company {
  final String name;          
  final String catchPhrase;  
  final String bs;            

  Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'catchPhrase': catchPhrase,
      'bs': bs,
    };
  }

  // Create Company instance from a map
  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      name: map['name'],
      catchPhrase: map['catchPhrase'],
      bs: map['bs'],
    );
  }
}
