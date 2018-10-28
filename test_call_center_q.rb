require_relative "call_center_q"
require "test/unit"

class TestCallCenterQ < Test::Unit::TestCase
  def test_initialize_with_right_calls_count
    # testing if simulated calls are generated correctly
    assert_equal(100, CallCenterQ.new.calls.count)
    assert_equal(116, CallCenterQ.new(period: 70).calls.count)
    assert_equal(500, CallCenterQ.new(period: 150, calls_per_hour: 200).calls.count)
    assert_equal(22, CallCenterQ.new(period: 135, calls_per_hour: 10).calls.count)
  end

  def test_calculating_averages
    q = CallCenterQ.new(agents_count: 5, period: 10, calls_per_hour: 60)
    # in the class calls are actually randomly generated according to the given parameters
    # overwriting the calls can cause inconsistencies, just for testing!
    q.calls = Array.new(10) { Call.new(3, 1) }
    q.run_q
    # we have 10 calls all comming in at the first minute with a duration of 3 minutes
    # we have 5 agents
    # minute 1: 5 have to wait one minute, the other ones are served, no agents are free
    # -> average_current_waiting_time: 0.5
    # -> average_current_serve_time: 0
    # minute 2-3: 5 have to wait another minute, the other ones are served
    # -> average_current_waiting_time: 1, 1.5
    # -> average_current_serve_time: 0
    # minute 4: the other 5 calls can be taken, all agents are busy
    # -> average_current_waiting_time: 1.5
    # -> average_current_serve_time: 0
    # minute 5-6: all calls are taken, waiting time doesn't increase, all agents are busy
    # -> average_current_waiting_time: 1.5
    # -> average_current_serve_time: 0
    # minute 7-10: all calls are done, waiting time stays the same, all agents are free, so the serve time increases
    # keep in mind, the agents had zero waiting time at the start and in between calls and we want the average
    # so it's the waiting time now divided by 3
    # -> average_current_waiting_time: 1.5
    # -> average_current_serve_time: 1/3, 2/3, 3/3, 4/3
    assert_equal([0.5, 1, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5], q.queues.map(&:average_current_waiting_time))
    assert_equal([0, 0, 0, 0, 0, 0, 1/3.0, 2/3.0, 1, 4/3.0], q.queues.map(&:average_current_serve_time))
  end
end
