    Pod::Spec.new do |s|  
      
      s.name         = "CCAbbar"
      s.version      = "0.0.1"
      s.summary      = "Make development easier."  
      s.homepage     = "https://github.com/lecochao/CCAbbar"
      s.license      = "MIT"  
      s.author       = { "lecochao" => "lecochao@qq.com" }
      s.platform     = :ios, "9.0"
      s.source       = { :git => "https://github.com/lecochao/CCAbbar.git", :tag => s.version }
      s.source_files  = "WHKit", "WHKit/*.{h,m}"  
      s.framework  = "UIKit"  
      s.requires_arc = true   
      
    end  
