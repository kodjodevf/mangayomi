/// Represents a DoH provider with URL and bootstrap DNS hosts
class DoHProvider {
  /// Provider identifier (for persistence)
  final int id;

  /// User-friendly name
  final String name;

  /// DoH endpoint URL
  final String url;

  /// Bootstrap DNS hosts (IPs) to avoid circular resolution
  /// Mix of IPv4 and IPv6 for fallback
  final List<String> bootstrapIPs;

  /// Description for UI
  final String description;

  /// Region/category info
  final String region;

  const DoHProvider({
    required this.id,
    required this.name,
    required this.url,
    required this.bootstrapIPs,
    required this.description,
    required this.region,
  });

  @override
  String toString() => name;
}

/// All available DoH providers
final class DoHProviders {
  /// Cloudflare DNS - Fast, privacy-first
  static const cloudflare = DoHProvider(
    id: 0,
    name: 'Cloudflare',
    url: 'https://cloudflare-dns.com/dns-query',
    bootstrapIPs: [
      '162.159.36.1',
      '162.159.46.1',
      '1.1.1.1',
      '1.0.0.1',
      '162.159.132.53',
      '2606:4700:4700::1111',
      '2606:4700:4700::1001',
      '2606:4700:4700::0064',
      '2606:4700:4700::6400',
    ],
    description: 'Fast and privacy-first DNS',
    region: 'Global',
  );

  /// Google Public DNS - Reliable, fast
  static const google = DoHProvider(
    id: 1,
    name: 'Google',
    url: 'https://dns.google/dns-query',
    bootstrapIPs: [
      '8.8.4.4',
      '8.8.8.8',
      '2001:4860:4860::8888',
      '2001:4860:4860::8844',
    ],
    description: 'Google Public DNS',
    region: 'Global',
  );

  /// AdGuard DNS Unfiltered - No blocklists by default
  static const adguard = DoHProvider(
    id: 2,
    name: 'AdGuard',
    url: 'https://dns-unfiltered.adguard.com/dns-query',
    bootstrapIPs: [
      '94.140.14.140',
      '94.140.14.141',
      '2a10:50c0::1:ff',
      '2a10:50c0::2:ff',
    ],
    description: 'Unfiltered (no blocking)',
    region: 'Global',
  );

  /// Quad9 DNS - Privacy + security
  static const quad9 = DoHProvider(
    id: 3,
    name: 'Quad9',
    url: 'https://dns.quad9.net/dns-query',
    bootstrapIPs: ['9.9.9.9', '149.112.112.112', '2620:fe::fe', '2620:fe::9'],
    description: 'Privacy-focused with security',
    region: 'Global',
  );

  /// AliDNS - Optimized for Asia
  static const alidns = DoHProvider(
    id: 4,
    name: 'AliDNS',
    url: 'https://dns.alidns.com/dns-query',
    bootstrapIPs: [
      '223.5.5.5',
      '223.6.6.6',
      '2400:3200::1',
      '2400:3200:baba::1',
    ],
    description: 'Optimized for Asia',
    region: 'China',
  );

  /// DNSPod DNS - China mainland
  static const dnspod = DoHProvider(
    id: 5,
    name: 'DNSPod',
    url: 'https://doh.pub/dns-query',
    bootstrapIPs: ['1.12.12.12', '120.53.53.53'],
    description: 'China mainland DNS',
    region: 'China',
  );

  /// 360 DNS - China
  static const dns360 = DoHProvider(
    id: 6,
    name: '360 DNS',
    url: 'https://doh.360.cn/dns-query',
    bootstrapIPs: [
      '101.226.4.6',
      '218.30.118.6',
      '123.125.81.6',
      '140.207.198.6',
      '180.163.249.75',
      '101.199.113.208',
      '36.99.170.86',
    ],
    description: 'China domestic DNS',
    region: 'China',
  );

  /// Quad101 - Taiwan
  static const quad101 = DoHProvider(
    id: 7,
    name: 'Quad101',
    url: 'https://dns.twnic.tw/dns-query',
    bootstrapIPs: ['101.101.101.101', '2001:de4::101', '2001:de4::102'],
    description: 'Taiwan DNS service',
    region: 'Taiwan',
  );

  /// Mullvad DNS - Privacy-focused VPN provider
  static const mullvad = DoHProvider(
    id: 8,
    name: 'Mullvad',
    url: 'https://dns.mullvad.net/dns-query',
    bootstrapIPs: ['194.242.2.2', '2a07:e340::2'],
    description: 'Privacy-focused VPN provider',
    region: 'Global',
  );

  /// ControlD DNS - Unfiltered free option
  static const controld = DoHProvider(
    id: 9,
    name: 'ControlD',
    url: 'https://freedns.controld.com/p0',
    bootstrapIPs: ['76.76.2.0', '76.76.10.0', '2606:1a40::', '2606:1a40:1::'],
    description: 'Unfiltered (free option)',
    region: 'Global',
  );

  /// Njalla DNS - Non-logging, uncensored
  static const njalla = DoHProvider(
    id: 10,
    name: 'Njalla',
    url: 'https://dns.njal.la/dns-query',
    bootstrapIPs: ['95.215.19.53', '2001:67c:2354:2::53'],
    description: 'Non-logging and uncensored',
    region: 'Global',
  );

  /// Shecan DNS - Iran censorship bypass
  static const shecan = DoHProvider(
    id: 11,
    name: 'Shecan',
    url: 'https://free.shecan.ir/dns-query',
    bootstrapIPs: ['178.22.122.100', '185.51.200.2'],
    description: 'Iran censorship bypass',
    region: 'Iran',
  );

  /// All providers in a list
  static const List<DoHProvider> all = [
    cloudflare,
    google,
    adguard,
    quad9,
    alidns,
    dnspod,
    dns360,
    quad101,
    mullvad,
    controld,
    njalla,
    shecan,
  ];

  static final Map<int, DoHProvider> byId = {
    for (final provider in all) provider.id: provider,
  };
}
