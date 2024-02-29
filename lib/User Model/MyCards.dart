class MyCardsModel {
  String? accountname = "";
  String? bankname = "";
  String? accountNumber = "";
  String? expireDate = "";
  String? dateLinked = "";
  String? imagePath = "";

  MyCardsModel(
      {this.accountname,
      this.bankname,
      this.accountNumber,
      this.expireDate,
      this.dateLinked,
      this.imagePath});
}

List<MyCardsModel> bankingCardList() {
  List<MyCardsModel> list = [];
  var list1 = MyCardsModel(
      accountname: "Jackson Smith",
      bankname: "Absa Bank Ghana",
      accountNumber: "123456789087",
      expireDate: "01/27",
      dateLinked: '10/Jan/2024',
      imagePath: "images/banking/AbsaBank.png");
  list.add(list1);

  var list2 = MyCardsModel(
      accountname: "Adam Johnson",
      bankname: "Union Bank",
      accountNumber: "098765432123",
      dateLinked: '10/Jan/2024',
      expireDate: "06/27");
  list.add(list2);

  var list3 = MyCardsModel(
      accountname: "Ana Willson",
      bankname: "Unitied States Bank",
      accountNumber: "098765432123",
      dateLinked: '10/Jan/2024',
      expireDate: "01/27");
  list.add(list3);

  return list;
}
