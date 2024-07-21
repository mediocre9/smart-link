import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_link/config/colors/app_colors.dart';
import 'package:smart_link/config/config.dart';

class KeysConfigurationScreen extends StatefulWidget {
  const KeysConfigurationScreen({super.key});

  @override
  KeysConfigurationScreenState createState() => KeysConfigurationScreenState();
}

enum RobotCommand {
  forward,
  backward,
  left,
  right,
  stop,
  cameraUp,
  cameraDown,
  cameraLeft,
  cameraRight,
  cameraStop,
}

class KeysConfigurationScreenState extends State<KeysConfigurationScreen> {
  late SharedPreferences _prefs;
  final Map<RobotCommand, String> _defaultCommands = {
    RobotCommand.stop: "X",
    RobotCommand.left: "L",
    RobotCommand.right: "R",
    RobotCommand.forward: "F",
    RobotCommand.backward: "B",
    RobotCommand.cameraUp: "W",
    RobotCommand.cameraStop: "0",
    RobotCommand.cameraDown: "S",
    RobotCommand.cameraLeft: "A",
    RobotCommand.cameraRight: "D",
  };

  @override
  void initState() {
    super.initState();
    _loadSharedPreferences();
  }

  Future<void> _loadSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SettingsTile _buildSettingsTile(RobotCommand command) {
    String commandString = command.toString().split('.').last;
    String title = commandString[0].toUpperCase() + commandString.substring(1);
    IconData icon;
    switch (command) {
      case RobotCommand.forward:
        icon = Icons.arrow_upward;
        break;
      case RobotCommand.backward:
        icon = Icons.arrow_downward;
        break;
      case RobotCommand.left:
        icon = Icons.arrow_back;
        break;
      case RobotCommand.right:
        icon = Icons.arrow_forward;
        break;
      case RobotCommand.stop:
        icon = Icons.stop;
        break;
      case RobotCommand.cameraUp:
        icon = Icons.arrow_upward;
        break;
      case RobotCommand.cameraDown:
        icon = Icons.arrow_downward;
        break;
      case RobotCommand.cameraLeft:
        icon = Icons.arrow_back;
        break;
      case RobotCommand.cameraRight:
        icon = Icons.arrow_forward;
        break;
      case RobotCommand.cameraStop:
        icon = Icons.stop;
        break;
    }

    return SettingsTile.navigation(
      title: Text(title),
      leading: Icon(
        icon,
        color: Colors.grey,
      ),
      onPressed: (BuildContext context) {
        _showDialog(context, command);
      },
    );
  }

  void _showDialog(BuildContext context, RobotCommand command) {
    String defaultValue = _defaultCommands[command]!;
    TextEditingController controller = TextEditingController(
      text: _prefs.getString(command.toString()) ?? defaultValue,
    );

    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(30),
          title: Text(command.toString().split('.').last),
          children: [
            TextField(
              decoration: const InputDecoration(hintText: "Enter Key"),
              controller: controller,
            ),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () {
                String enteredValue = controller.text.trim();
                if (enteredValue.isNotEmpty) {
                  _prefs.setString(command.toString(), enteredValue);
                } else {
                  _prefs.setString(command.toString(), defaultValue);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Keys Configuration"),
      ),
      body: SettingsList(
        darkTheme: const SettingsThemeData(
          settingsSectionBackground: AppColors.scaffold,
          settingsListBackground: AppColors.scaffold,
        ),
        sections: [
          SettingsSection(
            title: const Text('Robot Movement'),
            tiles: [
              _buildSettingsTile(RobotCommand.forward),
              _buildSettingsTile(RobotCommand.backward),
              _buildSettingsTile(RobotCommand.left),
              _buildSettingsTile(RobotCommand.right),
              _buildSettingsTile(RobotCommand.stop),
            ],
          ),
          SettingsSection(
            title: const Text('Camera'),
            tiles: [
              _buildSettingsTile(RobotCommand.cameraUp),
              _buildSettingsTile(RobotCommand.cameraDown),
              _buildSettingsTile(RobotCommand.cameraLeft),
              _buildSettingsTile(RobotCommand.cameraRight),
              _buildSettingsTile(RobotCommand.cameraStop),
            ],
          ),
        ],
      ),
    );
  }
}
