;;;; cosine-similarity.asd

(asdf:defsystem #:cosine-similarity
  :description "Veryfying similarity of strings and text files on scale [0.0-1.0]"
  :author "Wojciech Karpiel <w.karpiel@yandex.com>"
  :license "public domain"
  :depends-on (#:eager-future2
               #:split-sequence)
  :serial t
  :components ((:file "package")
               (:file "cosine-similarity")))

