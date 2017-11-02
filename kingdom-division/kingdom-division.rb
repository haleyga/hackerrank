#!/bin/ruby

MOD_NUM = 1000000007

class City
  attr_accessor :id
  attr_accessor :owner
  attr_accessor :neighbors

  def initialize(id, owner)
    @id               = id
    @owner            = owner
    @neighbors        = []
    @is_battle_ground = false
  end

  def add_road_from(from_city)
    @neighbors.push from_city
  end

  def add_road_to(to_city)
    @neighbors.push to_city
  end

  def is_leaf?
    @neighbors.length == 1
  end

  def is_internal_with_leaves?
    !is_internal_leaf? && @neighbors.select(&:is_leaf?).length > 0
  end

  def is_internal_without_leaves?
    !is_leaf? && @neighbors.select(&:is_leaf?).none?
  end

  def is_internal_leaf?
    !is_leaf? && @neighbors.select(&:is_leaf?).length == @neighbors.length - 1
  end

  def count_divisions(calling_node=self, level=0)
    tab_prefix = "\t"*level
    internal = @neighbors.select{|x| x.id != calling_node.id && !x.is_leaf?}
    puts "#{tab_prefix}#{@id} neighbors #{@neighbors.map(&:id)}"
    puts "#{tab_prefix}#{@id} valid neighbor count #{internal.length}"
    internal_leaves = @neighbors.select{|x| x.id != calling_node.id && x.is_internal_leaf?}
    internal_without_leaves = @neighbors.select{|x| x.id != calling_node.id && x.is_internal_without_leaves?}
    internal_with_leaves = @neighbors.select{|x| x.id != calling_node.id && x.is_internal_with_leaves?}
    if is_leaf?
      puts "#{tab_prefix}#{@id} is a leaf"
      count = 0 + @neighbors.select{|x| x.id != calling_node.id}.map{|x| x.count_divisions(self, level+1)}
    elsif is_internal_leaf?
      puts "#{tab_prefix}#{@id} is an internal leaf"
      count = 2 + internal.map{|x| x.count_divisions(self, level+1)}.inject(0){|sum,x| sum+x}
    elsif is_internal_with_leaves?
      puts "#{tab_prefix}#{@id} is an internal with leaves"
      count = 2 + internal.map{|x| x.count_divisions(self, level+1)}.inject(0){|sum,x| sum+x} + exclamation_operator(internal.length)
    elsif is_internal_without_leaves?
      puts "#{tab_prefix}#{@id} is an internal without leaves"
      count = 2 + internal.map{|x| x.count_divisions(self, level+1)}.inject(0){|sum,x| sum+x} + 2*internal.length
    end
    puts "#{tab_prefix}:#{@id} count is #{count}"
    return count

  end

  def is_battle_ground?
    return @neighbors.select{|neighbor| neighbor.owner == @owner}.none?
  end

  def change_owner
    @owner = @owner == :betty ? :reggy : :betty
    @neighbors.select(&:is_leaf?).each(&:change_owner)
  end

  def division_count1(calling_node=self, level=0)
    puts "\n"
    tab_prefix = "\t"*level
    puts "#{tab_prefix}self => #{@id}, neighbors: #{@neighbors.select{|neighbor| neighbor.id != calling_node.id}.map(&:id)}"
    puts "#{tab_prefix}calling_node id: #{calling_node.id}"
    puts "#{tab_prefix}is_leaf? #{is_leaf?}"
    if is_leaf?
      puts "#{tab_prefix}returning 0 from #{@id}"
      return 0
    end
    puts "#{tab_prefix}is_internal_leaf? #{is_internal_leaf?}"
    subtree_count = @neighbors.select{|neighbor| neighbor.id != calling_node.id && !neighbor.is_leaf?}
                        .map{|neighbor| neighbor.division_count(self, level+1)}
                        .inject(0){|sum,x| sum + x}
    if is_internal_leaf?
      puts "#{tab_prefix}returning 2 + neighbors from #{@id}"
      return 2 + subtree_count
    end

    subtree_count = @neighbors.select{|neighbor| neighbor.id != calling_node.id && !neighbor.is_leaf?}
                              .map{|neighbor| neighbor.division_count(self, level+1)}
                              .inject(0){|sum,x| sum + x}

    # puts "#{tab_prefix}subtree(root #{@id}) sum: #{subtree_count}"
    # puts "#{tab_prefix}is_internal_without_leaves? #{is_internal_without_leaves?}"
    if is_internal_without_leaves?
      puts "#{tab_prefix}returning 2+subtree from #{@id}: #{2+subtree_count}"
      return 2 + subtree_count
    end
    puts "#{tab_prefix}returning subtree_count + 2 from #{@id}: #{subtree_count + 2*exclamation_operator(@neighbors.select{|neighbor| neighbor.is_internal_leaf?}.length) + 2}"
    return subtree_count + 2*exclamation_operator(@neighbors.select{|neighbor| neighbor.is_internal_leaf?}.length) + 2
  end

  def exclamation_operator(num)
    puts "exclamation_operator #{num}"
    (1..num).to_a.inject(1){|product,x| product * x}
  end

end

class Kingdom
  attr_accessor :num_cities
  attr_accessor :city_hash
  attr_accessor :valid_divisions

  def initialize(num_cities)
    @num_cities = num_cities
    @city_hash = Hash.new(nil)
    @valid_divisions = 0
    @effective_cities = Array.new
  end

  def add_road(from, to)
    from_city = @city_hash[from] || City.new(from, :betty)
    to_city = @city_hash[to] || City.new(to, :betty)

    from_city.add_road_to to_city
    to_city.add_road_from from_city

    @city_hash[from] = from_city
    @city_hash[to] = to_city
  end

  def find_internal_nodes
    @internal_cities = @city_hash.values.reject(&:is_leaf?)
    @internal_cities
  end

  def find_divisions
    available_for_change = get_non_leaf_cities
    # puts "available_for_change: #{available_for_change.map(&:id)}"
    last_set = nil
    checked_sets = Hash.new(false)
    city_hash_clone = @city_hash.clone
    (0..(2**available_for_change.length)-1).each do |iteration|
      set = iteration.to_s(2).rjust(available_for_change.length).split('').map(&:to_i)
      next if (checked_sets[set])
      # puts "\tlast_set: #{last_set}"
      # puts "\tset: #{set}"
      indexes_changing_owners = !last_set ? set : last_set.zip(set).map { |a, b| a ^ b }
      # puts "\tindexes_changing_owners: #{indexes_changing_owners}"
      available_for_change.each_index.select {|i| indexes_changing_owners[i] == 1}.map{|i| available_for_change[i]}.map(&:change_owner)
      # print_division
      @valid_divisions += 1 if is_valid_division?
      @city_hash = city_hash_clone
      last_set = set
      checked_sets[last_set] = true
      checked_sets[last_set.zip([1]*available_for_change.length).map {|a,b| a ^ b }] = true
    end
    @valid_divisions *= 2
  end

  private

  def print_division
    puts "\t\tkingdom"
    @city_hash.each do |k,v|
      puts "\t\t\t#{v.id},#{v.owner} => from: #{v.neighbors.map(&:id)}"
    end
  end

  def get_non_leaf_cities
    @city_hash.values.reject(&:is_leaf?)
  end

  def is_valid_division?
    # puts "\t\tbattle ground cities: #{@city_hash.values.select(&:is_battle_ground?).map(&:id)}"
    !@city_hash.values.select(&:is_battle_ground?).any?
  end

end

n = gets.strip.to_i
kingdom = Kingdom.new n

for a0 in (0..n-1-1)
  u,v = gets.strip.split(' ')
  u = u.to_i
  v = v.to_i
  kingdom.add_road u, v
end

kingdom.find_divisions
puts kingdom.valid_divisions % MOD_NUM

# kingdom.find_internal_nodes
# puts kingdom.count_divisions % MOD_NUM

internal = kingdom.find_internal_nodes
# puts internal.first.division_count % MOD_NUM
puts internal.first.count_divisions % MOD_NUM