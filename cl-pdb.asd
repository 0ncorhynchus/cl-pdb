(defsystem cl-pdb
  :description "PDB file format library"
  :version "0.1"
  :license "MIT"
  :pathname #P"src/"
  :depends-on ("alexandria")
  :components
  ((:file "package")
   (:file "utils")
   (:file "pdb")
   (:file "records")
   (:file "atom")
   (:file "manipulation")))
