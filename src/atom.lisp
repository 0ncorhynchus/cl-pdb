(in-package :cl-pdb)

(defun coordinate (record)
  (list (x record) (y record) (z record)))

(defun select-chain (id records)
  (filter (lambda (x) (char= id (chainID x))) records))

