;;; kam-common.el --- Common functions for my configuration -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:
(defgroup kam-common ()
  "Common commands intended to be used throughout the configuration."
  :group 'editing)

(defmacro kam-when-system-type (sys-type &rest body)
  "Run BODY forms when SYS-TYPE is equal to `system-type'.
SYS-TYPE should be a symbol corresponding to the operating system of the
host. Please see `system-type' for accepted symbols."
  (declare (indent 1) (debug (sexp def-body)))
  `(when (eq ',system-type ,sys-type)
     ,@body))

(defmacro kam-when-system-name (sys-name &rest body)
  "Run BODY forms when SYS-NAME is equal to `system-name'.
SYS-NAME should be a string corresponding to the host name of the
system."
  (declare (indent 1) (debug (sexp def-body)))
  `(when (string-equal ,(system-name) ,sys-name)
     ,@body))

(defmacro kam-with-directory (directory &rest body)
  "Run BODY forms in DIRECTORY."
  (declare (indent 1) (debug (sexp def-body)))
  `(let ((default-directory ,directory))
     ,@body))

(defmacro kam-as-sudo (&rest body)
  "Run BODY forms as Sudo."
  (declare (indent 1) (debug (sexp def-body)))
  `(let ((default-directory "/sudo::"))
     ,@body))

(defun kam-disable-command (cmd)
  "Disable command CMD."
  (put cmd 'disabled t))

(defun kam-find-file-auto-create-missing-dirs ()
  "Auto-create missing directories in `find-file' if not found."
  (let ((target-dir (file-name-directory buffer-file-name)))
    (unless (file-exists-p target-dir)
      (make-directory target-dir t))))

(defvar kam--line-regexp-alist
  '((empty . "[\s\t]*$")
    (indent . "^[[:blank:]]+")
    (non-empty . "^.+$")
    (list . "^\\([\s\t#*+]+\\|[0-9]+[^\s]?[).]+\\)")
    (heading . "^[=-\\*]+\\|[*]+"))
  "Alist of regexp types used by `kam-line-regexp-p'.")

(defun kam-line-regexp-p (type &optional n)
  "Test for TYPE on the current line.
TYPE is the car of a cons cell in `kam--line-regexp-alist'. It matches a
regular expression. With optional N, search in the Nth line from point."
  (save-excursion
    (goto-char (line-beginning-position))
    (and (not (bobp))
         (or (beginning-of-line n) t)
         (save-match-data
           (looking-at
            (alist-get type kam--line-regexp-alist))))))

(defun kam-call-function-quietly (orig-fn &rest args)
  "Call ORIG-FN with ARGS while suppressing any generated messages."
  (let ((inhibit-message t))
    (apply orig-fn args)))

(defun kam-erase-buffer-force ()
  "Erase the buffer, even if `read-only' is t."
  (let ((inhibit-read-only t))
    (erase-buffer)))

(defun kam--duplicate-buffer-substring (boundaries)
  "Duplicate buffer substring between BOUNDARIES.
BOUNDARIES is a cons cell representing buffer positions."
  (unless (consp boundaries)
    (error "`%s' is not a cons cell" boundaries))
  (let ((beg (car boundaries))
        (end (cdr boundaries)))
    (goto-char end)
    (newline)
    (insert (buffer-substring-no-properties beg end))))

(defun kam-line-empty-before-point-p ()
  "Return non-nil if there are only spaces or tabs before the point on the current line."
  (if (looking-back (alist-get 'indent kam--line-regexp-alist))
      t
    nil))

(defun kam-line-only-spaces-or-symbols-p ()
  "Return non-nil if there are only spaces or punctuation before the point on the current line."
  (if (looking-back "^\([[:blank:]]\\|[[:punct:]])*" 1)
      t
    nil))

(defun kam-crm-exclude-selected-p (input)
  "Filter out INPUT from `completing-read-multiple'.
Hide non-destructively the selected entries from completion table,
avoiding the risk of entering the same match twice. Use as the PREDICATE
of `completing-read-multiple'."
  (if-let* ((pos (string-match-p crm-separator input))
            (rev-input (reverse input))
            (element (reverse
                      (substring rev-input 0
                                 (string-match-p crm-separator rev-input))))
            (flag t))
      (progn
        (while pos
          (if (string= (substring input 0 pos) element)
              (setq pos nil)
            (setq input (substring input (1+ pos))
                  pos (string-match-p crm-separator input)
                  flag (when pos t))))
        (not flag))
    t))

(defun kam-active-minor-modes ()
  "Return a list of active minor modes for the current buffer."
  (let ((active-modes))
    (mapc (lambda (m)
            (when (and (boundp m) (symbol-value m))
              (push m active-modes)))
          minor-mode-list)
    active-modes))

(defun kam-buffer-hidden-p (buf)
  "Return non-nil if BUF is hidden."
  (string-prefix-p " " (buffer-name buf)))

(defun kam-clear-echo-area (&rest _nil)
  "Clear the echo area.
Use this as advice :after a noisy function."
  (message ""))

(defun kam-first-char (str)
  "Return the first character from STR."
  (substring str 0 1))

(defun kam-filter-lines-in-string (input-string regexp &optional keep-matching)
  "Filter lines in INPUT-STRING that match REGEXP.
If KEEP-MATCHING is non-nil, keep lines that match; otherwise, remove
them. Returns the filtered string."
  (let* ((lines (split-string input-string "\\n" nil ""))
         (filtered-lines (if keep-matching
                             (cl-remove-if-not (lambda (line) (string-match-p regexp line)) lines)
                           (cl-remove-if (lambda (line) (string-match-p regexp line)) lines))))
    (mapconcat 'identity filtered-lines "\\n")))

(defun kam-reload-mode (mode)
  "Reload active minor MODE.
MODE is a symbol that represents an active minor mode. See
`kam-active-minor-modes' for reference."
  (call-interactively mode)
  (call-interactively mode))

(defun kam-mark (bounds)
  "Mark between BOUNDS as a cons cell of beginning and end positions.
Point is set at whichever position is lower, and the mark is set at
whichever position is higher."
  (let ((beg (car bounds))
        (end (cdr bounds)))
    (if (> beg end)
        (progn
          (goto-char beg)
          (push-mark end t t))
      (goto-char beg)
      (push-mark end t t))))

(defun kam-read-backup-file-name (file)
  "Read backup file name FILE."
  (if-let* ((backup-files (file-backup-file-names file)))
      (completing-read "Backup version: " backup-files nil t)
    (user-error "No backup files available for file %s" (buffer-file-name))))

(defun kam-current-elisp-sexp ()
  "Return the current Elisp expression based on the position of point."
  (cond
   ((looking-at "(") (sexp-at-point))
   ((looking-back ")" 1) (elisp--preceding-sexp))
   (t (save-excursion
        (search-backward "(")
        (sexp-at-point)))))

(define-minor-mode pager-mode
  "Minor mode for paging documents."
  :global nil
  (if pager-mode
      (progn
        (view-mode 1)
        (hide-cursor-mode 1)
        (scroll-lock-mode 1))
    (view-mode -1)
    (hide-cursor-mode -1)
    (scroll-lock-mode -1)))

(defun kam-read-feature (prompt &optional loaded-p)
  "Read feature name from the minibuffer, prompting with string PROMPT.
If optional second arg LOADED-P is non-nil, the feature must be loaded
from a file."
  (interactive (list
                "Feature: "))
  (intern (completing-read
           prompt
           (mapcar #'symbol-name
                   (if loaded-p
                       (delq nil
                             (mapcar
                              (lambda (x) (and (feature-file x) x))
                              features))
                     features)))))

(provide 'kam-common)
;;; kam-common.el ends here
