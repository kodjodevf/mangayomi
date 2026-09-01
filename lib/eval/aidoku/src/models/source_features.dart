/// Describes the features supported by an Aidoku WASM extension module.
class SourceFeatures {
  const SourceFeatures({
    this.providesListings = false,
    this.providesHome = false,
    this.dynamicFilters = false,
    this.dynamicSettings = false,
    this.dynamicListings = false,
    this.processesPages = false,
    this.providesImageRequests = false,
    this.providesPageDescriptions = false,
    this.providesAlternateCovers = false,
    this.providesBaseUrl = false,
    this.handlesNotifications = false,
    this.handlesDeepLinks = false,
    this.handlesBasicLogin = false,
    this.handlesWebLogin = false,
    this.handlesMigration = false,
  });

  final bool providesListings;
  final bool providesHome;
  final bool dynamicFilters;
  final bool dynamicSettings;
  final bool dynamicListings;
  final bool processesPages;
  final bool providesImageRequests;
  final bool providesPageDescriptions;
  final bool providesAlternateCovers;
  final bool providesBaseUrl;
  final bool handlesNotifications;
  final bool handlesDeepLinks;
  final bool handlesBasicLogin;
  final bool handlesWebLogin;
  final bool handlesMigration;

  @override
  String toString() =>
      'SourceFeatures(providesListings: $providesListings, providesHome: $providesHome, dynamicFilters: $dynamicFilters)';
}
