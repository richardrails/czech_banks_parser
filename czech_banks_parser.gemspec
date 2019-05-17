Gem::Specification.new do |s|
  s.name               = "czech_banks_parser"
  s.version            = "0.0.6"
  s.default_executable = "czech_banks_parser"
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.0.0'

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Richard Lapiš"]
  s.date = %q{2018-05-14}
  s.description = %q{A parser from Czech Banks API's - CSAS, FIO}
  s.email = %q{richard.lapis@gmail.com}
  s.files = `git ls-files`.split("\n")
  s.test_files = []
  s.homepage = %q{https://github.com/richardrails/czech_banks_parser}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{A parser from Czech Banks API's}
  s.license = 'MIT'

  s.add_runtime_dependency("rest-client", "~> 1.7.3")

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end