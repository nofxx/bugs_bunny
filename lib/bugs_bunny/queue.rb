module BugsBunny
  class Queue
    include Helper
    attr_reader :name, :msgs, :users, :ready, :noack, :commit, :acts
    @queues = []

    def self.all
      # possible with amqp?
      `rabbitmqctl list_queues -p #{Opt[:rabbit][:vhost]} name durable auto_delete arguments messages_ready messages_unacknowledged messages_uncommitted messages consumers transactions memory`.split("\n").each do |l|
        next if l =~ /Listing|\.\./
        @queues << BugsBunny::Queue.new(*l.split("\t"))
      end
      @queues
    end

    def self.create(name)
      MQ.queue(name, :durable => true).status do |msg, users|
        puts "#{msg} messages, #{users} consumers."
      end
    end

    def initialize(*params)
      @name, d, a, args, @ready, @noack, @commit, @msgs,
        @users, @acts, @memory = *params
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

    def memory
      @memory #"%2.f"
    end

    def inspect
      # xchange = MQ.fanout(@name)
      #, :durable => false, :auto_delete => true)#, :internal => true)
      #mq = MQ.queue(@name+"_bb", :exclusive => true)
      @mq.subscribe(:ack => true) do |h, body| #, :nowait => false
        print_queue(h, body)
      end
    end
    alias :live  :inspect
    alias :watch :inspect

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
      "#{@name} #{kind}: #{@msgs} messages"
    end

    def <=>(other)
      @name <=> other.name
    end

    private
    def name_kind
      "(#{kind[0].chr}) #{@name}"
    end
    def kind
      @durable ? "Durable" : "Volatile"
    end

    def halt
      BugsBunny::Rabbit.halt
    end

  end

end
