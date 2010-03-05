# Amqp rabbitmq stuff
module BugsBunny

  class Rabbit
    include Helper

    def initialize(params=nil)
    end

    def start!(command)
     # @mq = MQ.new AMQP::connect
      send(*command)
    end

    def vhosts
      puts `rabbitmqctl list_vhosts`
    end

    def queues(param=nil,name=nil)
      if param == "new"
        return halt("new <name>") unless name
        BugsBunny::Queue.create(name)
        return halt
      end
      qs = BugsBunny::Queue.all
      unless param
        print_table "Queues", qs.sort, :msgs, :name_kind,
          :users, :ready, :noack, :commit, :acts, :memory
      else
        qs.each(&:"#{param}")
      end
      halt
    end
    alias :qu :queues

    def queue(q, action="info", *params)
      rec = BugsBunny::Queue.new(q)
      if rec.respond_to?(action)
        rec.send(action, *params)
      else
        puts "No such action for queues."
        halt
      end
    end
    alias :q :queue

    def exchanges
      arr = `rabbitmqctl list_exchanges -p #{Opt[:rabbit][:vhost]} name type durable auto_delete arguments`.split("\n").map do |e|
        BugsBunny::Exchange.parse(e)
      end.reject(&:nil?).sort

      print_table "Exchanges", arr, :name, :kind, :durable_x, :delete_x
      halt
    end
    alias :ex :exchanges

    def bindings
      arr = `rabbitmqctl list_bindings -p #{Opt[:rabbit][:vhost]}`.split("\n")
      arr.map { |l|l.gsub(/^\t/, "") }.sort.each do |l|
        next if l =~ /Listing|\.\.\./
        from, to, args = l.split("\t")
        puts "#{from} <=> #{to}"
      end
      halt
    end
    alias :binds :bindings

    def halt(msg=nil)
      BugsBunny::Rabbit.halt(msg)
    end

    def self.halt(msg=nil)
      puts msg if msg
      MQ.queues{ |q| q.unsubscribe }
      AMQP.stop { EM.stop }
      #EM.stop_event_loop
      #exit
    end

    trap("INT") { halt }
    trap("TERM") { halt }

  end

end
