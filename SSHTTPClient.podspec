Pod::Spec.new do |s|
  s.name     = "SSHTTPClient"
  s.version  = "1.0.1"
  s.license  = { :type => 'MIT' }
  s.summary  = 'Sample network call.'
  s.homepage = 'https://github.com/SSamanta/'
  s.authors  = { 'Susim' => 'susim.samanta@me.com' }
  s.source   = { :git => "https://github.com/SSamanta/SSHTTPClient.git", :branch => "master", :tag => "v1.0.1"  }
  s.source_files = 'SSHTTPClient/SSHTTPClient/SSHTTPClient.{swift}'
  s.requires_arc = true
end
