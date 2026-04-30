;; -*- lexical-binding: t; -*-

(require 'dired)

(use-package dired
  :ensure nil
  :hook ((dired-mode . dired-hide-details-mode)
         (dired-mode . kam-dired-setup-imenu)
         (dired-mode . lin-mode))
  :bind
  (:map dired-mode-map
        ("<mouse-2>" . dired-mouse-find-file)
        ("b" . dired-up-directory)
        ("o" . dired-do-open)
        ("i" . kam-dired-insert-subdir)
        ("\\" . dired-create-empty-file)
        ([kam-i] . kam-split-window-right))
  :custom
  (dired-listing-switches "-AGFhlv --group-directories-first --time-style=long-iso")
  (dired-clean-confirm-killing-deleted-buffers nil)
  (dired-confirm-shell-command nil)
  (dired-no-confirm t)
  (dired-deletion-confirmer '(lambda (x) t))
  (dired-recursive-deletes 'always)
  (dired-recursive-copies 'always)
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-dwim-target t)
  (dired-auto-revert-buffer #'dired-directory-changed-p)
  (dired-make-directory-clickable t)
  (dired-create-empty-file-in-current-directory t)
  (dired-free-space 'separate)
  (dired-mouse-drag-files t)
  (image-dired-dir (expand-file-name "image-dired/" kam-emacs-cache-directory))
  (dired-guess-shell-alist-user
   '(("\\.\\(mp[34]\\|m4a\\|ogg\\|flac\\|webm\\|mkv\\)" "xdg-open")
     ("\\.\\(png\\|jpe?g\\|tiff\\)" "xdg-open")
     (".*" "xdg-open")))
  :config)

(define-minor-mode kam-dired-disable-revert-buffer-mode
    "Disable reverting the buffer in `dired-mode' when a file changes."
    :global t
    (if kam-dired-disable-revert-buffer-mode
        (setopt dired-do-revert-buffer nil
                dired-auto-revert-buffer (lambda (x) nil))
      (setopt dired-do-revert-buffer (lambda (dir) (not (file-remote-p dir)))
              dired-auto-revert-buffer nil)))

(defvar kam-dired-regexp-history nil
    "Minibuffer history of `kam-dired-regexp-prompt'.")

  (defun kam-dired-regexp-prompt ()
    (let ((default (car kam-dired-regexp-history)))
      (read-regexp
       (format-prompt "Files matching REGEXP" default)
       default 'kam-dired-regexp-history)))

  (defun kam-dired--get-files (regexp)
    "Return files matching REGEXP, recursively from `default-directory'."
    (directory-files-recursively default-directory regexp nil))

  (defun kam-dired-search-flat-list (regexp)
    "Return a Dired buffer for files matching REGEXP.
Perform the search recursively from the current directory."
    (interactive (list (kam-dired-regexp-prompt)))
    (if-let* ((files (kam-dired--get-files regexp))
              (relative-paths (mapcar #'file-relative-name files)))
        (dired (cons (format "kam-flat-dired for `%s'" regexp) relative-paths))
      (error "No files matching `%s'" regexp)))

  (defvar kam-dired--directory-header-regexp "^ +\\(.+\\):\n"
    "Pattern to match Dired directory headings.")

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
(defvar kam-automount-directory (format "/run/media/%s" user-login-name)
    "Directory under which drives are mounted.")

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

  (defun kam-dired--imenu-prev-index-position ()
    "Find the previous file in the buffer."
    (let ((subdir kam-dired-directory-header-regexp))
      (re-search-backward subdir nil t)))

  (defun kam-dired--imenu-extract-index-name ()
    "Return the name of the file at point."
    (file-relative-name
     (buffer-substring-no-properties (+ (line-beginning-position) 2)
                                     (1- (line-end-position)))))

  (defun kam-dired-setup-imenu ()
    "Configure `Imenu' for the current Dired buffer.
Add this to `dired-mode-hook'."
    (set (make-local-variable 'imenu-prev-index-position-function)
         'kam-dired--imenu-prev-index-position)
    (set (make-local-variable 'imenu-extract-index-name-function)
         'kam-dired--imenu-extract-index-name))

  (defun kam-dired-shell-command-on-file-at-point ()
    "Runs a shell command on the file at point."
    (interactive)
    (concat
     (read-shell-command "Shell command: ")
     " "
     (dired-file-name-at-point)))

  (defun kam-dired-home-dir ()
    "Opens the home directory."
    (interactive)
    (dired (getenv "HOME")))

  (defun kam-dired-mark-files-not-regexp (regexp)
    "Mark every file in a Dired buffer that does not match REGEXP."
    (interactive (list (read-regexp "Mark all files that are not (regexp): ")))
    (dired-mark-files-regexp regexp)
    (dired-toggle-marks))

  (defun kam-dired-kill-lines-not-regexp ()
    "Kill all lines in a Dired buffer not matching a regexp."
    (interactive)
    (kam-dired-mark-files-not-regexp)
    (dired-do-kill-lines))

(use-package dired-x
  :ensure nil
  :after (dired)
  :custom
  (dired-clean-up-buffers-too t)
  (dired-clean-confirm-killing-deleted-buffers nil))

(use-package dired-aux
  :ensure nil
  :after (dired)
  :custom
  (dired-isearch-filenames 'dwim)
  (dired-create-destination-dirs 'always)
  (dired-do-revert-buffer (lambda (dir) (not (file-remote-p dir))))
  (dired-create-destination-dirs-on-trailing-dirsep t)
  (dired-compress-file-default-suffix ".zip")
  (dired-compress-directory-default-suffix ".zip"))

(use-package wdired
  :ensure nil
  :bind
  (:map dired-mode-map
        ("w" . wdired-change-to-wdired-mode))
  :custom
  (wdired-allow-to-change-permissions t)
  (wdired-create-parent-directories t))

(use-package dired-subtree
  :after (dired)
  :bind
  (:map dired-mode-map
        ("<tab>" . dired-subtree-toggle)
        ("TAB" . dired-subtree-toggle)
        ;; ("C-<tab>" . kam-dired-subtree-up-toggle)
        )
  :config
  (defun kam-dired-subtree-up-toggle ()
    "Goes to the parent subtree and toggles the visibility of it."
    (interactive)
    (dired-subtree-up)
    (dired-subtree-toggle)))

(provide 'kam-dired)
;;; kam-dired.el ends here
