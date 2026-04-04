;; -*- lexical-binding: t; -*-

(use-package denote
  :hook ((dired-mode . denote-dired-mode)
         (after-init . denote-rename-buffer-mode))
  :bind
  ("C-c n h" . kam-ite-visit-home)
  ("C-c n w" . kam-ite-visit-workbench)
  ("C-c n d" . denote-open-or-create)
  ("C-c n b" . denote-backlinks)
  ("C-c n c" . denote-link-or-create)
  (:map dired-mode-map
        ("r" . denote-dired-rename-files))
  :config
  (setq denote-directory (expand-file-name "~/Documents/Resources/Notes/")
        ;; denote-infer-keywords t
        denote-sort-keywords t
        denote-prompts '(title keywords)
        denote-rename-confirmations '(rewrite-front-matter modify-file-name)
        denote-date-prompt-use-org-read-date t)

  (defvar kam-notes-home-note
    (concat denote-directory "20230928T043448--home__index.org")
    "The home note for my ITE.")

  (defvar kam-notes-workbench-note
    (concat denote-directory "20250807T185237--workbench__index.org")
    "The workbench note for my ITE.")

  (defun kam-notes-visit-home-note ()
    "Visits the `kam-notes-home-note'."
    (interactive)
    (find-file kam-ite-home-note))

  (defun kam-notes-set-custom-faces ()
    "Set custom faces for Denote."
    (standard-themes-with-colors
      (custom-set-faces))))

(use-package denote-sequence)

(use-package consult-denote
  :custom
  (consult-denote-find-command #'consult-fd)
  (consult-denote-grep-command #'consult-ripgrep)
  :bind
  ("C-c n g" . consult-denote-grep)
  ("C-c n f" . consult-denote-find)
  :config
  (consult-denote-mode 1))

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

(defun kam-notes-insert-literature-note-templete (template)
  "Insert TEMPLATE for creating a literature note, enhanced with `completing-read'."
  (interactive))
