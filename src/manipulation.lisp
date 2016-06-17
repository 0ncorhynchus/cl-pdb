(in-package :cl-pdb)

(defun line->record (line)
  (let* ((record-name (string-trim " " (modified-subseq line 0 6)))
         (record-type (get-record-type record-name)))
    (if record-type
      (read-record record-type line))))

(defun read-pdb (in)
  (declare (type stream in))
  (labels ((read-lazily ()
             ())))
  (loop for line = (read-line in nil)
        while line
        if (line->record line) collect it))

(defun filter-record (record-name pdb)
  (let ((record-type (get-record-type record-name)))
    (filter (lambda (x) (typep x record-type)) pdb)))
