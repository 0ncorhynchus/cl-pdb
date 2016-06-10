(in-package :pdb)

(defun as-keyword (sym) (intern (string sym) :keyword))

(defmacro with-gensyms ((&rest names) &body body)
  `(let ,(loop for n in names collect `(,n (gensym)))
  ,@body))

