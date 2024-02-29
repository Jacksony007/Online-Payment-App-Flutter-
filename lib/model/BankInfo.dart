class BankInfo {
  final String name;
  final String logoPath;

  BankInfo(this.name, this.logoPath);
}

class BankList {
  static List<BankInfo> getBanks() {
    return [
      BankInfo('Access Bank Ghana Plc', "images/banking/Accessbank.jpg"),
      BankInfo('Absa bank Ghana Plc', 'images/banking/AbsaBank.jpg'),
      BankInfo('Ghana commercial bank plc',
          "images/banking/GhanaCommercialBank.jpg"),
      BankInfo('National investment bank',
          "images/banking/NationalInvestimentBank.jpg"),
      BankInfo('Consolidated Bank of Ghana',
          "images/banking/Consolidated Bank of Ghana.jpg"),
    ];
  }
}

class OtherBank {
  static List<BankInfo> otherbanks() {
    return [
      BankInfo('Absa bank Ghana Plc', 'images/banking/AbsaBank.jpg'),
      BankInfo('Ghana commercial bank plc',
          "images/banking/GhanaCommercialBank.jpg"),
      BankInfo('National investment bank',
          "images/banking/NationalInvestimentBank.jpg"),
      BankInfo('Consolidated Bank of Ghana',
          "images/banking/Consolidated Bank of Ghana.jpg"),
    ];
  }
}
