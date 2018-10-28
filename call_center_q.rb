require_relative "call"
require_relative "agent"
require_relative "queue"

class CallCenterQ
  attr_accessor :calls, :queues

  def initialize(agents_count: 50, period: 60, calls_per_hour: 100)
    @agents = Array.new(agents_count) { Agent.new }
    # all time values are in minutes
    @period = period
    @calls_per_hour = calls_per_hour
    @calls = Array.new(calls_per_period) { Call.new(rand(2..20), rand(1..period)) }
    @current_minute = 0
  end

  def run_q
    @queues = []
    (1..@period).each do |minute|
      @current_minute = minute
      waiting_calls.each do |call|
        break if next_free_agent.nil?
        next_free_agent.calls_count += 1
        next_free_agent.busy_until = @current_minute + call.duration - 1
        call.status = 'fetched'
        # in a real environment I would definetely save the association of the call to the agent
      end
      add_waiting_times
      @queues << Queue.new(minute, @calls, @agents)
    end
  end

  def print_queues
    output = "----------------CallCenterQ--------------------\n"
    @queues.each do |queue|
      output.concat(
        "Minute #{queue.minute}
        Average current waiting time: #{queue.average_current_waiting_time.round(2)}
        Average current serve time: #{queue.average_current_serve_time.round(2)}\n"
      )
    end
    output
  end

  private

  def waiting_calls
    @calls.select { |call| call.minute_of_call <= @current_minute && call.status == 'waiting' }
  end

  def next_free_agent
    free_agents.first
  end

  def free_agents
    @agents.select { |agent| agent.busy_until < @current_minute }
  end

  def add_waiting_times
    free_agents.each { |agent| agent.waiting_time += 1 }
    waiting_calls.each { |call| call.waiting_time += 1 }
  end

  def calls_per_period
    @calls_per_hour * @period / 60
  end
end
