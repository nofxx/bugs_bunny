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
      halt
    end

    def queues
      # possible with amqp?
      `rabbitmqctl list_queues -p /nanite name durable auto_delete arguments node messages_ready messages_unacknowledged messages_uncommitted messages consumers transactions memory`.split("\n").each do |l|
        next if l =~ /Listing|\.\./
        @records << BugsBunny::Record.new(*l.split("\t"))
      end
      print_table "Queues", @records.sort_by { |r| r.msgs }
    end

    def exchanges
      print_table "Queues", @mq.exchanges
    end

    def queue(q, action="info")
      puts "Stats for queue #{q}:"
      rec = BugsBunny::Record.new(q)
      if rec.respond_to?(action)
        rec.send(action)
      else
        puts "No such action for queues."
      end
#      halt
    end

    def print_table(title, arr)
      halt if arr.empty?
      puts title
      arr.each do |q|
        puts q
      end
      halt
    end


    def halt
      MQ.queues{ |q| q.unsubscribe }
      AMQP.stop { EM.stop }
      # EM.stop_event_loop
      #Messaging.amqp.close { EM.stop }
      # MQ.queues.
    end

    trap("INT") do
      puts "\nClosing.."
      AMQP.stop{ EM.stop }
    end

  end

end
