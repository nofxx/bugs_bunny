module BugsBunny
  class Queue
    attr_reader :name, :msgs, :users
    @queues = []

    def self.all
      # possible with amqp?
      `rabbitmqctl list_queues -p #{Opt[:rabbit][:vhost]} name durable auto_delete arguments node messages_ready messages_unacknowledged messages_uncommitted messages consumers transactions memory`.split("\n").each do |l|
        next if l =~ /Listing|\.\./
        @queues << BugsBunny::Queue.new(*l.split("\t"))
      end
      @queues
    end

    def self.create(name)
      MQ.queue(name).status do |msg, users|
        puts "#{msg} messages, #{users} consumers."
      end
    end

    def initialize(*params)
      @name, d, a,_,_,ready,_,all,@users, @transactions, @mem = *params
      @msgs = ready.to_i + all.to_i
      @durable = eval(d) if d #ugly
      @auto_delete = eval(a) if a #more ugly
      @mq = MQ.queue(@name, :passive => true)
    end

    def info
      puts "About #{@name}"
      @mq.status do |msg, users|
        puts "#{msg} messages, #{users} consumers."
      end
      halt
    end

    def list
      inspect
      EM.add_timer(1) { halt }
    end

    def inspect
      puts ""
      @mq.bind(MQ.fanout(@name)).subscribe(:ack => true) do |h, body| #, :nowait => false
        puts "-------\n"
        print "QUEUE #{h.delivery_tag} (#{h.content_type}): "
        print "Redelivered " if h.redelivered
        puts  "Mode #{h.delivery_mode}"
        puts  "Consumer: #{h.consumer_tag} Exchange: #{h.exchange}"
        txt = read(body)
        puts "\nBody:"
        puts txt
        puts
      end
    end
    alias :live :inspect

    def add(txt)
      @mq.publish(txt)
      halt
    end
    alias :publish :add

    def pop
      @mq.pop do |h, b|
        puts "Pop => #{h}\n Body => #{b}" if b
        halt
      end
    end
    alias :get :pop

    def purge
      print "Purging #{name}... "
      @mq.purge
      print "Done.\n"
      halt
    end
    alias :clean :purge

    def delete
      @mq.delete #:if_empty, if_unused, :no_wait
      halt
    end

    def to_s
      "#{@name} #{durable}: #{@msgs} messages"
    end

    def <=>(other)
      @name <=> other.name
    end

    private

    def read(dump, mode=:marshal)
      case mode
      when :marshal then Marshal.load(dump)
      when :json    then JSON.load(dump)
      else dump
      end
    rescue
      dump
    end

    def durable
      @durable ? "Durable" : "Volatile"
    end

    def halt
      BugsBunny::Rabbit.halt
    end

  end

end
