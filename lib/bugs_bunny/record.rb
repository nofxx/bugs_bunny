module BugsBunny
  class Record
    attr_reader :name, :msgs, :users
    def initialize(*params)
      @name, d, a,_,_,@msgs,_,_,@users, @transactions, @mem = *params
      @durable = eval(d) if d #ugly
      @auto_delete = eval(a) if a #more ugly
      @mq = MQ.queue(@name, :passive => true)
    end

    def info
      @mq.status do |msg, users|
        puts "#{msg} messages, #{users} consumers."
      end
      AMQP.stop { EM.stop }
    end

    def inspect
      puts ""
      @mq.subscribe(:ack => true, :nowait => false) do |header, body|
        puts "QUEUE #{header.delivery_tag}: #{header.inspect}"
        txt = Marshal.load(body) rescue body
        puts "\nBody:"
        puts txt
        puts
        puts "--\n"
      end
    end

    def purge
    end

    def durable
      @durable ? "Durable" : "Volatile"
    end

    def to_s
      "#{@name} #{durable}: #{@msgs} messages"
    end

  end

end
