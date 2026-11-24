;;; kam-dired.el --- -*- lexical-binding: t; -*-
;;; Summary:

;;; Commentary:

;;; Code:
(require 'dired)

(defgroup kam-dired ()
  "Extensions for `dired-mode'."
  :group 'dired)

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
  (interactive "p" dired-mode)
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
  (interactive "p" dired-mode)
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
  (interactive nil dired-mode)
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
  (interactive "p" dired-mode)
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
  (hl-line-mode 1)
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
  (interactive (list (read-regexp "Mark all files that are not (regexp): ")) dired-mode)
  (dired-mark-files-regexp regexp)
  (dired-toggle-marks))

;;;###autoload
(defun kam-dired-kill-lines-not-regexp (regexp)
  "Kill all lines in a Dired buffer not matching REGEXP."
  (interactive (list (read-regexp "Kill all lines that are not (regexp): ")) dired-mode)
  (kam-dired-mark-files-not-regexp regexp)
  (dired-do-kill-lines))

;;;###autoload
(defun kam-dired-directory-kill-ring-save ()
  "Save the current `dired-directory' to the `kill-ring'."
  (interactive nil dired-mode)
  (with-temp-buffer
    (insert dired-directory)
    (kill-ring-save (point-min) (point-max))))

(defvar kam-dired-directory-history nil
  "History of visited Dired directories.")

(defun kam-dired-directory-add-to-history ()
  "Add current `dired-directory' to `kam-dired-directory-history'.
Duplicates are not saved."
  (when dired-directory
    (push dired-directory kam-dired-directory-history)
    (setopt kam-dired-directory-history (delete-dups kam-dired-directory-history))))

;;;###autoload
(defun kam-dired-delete-empty-dirs ()
  "Interactively mark all empty directories in current Dired buffer."
  (interactive nil dired-mode)
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (ignore-errors
        (when (directory-empty-p (dired-get-filename))
          (delete-directory (dired-get-filename))))
      (dired-next-line 1))))

;;;###autoload
(defun kam-dired-mark-empty-dirs ()
  "Mark all empty directories in current Dired buffer."
  (interactive nil dired-mode)
  (when (equal major-mode 'dired-mode)
    (save-excursion
      (goto-char (point-min))
      (while (not (eobp))
        (ignore-errors
          (when (directory-empty-p (dired-get-filename))
            (dired-mark 1)
            (dired-previous-line 1)))
        (dired-next-line 1)))))

(declare-function 'kam-du-size "kam-os")

;;;###autoload
(defun kam-dired-directory-get-size-recursively ()
  (interactive nil dired-mode)
  (let* ((files (directory-files-recursively
                 default-directory
                 directory-files-no-dot-files-regexp))
         (size (kam-du-size files)))
    (message "Total size of tree %s: %s" default-directory size)))

;;;###autoload
(define-minor-mode kam-dired-disable-revert-buffer-mode
  "Disable reverting the buffer in `dired-mode' when a file changes."
  :global nil
  (if kam-dired-disable-revert-buffer-mode
      (setopt-local dired-do-revert-buffer nil
                    dired-auto-revert-buffer nil)
    (setopt-local dired-do-revert-buffer (lambda (dir) (not (file-remote-p dir)))
                  dired-auto-revert-buffer t)))

;;;###autoload
(defun kam-dired-do-destroy (&optional arg)
  "Destroy all marked (or next ARG) files.
Like `dired-do-delete', but deletes the files with \"rm\" instead of
moving to the system trash."
  (interactive "p" dired-mode)
  (let ((delete-by-moving-to-trash nil))
    (dired-do-delete arg)))

;;;###autoload
(defun kam-dired-do-rename (&optional arg)
  "Rename current file or all marked (or next ARG) files.
Like `dired-do-rename', but when given universal prefix
argument (\\[universal-argument]), disable `dired-dwim-target'."
  (interactive "P" dired-mode)
  (let ((dired-dwim-target (if (equal arg '(4)) nil dired-dwim-target)))
    (dired-do-rename (unless (equal arg '(4)) arg))))

(provide 'kam-dired)
;;; kam-dired.el ends here
