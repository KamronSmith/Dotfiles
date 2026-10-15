;;; kam-notes.el --- Extensions to manage the notes that I take  -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:
;; (require 'org)
(require 'standard-themes)
(require 'kam-os)

(use-package denote
  :hook ((dired-mode . denote-dired-mode)
         (after-init . denote-rename-buffer-mode)
         (after-init . kam-notes-set-custom-faces)
         (denote-after-rename-file . kam-denote-add-known-keyword)
         (denote-after-new-note . kam-denote-add-known-keyword))
  :bind
  ("C-c n h" . kam-notes-visit-home-note)
  ("C-c n w" . kam-notes-visit-workbench-note)
  ("C-c n d" . denote-open-or-create)
  ("C-c n b" . denote-backlinks)
  ("C-c n c" . denote-link-or-create)
  ("C-c n p" . kam-notes-set-processed-property)
  ("C-c n r" . denote-rename-file)
  (:map dired-mode-map
        ("r" . denote-dired-rename-files))
  :custom
  (denote-buffer-name-prefix "")
  (denote-sort-keywords t)
  (denote-prompts '(title keywords))
  (denote-rename-confirmations nil)
  (denote-date-prompt-use-org-read-date t)
  :config
  (defvar kam-notes-directory
    (expand-file-name "Notes/" kam-documents-directory)
    "Directory where all of my notes live.")

  (defvar kam-zettelkasten-directory
    (expand-file-name "Zettelkasten/" kam-documents-directory)
    "Directory where my Zettelkasten lives.")

  (declare-function kam-denote-first-history-keyword "kam-notes.el")
  (declare-function kam-denote-keywords "kam-notes.el")

  (setq denote-directory kam-zettelkasten-directory)

  (defun kam-denote-keywords ()
    "Return a list of keywords based on `denote-keyword-history'."
    (let* ((list))
      (dolist (keywords denote-keyword-history)
        (let* ((split-keywords (split-string keywords ",")))
          (mapc (lambda (keyword) (push keyword list)) split-keywords)))
      list))

  (setq denote-known-keywords (delete-dups (kam-denote-keywords)))
  
  (defun kam-denote-open-or-create ()
    "Like"
    (interactive)
    (let ((denote-prompts '(title keywords subdirectory)))
      (denote-open-or-create)))

  (defun kam-notes-set-processed-property ()
    "Set the property PROCESSED to no on an org-mode heading."
    (interactive)
    (org-set-property "PROCESSED" "no"))

  (defun kam-denote-first-history-keyword ()
    "Return the most recent `denote-keyword-history' element as a list of strings."
    (string-split (car denote-keyword-history) ","))

  (defun kam-denote-add-known-keyword ()
    "Add the most recent created keywords to `denote-known-keywords'."
    (mapc (lambda (keyword)
            (when (or (not (member keyword denote-keyword-history))
                      (not (member keyword denote-known-keywords)))
              (add-to-list 'denote-known-keywords keyword)))
          (kam-denote-first-history-keyword)))

  (defun kam-notes-set-custom-faces ()
    "Set custom faces for Denote."
    (standard-themes-with-colors
      (custom-set-faces
       `(denote-faces-keywords ((,c :foreground ,magenta-warmer :weight normal)))
       ;; `(denote-faces-title ((,c :foreground ,fg-main :inherit bold)))
       `(denote-faces-year ((,c :foreground ,blue-intense)))
       `(denote-faces-month ((,c :foreground ,blue-faint)))
       `(denote-faces-day ((,c :foreground ,blue-faint)))
       `(denote-faces-time ((,c :foreground ,fg-dim)))
       `(denote-faces-hour ((,c :foreground ,fg-dim)))
       `(denote-faces-minute ((,c :foreground ,fg-dim)))
       `(denote-faces-second ((,c :foreground ,fg-dim))))))

  (add-to-list 'display-buffer-alist
               '((derived-mode . denote-query-mode)
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (window . root)
                 (window-height . 0.35)
                 (window-parameters . ((mode-line-format . none))))))

(use-package denote-sequence
  :bind
  ("C-c n s s" . denote-sequence)
  ("C-c n s f" . denote-sequence-find)
  ("C-c n l"   . denote-sequence-link)
  ("C-c n s d" . denote-sequence-dired)
  ("C-c n s r" . denote-sequence-reparent)
  ("C-c n s c" . denote-sequence-convert)
  :config
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
        (denote-sequence-dired)))))

(use-package consult-denote
  :custom
  (consult-denote-find-command #'consult-fd)
  (consult-denote-grep-command #'consult-ripgrep)
  :bind
  ("C-c n g" . consult-denote-grep)
  ("C-c n f" . consult-denote-find)
  :config
  (consult-denote-mode))

(use-package denote-org
  :config
  (setq denote-org-store-link-to-heading 'id))

(use-package denote-explore)

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

(defun kam-notes-insert-nonfiction-template ()
  "Insert `kam-notes-nonfiction-template'."
  (interactive)
  (goto-char (point-max))
  (newline)
  (insert kam-notes-nonfiction-template))

(defun kam-notes-insert-fiction-template ()
  "Insert `kam-notes-fiction-template'."
  (interactive)
  (goto-char (point-max))
  (newline)
  (insert kam-notes-fiction-template))

(defun kam-notes-insert-index-template ()
  "Insert a template for the index note."
  (interactive)
  (insert "* Indices\n\n* Other\n\n* References"))

(defun kam-notes-insert-literature-note-template (template)
  "Insert TEMPLATE for creating a literature note, enhanced with `completing-read'."
  (interactive))

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
