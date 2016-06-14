(in-package :cl-user)
(defpackage cl-pdb-asd
  (:use :cl :asdf))
(in-package :cl-pdb-asd)

(defsystem cl-pdb
  :description "PDB file format library"
  :version "0.1"
  :license "MIT"
  :pathname #P"src/"
  :components
  ((:file "package")
   (:file "utils")
   (:file "pdb")
   (:file "records")
   (:file "atom")))
