Pod::Spec.new do |s|  
      
    s.name         = "CCAbbar"
    s.version      = "1.0.6"
    s.summary      = "Make development easier."
    s.homepage     = "https://github.com/lecochao/CCAbbar"
    s.license      = "MIT"
    s.author       = { "lecochao" => "lecochao@qq.com" }
    s.platform     = :ios, "9.0"
    s.source       = { :git => "https://github.com/lecochao/CCAbbar.git", :tag => s.version }
    s.source_files  = "CCAbbar.h"
    s.framework  = "UIKit"
    s.requires_arc = true

    s.subspec 'CCDefine' do |ss|
        ss.public_header_files = 'CCDefine/CCDefine.h'
        ss.source_files = 'CCDefine/CCDefine.h'
    end
	s.subspec 'CCKit' do |ss|
		ss.dependency 'CCAbbar/CCDefine'
		ss.public_header_files = 'CCKit/*.h','CCKit/*/*.h'
		ss.source_files = 'CCKit/*.{h,m}','CCKit/*/*.{h,m}'
	end

	s.subspec 'Category' do |ss|
	#ss.dependency 'CCAbbar/CCDefine'
		ss.public_header_files = 'Category/*.h','Category/*/*.h'
		ss.source_files = 'Category/*.{h,m}','Category/*/*.{h,m}'
		ss.resource = 'Category/*.bundle'
	end
	s.subspec 'RACNetworking' do |ss|
		ss.public_header_files = 'RACNetworking/*/*.h','RACNetworking/*.h'
		ss.source_files = 'RACNetworking/*/*.{h,m}','RACNetworking/*.{h,m}'
		ss.dependency "JSONModel", "~> 1.8.0"
  		ss.dependency "AFNetworking", "~> 3.2.1"
    end
    #s.subspec 'Networking' do |ss|
	#	ss.public_header_files = 'Networking/*/*.h','Networking/*.h'
	#	ss.source_files = 'Networking/*/*.{h,m}','Networking/*.{h,m}'
	#	ss.dependency "JSONModel", "~> 1.8.0"
  	#	ss.dependency "AFNetworking", "~> 3.2.1"
    #end
end 