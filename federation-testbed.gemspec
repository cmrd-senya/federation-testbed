Gem::Specification.new do |spec|
  spec.name = "federation-testbed"
  spec.version = "0.1.0"

  spec.files = ["lib/**/*"]

  spec.summary = "A tool suite to help in testing of the Diaspora's federation protocol"
  spec.author = "cmrd Senya"
  spec.email = "senya@riseup.net"
  spec.homepage = "https://github.com/cmrd-senya/federation-testbed"

  spec.add_dependency("rest-client")
end
