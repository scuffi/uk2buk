import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/language/language_enum.dart';
import '../../providers/language/language_provider.dart';

class LanguageSwitch extends StatefulWidget {
  const LanguageSwitch({Key? key}) : super(key: key);

  @override
  State<LanguageSwitch> createState() => _LanguageSwitchState();
}

class _LanguageSwitchState extends State<LanguageSwitch> {
  bool positive = true;
  @override
  Widget build(BuildContext context) {
    // return AnimatedToggleSwitch<bool>.dual(
    //   current: positive,
    //   first: false,
    //   second: true,
    //   dif: 0.0,
    //   borderColor: Colors.transparent,
    //   borderWidth: 5.0,
    //   // height: 30,
    //   boxShadow: const [
    //     BoxShadow(
    //       color: Colors.black26,
    //       spreadRadius: 1,
    //       blurRadius: 2,
    //       offset: Offset(0, 1.5),
    //     ),
    //   ],
    //   onChanged: (b) => setState(() => positive = b),
    //   iconBuilder: (value) =>
    //       value ? Flag.fromCode(FlagsCode.GB) : Flag.fromCode(FlagsCode.UA),
    // );

    return AnimatedToggleSwitch<bool>.rolling(
      current: Provider.of<Language>(context).language == LanguageType.en,
      values: const [true, false],
      onTap: () async {
        setState(() {
          positive = !positive;
        });
        Provider.of<Language>(context, listen: false)
            .setLang(positive ? LanguageType.en : LanguageType.uk);

        // Add to storage so it saves on restart
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString(
            "language", positive ? LanguageType.en.name : LanguageType.uk.name);
      },
      onChanged: (i) async {
        setState(() {
          positive = i;
        });
        Provider.of<Language>(context, listen: false)
            .setLang(positive ? LanguageType.en : LanguageType.uk);

        // Add to storage so it saves on restart
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString(
            "language", positive ? LanguageType.en.name : LanguageType.uk.name);
      },
      iconBuilder: (lang, size, foreGround) {
        return Padding(
          padding: EdgeInsets.all(foreGround ? 2.0 : 5.0),
          child: Container(
            child: Flag.fromCode(
              lang ? FlagsCode.GB : FlagsCode.UA,
              borderRadius: 32,
              flagSize: FlagSize.size_1x1,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: foreGround
                    ? Border.all(color: Colors.indigoAccent[100]!, width: 4)
                    : const Border()),
          ),
        );
      },
      colorBuilder: (i) => Colors.transparent,
      borderColor: Colors.transparent,
      innerColor: Colors.black.withOpacity(0.1),
    );
  }
}
