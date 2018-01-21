require_relative 'spam_filter'


training_dir = "./emails/training/"
testing_dir = "./emails/testing/"

min_feature_select = 4

puts "Running  with feature selection minimum=4"


filter = SpamFilter.new(training_dir, 'word-stem')
filter.clean(min_feature_select)
filter.print_table_info
filter.classify_all("#{testing_dir}spam/", 'spam')
filter.classify_all("#{testing_dir}ham/", 'ham')


