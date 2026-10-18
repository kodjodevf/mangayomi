import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/novel/tts/novel_tts_service.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

const _localeNames = <String, String>{
  'ar-001': 'العربية',
  'bg-BG': 'Български',
  'bn-IN': 'বাংলা (ভারত)',
  'ca-ES': 'Català',
  'cs-CZ': 'Čeština',
  'da-DK': 'Dansk',
  'de-DE': 'Deutsch',
  'el-GR': 'Ελληνικά',
  'en-AU': 'English (Australia)',
  'en-GB': 'English (UK)',
  'en-IE': 'English (Ireland)',
  'en-IN': 'English (India)',
  'en-US': 'English (US)',
  'en-ZA': 'English (South Africa)',
  'es-ES': 'Español (España)',
  'es-MX': 'Español (México)',
  'fi-FI': 'Suomi',
  'fr-CA': 'Français (Canada)',
  'fr-FR': 'Français (France)',
  'he-IL': 'עברית',
  'hi-IN': 'हिन्दी',
  'hr-HR': 'Hrvatski',
  'hu-HU': 'Magyar',
  'id-ID': 'Bahasa Indonesia',
  'it-IT': 'Italiano',
  'ja-JP': '日本語',
  'kn-IN': 'ಕನ್ನಡ',
  'ko-KR': '한국어',
  'ms-MY': 'Bahasa Melayu',
  'nb-NO': 'Norsk Bokmål',
  'nl-BE': 'Nederlands (België)',
  'nl-NL': 'Nederlands',
  'pl-PL': 'Polski',
  'pt-BR': 'Português (Brasil)',
  'pt-PT': 'Português (Portugal)',
  'ro-RO': 'Română',
  'ru-RU': 'Русский',
  'sk-SK': 'Slovenčina',
  'sl-SI': 'Slovenščina',
  'sv-SE': 'Svenska',
  'ta-IN': 'தமிழ்',
  'te-IN': 'తెలుగు',
  'th-TH': 'ไทย',
  'tr-TR': 'Türkçe',
  'uk-UA': 'Українська',
  'vi-VN': 'Tiếng Việt',
  'yue-HK': '粵語 (香港)',
  'zh-CN': '中文 (简体)',
  'zh-TW': '中文 (繁體)',
};

class TtsSettingsTab extends ConsumerStatefulWidget {
  const TtsSettingsTab({super.key});

  @override
  ConsumerState<TtsSettingsTab> createState() => _TtsSettingsTabState();
}

class _TtsSettingsTabState extends ConsumerState<TtsSettingsTab> {
  List<dynamic> _languages = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    final tts = NovelTtsService.instance;
    final langs = await tts.getLanguages();
    langs.sort((a, b) => a.toString().compareTo(b.toString()));
    if (mounted) {
      setState(() {
        _languages = langs;
        _loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final speed = ref.watch(ttsSpeechRateStateProvider);
    final pitch = ref.watch(ttsPitchStateProvider);
    final language = ref.watch(ttsLanguageStateProvider);

    // "Default" needs a value of its own: the choice sheet answers null
    // when dismissed.
    const systemDefault = '';
    // The sheet scrolls; a tab is a column, not a list of its own.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ShioriSpace.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ShioriSliderRow(
            icon: Symbols.speed_rounded,
            title: context.l10n.tts_speed,
            value: speed,
            min: 0.1,
            max: 1.0,
            divisions: 9,
            // The engine's rate is half the speed people expect to read.
            valueLabel: (v) => '${(v * 2).toStringAsFixed(1)}×',
            // Back to 1×, as the pitch goes back to its default.
            defaultValue: 0.5,
            onReset: () {
              ref.read(ttsSpeechRateStateProvider.notifier).set(0.5);
              NovelTtsService.instance.setSpeed(0.5);
            },
            resetTooltip: context.l10n.reset,
            onChanged: (value) {
              ref.read(ttsSpeechRateStateProvider.notifier).set(value);
              NovelTtsService.instance.setSpeed(value);
            },
          ),
          ShioriSliderRow(
            icon: Symbols.tune_rounded,
            title: context.l10n.tts_pitch,
            value: pitch,
            min: 0.5,
            max: 2.0,
            divisions: 15,
            valueLabel: (v) => v.toStringAsFixed(1),
            defaultValue: 1,
            onReset: () {
              ref.read(ttsPitchStateProvider.notifier).set(1);
              NovelTtsService.instance.setPitch(1);
            },
            resetTooltip: context.l10n.reset,
            onChanged: (value) {
              ref.read(ttsPitchStateProvider.notifier).set(value);
              NovelTtsService.instance.setPitch(value);
            },
          ),
          if (_loaded)
            ShioriValueRow<String>(
              icon: Symbols.language_rounded,
              title: context.l10n.tts_language,
              searchHint: context.l10n.search,
              value: language ?? systemDefault,
              options: [
                ShioriChoice(systemDefault, context.l10n.tts_default),
                for (final lang in _languages)
                  ShioriChoice(
                    lang.toString(),
                    '${_localeNames[lang.toString()] ?? lang} ($lang)',
                  ),
              ],
              onChanged: (value) {
                final code = value == systemDefault ? null : value;
                ref.read(ttsLanguageStateProvider.notifier).set(code);
                if (code != null) NovelTtsService.instance.setLanguage(code);
              },
            )
          else
            const ShioriSkeletonRow(),
          const SizedBox(height: ShioriSpace.s48 * 2),
        ],
      ),
    );
  }
}
