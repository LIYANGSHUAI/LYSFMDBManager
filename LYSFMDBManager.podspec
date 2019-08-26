Pod::Spec.new do |s|
s.name         = "LYSFMDBManager"
s.version      = "0.0.1"
s.summary      = "简单对FMDB进一步封装,使用起来更方面"
s.description  = <<-DESC
简单对FMDB进一步封装,使用起来更方面,简单对FMDB进一步封装,使用起来更方面,简单对FMDB进一步封装,使用起来更方面
DESC
s.homepage     = "https://github.com/LIYANGSHUAI/LYSFMDBManager"

s.platform     = :ios, "8.0"
s.license      = "MIT"
s.author             = { "李阳帅" => "liyangshuai163@163.com" }

s.source       = { :git => "https://github.com/LIYANGSHUAI/LYSFMDBManager.git", :tag => s.version }

s.source_files  = "LYSFMDBManager", "LYSFMDBManager/*.{h,m}"
s.dependency "FMDB", "~> 2.7.2"
end
