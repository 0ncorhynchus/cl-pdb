(defsystem cl-pdb
  :description "PDB file format library"
  :version "0.1"
  :license "MIT"
  :pathname #P"src/"
  :depends-on ("alexandria")
  :components
  ((:file "package")
   (:file "utils"
          :depends-on ("package"))
   (:file "pdb"
          :depends-on ("package" "utils"))
   (:file "records"
          :depends-on ("package" "pdb"))
   (:file "atom"
          :depends-on ("package" "records"))
   (:file "manipulation"
          :depends-on ("package" "utils" "pdb"))))
