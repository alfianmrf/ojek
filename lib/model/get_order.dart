class GetOrderUser {
  late Order order;
  late List<String> driverUuid;

  GetOrderUser({required this.order, required this.driverUuid});

  GetOrderUser.fromJson(Map<String, dynamic> json) {
    order = (json['order'] != null ? new Order.fromJson(json['order']) : null)!;
    driverUuid = json['driver_uuid'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.order != null) {
      data['order'] = this.order.toJson();
    }
    data['driver_uuid'] = this.driverUuid;
    return data;
  }
}

class Order {
  late int customerId;
  late String customerName;
  late Null driverId;
  late int fee;
  late double pickupLat;
  late double pickupLong;
  late double destinationLat;
  late double destinationLong;
  late String destinationAddress;
  late String updatedAt;
  late String createdAt;
  late int id;

  Order(
      {required this.customerId,
      required this.customerName,
      this.driverId,
      required this.fee,
      required this.pickupLat,
      required this.pickupLong,
      required this.destinationLat,
      required this.destinationLong,
      required this.destinationAddress,
      required this.updatedAt,
      required this.createdAt,
      required this.id});

  Order.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    driverId = json['driver_id'];
    fee = json['fee'];
    pickupLat = json['pickup_lat'];
    pickupLong = json['pickup_long'];
    destinationLat = json['destination_lat'];
    destinationLong = json['destination_long'];
    destinationAddress = json['destination_address'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['driver_id'] = this.driverId;
    data['fee'] = this.fee;
    data['pickup_lat'] = this.pickupLat;
    data['pickup_long'] = this.pickupLong;
    data['destination_lat'] = this.destinationLat;
    data['destination_long'] = this.destinationLong;
    data['destination_address'] = this.destinationAddress;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
