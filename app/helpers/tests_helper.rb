module TestsHelper

  def test_level(test)
    case test.level
    when 0
      'easy'
    when 1
      'elementary'
    when 2
      'advanced'
    when 3
      'hard'
    else
      'hero'
    end
  end
end
