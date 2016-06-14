(in-package :cl-pdb)

(defrecord header-record "HEADER"
  ((classification string 11 50)
   (depDate        string 51 59)
   (idCode         string 63 66)))

(defrecord title-record "TITLE"
  ((continuation string 9 10)
   (title        string 11 80)))

(defrecord remark-record "REMARK"
  ((remarkNum integer 8 10)
   (empty     string 12 79)))

(defrecord cryst-record "CRYST1"
  ((a      float 7 15 3)
   (b      float 16 24 3)
   (c      float 25 33 3)
   (alpha  float 34 40 2)
   (beta   float 41 47 2)
   (gamma  float 48 54 2)
   (sGroup string 56 66)
   (z      integer 67 70)))

(defrecord model-record "MODEL"
  ((serial integer 11 14)))

(defrecord endmdl-record "ENDMDL" ())

(defrecord atom-record "ATOM"
  ((serial     integer 7 11)
   (name       string 13 16)
   (altLoc     char 17)
   (resName    string 18 20)
   (chainID    char 22)
   (resSeq     integer 23 26)
   (iCode      char 27)
   (x          float 31 38 3)
   (y          float 39 46 3)
   (z          float 47 54 3)
   (occupancy  float 55 60 2)
   (tempFactor float 61 66 2)
   (element    string 77 78)
   (charge     string 79 80)))

(defrecord ter-record "TER"
  ((serial  integer  7 11)
   (resName string 18 20)
   (chainID char 22)
   (resSeq  integer 23 26)
   (iCode char 27)))
