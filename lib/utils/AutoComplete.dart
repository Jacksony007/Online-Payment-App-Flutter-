import 'package:flutter/material.dart';
import 'package:free_flutter_ui_kits/model/UniversityInfo.dart';

class AutocompleteOptionsWidget extends StatelessWidget {
  final List<UniversityInfo> options;
  final AutocompleteOnSelected<UniversityInfo> onSelected;

  const AutocompleteOptionsWidget({
    required this.options,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: SizedBox(
          height: 300.0,
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(), // Ensure scrollability
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final UniversityInfo option = options.elementAt(index);
              return GestureDetector(
                onTap: () {
                  onSelected(option);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(option.imagePath),
                    radius: 15,
                  ),
                  title: Text(option.name),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
