;;;; cosine-similarity.lisp

(in-package #:cosine-similarity)

;;; "cosine-similarity" goes here. Hacks and glory await!

(defun split-words (input-string)
           (let ((lowercase-input (string-downcase input-string))
                 (predicate (lambda (char) (position char " .,;:-()[]{}_*/"))))
             (split-sequence:split-sequence-if predicate lowercase-input :remove-empty-subseqs t)))

(defun make-hash-of-words (input-string &optional (appended-hash (make-hash-table :test 'equal)))
    (do ((ms (split-words input-string) (cdr ms)))
        ((eq nil ms) appended-hash)
      (let* ((word (car ms))
            (word-count (gethash word appended-hash)))
        (if word-count
            (setf (gethash word appended-hash) (+ 1 word-count))
            (setf (gethash word appended-hash) 1)))))


(defun hash-vec-lenght (hash)
  (let ((result 0))
    (maphash (lambda (k v) (setq result (+ result (* v v)))) hash)
    (sqrt result)))

(defun hash-vec-product (hash1 hash2)
  (let ((result 0))
    (maphash (lambda (k v) (setq result (+ result (* v (gethash k hash2 0))))) hash1)
    result))

(defun cosine-similarity-of-hashes (hash1 hash2)
  (eager-future2:plet ((product (hash-vec-product hash1 hash2))
                       (len1 (hash-vec-lenght hash1))
                       (len2 (hash-vec-lenght hash2)))
    (/ product (* len1 len2))))

(defun cosine-similarity-of-strings (string1 string2)
  (eager-future2:pfuncall #'cosine-similarity-of-hashes (make-hash-of-words string1) (make-hash-of-words string2)))


;;now working with files:
(defun make-hash-of-words-from-file (file)
  (with-open-file (stream file)
    (do ((line (read-line stream nil) (read-line stream nil)) (hash (make-hash-of-words "") (make-hash-of-words line hash)))
        ((null line) hash))))

(defun cosine-similarity-of-files (file1 file2)
  (eager-future2:pfuncall #'cosine-similarity-of-hashes (make-hash-of-words-from-file file1) (make-hash-of-words-from-file file2)))
