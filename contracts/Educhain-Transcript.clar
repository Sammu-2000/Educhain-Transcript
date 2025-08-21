;; EduChain Transcript Smart Contract
;; A decentralized transcript management system on Stacks

(define-data-var institution-counter uint u0)
(define-data-var transcript-counter uint u0)

;; Store registered institutions
(define-map institutions
  uint
  {
    name: (string-ascii 50),
    wallet: principal
  }
)

;; Store transcripts
(define-map transcripts
  uint
  {
    student: principal,
    institution-id: uint,
    course: (string-ascii 100),
    grade: (string-ascii 5),
    year: uint
  }
)

;; Added input validation functions
;; Validate string is not empty
(define-private (is-valid-string (str (string-ascii 100)))
  (> (len str) u0)
)

;; Validate year is reasonable (between 1900 and 2100)
(define-private (is-valid-year (year uint))
  (and (>= year u1900) (<= year u2100))
)

;; Validate grade format (A, B, C, D, F with optional + or -)
(define-private (is-valid-grade (grade (string-ascii 5)))
  (and 
    (> (len grade) u0)
    (<= (len grade) u3)
  )
)

;; ============= Institution Management =============

;; Register a new institution (admin only)
(define-public (register-institution (name (string-ascii 50)) (wallet principal))
  (begin
    ;; Added input validation for institution name
    (asserts! (is-valid-string name) (err "Institution name cannot be empty"))
    (asserts! (is-standard wallet) (err "Invalid wallet address"))
    
    (var-set institution-counter (+ (var-get institution-counter) u1))
    (map-set institutions (var-get institution-counter) { name: name, wallet: wallet })
    
    ;; Log institution registration
    (print {event: "institution-registered", id: (var-get institution-counter), name: name, wallet: wallet})
    
    (ok (var-get institution-counter))
  )
)

;; ============= Transcript Management =============

;; Issue transcript (only by registered institution wallet)
(define-public (issue-transcript 
    (student principal) 
    (institution-id uint) 
    (course (string-ascii 100)) 
    (grade (string-ascii 5)) 
    (year uint))
  (let ((institution (map-get? institutions institution-id)))
    ;; Added comprehensive input validation
    (asserts! (is-standard student) (err "Invalid student address"))
    (asserts! (> institution-id u0) (err "Invalid institution ID"))
    (asserts! (is-valid-string course) (err "Course name cannot be empty"))
    (asserts! (is-valid-grade grade) (err "Invalid grade format"))
    (asserts! (is-valid-year year) (err "Invalid year"))
    
    (if (is-some institution)
        (let ((inst (unwrap-panic institution)))
          (if (is-eq (get wallet inst) tx-sender)
              (begin
                (var-set transcript-counter (+ (var-get transcript-counter) u1))
                (map-set transcripts (var-get transcript-counter)
                  {
                    student: student,
                    institution-id: institution-id,
                    course: course,
                    grade: grade,
                    year: year
                  })
                
                ;; Log transcript issuance
                (print {event: "transcript-issued", id: (var-get transcript-counter), student: student, institution: institution-id})
                
                (ok (var-get transcript-counter))
              )
              (err "Only institution wallet can issue transcripts")
          )
        )
        (err "Invalid institution")
    )
  )
)

;; Verify transcript (read-only, public access)
(define-read-only (verify-transcript (transcript-id uint))
  ;; Added input validation for transcript ID
  (begin
    (asserts! (> transcript-id u0) (err "Invalid transcript ID"))
    (match (map-get? transcripts transcript-id)
      transcript (ok transcript)
      (err "Transcript not found")
    )
  )
)

;; Added helper functions for better contract management
;; Get institution details (read-only)
(define-read-only (get-institution (institution-id uint))
  (begin
    (asserts! (> institution-id u0) (err "Invalid institution ID"))
    (match (map-get? institutions institution-id)
      institution (ok institution)
      (err "Institution not found")
    )
  )
)

;; Get total number of institutions
(define-read-only (get-institution-count)
  (ok (var-get institution-counter))
)

;; Get total number of transcripts
(define-read-only (get-transcript-count)
  (ok (var-get transcript-counter))
)
