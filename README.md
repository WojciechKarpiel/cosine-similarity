# cosine-similarity
Veryfying similarity of strings and text files on scale [0.0-1.0]

tl;dr
-----
```lisp
(cosine-similarity-of-strings "Hello world!" "Hello world!") ; => 1.00000
(cosine-similarity-of-strings "Hello world!" "Witaj, świecie!") ; => 0.00000
(cosine-similarity-of-strings "Somewhat similar to another string"
                              "I am a bit similar to string on the left") ; => 0.42426407
(cosine-similarity-of-files "~/.bashrc" "~/.bash_history") ; => 0.09706807
```

Okay, tell me more
------------------
It's a common lisp implementation of [this brilliant idea](http://blog.nishtahir.com/2015/09/19/fuzzy-string-matching-using-cosine-similarity/).  
You treat strings as vectors and calculate cosinus of angle between them.
