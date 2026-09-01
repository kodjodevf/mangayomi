import '../postcard/postcard_reader.dart';
import '../postcard/postcard_writer.dart';

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
  void toPostcard(PostcardWriter writer);
}

class GroupSetting extends SettingValue {
  const GroupSetting({this.footer, required this.items});
  final String? footer;
  final List<Setting> items;
  @override
  SettingType get type => SettingType.group;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeOption(footer, (w, s) => w.writeString(s));
    writer.writeList(items, (w, item) => item.toPostcard(w));
  }
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

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeList(values, (w, s) => w.writeString(s));
    writer.writeOption(titles, (w, list) => w.writeList(list, (w2, s) => w2.writeString(s)));
    writer.writeOption(authToOpen, (w, b) => w.writeBool(b));
    writer.writeOption(defaultValue, (w, s) => w.writeString(s));
  }
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

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeList(values, (w, s) => w.writeString(s));
    writer.writeOption(titles, (w, list) => w.writeList(list, (w2, s) => w2.writeString(s)));
    writer.writeOption(authToOpen, (w, b) => w.writeBool(b));
    writer.writeOption(defaultValue, (w, list) => w.writeList(list, (w2, s) => w2.writeString(s)));
  }
}

class ToggleSetting extends SettingValue {
  const ToggleSetting({this.subtitle, this.authToDisable, this.defaultValue = false});
  final String? subtitle;
  final bool? authToDisable;
  final bool defaultValue;
  @override
  SettingType get type => SettingType.toggle;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeOption(subtitle, (w, s) => w.writeString(s));
    writer.writeOption(authToDisable, (w, b) => w.writeBool(b));
    writer.writeOption(defaultValue, (w, b) => w.writeBool(b));
  }
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

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeF64(minimumValue);
    writer.writeF64(maximumValue);
    writer.writeOption(stepValue, (w, v) => w.writeF64(v));
    writer.writeOption(defaultValue, (w, v) => w.writeF64(v));
  }
}

class SegmentSetting extends SettingValue {
  const SegmentSetting({required this.options, this.defaultValue});
  final List<String> options;
  final int? defaultValue;
  @override
  SettingType get type => SettingType.segment;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeList(options, (w, s) => w.writeString(s));
    writer.writeOption(defaultValue, (w, v) => w.writeI64(v));
  }
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

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeOption(placeholder, (w, s) => w.writeString(s));
    writer.writeOption(autocapitalizationType, (w, v) => w.writeI64(v));
    writer.writeOption(keyboardType, (w, v) => w.writeI64(v));
    writer.writeOption(returnKeyType, (w, v) => w.writeI64(v));
    writer.writeOption(autocorrectionDisabled, (w, b) => w.writeBool(b));
    writer.writeOption(secure, (w, b) => w.writeBool(b));
    writer.writeOption(defaultValue, (w, s) => w.writeString(s));
  }
}

class ButtonSetting extends SettingValue {
  const ButtonSetting({this.destructive = false, this.confirmTitle, this.confirmText});
  final bool destructive;
  final String? confirmTitle;
  final String? confirmText;
  @override
  SettingType get type => SettingType.button;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeOption(destructive, (w, b) => w.writeBool(b));
    writer.writeOption(confirmTitle, (w, s) => w.writeString(s));
    writer.writeOption(confirmText, (w, s) => w.writeString(s));
  }
}

class LinkSetting extends SettingValue {
  const LinkSetting({required this.url, this.external});
  final String url;
  final bool? external;
  @override
  SettingType get type => SettingType.link;

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeString(url);
    writer.writeOption(external, (w, b) => w.writeBool(b));
  }
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

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeString(method.name);
    writer.writeOption(url, (w, s) => w.writeString(s));
    writer.writeOption(urlKey, (w, s) => w.writeString(s));
    writer.writeOption(logoutTitle, (w, s) => w.writeString(s));
    writer.writeOption(pkce, (w, b) => w.writeBool(b));
    writer.writeOption(tokenUrl, (w, s) => w.writeString(s));
    writer.writeOption(callbackScheme, (w, s) => w.writeString(s));
    writer.writeOption(useEmail, (w, b) => w.writeBool(b));
    writer.writeOption(localStorageKeys, (w, list) => w.writeList(list, (w2, s) => w2.writeString(s)));
    writer.writeOption(clearCookiesOnLogOut, (w, b) => w.writeBool(b));
  }
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

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeList(items, (w, item) => item.toPostcard(w));
    writer.writeOption(inlineTitle, (w, b) => w.writeBool(b));
    writer.writeOption(authToOpen, (w, b) => w.writeBool(b));
    writer.writeOption(icon, (w, s) => w.writeString(s));
    writer.writeOption(info, (w, s) => w.writeString(s));
  }
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

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeOption(lineLimit, (w, v) => w.writeI64(v));
    writer.writeOption(inline, (w, b) => w.writeBool(b));
    writer.writeOption(placeholder, (w, s) => w.writeString(s));
    writer.writeOption(defaultValue, (w, list) => w.writeList(list, (w2, s) => w2.writeString(s)));
  }
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

  @override
  void toPostcard(PostcardWriter writer) {
    writer.writeList(values, (w, s) => w.writeString(s));
    writer.writeOption(titles, (w, list) => w.writeList(list, (w2, s) => w2.writeString(s)));
    writer.writeOption(defaultValue, (w, s) => w.writeString(s));
  }
}

class CustomSetting extends SettingValue {
  const CustomSetting();
  @override
  SettingType get type => SettingType.custom;

  @override
  void toPostcard(PostcardWriter writer) {}
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
    final refreshes = (json['refreshes'] as List?)?.map((e) => e.toString()).toList() ?? const [];

    final SettingValue settingVal;
    switch (type) {
      case SettingType.group:
        final footer = json['footer'] as String?;
        final rawItems = json['items'] as List? ?? [];
        final items = rawItems.map((e) => Setting.fromJson(e as Map<String, dynamic>)).toList();
        settingVal = GroupSetting(footer: footer, items: items);
        break;
      case SettingType.select:
        final vals = (json['values'] as List?)?.map((e) => e.toString()).toList() ?? [];
        final titles = (json['titles'] as List?)?.map((e) => e.toString()).toList();
        final auth = json['authToOpen'] as bool?;
        final defVal = json['default']?.toString();
        settingVal = SelectSetting(values: vals, titles: titles, authToOpen: auth, defaultValue: defVal);
        break;
      case SettingType.multiselect:
        final vals = (json['values'] as List?)?.map((e) => e.toString()).toList() ?? [];
        final titles = (json['titles'] as List?)?.map((e) => e.toString()).toList();
        final auth = json['authToOpen'] as bool?;
        final defVal = (json['default'] as List?)?.map((e) => e.toString()).toList();
        settingVal = MultiSelectSetting(values: vals, titles: titles, authToOpen: auth, defaultValue: defVal);
        break;
      case SettingType.toggle:
        final subtitle = json['subtitle'] as String?;
        final auth = json['authToDisable'] as bool?;
        final defVal = (json['default'] as bool?) ?? false;
        settingVal = ToggleSetting(subtitle: subtitle, authToDisable: auth, defaultValue: defVal);
        break;
      case SettingType.stepper:
        final min = (json['minimumValue'] as num?)?.toDouble() ?? 0.0;
        final max = (json['maximumValue'] as num?)?.toDouble() ?? 100.0;
        final step = (json['stepValue'] as num?)?.toDouble();
        final defVal = (json['default'] as num?)?.toDouble();
        settingVal = StepperSetting(minimumValue: min, maximumValue: max, stepValue: step, defaultValue: defVal);
        break;
      case SettingType.segment:
        final opts = (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [];
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
        settingVal = ButtonSetting(destructive: destructive, confirmTitle: confirmTitle, confirmText: confirmText);
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
        final localStorageKeys = (json['localStorageKeys'] as List?)?.map((e) => e.toString()).toList();
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
        final items = rawItems.map((e) => Setting.fromJson(e as Map<String, dynamic>)).toList();
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
        final defVal = (json['default'] as List?)?.map((e) => e.toString()).toList();
        settingVal = EditableListSetting(
          lineLimit: lineLimit,
          inline: inline,
          placeholder: placeholder,
          defaultValue: defVal,
        );
        break;
      case SettingType.picker:
        final vals = (json['values'] as List?)?.map((e) => e.toString()).toList() ?? [];
        final titles = (json['titles'] as List?)?.map((e) => e.toString()).toList();
        final defVal = json['default']?.toString();
        settingVal = PickerSetting(values: vals, titles: titles, defaultValue: defVal);
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

  factory Setting.fromPostcard(PostcardReader reader) {
    final typeStr = reader.readString();
    final type = SettingType.fromName(typeStr);
    final key = reader.readString();
    final title = reader.readString();
    final notification = reader.readOption((r) => r.readString());
    final requires = reader.readOption((r) => r.readString());
    final requiresFalse = reader.readOption((r) => r.readString());
    final refreshes = reader.readOption((r) => r.readList((r2) => r2.readString())) ?? const [];
    // Read enum byte value
    final _ = reader.readU8();

    final SettingValue settingVal;
    switch (type) {
      case SettingType.group:
        final footer = reader.readOption((r) => r.readString());
        final items = reader.readList((r) => Setting.fromPostcard(r));
        settingVal = GroupSetting(footer: footer, items: items);
        break;
      case SettingType.select:
        final vals = reader.readList((r) => r.readString());
        final titles = reader.readOption((r) => r.readList((r2) => r2.readString()));
        final auth = reader.readOption((r) => r.readBool());
        final defVal = reader.readOption((r) => r.readString());
        settingVal = SelectSetting(values: vals, titles: titles, authToOpen: auth, defaultValue: defVal);
        break;
      case SettingType.multiselect:
        final vals = reader.readList((r) => r.readString());
        final titles = reader.readOption((r) => r.readList((r2) => r2.readString()));
        final auth = reader.readOption((r) => r.readBool());
        final defVal = reader.readOption((r) => r.readList((r2) => r2.readString()));
        settingVal = MultiSelectSetting(values: vals, titles: titles, authToOpen: auth, defaultValue: defVal);
        break;
      case SettingType.toggle:
        final subtitle = reader.readOption((r) => r.readString());
        final auth = reader.readOption((r) => r.readBool());
        final defVal = reader.readOption((r) => r.readBool()) ?? false;
        settingVal = ToggleSetting(subtitle: subtitle, authToDisable: auth, defaultValue: defVal);
        break;
      case SettingType.stepper:
        final min = reader.readF64();
        final max = reader.readF64();
        final step = reader.readOption((r) => r.readF64());
        final defVal = reader.readOption((r) => r.readF64());
        settingVal = StepperSetting(minimumValue: min, maximumValue: max, stepValue: step, defaultValue: defVal);
        break;
      case SettingType.segment:
        final opts = reader.readList((r) => r.readString());
        final defVal = reader.readOption((r) => r.readI64());
        settingVal = SegmentSetting(options: opts, defaultValue: defVal);
        break;
      case SettingType.text:
        final placeholder = reader.readOption((r) => r.readString());
        final autocap = reader.readOption((r) => r.readI64());
        final keyboard = reader.readOption((r) => r.readI64());
        final returnKey = reader.readOption((r) => r.readI64());
        final autocorrect = reader.readOption((r) => r.readBool()) ?? false;
        final secure = reader.readOption((r) => r.readBool()) ?? false;
        final defVal = reader.readOption((r) => r.readString());
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
        final destructive = reader.readOption((r) => r.readBool()) ?? false;
        final confirmTitle = reader.readOption((r) => r.readString());
        final confirmText = reader.readOption((r) => r.readString());
        settingVal = ButtonSetting(destructive: destructive, confirmTitle: confirmTitle, confirmText: confirmText);
        break;
      case SettingType.link:
        final url = reader.readString();
        final external = reader.readOption((r) => r.readBool());
        settingVal = LinkSetting(url: url, external: external);
        break;
      case SettingType.login:
        final methodStr = reader.readString();
        final method = LoginMethod.values.byName(methodStr);
        final url = reader.readOption((r) => r.readString());
        final urlKey = reader.readOption((r) => r.readString());
        final logoutTitle = reader.readOption((r) => r.readString());
        final pkce = reader.readOption((r) => r.readBool()) ?? false;
        final tokenUrl = reader.readOption((r) => r.readString());
        final callbackScheme = reader.readOption((r) => r.readString());
        final useEmail = reader.readOption((r) => r.readBool());
        final localStorageKeys = reader.readOption((r) => r.readList((r2) => r2.readString()));
        final clearCookies = reader.readOption((r) => r.readBool()) ?? false;
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
        final items = reader.readList((r) => Setting.fromPostcard(r));
        final inlineTitle = reader.readOption((r) => r.readBool()) ?? false;
        final authToOpen = reader.readOption((r) => r.readBool()) ?? false;
        final icon = reader.readOption((r) => r.readString());
        final info = reader.readOption((r) => r.readString());
        settingVal = PageSetting(
          items: items,
          inlineTitle: inlineTitle,
          authToOpen: authToOpen,
          icon: icon,
          info: info,
        );
        break;
      case SettingType.editableList:
        final lineLimit = reader.readOption((r) => r.readI64());
        final inline = reader.readOption((r) => r.readBool()) ?? false;
        final placeholder = reader.readOption((r) => r.readString());
        final defVal = reader.readOption((r) => r.readList((r2) => r2.readString()));
        settingVal = EditableListSetting(
          lineLimit: lineLimit,
          inline: inline,
          placeholder: placeholder,
          defaultValue: defVal,
        );
        break;
      case SettingType.picker:
        final vals = reader.readList((r) => r.readString());
        final titles = reader.readOption((r) => r.readList((r2) => r2.readString()));
        final defVal = reader.readOption((r) => r.readString());
        settingVal = PickerSetting(values: vals, titles: titles, defaultValue: defVal);
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

  void toPostcard(PostcardWriter writer) {
    writer.writeString(value.type.name);
    writer.writeString(key);
    writer.writeString(title);
    writer.writeOption(notification, (w, s) => w.writeString(s));
    writer.writeOption(requires, (w, s) => w.writeString(s));
    writer.writeOption(requiresFalse, (w, s) => w.writeString(s));
    writer.writeOption(refreshes.isEmpty ? null : refreshes, (w, list) => w.writeList(list, (w2, s) => w2.writeString(s)));
    writer.writeU8(value.type.value);
    value.toPostcard(writer);
  }
}
