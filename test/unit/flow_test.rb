# coding:utf-8

require_relative '../test_helper'

class FlowTest < ActiveSupport::TestCase
  test "Can set the display name" do
    s = SmartAnswer::Flow.new do
      display_name "Sweet or savoury?"
    end
    
    assert_equal "Sweet or savoury?", s.display_name
  end
  
  test "Can build outcome nodes" do
    s = SmartAnswer::Flow.new do
      outcome :you_dont_have_a_sweet_tooth
    end
    
    assert_equal 1, s.nodes.size
    assert_equal 1, s.outcomes.size
    assert_equal [:you_dont_have_a_sweet_tooth], s.outcomes.map(&:name)
  end
  
  test "Can build multiple choice question nodes" do
    s = SmartAnswer::Flow.new do
      multiple_choice :do_you_like_chocolate? do
        option :yes => :sweet_tooth
        option :no => :savoury_tooth
      end
      
      outcome :sweet_tooth
      outcome :savoury_tooth
    end
    
    assert_equal 3, s.nodes.size
    assert_equal 2, s.outcomes.size
    assert_equal 1, s.questions.size
  end

  test "Question nodes are automatically numbered" do
    s = SmartAnswer::Flow.new do
      multiple_choice :do_you_like_chocolate?
      outcome :sweet_tooth
      multiple_choice :do_you_like_apples?
    end
    
    assert_equal 1, s.questions[0].number
    assert_equal 2, s.questions[1].number
  end
  
  test "Can load a flow from a file" do
    SmartAnswer::Flow.with_load_path(File.dirname(__FILE__) + '/../fixtures/') do
      flow = SmartAnswer::Flow.load('flow_sample')
      assert_equal 1, flow.questions.size
      assert_equal :hotter_or_colder?, flow.questions.first.name
      assert_equal %w{hotter colder}, flow.questions.first.options
      assert_equal [:hot, :cold], flow.outcomes.map(&:name)
    end
  end

  test "Dodgy filenames are blocked when loading" do
    assert_raises RuntimeError do
      SmartAnswer::Flow.load("/etc/passwd")
    end
  end

  context "sequence of two questions" do
    setup do
      @flow = SmartAnswer::Flow.new do
        multiple_choice :do_you_like_chocolate? do
          option yes: :sweet
          option no: :do_you_like_jam?
        end

        multiple_choice :do_you_like_jam? do
          option yes: :sweet
          option no: :savoury
        end
        outcome :sweet
        outcome :savoury
      end
    end
    
    should "calculate state after a series of responses" do
      assert_equal :do_you_like_chocolate?, @flow.process([]).current_node
      assert_equal :do_you_like_jam?, @flow.process(%w{no}).current_node
      assert_equal :sweet, @flow.process(%w{no yes}).current_node
      assert_equal :sweet, @flow.process(%w{yes}).current_node
      assert_equal :savoury, @flow.process(%w{no no}).current_node
      assert_raises SmartAnswer::InvalidResponse do
        @flow.process(%w{maybe})
      end
    end
  
    should "calculate the path traversed by a series of responses" do
      assert_equal [], @flow.path([])
      assert_equal [:do_you_like_chocolate?], @flow.path(%w{no})
      assert_equal [:do_you_like_chocolate?, :do_you_like_jam?], @flow.path(%w{no yes})
      assert_equal [:do_you_like_chocolate?], @flow.path(%w{yes})
      assert_equal [:do_you_like_chocolate?, :do_you_like_jam?], @flow.path(%w{no no})
      assert_raises SmartAnswer::InvalidResponse do
        @flow.path(%w{maybe})
      end
    end
  end
end