/*
{
    "userId": 1,
    "id": 1,
    "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
    "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
  }
*/

class _EndpointVariables {
  const _EndpointVariables();
  String get userId => "userId";
  String get id => "id";
  String get title => "title";
  String get body => "body";
  String get amount => "amount";
}

class Transaction {
  static const endpointVariables = _EndpointVariables();

  num? userId;
  num? id;
  String? title;
  String? body;
  num amount;

  Transaction({
    this.userId,
    this.id,
    this.title,
    this.body,
    required this.amount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      userId: json[endpointVariables.userId],
      id: json[endpointVariables.id],
      title: json[endpointVariables.title],
      body: json[endpointVariables.body],
      amount: json[endpointVariables.amount] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      endpointVariables.userId: userId,
      endpointVariables.id: id,
      endpointVariables.title: title,
      endpointVariables.body: body,
      endpointVariables.amount: amount,
    };
    return map;
  }
}
