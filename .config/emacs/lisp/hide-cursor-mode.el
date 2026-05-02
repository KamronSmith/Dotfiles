;; -*- lexical-binding: t; -*-

(defvar-local hide-cursor--original nil)

(define-minor-mode hide-cursor-mode
  "Hide or show the cursor."
  :global nil
  :lighter "H"
  (if hide-cursor-mode
      (progn
	(setq-local hide-cursor--original cursor-type)
	(setq-local cursor-type nil))
    (setq cursor-type (or hide-cursor--original
			  t))))
