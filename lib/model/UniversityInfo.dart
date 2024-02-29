class UniversityInfo {
  final String name;
  final String imagePath;
  final String accountNumber;
  final String location;

  UniversityInfo(this.name, this.imagePath, this.accountNumber, this.location );
}

class UniversityList {
  static List<UniversityInfo> getUniversities() {
    return [
      UniversityInfo('University of Ghana (UG)', "images/banking/Banking_ic_messenger.png", '12345', 'Accra'),
      UniversityInfo('University of Cape Coast (UCC)', "images/banking/Banking_ic_Inst.png", '6789', 'East Accra'),
      UniversityInfo(
        'Kwame Nkrumah University of Science and Technology (KNUST)',
          "images/banking/Banking_ic_user2.jpg", '09876', 'Agonna'
      ),
      UniversityInfo('Pentecost University', "images/banking/Banking_ic_Skype.png", '54321', 'North Ghana'),
      UniversityInfo('Mampong College of Education', "images/banking/Banking_ic_Inst.png", '87654', 'Mompong'),
      UniversityInfo(
        "St. Monica's College of Education",
        "images/banking/Banking_ic_Inst.png", '346954','West Ghana'
      ),
      UniversityInfo('Others', "images/banking/AbsaBank.png", '23452','Other'),
    ];
  }
}
