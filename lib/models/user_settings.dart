import 'package:json_annotation/json_annotation.dart';
import 'package:recipe_search/models/search_settings.dart';

import '../helpers/update_dynamic.dart';

part 'user_settings.g.dart';

@JsonSerializable(createToJson: true)
class UserSettings {
  final bool askBeforeRemoving;
  final SearchSettings? lastSearch;

  UserSettings({
    required this.askBeforeRemoving,
    this.lastSearch,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) => _$UserSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);

  factory UserSettings.copyWith(
    UserSettings old, {
    bool? askBeforeRemoving,
    SearchSettings? lastSearch,
  }) {
    return UserSettings(
      askBeforeRemoving: update(old.askBeforeRemoving, askBeforeRemoving),
      lastSearch: update(old.lastSearch, lastSearch),
    );
  }

  factory UserSettings.base() => UserSettings(askBeforeRemoving: true);
}
