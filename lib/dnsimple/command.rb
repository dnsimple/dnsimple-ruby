module DNSimple
  class Command
    def initialize(out=$stdout)
      @out = out
    end
    def say(message)
      @out.write("#{message}\n")
    end
  end
end
