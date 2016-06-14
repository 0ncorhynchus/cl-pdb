(in-package :cl-pdb)

(defun as-keyword (sym) (intern (string sym) :keyword))

(defmacro with-gensyms ((&rest names) &body body)
  `(let ,(loop for n in names collect `(,n (gensym)))
  ,@body))

(defun filter (fn lst)
  (unless (null lst)
    (let ((x (car lst)))
      (if (funcall fn x)
        (cons x (filter fn (cdr lst)))
        (filter fn (cdr lst))))))

