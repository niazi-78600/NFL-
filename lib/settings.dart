import 'package:flutter/material.dart';
class SettingsDialog extends StatelessWidget {
  final Brightness brightness;
  final bool enableNotifications;
  final bool enableSound;
  final ValueChanged<Brightness?> onBrightnessChanged; // Update the callback type
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<bool> onSoundChanged;

  const SettingsDialog({
    Key? key,
    required this.brightness,
    required this.enableNotifications,
    required this.enableSound,
    required this.onBrightnessChanged,
    required this.onNotificationsChanged,
    required this.onSoundChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Settings"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Theme"),
          ListTile(
            title: Text("Light"),
            leading: Radio(
              value: Brightness.light,
              groupValue: brightness,
              onChanged: (value) => onBrightnessChanged(Brightness.light), // Ensure non-null value
            ),
          ),
          ListTile(
            title: Text("Dark"),
            leading: Radio(
              value: Brightness.dark,
              groupValue: brightness,
              onChanged: (value) => onBrightnessChanged(Brightness.dark), // Ensure non-null value
            ),
          ),
          Divider(),
          Text("Notifications"),
          SwitchListTile(
            title: Text("Enable Notifications"),
            value: enableNotifications,
            onChanged: onNotificationsChanged,
          ),
          SwitchListTile(
            title: Text("Enable Sound"),
            value: enableSound,
            onChanged: onSoundChanged,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Close"),
        ),
      ],
    );
  }
}