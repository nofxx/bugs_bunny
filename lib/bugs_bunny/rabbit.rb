# Amqp rabbitmq stuff
module BugsBunny

  class Rabbit

    def initialize(params=nil)
      @records = []
    end

    def start!(command)
     # @mq = MQ.new AMQP::connect
      send(*command)
    end

    def vhosts
      puts `rabbitmqctl list_vhosts`
    end

    def queues
      # possible with amqp?
      `rabbitmqctl list_queues -p /nanite name durable auto_delete arguments node messages_ready messages_unacknowledged messages_uncommitted messages consumers transactions memory`.split("\n").each do |l|
        next if l =~ /Listing|\.\./
        @records << BugsBunny::Record.new(*l.split("\t"))
      end
      print_table "Queues", @records.sort_by { |r| r.msgs }
      halt
    end

    def exchanges
      print_table "Queues", @mq.exchanges
    end

    def queue(q, action="info")
      rec = BugsBunny::Record.new(q)
      if rec.respond_to?(action)
        rec.send(action)
      else
        puts "No such action for queues."
      end
    end

    def print_table(title, arr)
      return if arr.empty?
      puts title
      arr.each do |q|
        puts q
      end
    end

    def halt
      BugsBunny::Rabbit.halt
    end

    def self.halt
      puts
      MQ.queues{ |q| q.unsubscribe }
      AMQP.stop { EM.stop }
    end

    trap("INT") { halt }
    trap("TERM") { halt }

  end

end
