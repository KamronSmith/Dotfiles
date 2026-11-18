;;; kam-tasks.el --- -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:

(require 'kam-os)
(require 'org)

(defvar kam-todo-file
  (expand-file-name "Inbox/todo.org" kam-home-directory))

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

;;;###autoload
(defun kam-project-todo-grep ()
  "Grep for TODOs starting in the current project's root directory."
  (interactive)
  (let* ((proj (project-current))
         (root (project-root proj))
         (default-directory root))
    (kam-todo-grep)))

(provide 'kam-tasks)
;;; kam-tasks.el ends here
