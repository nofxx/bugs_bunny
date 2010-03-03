# Command Line Stuff
require 'yaml'
begin
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
        conn = BugsBunny::Rabbit.new
        unless conn.respond_to?(argv[0])
          puts "Can`t do that."; exit
        end
        log "Connecting to rabbitmq #{Opt[:rabbit][:vhost]}"
        AMQP.start(Opt[:rabbit]) do
          conn.start!(argv)
        end
      end
    end

    def config
      path = "./"
      path = "config/" if File.exists?("config/")
      if config_exists?(path) && !Opt[:force]
        puts "Config file already exists"
        exit
      else
        File.copy(File.dirname(__FILE__) + "/#{CONFIG_FILE}", path)
        puts "Copied config file to #{path}"
      end
    end

    private

    def log(*args)
      #return unless Opt[:verbose]
      puts *args
    end

    def config_exists?(path, name = CONFIG_FILE)
      File.exists?(path + name)
    end

    def parse_config
      unless file = Opt[:config]
        file = ["", "config/"].select { |p| config_exists?(p) }[0]
        file += CONFIG_FILE
      end
      unless File.exists?(file)
        puts "No config file"; exit
      end
      Opt[:rabbit].merge! YAML.load(File.read(file))
    end

  end

end
