Pod::Spec.new do |s|
  s.name             = 'remote_webview_interceptor'
  s.version          = '1.0.0'
  s.summary          = 'shouldInterceptRequest for WKWebView.'
  s.description      = <<-DESC
Routes the http and https requests of selected WKWebViews through a URL scheme
handler, so the app can answer them itself or load them from the network.
                       DESC
  s.homepage         = 'https://github.com/kodjodevf/mangayomi'
  s.license          = { :type => 'Apache-2.0' }
  s.author           = { 'Mangayomi' => 'kodjodevf@users.noreply.github.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*.swift'
  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'
  s.ios.deployment_target = '15.0'
  s.osx.deployment_target = '12.0'
  s.frameworks = 'WebKit'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
