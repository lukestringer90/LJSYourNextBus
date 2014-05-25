Pod::Spec.new do |s|
  s.name         = "LJSYourNextBus"
  s.version      = "1.1.0"
  s.summary      = "Native Objective-C interface to South Yorkshire Passenger Transport Executive Live departure information (http://tsy.acislive.com)."
  s.description  = <<-DESC
                    Native Objective-C interface to South Yorkshire Passenger Transport Executive Live departure information
                    Scrapes live departure data from http://tsy.acislive.com into Objective-C `Stop`, `Service` and `Departure` objects.
                   DESC
  s.homepage     = "https://bitbucket.org/lukestringer90/ljstravelsouthyorkshire"
  s.license      = 'MIT'
  s.author       = { "Luke Stringer" => "lukestringer630@gmail.com" }
  s.source       = { :git => "git@bitbucket.org:lukestringer90/ljstravelsouthyorkshire.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.public_header_files = 'Classes/LJSYourNextBusClient.h', 'Classes/LJSStop.h', 'Classes/LJSService.h', 'Classes/LJSDeparture.h'
  s.dependency 'ObjectiveGumbo'
end
