class Agent
  attr_accessor :busy_until, :waiting_time, :calls_count

  def initialize
    @busy_until = 0
    @waiting_time = 0
    @calls_count = 0
  end
end
