enum SettingType {
  group(0),
  select(1),
  multiselect(2),
  toggle(3),
  stepper(4),
  segment(5),
  text(6),
  button(7),
  link(8),
  login(9),
  page(10),
  editableList(11),
  custom(12),
  picker(13);

  const SettingType(this.value);
  final int value;

  static SettingType fromValue(int val) {
    for (final t in values) {
      if (t.value == val) return t;
    }
    return SettingType.custom;
  }

  static SettingType fromName(String name) {
    switch (name) {
      case 'group':
        return SettingType.group;
      case 'select':
        return SettingType.select;
      case 'multi-select':
        return SettingType.multiselect;
      case 'switch':
      case 'toggle':
        return SettingType.toggle;
      case 'stepper':
        return SettingType.stepper;
      case 'segment':
        return SettingType.segment;
      case 'text':
        return SettingType.text;
      case 'button':
        return SettingType.button;
      case 'link':
        return SettingType.link;
      case 'login':
        return SettingType.login;
      case 'page':
        return SettingType.page;
      case 'editable-list':
        return SettingType.editableList;
      case 'picker':
        return SettingType.picker;
      case 'custom':
      default:
        return SettingType.custom;
    }
  }
}

sealed class SettingValue {
  const SettingValue();
  SettingType get type;
}

class GroupSetting extends SettingValue {
  const GroupSetting({this.footer, required this.items});
  final String? footer;
  final List<Setting> items;
  @override
  SettingType get type => SettingType.group;
}

class SelectSetting extends SettingValue {
  const SelectSetting({
    required this.values,
    this.titles,
    this.authToOpen,
    this.defaultValue,
  });
  final List<String> values;
  final List<String>? titles;
  final bool? authToOpen;
  final String? defaultValue;
  @override
  SettingType get type => SettingType.select;
}

class MultiSelectSetting extends SettingValue {
  const MultiSelectSetting({
    required this.values,
    this.titles,
    this.authToOpen,
    this.defaultValue,
  });
  final List<String> values;
  final List<String>? titles;
  final bool? authToOpen;
  final List<String>? defaultValue;
  @override
  SettingType get type => SettingType.multiselect;
}

class ToggleSetting extends SettingValue {
  const ToggleSetting({
    this.subtitle,
    this.authToDisable,
    this.defaultValue = false,
  });
  final String? subtitle;
  final bool? authToDisable;
  final bool defaultValue;
  @override
  SettingType get type => SettingType.toggle;
}

class StepperSetting extends SettingValue {
  const StepperSetting({
    required this.minimumValue,
    required this.maximumValue,
    this.stepValue,
    this.defaultValue,
  });
  final double minimumValue;
  final double maximumValue;
  final double? stepValue;
  final double? defaultValue;
  @override
  SettingType get type => SettingType.stepper;
}

class SegmentSetting extends SettingValue {
  const SegmentSetting({required this.options, this.defaultValue});
  final List<String> options;
  final int? defaultValue;
  @override
  SettingType get type => SettingType.segment;
}

class TextSetting extends SettingValue {
  const TextSetting({
    this.placeholder,
    this.autocapitalizationType,
    this.keyboardType,
    this.returnKeyType,
    this.autocorrectionDisabled = false,
    this.secure = false,
    this.defaultValue,
  });
  final String? placeholder;
  final int? autocapitalizationType;
  final int? keyboardType;
  final int? returnKeyType;
  final bool autocorrectionDisabled;
  final bool secure;
  final String? defaultValue;
  @override
  SettingType get type => SettingType.text;
}

class ButtonSetting extends SettingValue {
  const ButtonSetting({
    this.destructive = false,
    this.confirmTitle,
    this.confirmText,
  });
  final bool destructive;
  final String? confirmTitle;
  final String? confirmText;
  @override
  SettingType get type => SettingType.button;
}

class LinkSetting extends SettingValue {
  const LinkSetting({required this.url, this.external});
  final String url;
  final bool? external;
  @override
  SettingType get type => SettingType.link;
}

enum LoginMethod { basic, oauth, web }

class LoginSetting extends SettingValue {
  const LoginSetting({
    required this.method,
    this.url,
    this.urlKey,
    this.logoutTitle,
    this.pkce = false,
    this.tokenUrl,
    this.callbackScheme,
    this.useEmail,
    this.localStorageKeys,
    this.clearCookiesOnLogOut = false,
  });
  final LoginMethod method;
  final String? url;
  final String? urlKey;
  final String? logoutTitle;
  final bool pkce;
  final String? tokenUrl;
  final String? callbackScheme;
  final bool? useEmail;
  final List<String>? localStorageKeys;
  final bool clearCookiesOnLogOut;
  @override
  SettingType get type => SettingType.login;
}

class PageSetting extends SettingValue {
  const PageSetting({
    required this.items,
    this.inlineTitle = false,
    this.authToOpen = false,
    this.icon,
    this.info,
  });
  final List<Setting> items;
  final bool inlineTitle;
  final bool authToOpen;
  final String? icon;
  final String? info;
  @override
  SettingType get type => SettingType.page;
}

class EditableListSetting extends SettingValue {
  const EditableListSetting({
    this.lineLimit,
    this.inline = false,
    this.placeholder,
    this.defaultValue,
  });
  final int? lineLimit;
  final bool inline;
  final String? placeholder;
  final List<String>? defaultValue;
  @override
  SettingType get type => SettingType.editableList;
}

class PickerSetting extends SettingValue {
  const PickerSetting({
    required this.values,
    this.titles,
    this.defaultValue,
  });
  final List<String> values;
  final List<String>? titles;
  final String? defaultValue;
  @override
  SettingType get type => SettingType.picker;
}

class CustomSetting extends SettingValue {
  const CustomSetting();
  @override
  SettingType get type => SettingType.custom;
}

class Setting {
  Setting({
    this.key = '',
    this.title = '',
    this.notification,
    this.requires,
    this.requiresFalse,
    this.refreshes = const [],
    required this.value,
  });

  String key;
  String title;
  String? notification;
  String? requires;
  String? requiresFalse;
  List<String> refreshes;
  SettingValue value;

  factory Setting.fromJson(Map<String, dynamic> json) {
    final typeStr = (json['type'] as String?) ?? 'group';
    final type = SettingType.fromName(typeStr);
    final key = (json['key'] as String?) ?? '';
    final title = (json['title'] as String?) ?? '';
    final notification = json['notification'] as String?;
    final requires = json['requires'] as String?;
    final requiresFalse = json['requiresFalse'] as String?;
    final refreshes =
        (json['refreshes'] as List?)?.map((e) => e.toString()).toList() ??
        const [];

    final SettingValue settingVal;
    switch (type) {
      case SettingType.group:
        final footer = json['footer'] as String?;
        final rawItems = json['items'] as List? ?? [];
        final items = rawItems
            .map((e) => Setting.fromJson(e as Map<String, dynamic>))
            .toList();
        settingVal = GroupSetting(footer: footer, items: items);
        break;
      case SettingType.select:
        final vals =
            (json['values'] as List?)?.map((e) => e.toString()).toList() ?? [];
        final titles =
            (json['titles'] as List?)?.map((e) => e.toString()).toList();
        final auth = json['authToOpen'] as bool?;
        final defVal = json['default']?.toString();
        settingVal = SelectSetting(
          values: vals,
          titles: titles,
          authToOpen: auth,
          defaultValue: defVal,
        );
        break;
      case SettingType.multiselect:
        final vals =
            (json['values'] as List?)?.map((e) => e.toString()).toList() ?? [];
        final titles =
            (json['titles'] as List?)?.map((e) => e.toString()).toList();
        final auth = json['authToOpen'] as bool?;
        final defVal =
            (json['default'] as List?)?.map((e) => e.toString()).toList();
        settingVal = MultiSelectSetting(
          values: vals,
          titles: titles,
          authToOpen: auth,
          defaultValue: defVal,
        );
        break;
      case SettingType.toggle:
        final subtitle = json['subtitle'] as String?;
        final auth = json['authToDisable'] as bool?;
        final defVal = (json['default'] as bool?) ?? false;
        settingVal = ToggleSetting(
          subtitle: subtitle,
          authToDisable: auth,
          defaultValue: defVal,
        );
        break;
      case SettingType.stepper:
        final min = (json['minimumValue'] as num?)?.toDouble() ?? 0.0;
        final max = (json['maximumValue'] as num?)?.toDouble() ?? 100.0;
        final step = (json['stepValue'] as num?)?.toDouble();
        final defVal = (json['default'] as num?)?.toDouble();
        settingVal = StepperSetting(
          minimumValue: min,
          maximumValue: max,
          stepValue: step,
          defaultValue: defVal,
        );
        break;
      case SettingType.segment:
        final opts =
            (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [];
        final defVal = (json['default'] as num?)?.toInt();
        settingVal = SegmentSetting(options: opts, defaultValue: defVal);
        break;
      case SettingType.text:
        final placeholder = json['placeholder'] as String?;
        final autocap = (json['autocapitalizationType'] as num?)?.toInt();
        final keyboard = (json['keyboardType'] as num?)?.toInt();
        final returnKey = (json['returnKeyType'] as num?)?.toInt();
        final autocorrect = (json['autocorrectionDisabled'] as bool?) ?? false;
        final secure = (json['secure'] as bool?) ?? false;
        final defVal = json['default']?.toString();
        settingVal = TextSetting(
          placeholder: placeholder,
          autocapitalizationType: autocap,
          keyboardType: keyboard,
          returnKeyType: returnKey,
          autocorrectionDisabled: autocorrect,
          secure: secure,
          defaultValue: defVal,
        );
        break;
      case SettingType.button:
        final destructive = (json['destructive'] as bool?) ?? false;
        final confirmTitle = json['confirmTitle'] as String?;
        final confirmText = json['confirmText'] as String?;
        settingVal = ButtonSetting(
          destructive: destructive,
          confirmTitle: confirmTitle,
          confirmText: confirmText,
        );
        break;
      case SettingType.link:
        final url = (json['url'] as String?) ?? '';
        final external = json['external'] as bool?;
        settingVal = LinkSetting(url: url, external: external);
        break;
      case SettingType.login:
        final methodStr = (json['method'] as String?) ?? 'basic';
        final method = LoginMethod.values.byName(methodStr);
        final url = json['url'] as String?;
        final urlKey = json['urlKey'] as String?;
        final logoutTitle = json['logoutTitle'] as String?;
        final pkce = (json['pkce'] as bool?) ?? false;
        final tokenUrl = json['tokenUrl'] as String?;
        final callbackScheme = json['callbackScheme'] as String?;
        final useEmail = json['useEmail'] as bool?;
        final localStorageKeys = (json['localStorageKeys'] as List?)
            ?.map((e) => e.toString())
            .toList();
        final clearCookies = (json['clearCookiesOnLogOut'] as bool?) ?? false;
        settingVal = LoginSetting(
          method: method,
          url: url,
          urlKey: urlKey,
          logoutTitle: logoutTitle,
          pkce: pkce,
          tokenUrl: tokenUrl,
          callbackScheme: callbackScheme,
          useEmail: useEmail,
          localStorageKeys: localStorageKeys,
          clearCookiesOnLogOut: clearCookies,
        );
        break;
      case SettingType.page:
        final rawItems = json['items'] as List? ?? [];
        final items = rawItems
            .map((e) => Setting.fromJson(e as Map<String, dynamic>))
            .toList();
        final inlineTitle = (json['inlineTitle'] as bool?) ?? false;
        final authToOpen = (json['authToOpen'] as bool?) ?? false;
        final icon = json['icon'] as String?;
        final info = json['info'] as String?;
        settingVal = PageSetting(
          items: items,
          inlineTitle: inlineTitle,
          authToOpen: authToOpen,
          icon: icon,
          info: info,
        );
        break;
      case SettingType.editableList:
        final lineLimit = (json['lineLimit'] as num?)?.toInt();
        final inline = (json['inline'] as bool?) ?? false;
        final placeholder = json['placeholder'] as String?;
        final defVal =
            (json['default'] as List?)?.map((e) => e.toString()).toList();
        settingVal = EditableListSetting(
          lineLimit: lineLimit,
          inline: inline,
          placeholder: placeholder,
          defaultValue: defVal,
        );
        break;
      case SettingType.picker:
        final vals =
            (json['values'] as List?)?.map((e) => e.toString()).toList() ?? [];
        final titles =
            (json['titles'] as List?)?.map((e) => e.toString()).toList();
        final defVal = json['default']?.toString();
        settingVal =
            PickerSetting(values: vals, titles: titles, defaultValue: defVal);
        break;
      case SettingType.custom:
        settingVal = const CustomSetting();
        break;
    }

    return Setting(
      key: key,
      title: title,
      notification: notification,
      requires: requires,
      requiresFalse: requiresFalse,
      refreshes: refreshes,
      value: settingVal,
    );
  }
}
