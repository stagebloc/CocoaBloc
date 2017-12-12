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
  end

   s.requires_arc = true
   s.frameworks = "Foundation"

end
