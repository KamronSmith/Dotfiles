;;; kam-project.el --- -*- lexical-binding: t; -*-
;;; Summary:

;;; Commentary:

;;; Code:
(require 'project)

(defun kam-project-switch-project (dir)
  "\"Switch\" to another project by running an Emacs command.
The available commands are presented as a dispatch menu
made from `project-switch-commands'.

When called in a program, it will use the project corresponding
to directory DIR."
  (interactive (list (funcall project-prompter)))
  (let ((command (if (symbolp project-switch-commands)
                     project-switch-commands
                   (project--switch-project-command dir)))
        (buffer (current-buffer)))
    (unwind-protect
        (progn
          (setq-local project-current-directory-override dir)
          (call-interactively command))
      (with-current-buffer buffer
        (kill-local-variable 'project-current-directory-override)))))

(defvar kam-project-name-history nil
  "Minibuffer history for `kam-project-new'.")

(defun kam-project-new ()
  "Create a project in the `kam-projects-directory'."
  (interactive)
  (let* ((default-directory kam-projects-directory)
         (project-name (read-directory-name "Project to create: "))
         (response (y-or-n-p "Do you want to initialize the project with a Git repository?")))
    (make-directory project-name)
    (if response
        (progn
          (async-shell-command (concat "git init " project-name))
          (make-empty-file (concat project-name "/project.txt")))
      (make-empty-file (concat project-name "/.project")))))

(defun kam-project-delete (proj)
  "Delete a project."
  (interactive (list (project-prompt-project-name)))
  (let* ((default-directory kam-projects-directory))
    (project-forget-project proj)
    (delete-directory proj t t)))

(defun kam-project-root-command (command)
  "Run COMMAND in the project's root directory."
  (when (kam-buffer-has-project-p (current-buffer))
    (let* ((default-directory (or (project-root (project-current))
                                  default-directory)))
      (call-interactively command))))

(defun kam-project-compile-maybe ()
  "Run `compile' in the project root directory if the buffer belongs to a project."
  (interactive)
  (if (kam-buffer-has-project-p (current-buffer))
      (kam-project-root-command 'compile)
    (call-interactively 'compile)))

(defun kam-project-grep ()
  "Run `grep' in the project's root directory."
  (interactive)
  (kam-project-root-command 'grep))

(defun kam-project-dired ()
  "Dired in the project root directory."
  (interactive)
  (dired (project-root (project-current))))

(defun kam-buffer-has-project-p (buf)
  "Return t if BUF belongs to a project, nil otherwise."
  (not (null (project-current nil (buffer-local-value 'default-directory buf)))))

(defun kam-project-remember-advice ()
  "Remember projects after creation."
  (project-remember-projects-under kam-projects-directory t)
  (kam-clear-echo-area))

(defun kam-project-update-list ()
  "Update the project list when deleting/adding projects."
  (interactive)
  (project-forget-zombie-projects)
  (project-remember-projects-under kam-projects-directory)
  (project-remember-projects-under kam-software-directory))

(defun kam-project-files ()
  "Return a list of all the project files in the current project."
  (when-let* ((project (project-current nil))
              (find-program "fd --follow --hidden --color=never --type file")
              (project-files-relative-names t))
    (project-files project)))

(defun kam-project-prefixed-buffer-name-override (mode)
  (concat ": "
          (if-let* ((proj (project-current nil)))
              (project-name proj)
            (file-name-nondirectory
             (directory-file-name default-directory)))
          "*"))

(provide 'kam-project)
;;; kam-project.el ends here
