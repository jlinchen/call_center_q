require_relative "call"
require_relative "agent"

class Queue
  attr_accessor :minute, :average_current_waiting_time, :average_current_serve_time

  def initialize(minute, calls, agents)
    @minute = minute
    @calls = calls
    @agents = agents
    @average_current_waiting_time = calculate_average_current_waiting_time
    @average_current_serve_time = calculate_average_current_serve_time
  end

  private

  def calculate_average_current_waiting_time
    calls_until_now = @calls.select { |call| call.minute_of_call <= minute }
    calls_until_now.map(&:waiting_time).reduce(0, :+) / calls_until_now.count.to_f
  end

  def calculate_average_current_serve_time
    @agents.map { |agent| agent.waiting_time / (agent.calls_count.to_f + 1) }.reduce(0, :+) / @agents.count.to_f
  end
end
