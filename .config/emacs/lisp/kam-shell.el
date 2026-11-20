;;; kam-shell.el --- -*- lexical-binding: t; -*-
;;; Summary:

;;; Commentary:

;;; Code:
(require 'shell)
(require 'comint)
(require 'kam-comint)

(defgroup kam-shell nil
  "Extensions for `shell-mode'."
  :group 'shell)

(defun kam-shell-command--prompt ()
  (read-shell-command
   (format-prompt "Shell command in '%s'" nil (abbreviate-file-name default-directory))
   nil
   nil
   (let ((filename
          (cond
           (buffer-file-name)
           ((eq major-mode 'dired-mode)
            (dired-get-filename nil t)))))
     (and filename (file-relative-name filename)))))

(defvar kam-shell-cd-directories nil
  "List of accumulated `shell-last-dir'.")

(defun kam-shell-cd--track (&rest _)
  "Track shell input of cd commands.
Push `shell-last-dir' to `kam-shell-cd--directories'."
  (when-let* ((input (kam-comint--last-input))
              ((string-match-p "cd " input)))
    (push shell-last-dir kam-shell-cd-directories)))

(defvar kam-shell-cd-history nil
  "Minibuffer history for `kam-shell-cd'.")

(defun kam-shell-cd--prompt ()
  "Prompt for a directory among `kam-shell-cd--directories'."
  (if-let* ((history kam-shell-cd--directories)
            (dirs (cons default-directory history))
            (def (if (listp dirs) (car dirs) shell-last-dir)))
      (completing-read
       (format-prompt "Select directory: " def)
       dirs
       nil
       nil
       nil
       'kam-shell--cd-history)
    (user-error "No directories have been tracked")))

;;;###autoload
(defun kam-shell-cd ()
  "Navigate to directory in `shell-mode', with `consult-dir'."
  (declare (interactive-only t))
  (interactive)
  (let ((shell-dirs (delete-dups
                     (mapcar 'abbreviate-file-name
                             (remove nil
                                     kam-shell-cd-directories)))))
    (cond
     ((featurep 'consult-dir)
      (let* ((consult-dir--source-shell `(:name "Shell"
                                                :narrow ?s
                                                :category file
                                                :face consult-file
                                                :items ,shell-dirs))
             (consult-dir-sources (cons consult-dir--source-shell
                                        consult-dir-sources)))
        (kam-comint--insert-and-send "cd"
                                     (substring-no-properties
                                      (consult-dir--pick "Switch directory: "))))))))

;;;###autoload
(defun kam-shell-here ()
  "Open a shell in the directory associated with the current buffer's file.
The shell is renamed to match that directory to make multiple shell
windows easier."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (name (car (last (split-string parent "/" t)))))
    (shell)
    (rename-buffer (concat "*shell: " name "*"))))

;;;###autoload
(defun kam-shell-up-directory ()
  "Navigate a directory higher in the directory tree."
  (interactive)
  (kam-comint--insert-and-send "cd .."))

;;;###autoload
(defun kam-shell-home-directory ()
  "Open a shell in the home directory.
The shell is renamed to make opening multiple shells easier."
  (interactive)
  (kam-with-directory kam-home-directory
    (shell)))

(provide 'kam-shell)
;;; kam-shell.el ends here
