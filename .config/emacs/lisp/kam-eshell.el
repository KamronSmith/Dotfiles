;;; kam-eshell.el --- -*- lexical-binding: t; -*-
;;; Summary:

;;; Commentary:

;;; Code:
(require 'eshell)
(require 'em-hist)
(require 'consult)

(defvar kam-eshell-prompt-regexp "\\[[[:punct:][:alnum:]]+ — [[:punct:][:alnum:]]+ \\$ "
  "Regular expression that matches `eshell-prompt-function' used in Eshell buffers.")

(defun kam-eshell-input-filter (input)
  "Do not save the following INPUT:
- Empty lines
- Commands that start with a space, `cd', `ls', etc."
  (and
   (eshell-input-filter-default input)
   (eshell-input-filter-initial-space input)
   (not (string-prefix-p "cd " input))
   (not (string-prefix-p "cd" input))
   (not (string-prefix-p "ls " input))
   (not (string-prefix-p "ls" input))))

(defun kam-eshell-redirect-to-buffer (buffer)
  "Auto create command for redirecting to buffer BUFFER."
  (interactive (list (read-buffer "Redirect to buffer: ")))
  (insert (format " >>> #<%s>" buffer)))

(defun kam-eshell--pwd-replace-home (pwd)
  "Replace $HOME in PWD with a tilde (~) character."
  (let* ((home (expand-file-name (getenv "HOME")))
         (home-len (length home)))
    (if (and
         (>= (length pwd) home-len)
         (equal home (substring pwd 0 home-len)))
        (concat "~" (substring pwd home-len))
      pwd)))

(defun kam-eshell--pwd-shorten-dirs (pwd)
  "Shorten all directory names in PWD except the last two."
  (let ((p-lst (split-string pwd "/")))
    (if (> (length p-lst) 2)
        (concat
         (mapconcat
          (lambda (elm)
            (if (zerop (length elm)) ""
              (substring elm 0 1)))
          (butlast p-lst 2)
          "/")
         (mapconcat (lambda (elm) elm)
                    (last p-lst 2)
                    "/"))
      pwd)))

(defun kam-eshell--split-directory-prompt (directory)
  (if (string-match-p ".*/.*" directory)
      (list (file-name-directory directory) (file-name-base directory))
    (list "" directory)))

(defun kam-eshell--directory-prompt ()
  "Return a list of two elements describing the current directory.
The first element is the path two the current directory. The second is
parent directory."
  (kam-eshell--split-directory-prompt
   (kam-eshell--pwd-shorten-dirs
    (kam-eshell--pwd-replace-home
     (eshell/pwd)))))

(defun kam-eshell-next-prompt (&optional n)
  "Move to the end of the Nth next prompt in the buffer.
See `eshell-prompt-regexp'."
  (interactive "p")
  (re-search-forward eshell-prompt-regexp nil t n)
  (when eshell-highlight-prompt
    (while (not (get-text-property (line-beginning-position) 'read-only))
      (re-search-forward eshell-prompt-regexp nil t n)))
  (eshell-skip-prompt))

(defun kam-eshell-previous-prompt (&optional n)
  "Move to the end of the Nth previous prompt in the buffer.
See `eshell-prompt-regexp'."
  (interactive "p")
  (when (not n)
    (setq n 1))
  (re-search-backward kam-eshell-prompt-regexp)
  (end-of-line))

(defun eshell/clear ()
  "Clear the Eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-emit-prompt)))

(defun eshell/z (&optional regexp)
  "Navigate to a previously visited directory in Eshell, or to any directory offered by `consult-dir'.
Optionally, use REGEXP to search for previous directories."
  (interactive)
  (let ((eshell-dirs (delete-dups
                      (mapcar 'abbreviate-file-name
                              (ring-elements eshell-last-dir-ring)))))
    (cond
     ((and (not regexp) (featurep 'consult-dir)
           (let* ((consult-dir--source-eshell `(:name "Eshell"
                                                      :narrow ?e
                                                      :category file
                                                      :face consult-file
                                                      :items ,eshell-dirs))
                  (consult-dir-sources (cons consult-dir--source-eshell
                                             consult-dir-sources)))
             (eshell/cd (substring-no-properties
                         (consult-dir--pick "Switch directory: ")))))
      (t (eshell/cd (if regexp (eshell-find-previous-directory regexp)
                      (completing-read "cd: " eshell-dirs))))))))

(defun kam-eshell-here ()
  "Opens up a new shell in the directory associated with the current buffers file.
The Eshell buffer is renamed to match that directory in order to make multiple Eshell windows easier."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (name (car (last (split-string parent "/" t)))))
    (eshell "new")
    (rename-buffer (concat "*eshell: " name "*"))
    (insert (concat "ls"))
    (eshell-send-input)))

(provide 'kam-eshell)
;;; kam-eshell.el ends here
