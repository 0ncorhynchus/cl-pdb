(in-package :cl-pdb)

(defun extract-record-name (line)
  (string-trim " " (modified-subseq line 0 6)))

(defun line->record (line)
  (declare (type string line))
  (let* ((record-name (extract-record-name line))
         (record-type (get-record-type record-name)))
    (if record-type
      (parse-record record-type line))))

(defun read-record (in)
  (declare (type stream in))
  (line->record (read-line in)))

(defun read-pdb (in)
  (declare (type stream in))
  (loop for line = (read-line in nil)
        while line
        if (line->record line) collect it))

(defun filter-record (record-name pdb)
  (declare (type string record-name))
  (declare (type list pdb))
  (let ((record-type (get-record-type record-name)))
    (filter (lambda (x) (typep x record-type)) pdb)))
