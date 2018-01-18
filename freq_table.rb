require_relative 'spam_filter'


pp_assassin_training_dir = "./assassin_pp/training/"
pp_assassin_testing_dir = "./assassin_pp/testing/"

print "=========================================================================="
puts "==========================================================================="
pp_assassin_word_filter = SpamFilter.new(pp_assassin_training_dir, 'word-stem')
pp_assassin_word_filter.print_table_info
pp_assassin_word_filter.classify_all("#{pp_assassin_testing_dir}spam/", 'spam')
pp_assassin_word_filter.classify_all("#{pp_assassin_testing_dir}ham/", 'ham')

pp_assassin_word_filter.print_frequency_table

puts "\n************************* processing complete *****************************"
puts "******************* Programmed by Andrew Vaillancourt *********************"
puts "***************************************************************************"