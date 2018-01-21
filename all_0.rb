require_relative 'spam_filter'


assassin_training_dir = "./assassin/training/"
assassin_testing_dir = "./assassin/testing/"
pp_assassin_training_dir = "./assassin_pp/training/"
pp_assassin_testing_dir = "./assassin_pp/testing/"
enron_training_dir = "./enron_pp/training/"
enron_test_dir = "./enron_pp/testing/"
min_feature_select = 10

print "=========================================================================="
puts "==========================================================================="
pp_assassin_word_filter = SpamFilter.new(pp_assassin_training_dir, 'word-stem')
pp_assassin_word_filter.print_table_info
pp_assassin_word_filter.classify_all("#{pp_assassin_testing_dir}spam/", 'spam')
pp_assassin_word_filter.classify_all("#{pp_assassin_testing_dir}ham/", 'ham')

print "=========================================================================="
puts "==========================================================================="

pp_assassin_trigram_filter = SpamFilter.new(assassin_training_dir, 'trigram')
pp_assassin_trigram_filter.print_table_info
pp_assassin_trigram_filter.classify_all("#{assassin_testing_dir}spam/", 'spam')
pp_assassin_trigram_filter.classify_all("#{assassin_testing_dir}ham/", 'ham')

print "=========================================================================="
puts "==========================================================================="
assassin_word_filter = SpamFilter.new(assassin_training_dir, 'word-stem')
assassin_word_filter.print_table_info
assassin_word_filter.classify_all("#{assassin_testing_dir}spam/", 'spam')
assassin_word_filter.classify_all("#{assassin_testing_dir}ham/", 'ham')
print "=========================================================================="
puts "==========================================================================="
assassin_trigram_filter = SpamFilter.new(assassin_training_dir, 'trigram')
assassin_trigram_filter.print_table_info
assassin_trigram_filter.classify_all("#{assassin_testing_dir}spam/", 'spam')
assassin_trigram_filter.classify_all("#{assassin_testing_dir}ham/", 'ham')
print "=========================================================================="
puts "===================ruby tes========================================================"
enron_word_filter = SpamFilter.new(enron_training_dir, 'word-stem')
enron_word_filter.print_table_info
enron_word_filter.classify_all("#{enron_test_dir}spam/", 'spam')
enron_word_filter.classify_all("#{enron_test_dir}ham/", 'ham')
print "=========================================================================="
puts "==========================================================================="

enron_trigram_filter = SpamFilter.new(enron_training_dir, 'trigram')
enron_trigram_filter.print_table_info
enron_trigram_filter.classify_all("#{enron_test_dir}spam/", 'spam')
enron_trigram_filter.classify_all("#{enron_test_dir}ham/", 'ham')
print "=========================================================================="
puts "==========================================================================="
