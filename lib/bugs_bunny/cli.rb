# Command Line Stuff
require 'yaml'
begin # Needed (really?) for ruby 1.8
  require 'ftools'
rescue LoadError
end

module BugsBunny
  class CLI
    CONFIG_FILE = "rabbitmq.yml"

    def initialize(argv)
      if respond_to?(argv[0])
        send(*argv)
      else
        parse_config
        rb = BugsBunny::Rabbit.new
        unless rb.respond_to?(argv[0])
          puts "Can`t do that."; exit
        end
        log "Connecting to rabbitmq #{Opt[:rabbit][:vhost]}"
        AMQP.start(Opt[:rabbit]) { rb.start!(argv) }
      end
    end

    # Write down a yml in ./ or config/ for ease use with
    # bugs and on the
    def config
      path = "./"
      path = "config/" if File.exists?("config/")
      if config_exists?(path) && !Opt[:force]
        puts "Config file already exists"
        exit
      else
        FileUtils.copy(File.dirname(__FILE__) + "/#{CONFIG_FILE}", path)
        puts "Copied config file to #{path}"
      end
    end

    def seed
      parse_config
      puts "Creating user and vhost"
      puts `rabbitmqctl add_user #{Opt[:rabbit][:user]} #{Opt[:rabbit][:pass]}`
      puts `rabbitmqctl add_vhost #{Opt[:rabbit][:vhost]}`
      puts `rabbitmqctl set_permissions -p #{Opt[:rabbit][:vhost]} #{Opt[:rabbit][:user]} ".*" ".*" ".*"`
    end

    private

    def log(*args)
      return unless Opt[:verbose]
      puts *args
    end

    def config_exists?(path)
      File.exists?(path + CONFIG_FILE)
    end

    def parse_config
      unless file = Opt[:config]
        file = ["", "config/"].select { |p| config_exists?(p) }[0]
        file += CONFIG_FILE if file
      end
      unless file && File.exists?(file)
        puts "No config file.\nCreate one with 'config'"; exit
      end
      Opt[:rabbit].merge! YAML.load(File.read(file))
    end

  end

end
