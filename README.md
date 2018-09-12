
# SpamFilter

## A naive Bayesian spam classifier in Ruby

This implementation is centred around a `SpamFilter` class which accepts a training directory path in its constructor. It is assumed that the training directory contains two sub-directories: `spam` and `ham`.  The constructor also expects a string parameter ‘(`trigram` or `word-stem`) to determine how to tokenize the messages. `trigram` uses all three-character consecutive sequences of each string contained in the message. `word-stem` uses suffix stripped words as tokens. Both the trigram and word-stem tokenization strip all non-alpha-numeric characters from the message before tokenizing. All non-utf-8 characters are also scrubbed.


There were two e-mail corpuses used in my experiments; The [SpamAssassin Training Corpus](http://csmining.org/index.php/spam-assassin-datasets.html) and the [Enron Spam Datasets](http://nlp.cs.aueb.gr/software_and_datasets/Enron-Spam/index.html). You may use these datasets to see similar results as shown below.

 *Note: I’m unsure if the Enron datasets contain links to malicious sites so opening the email files in a browser is not recommended.*

The Enron Datasets contain only the body of the messages (no header or footer data were included). I also performed some preprocessing of the SpamAssassin corpus to remove the headers. I treated each SpamAssassin corpus pre-processed and non-pre-processed similarily, providing 3 different circumstances to assess the performance impact of *feature-selection* outlined in the [SpamCop paper](http://www.patrickpantel.com/download/papers/1998/aaai98.pdf).

Analysis of the effectiveness my implementation was assessed by running the 3 datasets, under 3 different conditions: no feature selection,  feature selection where combined_frequency > 4, and feature selection where combined_frequency > 10. The following charts display the results


![alt text](https://drive.google.com/file/d/1KWbZybeIHAuL1BGZpQOE5S82up2wnoGQ/view?usp=sharing "Logo Title Text 1")


![Screenshot](g1.png)
![Screenshot](docs/g1.png)
![Screenshot](/docs/g1.png)
![Screenshot](https://github.com/avcourt/spam-filter/blob/master/doc/g1.png)



### Dependencies
Using word stemming requires the ```fast-stemmer``` gem

Install fast-stemmer gem from command line
```gem install fast-stemmer```

### Running the program
`all_o.rb`, `all_4.rb`, `freq_table.rb`, `outline_requirements.rb` all demonstrate the API calls of the filter contained in `spam_filter.rb`

Run any of the provided programs
```ruby <filename>.rb```



### Author
**Andrew Vaillancourt**

### License
MIT
