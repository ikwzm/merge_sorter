require_relative './test_1.rb'

ways               = 4
i_words            = 2
o_words            = 2
sort_order         = 0
sign               = false
scenario_file_name = File.basename(__FILE__, ".rb") + ".snr"

File.open(scenario_file_name,'w') do |file|
  test_1(file, ways, i_words, o_words, sort_order, sign, 100)
end

