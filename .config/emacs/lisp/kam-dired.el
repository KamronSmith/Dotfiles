;;; kam-dired.el --- -*- lexical-binding: t; -*-
;;; Summary: 

;;; Commentary: 

;;; Code:
(defvar kam-automount-directory (format "/run/media/%s" user-login-name)
  "Directory under which drives are mounted.")

;;;###autoload
(defun kam-dired-automount-open-in-dired ()
  "Open the automounted drive in `Dired'.
If there is more than one, let the user choose."
  (interactive)
  (let ((dirs (directory-files kam-automount-directory nil "^[^.]")))
    (dired (file-name-concat
            kam-automount-directory
            (cond ((null dirs)
                   (error "No drives mounted"))
                  ((= (length dirs) 1)
                   (car dirs))
                  (t
                   (completing-read "Open in Dired: " dirs nil t)))))))

(defvar kam-dired--directory-header-regexp "^ +\\(.+\\):\n"
  "Pattern to match Dired directory headings.")

;;;###autoload
(defun kam-dired-subdirectory-next (&optional arg)
  "Move to the next or optional ARGth Dired subdirectory header.
For more information, read `dired-maybe-insert-subdir'."
  (interactive "p")
  (let ((pos (point))
        (subdir kam-dired--directory-header-regexp))
    (goto-char (line-end-position))
    (if (re-search-forward subdir nil t (or arg nil))
        (progn
          (goto-char (match-beginning 1))
          (goto-char (line-beginning-position)))
      (goto-char pos))))

;;;###autoload
(defun kam-dired-subdirectory-previous (&optional arg)
  "Move to the previous or optional ARGth Dired subdirectory heading.
For more information, read `dired-maybe-insert-subdir'."
  (interactive "p")
  (let ((pos (point))
        (subdir kam-dired--directory-header-regexp))
    (goto-char (line-beginning-position))
    (if (re-search-backward subdir nil t (or arg nil))
        (goto-char (line-beginning-position))
      (goto-char pos))))

(defun kam-dired--dir-list (list)
  "Filter out non-directory file paths in LIST."
  (cl-remove-if-not
   (lambda (dir)
     (file-directory-p dir))
   list))

;;;###autoload
(defun kam-dired-remove-inserted-subdirs ()
  "Remove all inserted Dired subdirectories."
  (interactive)
  (goto-char (point-max))
  (while (and (kam-dired-subdirectory-previous)
              (not (equal (dired-current-directory)
                          (expand-file-name default-directory))))
    (dired-kill-subdir)))

(defun kam-dired--insert-dir (dir &optional flags)
  "Insert DIR using optional FLAGS."
  (dired-maybe-insert-subdir (expand-file-name dir) (or flags nil)))

;;;###autoload
(defun kam-dired-insert-subdir (&optional arg)
  "Generic command to insert subdirectories in Dired buffers.

When items are marked, insert those which are subdirectories of the
current directory. Ignore regular files. If no files are active and
point is on a subdirectory line, insert it directly. If no files are
active and point is not on a subdirectory line, prompt for a
subdirectory using completion. When optional ARG as a single
prefix (`\\[universal-argument]') argument, prompt for command line
flags to pass to the underlying ls program. With optional ARG as a
double prefix argument, remove all inserted subdirectories."
  (interactive "p")
  (let* ((name (dired-get-marked-files))
         (flags (when (eq arg 4)
                  (read-string "Flags for `ls' listing: "
                               (or dired-subdir-switches dired-actual-switches)))))
    (cond
     ((eq arg 16)
      (kam-dired-remove-inserted-subdirs))
     ((and (length> name 1) (kam-dired--dir-list name))
      (mapc (lambda (file)
              (when (file-directory-p file)
                (kam-dired--insert-dir file flags)))
            name))
     ((and (length= name 1) (file-directory-p (car name)))
      (kam-dired--insert-dir (car name) flags))
     (t
      (let ((selection (read-directory-name "Insert directory: ")))
        (kam-dired--insert-dir selection flags))))))

(defun kam-dired--imenu-prev-index-position ()
  "Find the previous file in the buffer."
  (let ((subdir kam-dired-directory-header-regexp))
    (re-search-backward subdir nil t)))

(defun kam-dired--imenu-extract-index-name ()
  "Return the name of the file at point."
  (file-relative-name
   (buffer-substring-no-properties (+ (line-beginning-position) 2)
                                   (1- (line-end-position)))))

(defun kam-dired-mode-setup ()
  "Setup function for `dired-mode'."
  (if hide-cursor-mode
      (hide-cursor-mode -1)
    (hide-cursor-mode 1))
  (if hl-line-mode
      (hl-line-mode -1)
    (hl-line-mode 1))
  (kam-dired-imenu-setup))

(defun kam-dired-imenu-setup ()
  "Setup `imenu' for the current `dired-mode' buffer."
  (set (make-local-variable 'imenu-prev-index-position-function)
       'kam-dired--imenu-prev-index-position)
  (set (make-local-variable 'imenu-extract-index-name-function)
       'kam-dired--imenu-extract-index-name))

;;;###autoload
(defun kam-dired-mark-files-not-regexp (regexp)
  "Mark every file in a Dired buffer that does not match REGEXP."
  (interactive (list (read-regexp "Mark all files that are not (regexp): ")))
  (dired-mark-files-regexp regexp)
  (dired-toggle-marks))

;;;###autoload
(defun kam-dired-kill-lines-not-regexp (regexp)
  "Kill all lines in a Dired buffer not matching a regexp."
  (interactive (list (read-regexp "Kill all lines that are not (regexp): ")))
  (kam-dired-mark-files-not-regexp regexp)
  (dired-do-kill-lines))

;;;###autoload
(defun kam-dired-directory-kill-ring-save ()
  "Save the current `dired-directory' to the `kill-ring'."
  (interactive)
  (when (derived-mode-p 'dired-mode)
    (with-temp-buffer
      (insert dired-directory)
      (kill-ring-save (point-min) (point-max)))))

(defvar kam-dired-directory-history nil
  "History of visited Dired directories.")

(defun kam-dired-directory-add-to-history ()
  "Add the currently visited `dired-directory' to `kam-dired-directory-history'.
Duplicates are not saved."
  (when dired-directory
    (push dired-directory kam-dired-directory-history)
    (setopt kam-dired-directory-history (delete-dups kam-dired-directory-history))))

;;;###autoload
(define-minor-mode kam-dired-disable-revert-buffer-mode
  "Disable reverting the buffer in `dired-mode' when a file changes."
  :global nil
  (if kam-dired-disable-revert-buffer-mode
      (setopt-local dired-do-revert-buffer nil
                    dired-auto-revert-buffer nil)
    (setopt-local dired-do-revert-buffer (lambda (dir) (not (file-remote-p dir)))
                  dired-auto-revert-buffer t)))

(provide 'kam-dired)
;;; kam-dired.el ends here
