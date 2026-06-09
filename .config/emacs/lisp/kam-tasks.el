;;; kam-tasks.el --- -*- lexical-binding: t; -*-

;;; Summary: 

;;; Commentary: 

;;; Code:

(require 'org)

(defvar kam-tasks-inbox-directory "/home/kam/Documents/Inbox/"
  "Directory where the inbox is stored.")

(defvar kam-tasks-projects-directory "/home/kam/Projects/"
  "Directory where the projects are stored.")

(defvar kam-tasks-tasks-file (expand-file-name "tasks.org" kam-tasks-inbox-directory)
  "File where the tasks information is stored.")

(setq org-agenda-files kam-tasks-tasks-file)

(provide 'kam-tasks)
;;; kam-tasks.el ends here
