(in-package :cl-pdb)

(defun as-keyword (sym) (intern (string sym) :keyword))

(defun filter (fn lst)
  (unless (null lst)
    (let ((x (car lst)))
      (if (funcall fn x)
        (cons x (filter fn (cdr lst)))
        (filter fn (cdr lst))))))

(defun validated-index (index line)
  (min index (length line)))

(defun modified-subseq (line start end)
  (subseq line
          (validated-index start line)
          (validated-index end line)))

