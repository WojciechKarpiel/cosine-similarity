(ns cosine-similarity.core
  (:require [clojure.string :as str]
            [clojure.java.io :as io]))


(defn split-words
  [input]
  (str/split (str/lower-case input) #"\W+"))

(defn make-hash-of-words
  "Creates hash table [:word number-of-occurencies]"
  ([input] (make-hash-of-words input {}))
  ([input hash-table]
    (reduce
      (fn [hash word] (assoc hash word (inc (get hash word 0))))
      hash-table
      (split-words input))))

(defn hash-vec-length
  [hash]
  (Math/sqrt (reduce (fn [result [_ val]] (+ result (* val val))) 0 hash)))


(defn hash-vec-product
  [hash1 hash2]
  (reduce
    (fn [result [key val]] (+ result (* val (get hash2 key 0))))
    0
    hash1))

(defn cosine-similarity-of-hashes
  [hash1 hash2]
  (let [product (future (hash-vec-product hash1 hash2))
        len1 (future (hash-vec-length hash1))
        len2 (future (hash-vec-length hash2))]
    (/ @product (* @len1 @len2))))

(defn cosine-similarity-of-strings
  [string1 string2]
  (let [hash1 (future (make-hash-of-words string1))
        hash2 (future (make-hash-of-words string2))]
    (cosine-similarity-of-hashes @hash1 @hash2)))

(defn make-hash-of-words-from-file
  [file]
  (make-hash-of-words (slurp file)))

(defn cosine-similarity-of-files
  [file1 file2]
  (let [hash1 (future (make-hash-of-words-from-file file1))
        hash2 (future (make-hash-of-words-from-file file2))]
    (cosine-similarity-of-hashes @hash1 @hash2)))