import 'package:mangayomi/models/source.dart';

/// Dart template used when generating a new local Dart extension.
const dartExtensionTemplate = r'''
import 'package:mangayomi/bridge_lib.dart';
import 'dart:convert';

class TestSource extends MProvider {
  TestSource({required this.source});

  MSource source;

  final Client client = Client();

  // Helpers you can use anywhere in this file:
  //
  //   client.get(Uri.parse(url), headers: {...}) and client.post(...)
  //       Make HTTP requests. The response's text is `res.body`.
  //   parseHtml(html)
  //       Turns an HTML String into a document you can search:
  //         final doc = parseHtml(res.body);
  //         doc.select("div.item")    all matches, as a list
  //         doc.selectFirst("h1")     the first match
  //       On a match: `.text` is its text and `.attr("href")` an attribute.
  //   xpath(html, expression)
  //       Returns the values an XPath expression finds in an HTML String.
  //   getUrlWithoutDomain(url)
  //       "https://example.com/a/b?c=1" becomes "/a/b?c=1".
  //   substringAfter(text, pattern), substringBefore(text, pattern),
  //   substringAfterLast(text, pattern), substringBeforeLast(text, pattern)
  //       Cut a String around the first (or last) occurrence of a pattern.
  //   parseStatus(...) and parseDates(...) are described in [getDetail].
  //   getPreferenceValue(...) is described in [getSourcePreferences].

  /// Whether this source has a "latest updates" listing.
  /// Return true if you implement [getLatestUpdates], otherwise false.
  @override
  bool get supportsLatest => true;

  /// Extra HTTP headers to send with this source's requests,
  /// for example {"Referer": "https://example.com"}.
  /// Return {} if none are needed.
  @override
  Map<String, String> get headers => {};

  /// Returns one page of the source's popular entries (shown when browsing).
  ///
  /// [page] starts at 1 and goes up while more pages exist.
  ///
  /// Return `MPages(list, hasNextPage)`:
  /// - `list`: the entries on this page. Each entry (a manga, anime or
  ///   novel) is an `MManga`; see the example below.
  /// - `hasNextPage`: true if there is another page after this one.
  ///
  /// Example of one entry (all three fields are needed):
  ///
  ///     MManga(
  ///       name: "Title",
  ///       link: "/title-page",
  ///       imageUrl: "https://example.com/cover.jpg",
  ///     )
  ///
  /// `name` is the title, `link` is the URL or path of the entry's page, and
  /// `imageUrl` is its cover image.
  @override
  Future<MPages> getPopular(int page) async {
    // TODO: implement
  }

  /// Returns one page of the most recently updated entries.
  /// Only used when [supportsLatest] returns true.
  ///
  /// [page] starts at 1 and goes up while more pages exist.
  ///
  /// Return `MPages(list, hasNextPage)`: `list` holds the entries as
  /// `MManga(name: ..., link: ..., imageUrl: ...)` and `hasNextPage` is true
  /// if there is another page after this one.
  @override
  Future<MPages> getLatestUpdates(int page) async {
    // TODO: implement
  }

  /// Returns one page of search results.
  ///
  /// [query] is the text the user typed. [page] starts at 1 and goes up
  /// while more pages exist. [filterList] contains the filters from
  /// [getFilterList], with the user's selections applied.
  ///
  /// To read the selections, loop over `filterList.filters`. For each filter,
  /// `filter.type` is the identifier you gave it in [getFilterList] and
  /// `filter.state` is what the user chose:
  /// - `SelectFilter`: the number of the chosen option. The option itself
  ///   is `filter.values[filter.state]`, and its `value` is what you gave it.
  /// - `CheckBoxFilter`: true if checked.
  /// - `TriStateFilter`: 0 ignored, 1 included, 2 excluded.
  /// - `TextFilter`: the text typed.
  /// - `GroupFilter`: a list of the filters inside the group; read each
  ///   one's `state` the same way.
  ///
  /// Return `MPages(list, hasNextPage)`: `list` holds the results as
  /// `MManga(name: ..., link: ..., imageUrl: ...)` and `hasNextPage` is true
  /// if there is another page after this one.
  @override
  Future<MPages> search(String query, int page, FilterList filterList) async {
    // TODO: implement
  }

  /// Returns the full details of one entry, including its list of chapters
  /// (episodes, for anime).
  ///
  /// [url] is the `link` you gave this entry in the listing or search results.
  ///
  /// Return an `MManga`. Leave out any field the source does not provide:
  ///
  ///     MManga(
  ///       name: "Title",
  ///       imageUrl: "https://example.com/cover.jpg",
  ///       description: "A short summary.",
  ///       author: "Author name",
  ///       artist: "Artist name",
  ///       status: MStatus.ongoing,
  ///       genre: ["Action", "Drama"],
  ///       chapters: [
  ///         MChapter(
  ///           name: "Chapter 1",
  ///           url: "/chapter-1",
  ///           dateUpload: "1700000000000",
  ///           scanlator: "Group name",
  ///         ),
  ///       ],
  ///     )
  ///
  /// - `status` is one of `MStatus.ongoing`, `MStatus.completed`,
  ///   `MStatus.onHiatus`, `MStatus.canceled`, `MStatus.publishingFinished`
  ///   or `MStatus.unknown`.
  /// - `chapters` holds one `MChapter` per chapter, or per episode for anime.
  ///   `name` and `url` are required. `dateUpload` is optional: the upload
  ///   time in milliseconds since 1970, written as a String.
  ///   `scanlator` is optional: the group that released it.
  ///
  /// Helpers for filling these in:
  /// - `parseStatus(text, statusList)` turns the status text of the website
  ///   into an `MStatus`. `statusList` is a list holding one map of the
  ///   website's wording to a number: 0 ongoing, 1 completed, 2 on hiatus,
  ///   3 canceled, 4 publishing finished. The text is compared ignoring
  ///   upper and lower case, and a text with no match gives `MStatus.unknown`.
  ///
  ///       status: parseStatus("Ongoing", [
  ///         {"Ongoing": 0, "Completed": 1, "Hiatus": 2, "Cancelled": 3},
  ///       ]),
  ///
  /// - `parseDates(dates, format, locale)` turns a list of date texts into
  ///   a list of Strings in the form `dateUpload` expects. `format` is how
  ///   the website writes dates and `locale` its language. It also
  ///   understands wording like "2 days ago".
  ///
  ///       parseDates(["Jan 5, 2024", "2 days ago"], "MMM d, yyyy", "en")
  @override
  Future<MManga> getDetail(String url) async {
    // TODO: implement
  }

  // For novel html content
  /// Returns the text of one novel chapter as an HTML String.
  ///
  /// [name] is the chapter's name and [url] is the chapter's `url`
  /// from [getDetail].
  @override
  Future<String> getHtmlContent(String name, String url) async {
    // TODO: implement
  }

  // Clean html up for reader
  /// Takes the HTML returned by [getHtmlContent] and returns it as a cleaned
  /// up HTML String, ready to be shown in the reader.
  @override
  Future<String> cleanHtmlContent(String html) async {
    // TODO: implement
  }

  // For anime episode video list
  /// Returns the available videos of one episode, for example one per
  /// quality or server.
  ///
  /// [url] is the episode's `url` from [getDetail].
  ///
  /// Return a list with one `MVideo` per video:
  ///
  ///     MVideo(
  ///       "https://example.com/video.m3u8",
  ///       "1080p",
  ///       "https://example.com/video.m3u8",
  ///       headers: {"Referer": "https://example.com"},
  ///       subtitles: [MTrack(file: "https://example.com/en.vtt", label: "English")],
  ///     )
  ///
  /// The three positional values are, in order: the direct video link, a
  /// quality label shown to the user (for example "1080p" or "Server 1"),
  /// and the video's original URL (often the same as the direct link).
  /// A video missing the link or the original URL is skipped.
  /// `headers` (needed to play the video), `subtitles` and `audios` (lists of
  /// `MTrack`) are optional.
  ///
  /// For common video hosts there are ready-made helpers that take the
  /// host's page URL and return the list of videos for you, so you can
  /// return it as it is. Some take extra values, such as a label prefix or
  /// a quality: `streamWishExtractor`, `filemoonExtractor`,
  /// `streamTapeExtractor`, `doodExtractor`, `voeExtractor`,
  /// `okruExtractor`, `sibnetExtractor`, `mp4UploadExtractor`,
  /// `gogoCdnExtractor`, `myTvExtractor`, `vidBomExtractor`,
  /// `streamlareExtractor`, `sendVidExtractor` and `yourUploadExtractor`.
  @override
  Future<List<MVideo>> getVideoList(String url) async {
    // TODO: implement
  }

  // For manga chapter pages
  /// Returns the image URLs of one chapter's pages, in reading order, as a
  /// list of Strings.
  ///
  /// [url] is the chapter's `url` from [getDetail].
  @override
  Future<List<String>> getPageList(String url) async{
    // TODO: implement
  }

  /// Optional. Returns the filters shown on the search screen, for example
  /// a genre or status selector. Return [] for no filters.
  ///
  /// Available filter types: `SelectFilter` (a dropdown),
  /// `CheckBoxFilter` (a checkbox), `TriStateFilter` (ignore, include or
  /// exclude), `TextFilter` (a text field), `SortFilter` (sort options with
  /// a direction), `GroupFilter` (a group of other filters),
  /// `HeaderFilter` (a label) and `SeparatorFilter` (a divider).
  ///
  /// Each is created like this (the first value of those that have one is an
  /// identifier of your choice that you read back in [search]):
  ///
  ///     SelectFilter("sort", "Order by", 0, [
  ///       SelectFilterOption("Popular", "popular"),
  ///       SelectFilterOption("Newest", "newest"),
  ///     ]),
  ///     CheckBoxFilter("Completed only", "completed"),
  ///     TriStateFilter("Action", "action"),
  ///     TextFilter("author", "Author"),
  ///     GroupFilter("genres", "Genres", [
  ///       TriStateFilter("Action", "action"),
  ///       TriStateFilter("Drama", "drama"),
  ///     ]),
  ///     HeaderFilter("Section title"),
  ///     SeparatorFilter(),
  ///
  /// `SelectFilter`: identifier, label, number of the option chosen at the
  /// start, then the options as `SelectFilterOption(label, value)`.
  /// `CheckBoxFilter` and `TriStateFilter`: label, value.
  @override
  List<dynamic> getFilterList() {
    // TODO: implement
  }

  /// Optional. Returns the settings the user can change for this source.
  /// Return [] for no settings.
  ///
  /// Available setting types: `CheckBoxPreference`, `SwitchPreferenceCompat`,
  /// `ListPreference`, `MultiSelectListPreference` and `EditTextPreference`.
  /// Each one needs a unique `key` so its value can be saved and read back,
  /// for example:
  ///
  ///     SwitchPreferenceCompat(
  ///       key: "show_extra",
  ///       title: "Show extra content",
  ///       summary: "A short explanation.",
  ///       value: false,
  ///     )
  ///
  /// To read a setting back, for example in [getPopular], use
  /// `getPreferenceValue(source.id, "show_extra")`. It returns, depending
  /// on the type: `CheckBoxPreference` and `SwitchPreferenceCompat` a
  /// bool, `EditTextPreference` the text, `ListPreference` the chosen
  /// entry's value, and `MultiSelectListPreference` the list of chosen
  /// values.
  @override
  List<dynamic> getSourcePreferences() {
    // TODO: implement
  }
}

TestSource main(MSource source) {
  return TestSource(source:source);
}''';

/// Generates a JavaScript extension boilerplate template for the given [source].
String jsExtensionTemplate(Source source) =>
    '''
const mangayomiSources = [{
    "name": "${source.name}",
    "lang": "${source.lang}",
    "baseUrl": "${source.baseUrl}",
    "apiUrl": "${source.apiUrl}",
    "iconUrl": "${source.iconUrl}",
    "typeSource": "${source.typeSource}",
    "itemType": ${source.itemType.index},
    "isNsfw": ${source.isNsfw},
    "version": "${source.version}",
    "pkgPath": "",
    "notes": "${source.notes}"
}];

// Every method returns plain data (objects, arrays, strings, numbers and
// booleans). Async methods may return the value directly or a Promise.
//
// Helpers you can use anywhere in this file:
//
//   const client = new Client();
//   await client.get(url, headers) and client.post(url, headers, body)
//       Make HTTP requests. The response's text is `res.body`.
//   const doc = new Document(html);
//       Turns an HTML string into a document you can search:
//         doc.select("div.item")    all matches, as an array
//         doc.selectFirst("h1")     the first match
//       On a match: .text is its text and .attr("href") an attribute.
//       doc.xpath(expression) searches with XPath instead.
//   parseDates(dates, format, locale)
//       Described in getDetail.
//   new SharedPreferences().get(key)
//       Described in getSourcePreferences.
class DefaultExtension extends MProvider {
    /**
     * Optional. Extra HTTP headers to send with this source's requests.
     * @param {string} url the source's base URL
     * @returns {Object<string, string>} for example
     *     {"Referer": "https://example.com"}, or {} if none are needed
     */
    getHeaders(url) {
        throw new Error("getHeaders not implemented");
    }

    /**
     * Returns one page of the source's popular entries (shown when browsing).
     * @param {number} page starts at 1 and goes up while more pages exist
     * @returns {Promise<{list: Object[], hasNextPage: boolean}>}
     *     list: the entries on this page. Each entry (a manga, anime or
     *     novel) is an object with a name (the title), a link (the URL or
     *     path of its page) and an imageUrl (its cover image). All three
     *     are needed.
     *     hasNextPage: true if there is another page after this one.
     * @example
     * return {
     *     list: [
     *         { name: "Title", link: "/title-page", imageUrl: "https://example.com/cover.jpg" }
     *     ],
     *     hasNextPage: true
     * };
     */
    async getPopular(page) {
        throw new Error("getPopular not implemented");
    }

    /**
     * Optional. Whether this source has a "latest updates" listing.
     * @returns {boolean} true if you implement getLatestUpdates, otherwise
     *     false
     */
    get supportsLatest() {
        throw new Error("supportsLatest not implemented");
    }

    /**
     * Returns one page of the most recently updated entries.
     * Only used when supportsLatest returns true.
     * @param {number} page starts at 1 and goes up while more pages exist
     * @returns {Promise<{list: Object[], hasNextPage: boolean}>}
     *     list: the entries on this page, each an object with name, link and
     *     imageUrl.
     *     hasNextPage: true if there is another page after this one.
     * @example
     * return {
     *     list: [
     *         { name: "Title", link: "/title-page", imageUrl: "https://example.com/cover.jpg" }
     *     ],
     *     hasNextPage: true
     * };
     */
    async getLatestUpdates(page) {
        throw new Error("getLatestUpdates not implemented");
    }

    /**
     * Returns one page of search results.
     * @param {string} query the text the user typed
     * @param {number} page starts at 1 and goes up while more pages exist
     * @param {Object[]} filters the filters from getFilterList, with the
     *     user's selections applied. For each filter, type is the
     *     identifier you gave it in getFilterList and state is what the
     *     user chose: for "SelectFilter" the number of the chosen option
     *     (the option is values[state], and its value is what you gave it),
     *     for "CheckBox" true if checked, for "TriState" 0 ignored,
     *     1 included or 2 excluded, for "TextFilter" the text typed, for
     *     "GroupFilter" an array of the filters inside the group.
     * @returns {Promise<{list: Object[], hasNextPage: boolean}>}
     *     list: the results on this page, each an object with name, link and
     *     imageUrl.
     *     hasNextPage: true if there is another page after this one.
     * @example
     * return {
     *     list: [
     *         { name: "Title", link: "/title-page", imageUrl: "https://example.com/cover.jpg" }
     *     ],
     *     hasNextPage: false
     * };
     */
    async search(query, page, filters) {
        throw new Error("search not implemented");
    }

    /**
     * Returns the full details of one entry, including its list of chapters
     * (episodes, for anime).
     * @param {string} url the link you gave this entry in the listing or
     *     search results
     * @returns {Promise<Object>} an object with the fields below. Leave out
     *     any field the source does not provide.
     *     status: 0 ongoing, 1 completed, 2 on hiatus, 3 canceled,
     *     4 publishing finished. Any other value means unknown. Convert
     *     the website's wording to these numbers yourself.
     *     chapters: one object per chapter, or per episode for anime. name
     *     and url are required. dateUpload is optional: the upload time in
     *     milliseconds since 1970, written as a string. scanlator is
     *     optional: the group that released it. Anime episodes can also have
     *     thumbnailUrl, description, duration, downloadSize and isFiller.
     *     To get dateUpload from the website's date text, use
     *     parseDates(dates, format, locale): it takes an array of date texts,
     *     the format the website writes dates in and its language, and
     *     returns an array of strings in the form dateUpload expects. It
     *     also understands wording like "2 days ago". For example
     *     parseDates(["Jan 5, 2024", "2 days ago"], "MMM d, yyyy", "en").
     * @example
     * return {
     *     name: "Title",
     *     imageUrl: "https://example.com/cover.jpg",
     *     description: "A short summary.",
     *     author: "Author name",
     *     artist: "Artist name",
     *     status: 0,
     *     genre: ["Action", "Drama"],
     *     chapters: [
     *         { name: "Chapter 1", url: "/chapter-1", dateUpload: "1700000000000", scanlator: "Group name" }
     *     ]
     * };
     */
    async getDetail(url) {
        throw new Error("getDetail not implemented");
    }

    // For novel html content
    /**
     * Returns the text of one novel chapter as an HTML string.
     * @param {string} name the chapter's name
     * @param {string} url the chapter's url from getDetail
     * @returns {Promise<string>}
     */
    async getHtmlContent(name, url) {
        throw new Error("getHtmlContent not implemented");
    }

    // Clean html up for reader
    /**
     * Takes the HTML returned by getHtmlContent and returns it as a cleaned
     * up HTML string, ready to be shown in the reader.
     * @param {string} html
     * @returns {Promise<string>}
     */
    async cleanHtmlContent(html) {
        throw new Error("cleanHtmlContent not implemented");
    }

    // For anime episode video list
    /**
     * Returns the available videos of one episode, for example one per
     * quality or server.
     * @param {string} url the episode's url from getDetail
     * @returns {Promise<Object[]>} one object per video. url (the direct
     *     video link), quality (a label shown to the user, for example
     *     "1080p" or "Server 1") and originalUrl (the video's original URL,
     *     often the same as url) are needed; a video missing url or
     *     originalUrl is skipped. headers (needed to play the video),
     *     subtitles and audios are optional.
     *     For common video hosts there are ready-made helpers that take the
     *     host's page URL and return the array of videos for you, so you
     *     can return it as it is. Some take extra values, such as a label
     *     prefix or a quality: streamWishExtractor, filemoonExtractor,
     *     streamTapeExtractor, doodExtractor, voeExtractor, okruExtractor,
     *     sibnetExtractor, mp4UploadExtractor, gogoCdnExtractor,
     *     myTvExtractor, vidBomExtractor, streamlareExtractor,
     *     sendVidExtractor and yourUploadExtractor. For example
     *     return await streamWishExtractor(url, "StreamWish - ").
     * @example
     * return [
     *     {
     *         url: "https://example.com/video.m3u8",
     *         quality: "1080p",
     *         originalUrl: "https://example.com/video.m3u8",
     *         headers: { "Referer": "https://example.com" },
     *         subtitles: [{ file: "https://example.com/en.vtt", label: "English" }],
     *         audios: []
     *     }
     * ];
     */
    async getVideoList(url) {
        throw new Error("getVideoList not implemented");
    }

    // For manga chapter pages
    /**
     * Returns the pages of one chapter, in reading order.
     * @param {string} url the chapter's url from getDetail
     * @returns {Promise<Array<string | {url: string, headers: Object<string, string>}>>}
     *     one item per page: either the image URL as a string, or an object
     *     with the image url and the headers needed to load it.
     * @example
     * return ["https://example.com/1.jpg", "https://example.com/2.jpg"];
     */
    async getPageList(url) {
        throw new Error("getPageList not implemented");
    }

    /**
     * Optional. Returns the filters shown on the search screen, for example
     * a genre or status selector. Return [] for no filters.
     * @returns {Object[]} filter objects. Each has a type_name that is one
     *     of "SelectFilter" (a dropdown), "CheckBox" (a checkbox), "TriState"
     *     (ignore, include or exclude), "TextFilter" (a text field),
     *     "SortFilter" (sort options with a direction), "GroupFilter" (a
     *     group of other filters), "HeaderFilter" (a label) or
     *     "SeparatorFilter" (a divider). Other values are ignored.
     * @example
     * return [
     *     {
     *         type_name: "SelectFilter", type: "sort", name: "Order by", state: 0,
     *         values: [
     *             { type_name: "SelectOption", name: "Popular", value: "popular" },
     *             { type_name: "SelectOption", name: "Newest", value: "newest" }
     *         ]
     *     },
     *     { type_name: "CheckBox", type: "completed", name: "Completed only", value: "completed", state: false },
     *     { type_name: "TriState", type: "genre", name: "Action", value: "action", state: 0 },
     *     { type_name: "TextFilter", type: "author", name: "Author", state: "" },
     *     { type_name: "GroupFilter", type: "genres", name: "Genres", state: [
     *         { type_name: "TriState", type: "genre", name: "Drama", value: "drama", state: 0 }
     *     ] },
     *     { type_name: "HeaderFilter", type: "", name: "Section title" },
     *     { type_name: "SeparatorFilter", type: "" }
     * ];
     */
    getFilterList() {
        throw new Error("getFilterList not implemented");
    }

    /**
     * Optional. Returns the settings the user can change for this source.
     * Return [] for no settings.
     * @returns {Object[]} one object per setting, with a unique key (so its
     *     value can be saved and read back) and one of checkBoxPreference,
     *     switchPreferenceCompat, listPreference, multiSelectListPreference
     *     or editTextPreference. To read a setting back, for example in
     *     getPopular, use new SharedPreferences().get("show_extra"). It
     *     returns, depending on the type: for checkBoxPreference and
     *     switchPreferenceCompat a boolean, for editTextPreference the text,
     *     for listPreference the chosen entry's value, and for
     *     multiSelectListPreference the array of chosen values.
     * @example
     * return [{
     *     key: "show_extra",
     *     switchPreferenceCompat: {
     *         title: "Show extra content",
     *         summary: "A short explanation.",
     *         value: false
     *     }
     * }];
     */
    getSourcePreferences() {
        throw new Error("getSourcePreferences not implemented");
    }
}
''';
