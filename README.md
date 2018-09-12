
# SpamFilter

## A naive Bayesian spam classifier in Ruby

This implementation is centred around a `SpamFilter` class which accepts a training directory path in its constructor. It is assumed that the training directory contains two sub-directories: `spam` and `ham`.  The constructor also expects a string parameter ‘(`trigram` or `word-stem`) to determine how to tokenize the messages. `trigram` uses all three-character consecutive sequences of each string contained in the message. `word-stem` uses suffix stripped words as tokens. Both the trigram and word-stem tokenization strip all non-alpha-numeric characters from the message before tokenizing. All non-utf-8 characters are also scrubbed.


There were two e-mail corpuses used in my experiments; The [SpamAssassin Training Corpus](http://csmining.org/index.php/spam-assassin-datasets.html) and the [Enron Spam Datasets](http://nlp.cs.aueb.gr/software_and_datasets/Enron-Spam/index.html). You may use these datasets to see similar results as shown below.

 *Note: I’m unsure if the Enron datasets contain links to malicious sites so opening the email files in a browser is not recommended.*

The Enron Datasets contain only the body of the messages (no header or footer data were included). I also performed some preprocessing of the SpamAssassin corpus to remove the headers. I treated each SpamAssassin corpus pre-processed and non-pre-processed similarily, providing 3 different circumstances to assess the performance impact of *feature-selection* outlined in the [SpamCop paper](http://www.patrickpantel.com/download/papers/1998/aaai98.pdf).

Analysis of the effectiveness my implementation was assessed by running the 3 datasets, under 3 different conditions: no feature selection,  feature selection where combined_frequency > 4, and feature selection where combined_frequency > 10. The following charts display the results


#### Legend:
- `s_a_pp _w` - pre-processed *SpamAssassin* Training Corpus(word)
- `s_a_pp _t` - pre-processed *SpamAssassin* Training Corpus(tri)
- `s_a _w` - *SpamAssassin* Training Corpus w/ headers(word)
- `s_a _t` - *SpamAssassin* Training Corpus w/ headers(tri)
- `e_w` - *Enron* Spam Dataset(w)


![Screenshot](https://github.com/avcourt/spam-filter/blob/master/doc/g1.png)

Word-stemming appeared to provide a overall higher accuracy in all cases over trigram
tokenization. However, trigram tokens performed nearly equally as well in the classifying of ham
messages. Feature selection of 4 increased the trigram unprocessed SpamAssassin corpus classification
by nearly 10% but saw only negligible increases/decreases everywhere else.:

![Screenshot](https://github.com/avcourt/spam-filter/blob/master/doc/g2.png)

Increasing feauture selection value to 10 only saw improvements in the Enron Dataset:

![Screenshot](https://github.com/avcourt/spam-filter/blob/master/doc/g3.png)



Overall,this implementation works quite well when tokenizing as suffix stripped words. It has an
extremely high correctness when classifying ham emails with both token methods, under all feature
selection variants. There may be some loss of precision errors affecting the performance of the trigram classification method, due to the much higher number of unique tokens contained in the messages.


### Provided Programs:

`all_0.rb`, `all_4.rb`, `all_10.rb` – runs all datasets with varying feature selection values

`freq_table.rb` - runs the header removed SpamAssassin corpus as stemmed-words without feature
selection and prints the generated frequency table
display_message_types.rb – runs the header removed SpamAssassin corpus as stemmed-words without

`outline_requirements.rb` - Prints first detected spam mesasge and first detected ham messages to the screen with some other information 


### API Notes

#### SpamFilter.rb: public methods

```ruby
SpamFilter.new(training, ‘token_type’) => constructor
```
```ruby
SpamFilter.clean(min_freq)  => uses the feature selection outlined in the SpamCop paper, where min is the minimum combined frequency aused in the frequency table.
```
```ruby
SpamFilter.print_freqency_table –prints the contents of the frequency table generated by the training data supplied to the constructor.
```
```ruby
SpamFilter,print_table_info – Prints information about the frequency table
```
```ruby
SpamFilter.prob_msg_spam(filepath)- calculates and returns the probability that the message at filepath is spam .
```
```ruby
SpamFilter.prob_msg_ham(filepath)- calculates and returns the probability that the message at filepath is ham.
```
```ruby
SpamFilter.classify(filepath) - returns true if message at filepath is classified as spam 
```
```ruby
SpamFilter.classify_all(directory, known_type)- classifies all messages in  directory. Uses a flag indicating what type of messages the folder contains to determine what percentage were correctly classified. 
```
```ruby
SpamFilter.first_spam()- returns and prints the first spam message found after calling classify() 
```
```ruby
SpamFilter.first_ham()- returns and prints the first ham message found after calling classify() 
```


### Dependencies
Using word stemming requires the `fast-stemmer` gem

Install fast-stemmer gem from command line
`gem install fast-stemmer`

### Running the program
`all_o.rb`, `all_4.rb`, `freq_table.rb`, `outline_requirements.rb` all demonstrate the API calls of the filter contained in `spam_filter.rb`

Run any of the provided programs
```ruby <filename>.rb```



### Author
**Andrew Vaillancourt**

### License
MIT
