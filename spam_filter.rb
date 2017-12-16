require 'fast_stemmer'



#*****************************************************************************
#  @Author: Andrew Vaillancourt 7729503
#  @COMP3190-A4
#
#  A naive Bayesian spam classifier
#
#*****************************************************************************
class SpamFilter

  attr_reader :spam_table
  attr_reader :ham_table
  attr_reader :uniq_s_toks
  attr_reader :uniq_h_toks
  attr_reader :total_s_toks
  attr_reader :total_h_toks
  attr_reader :tok_arr
  attr_reader :frequency_table
  attr_accessor :count_spam
  attr_accessor :count_ham
  attr_reader :file_count
  attr_reader :token_type
  attr_reader :cleaned
  attr_reader :spam_list
  attr_reader :ham_list


  # Assumes training directory contains 2 directories(./spam ./ham)
  def initialize(training_dir, token_type)
    @parent_dir = training_dir
    @token_type = token_type
    @spam_table = find_frequency("#{training_dir}spam")
    @ham_table = find_frequency("#{training_dir}ham")
    @uniq_s_toks = @spam_table.length
    @uniq_h_toks = @ham_table.length
    @total_s_toks = @spam_table.inject(0) { |sum, tok| sum + tok[1] }
    @total_h_toks = @ham_table.inject(0) { |sum, tok| sum + tok[1] }
    @tok_arr = @ham_table.keys.concat(@spam_table.keys).uniq!.sort!
    @frequency_table = create_frequency_table
    @file_count = 0
    @count_spam = 0
    @count_ham = 0
    @spam_list = []
    @ham_list = []

  end


  # Returns an array of all trigrams contained in str
  def get_trigram(str)
    trigrams = []
    while str.length >= 3 do
      trigrams << str[0...3]
      str.slice!(0)
    end
    trigrams
  end


  # Returns an array of all tokens contained in a file.
  # Slurps whole file, hopefully there's no 4gb files in there!
  def message_tokens(filepath)
    tokens = []
    content = File.readlines(filepath)
    content.each  do |line|
      words = line.scrub.gsub(/[^0-9A-Za-z]/, ' ').downcase.split  # split line at whitespace, and remove non-alphsnums
      if token_type == 'trigram'
        words.each { |w| tokens.push(*(get_trigram(w))) } # get trigrams for each word in line, push them to tokens
      else # get words
        words.delete_if{ |w| w.length > 10 }
        words.each { |w| tokens.push(w.stem) }  # swap with below to enable/disable stemming
        # tokens.push(*words)                   # ----- swap me ------ #
      end
    end
    tokens
  end


  # Generates a hash |k,v| where k=token and v=frequency of tokens found in
  # all files contained in directory#{dir_name}
  def find_frequency(dir_name)
    table = Hash.new # running total, gets updated for each file

    filenames = Dir.entries(dir_name)  # array of filenames in directory
    filenames.shift(2)  # delete parent directories

    print "\nGenerating #{@token_type} frequency table for files in directory: #{dir_name}/   \t"
    wait_message

    filenames.each do |x|
      tokens = message_tokens("#{dir_name}/#{x}")
      freq = tokens.each_with_object(Hash.new(0)) { |tri, count| count[tri] += 1 } # create hash {:token => frequency }
      table.merge!(freq) { |k, o, n| o + n }  # update table with all tokens from this message
    end
    table.delete_if{ |k, v| v.to_i < 2 }
    table
  end


  # Removes entries from frequency table if they are deemed poor indicators
  # removes tokens if combined spam/ham frequency is below min_freq
  def clean(min_freq)
    @cleaned = true
    old_num_tokens = @frequency_table.length
    @frequency_table.delete_if do |k,v|
      v[0] + v[1] < min_freq || ( v[2] / (v[2] + v[3])).between?(0.45, 0.55)
    end
    puts "\n***********************************************************************************************"
    puts "*** #SpamFilter.clean called. Using feature selection to remove noise from frequency table"
    puts "** #{old_num_tokens - @frequency_table.length} tokens removed from table"
    puts "***********************************************************************************************"

  end


  # Main frequency table with combined spam/ham frequencies
  # creates a hash with token as key, value is array of the form:
  # |key, val|  val[0]=spamFreq, v[1]=hamFreq, v[2]=probabilitySpam, v[3]=probHam
  def create_frequency_table
    printf("\nGenerating probability table %-63s", '')
    freq_table = {}

    @tok_arr.each do |x|
      table_entry = []

      spam_freq = @spam_table[x]
      if spam_freq == nil then spam_freq = 0 end
      table_entry << spam_freq

      ham_freq = @ham_table[x]
      if ham_freq == nil then ham_freq = 0 end
      table_entry << ham_freq

      prob_spam = (spam_freq + 1 / @uniq_s_toks.to_f) / (@total_s_toks + 1)
      table_entry << prob_spam

      prob_ham = (ham_freq + 1 / @uniq_h_toks.to_f) / (@total_h_toks + 1)

      table_entry << prob_ham

      freq_table[x] = table_entry
    end
    freq_table
  end


  # return probability that a token is spam from frequency table
  def get_prob_spam(token)
    if @frequency_table.has_key?(token)
      probSpam = @frequency_table[token][2]
      return probSpam
    else # token not found"
      return ( 1.0 / @uniq_s_toks ) / ( @total_s_toks + 1 )
    end
  end

  # return probability that a token is ham from frequency table
  def get_prob_ham(token)
    if @frequency_table.has_key?(token)
      probHam = @frequency_table[token][3]
      return probHam
    else # token unique to this message
      return ( 1.0 / @uniq_s_toks ) / ( @total_s_toks + 1 )
    end
  end


  # calculates prob message is spam based on frequency table values
  # called by #classify
  def prob_msg_spam(filepath)
    tokens = message_tokens(filepath)
    tokens.inject(0){ |sum,x| sum + Math.log10(get_prob_spam(x)) }
  end


  # calculates probability message is ham based on frequency table values
  # called by #classify
  def prob_msg_ham(filepath)
    tokens = message_tokens(filepath)
    tokens.inject(0){ |sum,x| sum + Math.log10(get_prob_ham(x)) }
  end


  # classify a single message as spam/ham returns filepath
  def classify(filepath)
    @file_count += 1
    if prob_msg_spam(filepath) > prob_msg_ham(filepath)
      @count_spam += 1
      # puts filepath
      @spam_list << filepath
      return true;
    else
      @count_ham += 1
      @ham_list << filepath
      return false
    end
  end


  # classifies entire directory, creates array of filenames marked as spam/ham
  # calling this updates @spam_list and @ham_list with dir_path filenames
  def classify_all(dir_path, known_type)
    @ham_list = []
    @spam_list = []
    @file_count = 0
    @count_spam = 0
    @count_ham = 0
    print "\nClassifying all emails found in directory: \t\t\t\t   #{dir_path}\t\t\t"
    filenames = Dir.entries(dir_path).sort!  # array of filenames in directory

    filenames.shift(2)  # delete parent directories
    filenames.each { |x| classify("./#{dir_path}#{x}") }

    printf("\n\tTotal: %35s%-15s\n", '', "Spam:\t#{@count_spam}")
    printf("\tTotal: %35s%-15s\n", '', "Ham:\t#{@count_ham}")
    correct = known_type == 'spam' ? @count_spam/@file_count.to_f : @count_ham/@file_count.to_f
    printf("\tPercentage correctly classified: %35s%-8s\n", '', (correct*100).round(1) )
  end


  # prints info about frequency table and data analyzed
  def print_table_info
    puts "\n\nTraining and frequency table info:"
    if @cleaned then puts "** Note some entries have been removed by feature selection" end
    puts "\nTotal unique #{@token_type}s in all spam messages: \t\t#{@spam_table.length}"
    puts "Total unique #{@token_type}s in all ham messages:  \t\t#{@ham_table.length}"
    puts "Total unique #{@token_type}s in all combined messages: \t#{@frequency_table.length}"
    puts "Total number of spam emails:  \t\t\t\t\t\t#{Dir["#{@parent_dir}spam/**/*"].length}"
    puts "Total number of ham emails:\t\t\t\t\t\t#{Dir["#{@parent_dir}ham/**/*"].length}"
    puts "Total tokens in spam emails:  \t\t\t\t\t\t#{@total_s_toks}"
    puts "Total tokens in ham emails:\t\t\t\t\t\t#{@total_h_toks}"
  end


  # print frequency table => :xyz :sFreq :hFreq :probSpam :probHam
  def print_frequency_table
    @frequency_table.each do |k,v|
      printf("token: %-10s spam: %-5s ham: %-5s pspam: %-25s pham: %-25s\n", k, v[0], v[1], v[2], v[3])
    end
  end


  # prints first message classified as spam in testing directory
  def first_spam
    # puts "*********************************************************************"
    puts "\nFirst message marked as spam:"
    puts "*********************************************************************"
    puts File.read(@spam_list[0])
    puts "*********************************************************************"
    File.read(@spam_list[0])
  end

  # prints first message classified as ham in testing directory
  def first_ham
    # puts "*********************************************************************"
    puts "\nFirst message marked as ham:"
    puts "*********************************************************************"
    puts File.read(@ham_list[0])
    puts "*********************************************************************"
    File.read(@ham_list[0])
  end


  def wait_message
    t = Thread.new do
      while true do
        print '.'
        sleep 2
      end
    end
  end

end # class

