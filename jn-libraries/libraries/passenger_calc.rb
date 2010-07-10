class Chef::Recipe
  # quick way to determine passenger_max_pool_size:
  #   assumes very generous 300MB processes to account for other stuff running on the system
  #   ie. 1200MB total, this would say passenger_max_pool_size = 4,
  #   realistic: 4 * ~150MB-200MB == 600MB-800MB, 400MB free
  def calc_passenger_max_pool_size
    x = (node[:memory][:total].to_s.gsub(/kB/, '000').to_f / 300_000_000).ceil
    raise "calc_passenger_max_pool_size isn't working for you, or you have too little memory" if x == 0
    x
  end
end
