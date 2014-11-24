Pod::Spec.new do |s|
    s.name = 'CocoaBloc'
    s.version = '0.0.4'
    s.authors = { 'John Heaton' => 'pikachu@stagebloc.com',
                  'Dave Skuza'  => 'neo@stagebloc.com' }
    s.social_media_url = 'https://twitter.com/StageBloc'
    s.homepage = 'https://github.com/stagebloc/CocoaBloc'
    s.summary = 'StageBloc Cocoa SDK'
    s.description = 'An Objective-C(Swift-compatible) library for interacting with StageBloc, and displaying StageBloc information/content to users.'
    s.dependency 'ReactiveCocoa'
    s.source = { :git => 'https://github.com/stagebloc/CocoaBloc.git', :tag => '0.0.1-podspec' }
    s.requires_arc = true
    s.source_files = 'Projects/Library/CocoaBloc/CocoaBloc.h'
    s.private_header_files = 'Projects/Library/CocoaBloc/Internal/*.h'
    s.ios.deployment_target = '7.0'
    s.osx.deployment_target = '10.9'

    s.subspec 'Categories' do |ss|
      ss.header_mappings_dir = 'Projects/Library/CocoaBloc/Categories'
      ss.source_files = 'Projects/Library/CocoaBloc/Categories/*.{h,m}'
    end

    s.subspec 'API' do |ss|
      ss.dependency 'AFNetworking'
      ss.dependency 'AFNetworking-RACExtensions'
      ss.dependency 'CocoaBloc/Models'
      ss.header_mappings_dir = 'Projects/Library/CocoaBloc/API'
      ss.source_files = 'Projects/Library/CocoaBloc/API/*.{h,m}'
    end

    s.subspec 'Models' do |ss|
      ss.dependency 'Mantle'
      ss.header_mappings_dir = 'Projects/Library/CocoaBloc/Models'
      ss.source_files = 'Projects/Library/CocoaBloc/{Models,Internal/Categories}/*.{h,m}'
      ss.private_header_files = 'Projects/Library/CocoaBloc/Internal/**/*.h'
    end

    s.subspec 'UI' do |ss|
      ss.dependency 'PureLayout'
      ss.dependency 'SDWebImage'
      ss.dependency 'CocoaBloc/Categories'
      ss.source_files = 'Projects/Library/CocoaBloc/UI/*.{h,m}'
      ss.header_mappings_dir = 'Projects/Library/CocoaBloc/UI'
      ss.resource_bundle = {'CocoaBlocUI' => 'Projects/Library/CocoaBloc/CocoaBlocUI.xcassets'}
    end

    s.subspec 'ViewModels' do |ss|
      ss.dependency 'CocoaBloc/API'
      ss.source_files = 'Projects/Library/CocoaBloc/ViewModels/*.{h,m}'
      ss.header_mappings_dir = 'Projects/Library/CocoaBloc/ViewModels'
    end

    s.subspec 'Camera' do |ss|
      ss.dependency 'CocoaBloc/API'
      ss.dependency 'CocoaBloc/UI'
      ss.dependency 'CocoaBloc/Categories'
      ss.dependency 'pop', '~>1.0.7'
      ss.source_files = 'Projects/Library/CocoaBloc/Camera/*.{h,m}'
      ss.header_mappings_dir = 'Projects/Library/CocoaBloc/Camera'
    end

end
