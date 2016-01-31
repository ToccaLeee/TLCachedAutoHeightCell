
Pod::Spec.new do |s|
  s.name                 = "TLCachedAutoHeightCell"

  s.version              = "0.1.6"

  s.summary              = "A framework for automatically calculating and caching cell height."

  s.description          = <<-DESC
                            Automatically cell height calculating and position or content based height caching.
                            DESC

  s.homepage             = "https://github.com/ToccaLeee/TLCachedAutoHeightCell"

  s.license              = 'MIT'

  s.author               = { "ToccaLee" => "xiaoliu.li@ele.me" }

  s.source               = { :git => "https://github.com/ToccaLeee/TLCachedAutoHeightCell.git", :tag => s.version.to_s }

  s.platform             = :ios, '7.0'

  s.requires_arc         = true

  s.source_files         = 'Pod/Classes/*.h', 'Pod/Classes/Cache/*.{h,m}', 'Pod/Classes/AutoHeight/*.{h,m}'

  s.public_header_files  = 'Pod/Classes/TLCachedAutoHeightCell.h', 'Pod/Classes/AutoHeight/*.h', 'Pod/Classes/Cache/*.h'

  s.resource_bundles     = {
    'TLCachedAutoHeightCell' => ['Pod/Assets/*.png']
  }

  s.frameworks           = 'UIKit'
end
