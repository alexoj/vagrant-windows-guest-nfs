source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

group :development do
    gem "bundler", "~> 1.16"
    gem "rake", "~> 10.0"
    gem "vagrant", git: "https://github.com/mitchellh/vagrant.git"
end

group :plugins do
    gem "vagrant-windows-guest-nfs", path: "."
end
