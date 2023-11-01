import 'package:catan_app/screens/boards/base_game.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';


class MainMenuScreen extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    page({required Widget child}) => Styled.widget(child: child)
        .padding(vertical: 30, horizontal: 20)
        .constrained(minHeight: MediaQuery.of(context).size.height - (2 * 30))
        .scrollable();

    return <Widget>[
        const Text(
          'Catan Board Shuffler',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40,color: Colors.teal),
        ).alignment(Alignment.center).padding(bottom: 20),
        Settings(navigator: Navigator.of(context)),
      ].toColumn().parent(page);
  }
}




class SettingsItemModel {
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const SettingsItemModel({
    required this.color,
    required this.description,
    required this.icon,
    required this.title,
  });
}

 List<SettingsItemModel> settingsItems = [
  const SettingsItemModel(
    icon: Icons.location_on,
    color: Color(0xff8D7AEE),
    title: 'Base Game',
    description: 'Base version of the Catan Game board generator',
  ),
];

class Settings extends StatelessWidget {
  final NavigatorState navigator;

  const Settings({required this.navigator});

  @override
  Widget build(BuildContext context) => settingsItems
      .map((settingsItem) => SettingsItem(
            settingsItem.icon,
            settingsItem.color,
            settingsItem.title,
            settingsItem.description,
            (){
              if (settingsItem.title == 'Base Game')
              {
                navigator.push(MaterialPageRoute(builder: (context) => BaseGame()));
              }
            }
          ))
      .toList()
      .toColumn();
}

class SettingsItem extends StatefulWidget {
  const SettingsItem(this.icon, this.iconBgColor, this.title, this.description,this.onTap, {super.key});

  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  _SettingsItemState createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    settingsItem({required Widget child}) => Styled.widget(child: child)
        .alignment(Alignment.center)
        .borderRadius(all: 15)
        .ripple()
        .backgroundColor(Colors.white, animate: true)
        .clipRRect(all: 25) // clip ripple
        .borderRadius(all: 25, animate: true)
        .elevation(
          pressed ? 0 : 20,
          borderRadius: BorderRadius.circular(25),
          shadowColor: const Color(0x30000000),
        ) // shadow borderRadius
        .constrained(height: 80)
        .padding(vertical: 12) // margin
        .gestures(
          onTapChange: (tapStatus) => setState(() => pressed = tapStatus),
          onTap: widget.onTap,
        )
        .scale(all:pressed?0.95:1 ,animate:true)
        .animate(const Duration(milliseconds: 150), Curves.easeOut);

    final Widget icon = Icon(widget.icon, size: 20, color: Colors.white)
        .padding(all: 12)
        .decorated(
          color: widget.iconBgColor,
          borderRadius: BorderRadius.circular(30),
        )
        .padding(left: 15, right: 10);

    final Widget title = Text(
      widget.title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ).padding(bottom: 5);

    final Widget description = Text(
      widget.description,
      style: const TextStyle(
        color: Colors.black26,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );

    return settingsItem(
      child: <Widget>[
        icon,
        <Widget>[
          title,
          description,
        ].toColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ].toRow(),
    );
  }
}