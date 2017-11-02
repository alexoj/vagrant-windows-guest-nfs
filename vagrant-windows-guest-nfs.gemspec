lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "vagrant-windows-guest-nfs/version"

Gem::Specification.new do |spec|
  spec.name          = "vagrant-windows-guest-nfs"
  spec.version       = VagrantWindowsGuestNfs::VERSION
  spec.authors       = ["Alejandro Ojeda"]
  spec.email         = ["alex@x3y.org"]

  spec.summary       = %q{Vagrant plugin that mounts NFS shared folders in windows guests.}
  spec.homepage      = "https://github.com/alexoj/vagrant-windows-guest-nfs"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
