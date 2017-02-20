Pod::Spec.new do |s|

  s.name         = "CocoaBloc"
  s.version      = "1.0"
  s.summary      = "A short description of CocoaBloc."

  s.description  = "A Swift library for using the StageBloc v1 REST API."

  s.homepage     = "http://EXAMPLE/CocoaBloc"
  s.license      = ":type => 'MIT', :file => 'LICENSE'"

  s.author             = { "Billy Lavoie" => "billy_lavoie@hotmail.com" }
  s.platform     = :ios, "9.0"
  s.ios.deployment_target = '9.0'


  s.source       = { :git => 'https://github.com/stagebloc/CocoaBloc.git', :branch => 'v2/cocoapod', :tag => s.version.to_s }

  s.subspec 'Core' do |ss|
    ss.source_files = "CocoaBloc/**/*.{swift,h,m}"
    ss.public_header_files = "CocoaBloc/**/*.h"
    ss.exclude_files = ["CocoaBloc/Extensions/SBContentStreamObject+ContentType.swift", "CocoaBloc/API Types & Endpoints/API+Content.swift", "CocoaBloc/API Types & Endpoints/API+FanClub.swift", "CocoaBloc/**/Audio.swift", "CocoaBloc/**/Audio*.swift", "*ReactiveCocoaBloc*"]
  end


  s.subspec 'ReactiveCocoaBloc' do |ss|
    ss.source_files = 'ReactiveCocoaBloc/**/*.{swift}'
    ss.dependency 'ReactiveCocoa', '~> 5.0.0'
    ss.dependency 'CocoaBloc/Core'
  end

   s.requires_arc = true
   s.frameworks = "Foundation"

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "Alamofire"
  s.dependency "Runes"
  s.dependency "Argo"
  s.dependency "Curry"

end
