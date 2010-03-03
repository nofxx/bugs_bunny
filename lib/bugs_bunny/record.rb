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
      puts "About #{@name}"
      @mq.status do |msg, users|
        puts "#{msg} messages, #{users} consumers."
      end
      halt
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
      puts "Purging #{name}.."
      @mq.purge
      puts "Done."
      halt
    end
    alias :clean :purge

    def pop
      @mq.pop do |h, body|
        if body
          puts "Pop => #{h}"
          puts "Body => #{b}"
        end
        halt
      end
    end


    def to_s
      "#{@name} #{durable}: #{@msgs} messages"
    end

    def <=>(other)
      @name <=> other.name
    end

    private

    def durable
      @durable ? "Durable" : "Volatile"
    end

    def halt
      BugsBunny::Rabbit.halt
    end

  end

end
