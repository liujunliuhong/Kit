
Pod::Spec.new do |s|
  s.name                       = 'YHOCTool'
  s.homepage                   = 'https://github.com/liujunliuhong/Kit'
  s.summary                    = 'OC版本的开发工具，逐步向Swift迁移'
  s.description                = 'OC版本的开发工具，逐步向Swift迁移'
  s.author                     = { 'liujunliuhong' => '1035841713@qq.com' }
  s.version                    = '0.0.2'
  s.source                     = { :git => 'https://github.com/liujunliuhong/Kit.git', :tag => s.version.to_s }
  s.platform                   = :ios, '9.0'
  s.license                    = { :type => 'MIT', :file => 'LICENSE' }
  s.module_name                = 'YHOCTool'
  s.swift_version              = '5.0'
  s.ios.deployment_target      = '9.0'
  s.requires_arc               = true
  s.static_framework = true
  
  


  # Core
  s.subspec 'Core' do |ss|
  ss.source_files              = 'Sources/Core/*', 'Sources/Core/*/*', 'Sources/Core/*/*/*'
  ss.dependency 'AFNetworking'
  ss.dependency 'Texture'
  ss.dependency 'SDWebImage'
  ss.dependency 'SDWebImageWebPCoder'
  ss.dependency 'YYText'
  ss.dependency 'MBProgressHUD'
  ss.dependency 'Masonry'
  ss.dependency 'FLAnimatedImage'
  end

end
