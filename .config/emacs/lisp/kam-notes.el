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
         (after-init . kam-notes-set-custom-faces))
  :bind
  ("C-c n h" . kam-notes-visit-home-note)
  ("C-c n w" . kam-notes-visit-workbench-note)
  ("C-c n d" . denote-open-or-create)
  ("C-c n b" . denote-backlinks)
  ("C-c n c" . denote-link-or-create)
  ("C-c n p" . kam-notes-set-processed-property)
  (:map dired-mode-map
        ("r" . denote-dired-rename-files))
  :config
  (defvar kam-notes-directory
    (expand-file-name kam-documents-directory "Notes/")
    "Directory where all of my notes live.")

  (setq denote-directory kam-notes-directory
        ;; denote-infer-keywords t
        denote-sort-keywords t
        denote-prompts '(title keywords)
        denote-rename-confirmations '(rewrite-front-matter modify-file-name)
        denote-date-prompt-use-org-read-date t)

  (defvar kam-notes-home-note
    (expand-file-name "20230928T043448--home__index.org" denote-directory)
    "The home note for my ITE.")

  (defvar kam-notes-workbench-note
    (expand-file-name "20250807T185237--workbench__index.org" denote-directory)
    "The workbench note for my ITE.")

  (defun kam-notes-visit-home-note ()
    "Visit the `kam-notes-home-note'."
    (interactive)
    (find-file kam-notes-home-note))

  (defun kam-notes-set-processed-property ()
    "Set the property PROCESSED to no on an org-mode heading."
    (interactive)
    (org-set-property "PROCESSED" "no"))

  (defun kam-notes-set-custom-faces ()
    "Set custom faces for Denote."
    (standard-themes-with-colors
      (custom-set-faces
       `(denote-faces-keywords ((,c :foreground ,magenta-warmer :weight normal)))
       `(denote-faces-title ((,c :foreground ,fg-main :inherit bold)))
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
  ("C-c n s l" . denote-sequence-link)
  ("C-c n s d" . denote-sequence-dired)
  ("C-c n s r" . denote-sequence-reparent)
  ("C-c n s c" . denote-sequence-convert))

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
