require 'gli'
require 'test/unit'
require 'test/unit/ui/console/testrunner'

include GLI
class TC_testSwitch < Test::Unit::TestCase

  def test_basics_simple
    switch = Switch.new(:filename,'Use filename')
    do_basic_asserts(switch,:filename,nil,'Use filename')
  end

  def test_basics_kinda_complex
    switch = Switch.new([:f],'Use filename')
    do_basic_asserts(switch,:f,nil,'Use filename')
  end

  def test_basics_complex
    switch = Switch.new([:f,:file,:filename],'Use filename')
    do_basic_asserts(switch,:f,[:file,:filename],'Use filename')
  end

  def do_basic_asserts(switch,name,aliases,desc)
    assert_equal(name,switch.name)
    assert_equal(aliases,switch.aliases)
    assert_equal(desc,switch.description)
    assert_equal("#{Switch.as_switch(name)} - #{desc}",switch.usage)
  end
  def test_find_one_switch
    args = %w(foo bar -f -g -h baz)
    switch = Switch.new(:f,"Some Switch")
    args_size = args.length
    present = switch.get_value!(args)
    assert(present)
    assert_equal(args_size - 1,args.size)
  end

  def test_find_one_switch_long
    args = %w(foo bar --file -g -h baz)
    switch = Switch.new([:f,:file,:bar],"Some Switch")
    args_size = args.length
    present = switch.get_value!(args)
    assert(present)
    assert_equal(args_size - 1,args.size)
  end

  def test_find_many_switchs
    args = %w(foo bar -f -g --file -h baz -f -file --fileblah --f)
    switch = Switch.new([:f,:file],"Some Switch")
    args_size = args.length
    times = 0
    while switch.get_value!(args)
      times += 1
    end
    assert_equal(3,times)
    assert_equal(args_size - times,args.size)
  end

  def test_find_switch_not_there
    args = %w(foo bar -f -g -h baz)
    switch = Switch.new(:i,"Some Switch")
    args_size = args.length
    present = switch.get_value!(args)
    assert(!present)
    assert_equal(args_size,args.size)
  end
end
