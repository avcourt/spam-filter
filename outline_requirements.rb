require_relative 'spam_filter'


training_dir = "./emails/training/"
testing_dir = "./emails/testing/"


filter = SpamFilter.new(training_dir, 'word-stem')
filter.print_table_info
filter.classify_all("#{testing_dir}spam/", 'spam')
filter.first_spam
filter.first_ham
filter.classify_all("#{testing_dir}ham/", 'ham')
filter.first_spam
filter.first_ham

puts "\n************************* processing complete *****************************"

