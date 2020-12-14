import 'package:youtube_darker/common/colors.dart';
import 'package:youtube_darker/models/user-lifecycle-models/ui-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppSearch extends SearchDelegate<dynamic> {
  List dummySuggestions = [
    'Adeola',
    'Mike',
    'Malcom',
    'Steph',
    'Steph',
    'Steph',
    'Steph',
    'Steph',
    'Steph',
    'Steph',
    'Steph',
    'Steph',
    'Steph',
    'Steph',
    'Steph',
  ];
  @override
  String get searchFieldLabel => 'Search';

  @override
  TextStyle get searchFieldStyle => TextStyle(
        color: iconColor,
        fontSize: 18.0,
      );
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      textTheme: TextTheme(
        headline6: TextStyle(
          color: textColor,
          fontSize: 18.0,
        ),
      ),
      primaryIconTheme: IconThemeData(color: backgroundColor),
      primaryColor: backgroundColor,
      primaryColorBrightness: Brightness.dark,
    );
  }

  ScrollController scrollController = ScrollController();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      CupertinoButton(
        child: Icon(
          Icons.clear,
          color: iconColor,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Consumer<UIModel>(
      builder: (context, uiModel, _) {
        return CupertinoButton(
          child: Icon(
            Icons.arrow_back_sharp,
            color: iconColor,
          ),
          onPressed: () {
            uiModel.navBarHeight = 50;
            FocusScope.of(context).requestFocus(new FocusNode());
            close(context, null);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(color: backgroundColor);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return GestureDetector(
      onHorizontalDragDown: (_) {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        color: backgroundColor,
        child: Scrollbar(
          controller: scrollController,
          child: ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 0.0, bottom: 4.0, top: 5.0),
              child: ListTile(
                onTap: () {},
                title: Text(
                  dummySuggestions[index],
                ),
                trailing: Icon(Icons.call_made_sharp, color: iconColor),
                // leading: Icon(Icons.star_sharp, color: iconColor),
              ),
            ),
            itemCount: dummySuggestions.length,
          ),
        ),
      ),
    );
  }
}
