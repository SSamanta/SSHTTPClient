Pod::Spec.new do |s|
  s.name     = "SSHTTPClient"
  s.version  = "1.0.0"
  s.license  = 'MIT'
  s.summary  = 'Sample network call.'
  s.homepage = 'https://github.com/SSamanta/'
  s.authors  = { 'Susim' => 'susim.samanta@me.com' }
  s.source   = { :git => "https://github.com/SSamanta/SSHTTPClient.git", :branch => "master", :tag => "v1.0.0"  }
  spec.source_files = 'SSHTTPClient.{swift}'
end
