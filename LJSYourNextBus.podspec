Pod::Spec.new do |s|
  s.name         = "LJSYourNextBus"
  s.version      = "3.1.2"
  s.summary      = "Objective-C wrapper for YourNextBus times from South and West Yorkshire Transport."
  s.description  = <<-DESC
                    Objective-C wrapper for YourNextBus times from South and West Yorkshire Transport
                    Scrapes live departure data from South or West Yorkshire Transport into Objective-C `Stop`, `Service` and `Departure` objects.
                   DESC
  s.homepage     = "https://github.com/lukestringer90/LJSYourNextBus"
  s.license      = 'MIT'
  s.author       = { "Luke Stringer" => "lukestringer90@gmail.com" }
  s.source       = { :git => "https://github.com/lukestringer90/LJSYourNextBus.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.public_header_files = 'Classes/LJSYourNextBusClient.h', 'Classes/LJSSouthYorkshireClient.h', 'Classes/LJSWestYorkshireClient.h', 'Classes/LJSStop.h', 'Classes/LJSService.h', 'Classes/LJSDeparture.h', 'Classes/LJSLiveDataResult.h'
  
  s.dependency 'ObjectiveGumbo'
end
