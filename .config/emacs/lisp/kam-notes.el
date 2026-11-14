;;; kam-notes.el --- Extensions to manage the notes that I take  -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:
;; (require 'org)
(require 'standard-themes)
(require 'kam-os)
(require 'denote)
(require 'denote-sequence)

(defun kam-denote-keywords ()
  "Return a list of keywords based on `denote-keyword-history'."
  (delete-dups (denote-infer-keywords-from-files)))

(defun kam-denote-first-history-keyword ()
  "Return the most recent `denote-keyword-history' element as a list of strings."
  (string-split (car denote-keyword-history) ","))

(defun kam-denote-add-known-keyword ()
  "Add the most recent created keywords to `denote-known-keywords'."
  (mapc (lambda (keyword)
          (when (not (member keyword denote-known-keywords))
            (add-to-list 'denote-known-keywords keyword)))
        (kam-denote-first-history-keyword)))

(defun kam-denote-open-or-create ()
  "Like"
  (interactive)
  (let ((denote-prompts '(title keywords subdirectory)))
    (denote-open-or-create)))

;;;###autoload
(defun kam-notes-set-processed-property ()
  "Set the property PROCESSED to no on an org-mode heading."
  (interactive)
  (org-set-property "PROCESSED" "no"))

;;;###autoload
(defun kam-denote-sequence-dired-with-clone ()
  "Clone existing Dired buffer and run `denote-sequence-dired'."
  (interactive)
  (when (not (derived-mode-p 'dired-mode))
    (user-error "Not in a dired-mode buffer"))
  (let* ((prev-subdir-alist dired-subdir-alist)
         (buf (current-buffer)))
    ;; (with-current-buffer buf
    ;;   (clone-indirect-buffer "DIRED-SEQUENCE-CLONE-TEST" t)
    ;;   (setq dired-subdir-alist prev-subdir-alist)
    ;;   (denote-sequence-dired))
    (clone-indirect-buffer "TESTTEST" t)
    (with-current-buffer buf
      (setq dired-subdir-alist prev-subdir-alist)
      (denote-sequence-dired))))

(defvar kam-notes-nonfiction-template
  "* Questions to ask
** What is it about?
** What is it actually saying?
** Is it true?
** Why do you care?
* Structure Of Understanding
** Definitions
** Index
** Key Ideas
** Outline
* Quotes"
  "Template to insert when creating a literature note for fiction media.")

(defvar kam-notes-fiction-template
  "* Questions to ask
** What is the unity of the plot in the story?
** What are the roles that the various characters play, and what key events are they in?
** Is it a likely story? Why?
** Does the work satisfy your heart and mind? Why?
** Do you appreciate the beauty of the work? Why?
* Structure of understanding
** Characters
** Key Events
** Themes
* Quotes"
  "Template to insert when creating a literature note for fiction media.")

;;;###autoload
(defun kam-notes-insert-nonfiction-template ()
  "Insert `kam-notes-nonfiction-template'."
  (interactive)
  (goto-char (point-max))
  (newline)
  (insert kam-notes-nonfiction-template))

;;;###autoload
(defun kam-notes-insert-fiction-template ()
  "Insert `kam-notes-fiction-template'."
  (interactive)
  (goto-char (point-max))
  (newline)
  (insert kam-notes-fiction-template))

;;;###autoload
(defun kam-notes-insert-index-template ()
  "Insert a template for the index note."
  (interactive)
  (insert "* Indices\n\n* Other\n\n* References"))

;;;###autoload
(defun kam-notes-insert-literature-note-template (template)
  "Insert TEMPLATE for creating a literature note, enhanced with `completing-read'."
  (interactive))

;;;###autoload
(defun kam-notes-insert-quote-block (title)
  "Insert a quote block with an org mode heading superior."
  (interactive (list (read-string "Enter a title: ")))
  (org-previous-visible-heading 1)
  (org-insert-heading)
  (org-set-property "PROCESSED" "no")
  (insert title)
  (org-end-of-subtree)
  (newline)
  (tempo-template-org-quote))

(provide 'kam-notes)
;;; kam-notes.el ends here
