(in-package :cl-pdb)

(defvar *records* (make-hash-table :test #'equalp))

(defun get-record-type (record-name)
  (gethash record-name *records*))

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

(defun export-slot (spec)
  (let ((name (first spec)))
    `(export ',name)))

(defgeneric parse-record (type line))

(defmacro defrecord (name record-name slots)
  (with-gensyms (typevar objectvar linevar recordvar)
    `(progn
      (defclass ,name ()
        ,(mapcar #'slot->defclass-slot slots))
      (defmethod parse-record ((,typevar (eql ',name)) ,linevar)
        (let ((,objectvar (make-instance ',name)))
          (with-slots ,(mapcar #'first slots) ,objectvar
            ,@(mapcar #'(lambda (x) (slot->read-string-as x linevar))
                      slots))
        ,objectvar))
      (export ',name)
      ,@(mapcar #'export-slot slots)
      (setf (gethash ,record-name *records*) ',name))))

