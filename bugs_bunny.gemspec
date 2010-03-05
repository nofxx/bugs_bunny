# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{bugs_bunny}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marcos Piccinini"]
  s.date = %q{2010-03-05}
  s.default_executable = %q{bbunny}
  s.description = %q{Play/Manage RabbitMQ. Vhosts, queues.}
  s.email = %q{x@nofxx.com}
  s.executables = ["bbunny"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/bbunny",
     "bugs_bunny.gemspec",
     "cucumber.yml",
     "features/bugs_bunny.feature",
     "features/exchanges.feature",
     "features/queues.feature",
     "features/step_definitions/bugs_bunny_steps.rb",
     "features/step_definitions/queue_steps.rb",
     "features/support/env.rb",
     "lib/bugs_bunny.rb",
     "lib/bugs_bunny/cli.rb",
     "lib/bugs_bunny/exchange.rb",
     "lib/bugs_bunny/helper.rb",
     "lib/bugs_bunny/queue.rb",
     "lib/bugs_bunny/rabbit.rb",
     "lib/bugs_bunny/rabbitmq.yml",
     "spec/bugs_bunny/cli_spec.rb",
     "spec/bugs_bunny/rabbit_spec.rb",
     "spec/bugs_bunny_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/nofxx/bugs_bunny}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Play/Manage RabbitMQ}
  s.test_files = [
    "spec/bugs_bunny/cli_spec.rb",
     "spec/bugs_bunny/rabbit_spec.rb",
     "spec/bugs_bunny_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<amqp>, [">= 0.6.7"])
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
    else
      s.add_dependency(%q<amqp>, [">= 0.6.7"])
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<cucumber>, [">= 0"])
    end
  else
    s.add_dependency(%q<amqp>, [">= 0.6.7"])
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<cucumber>, [">= 0"])
  end
end

