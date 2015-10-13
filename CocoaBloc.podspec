Pod::Spec.new do |s|
	s.name	 	= 'CocoaBloc'
	s.version = '2.0.0-alpha'
	s.authors = { 'John Heaton' => 'pikachu@stagebloc.com',
								'David Warner' => 'spiderman@stagebloc.com' }
	s.social_media_url = 'https://twitter.com/StageBloc'
	s.license = { :type => 'MIT', :file => 'LICENSE' }
	s.source = { :git => 'https://github.com/stagebloc/CocoaBloc.git' }
	s.summary = 'StageBloc REST API client for iOS/OS X'
	s.ios.deployment_target = '8.0'
	s.requires_arc = true
	s.module_name = 'CocoaBloc'

	s.dependency 'Mantle'
	s.dependency 'Moya/ReactiveCocoa', '~> 4.0'

	s.source_files = 'CocoaBloc/**/*.{h,m,swift}'
	s.public_header_files = 'CocoaBloc/{Models,API}/*.h'
	s.private_header_files = 'CocoaBloc/Private/*.h'
end
