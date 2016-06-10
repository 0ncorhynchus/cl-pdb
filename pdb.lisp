(in-package :pdb)

(defvar *records* (make-hash-table :test #'equalp))

(defun get-record-type (record-name)
  (gethash record-name *records*))

(defun validated-index (index line)
  (min index (length line)))

(defun modified-subseq (line start end)
  (subseq line
          (validated-index start line)
          (validated-index end line)))

(defgeneric read-string-as (type line args))

(defmethod read-string-as ((type (eql 'string)) line args)
  (let ((start (1- (first args)))
        (end   (second args)))
    (modified-subseq line start end)))

(defmethod read-string-as ((type (eql 'char)) line args)
  (let* ((n (first args))
         (str (read-string-as 'string line (list n n))))
    (if (plusp (length str))
      (char str 0))))

(defmethod read-string-as ((type (eql 'integer)) line args)
  (parse-integer
    (read-string-as 'string line args)
    :junk-allowed t))

(defmethod read-string-as ((type (eql 'float)) line args)
  (let* ((start (first args))
         (end   (second args))
         (power (third args))
         (point (- end power))
         (a (read-string-as 'integer line (list start (1- point))))
         (b (read-string-as 'integer line (list (1+ point) end))))
    (if (and a b)
      (+ a (* b (expt 10.0 (- power)))))))

(defun slot->defclass-slot (spec)
  (let ((name (first spec))
        (type (second spec)))
    `(,name :type ,type :initarg ,(as-keyword name) :accessor ,name)))

(defun slot->read-string-as (spec line)
  (let ((name (first spec))
        (type (second spec))
        (args (cddr spec)))
    `(setf ,name (read-string-as ',type ,line ',args))))

(defgeneric read-record (type line))

(defmacro defrecord (name record-name slots)
  (with-gensyms (typevar objectvar linevar)
    `(progn
      (defclass ,name ()
        ,(mapcar #'slot->defclass-slot slots))
      (defmethod read-record ((,typevar (eql ',name)) ,linevar)
        (let ((,objectvar (make-instance ',name)))
          (with-slots ,(mapcar #'first slots) ,objectvar
            ,@(mapcar #'(lambda (x) (slot->read-string-as x linevar)) slots))
        ,objectvar))
      (setf (gethash ,record-name *records*) ',name))))

(defun line->record (line)
  (let* ((record-name (string-trim " " (modified-subseq line 0 6)))
         (record-type (get-record-type record-name)))
    (if record-type
      (read-record record-type line))))

(defun read-pdb (filename)
  (with-open-file (in filename)
    (loop for line = (read-line in nil)
          while line
          if (line->record line) collect it)))

(defun filter-record (record-name pdb)
  (let ((record-type (get-record-type record-name)))
    (filter (lambda (x) (typep x record-type)) pdb)))
