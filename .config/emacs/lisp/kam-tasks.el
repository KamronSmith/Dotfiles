;;; kam-tasks.el --- -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:

(require 'kam-os)
(require 'org)

(defvar kam-inbox-directory (expand-file-name "Inbox/" kam-home-directory)
  "Directory where the inbox is stored.")

(defvar kam-todo-file (expand-file-name "todo.org" kam-inbox-directory)
  "File where all of the todo  information is stored.")

(setq org-agenda-files `(,kam-todo-file))

(defvar kam-todo-regex
  `(seq
    (optional (eval comment-start))
    (group (any "t" "T") (any "o" "O") (any "d" "D") (any "o" "O"))
    (optional
     space (repeat 4 digit)
     "-"
     (repeat 2 digit)
     "-"
     (repeat 2 digit))
    ":")
  "Regex for looking for searching for TODOs.")

;; (defun kam-todo-grep ()
;;   "Grep for TODOs starting in the current directory."
;;   (interactive)
;;   (grep (concat
;;          "rg -nSP --follow --no-heading --color=always \'"
;;          (prx (eval kam-todo-regex))
;;          "\'")))

(defun kam-project-todo-grep ()
  "Grep for TODOs starting in the current project's root directory."
  (interactive)
  (let* ((proj (project-current))
         (root (project-root proj))
         (default-directory root))
    (kam-todo-grep)))

(defun kam-project-files ()
  "Return all project files in a given directory, respects .gitignore."
  (interactive)
  (let* ((proj (project-current))
         (root (project-root proj))
         (default-directory root))
    (split-string (shell-command-to-string "fd -p -L ."))))

(provide 'kam-tasks)
;;; kam-tasks.el ends here
