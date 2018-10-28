class Call
  attr_accessor :duration, :minute_of_call, :waiting_time, :status
  def initialize(duration, minute_of_call)
    # duration in minutes
    @duration = duration
    @minute_of_call = minute_of_call
    @waiting_time = 0
    @status = 'waiting'
  end
end
