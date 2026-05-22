;;; kam-todo.el --- -*- lexical-binding: t; -*-

;;; Summary: 

;;; Commentary: 

;;; Code:

(require 'org)

(defvar kam-todo-inbox-directory "/home/kam/Documents/Inbox/"
  "Directory where the inbox is stored.")

(defvar kam-todo-projects-directory "/home/kam/Documents/Projects/"
  "Directory where the projects are stored.")

(defvar kam-todo-todo-file (expand-file-name "todo.org" kam-todo-inbox-directory)
  "File where the todo information is stored.")

(setq org-agenda-files kam-todo-todo-file)

(provide 'kam-todo)
;;; kam-todo.el ends here
