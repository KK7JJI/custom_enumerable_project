module Enumerable
  # Your code goes here
  #
  # I rewrote this one using &block instead to convince myself
  # that it works the same as using yield.
  #
  # def my_map
  #   return to_enum(:my_map) unless block_given?
  #   result = []
  #   my_each { |elem| result << yield(elem) }
  #   result
  # end

  def my_map(&block)
    return to_enum(:my_map) unless block_given?
    result = []
    my_each { |elem| result << block.call(elem) }
    result
  end

  def my_select
    return to_enum(:my_select) unless block_given?
    result = []
    my_each do  |elem|
      result << elem if yield(elem)
    end
    result
  end

  def my_count
    count = 0
    if block_given?
      my_each { |elem| count += 1 if yield(elem) }
    else
      my_each { |_elem| count += 1 }
    end
    count
  end

  def my_all?
    return to_enum(:my_all) unless block_given?
    if block_given?
      my_each { |elem| return false unless yield(elem) }
    else
      my_each { |elem| return false unless elem }
    end
    true
  end

  def my_any?
    return to_enum(:my_all) unless block_given?
    if block_given?
      my_each { |elem| return true if yield(elem) }
    else
      my_each { |elem| return true if elem }
    end
    false
  end

  def my_none?
    return to_enum(:my_none) unless block_given?
    if block_given?
      my_each { |elem| return false if yield(elem) }
    else
      my_each { |elem| return false if elem }
    end
    true
  end

  def my_inject(initial = nil, sym = nil, &block)

    if initial.is_a?(Symbol) && sym.nil?
      sym = initial
      initial = nil
    end

    if sym
      block = ->(acc, elem) { acc.send(sym, elem) }
    end

    acc_set = false
    acc = initial

    my_each do |elem|
      if acc_set == false && acc.nil?
        acc = elem
        acc_set = true
      else
        acc = block.call(acc, elem)
      end
    end
    acc
  end

end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
# lib/my_enumerables.rb

class Array
  def my_each
    return to_enum(:my_each) unless block_given?
    for item in self
      yield(item)
    end
  end
end

