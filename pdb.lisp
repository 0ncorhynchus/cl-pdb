(defgeneric read-string-as (type line args))

(defun validated-index (index line)
  (min index (length line)))

(defmethod read-string-as ((type (eql 'string)) line args)
  (let ((start (1- (first args)))
        (end   (second args)))
    (subseq line
          (validated-index start line)
          (validated-index end line))))

(defmethod read-string-as ((type (eql 'char)) line args)
  (let ((n (first args)))
    (char (read-string-as 'string line (list n n)) 0)))

(defmethod read-string-as ((type (eql 'integer)) line args)
  (parse-integer
    (read-string-as 'string line args)))

(defmethod read-string-as ((type (eql 'float)) line args)
  (let* ((start (first args))
         (end   (second args))
         (power (third args))
         (point (- end power))
         (a (read-string-as 'integer line (list start (1- point))))
         (b (read-string-as 'integer line (list (1+ point) end))))
    (+ a (* b (expt 10.0 (- power))))))

(defgeneric read-record (type line))

(defmacro with-gensyms ((&rest names) &body body)
  `(let ,(loop for n in names collect `(,n (gensym)))
  ,@body))

(defun as-keyword (sym) (intern (string sym) :keyword))

(defun slot->defclass-slot (spec)
  (let ((name (first spec)))
    `(,name :initarg ,(as-keyword name) :accessor ,name)))

(defun slot->read-string-as (spec line)
  (let ((name (first spec))
        (type (second spec))
        (args (cddr spec)))
    `(setf ,name (read-string-as ',type ,line ',args))))

(defmacro defrecord (name slots)
  (with-gensyms (typevar objectvar linevar)
    `(progn
      (defclass ,name ()
        ,(mapcar #'slot->defclass-slot slots))
      (defmethod read-record ((,typevar (eql ',name)) ,linevar)
        (let ((,objectvar (make-instance ',name)))
          (with-slots ,(mapcar #'first slots) ,objectvar
            ,@(mapcar #'(lambda (x) (slot->read-string-as x linevar)) slots))
        ,objectvar)))))

