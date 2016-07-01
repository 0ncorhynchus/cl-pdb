(in-package :cl-pdb)

(defun coordinate (record)
  (declare (type atom-record record))
  (list (x record) (y record) (z record)))

(defun select-chain (id records)
  (declare (type list records))
  (declare (type character id))
  (filter (lambda (x) (char= id (chainID x))) records))


(defun extract-serial (line)
  (string-trim " " (modified-subseq line 0 6)))

(define-condition unknown-record-type (error)
  ((serial :initarg :serial :reader serial)))

(defun parse-record (line)
  (declare (type string line))
  (let* ((serial (extract-serial line))
         (record-type (get-record-type serial)))
    (if record-type
      (line->record record-type line)
      (error 'unknown-record-type :serial serial))))

(defun read-record (in)
  (declare (type stream in))
  (let ((line (read-line in nil)))
    (when line (parse-record line))))

(defun read-pdb (in)
  (declare (type stream in))
  (loop for record = (restart-case (read-record in)
                       (skip-record () nil))
        while record
        collect record))

(defun filter-record (serial pdb)
  (declare (type string serial))
  (declare (type list pdb))
  (let ((record-type (get-record-type serial)))
    (filter (lambda (x) (typep x record-type)) pdb)))
