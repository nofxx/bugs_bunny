module BugsBunny
  class Exchange
    attr_reader :name, :durable, :delete

    def self.parse(txt)
      return nil if txt =~ /Listing|\.\.\./
      new(txt)
    end

    def initialize(txt)
      @name, @kind, @durable, @delete, @args = txt.split("\t")
    end

    def <=>(other)
      @name <=> other.name
    end

    def kind
      @kind.capitalize
    end

    def x(x)
      eval(x) ? "    X" : ""
    end

    def durable_x;      x(@durable);    end
    def delete_x;      x(@delete);    end
  end
end
