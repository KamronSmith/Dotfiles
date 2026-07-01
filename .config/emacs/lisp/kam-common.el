;;; kam-common.el --- Common functions for my configuration -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:
(defgroup kam-common ()
  "A group of functions intended to be used throughout the configuration."
  :group 'editing)

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

(defun kam-call-function-quietly (function)
  "Call FUNCTION while suppressing any generated messages."
  (let ((inhibit-message t))
    (funcall function)))

(defun kam-execute-command-on-file-buffer (cmd)
  "Execute CMD on the buffer and associated file."
  (interactive "sCommand to excute: ")
  (let* ((file-name (buffer-file-name))
         (full-cmd (concat cmd " " file-name)))
    (async-shell-command full-cmd)))

(defun kam-sudo ()
  "Find the current file or directory using SUDO."
  (interactive)
  (let ((destination (or buffer-file-name default-directory)))
    (if (string= (file-remote-p destination 'method) "sudo")
        (user-error "Already using `sudo'")
      (find-file (format "/sudo::/%s" destination)))))

(defun kam--duplicate-buffer-substring (boundaries)
  "Duplicate buffer substring between BOUNDARIES.
BOUNDARIES is a cons cell representing buffer positions."
  (unless (consp boundaries)
    (error "`%s' is not a cons cell" boundaries))
  (let ((beg (car boundaries))
        (end
         (cdr boundaries)))
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

(defun kam-clear-echo-area (&rest _nil)
  "Clear the echo area.
Use this as advice :after a noisy function."
  (message ""))

(defun kam-first-char (str)
  "Return the first character from STR."
  (substring str 0 1))

(defun kam-reload-mode (mode)
  "Reload active minor MODE.
MODE is a symbol that represents an active minor mode. See
`kam-active-minor-modes' for reference."
  (call-interactively mode)
  (call-interactively mode))

(defun kam-next-error (&optional arg)
  "Go to the next error ARG number of times.
If ARG is not provided, ARG is 1."
  (interactive "P")
  (unless arg
    (setq arg 1))
  (push-mark (point) t nil)
  (dotimes (_ arg)
    (cond
     ((and (bound-and-true-p flycheck-mode) (derived-mode-p 'prog-mode))
      (flycheck-next-error)
      (setq this-command 'flycheck-next-error))
     ((and (bound-and-true-p flymake-mode) (derived-mode-p 'prog-mode))
      (flymake-goto-next-error)
      (setq this-command 'flymake-goto-next-error))
     ((derived-mode-p 'compilation-mode)
      (compilation-next-error arg)
      (setq this-command 'compilation-next-error))
     ((and (derived-mode-p 'text-mode) (bound-and-true-p jinx-mode))
      (jinx-next))
     (t
      (next-error arg)
      (setq this-command 'next-error)))))

(defun kam-prev-error (&optional arg)
  "Go to the previous error ARG number of times.
If ARG is not provided, ARG is 1."
  (interactive "P")
  (unless arg
    (setq arg 1))
  (push-mark (point) t nil)
  (dotimes (_ arg)
    (cond
     ((and (bound-and-true-p flycheck-mode) (derived-mode-p 'prog-mode))
      (flycheck-previous-error)
      (setq this-command 'flycheck-previous-error))
     ((and (bound-and-true-p flymake-mode) (derived-mode-p 'prog-mode))
      (flymake-goto-prev-error)
      (setq this-command 'flymake-goto-prev-error))
     ((derived-mode-p 'compilation-mode)
      (compilation-previous-error arg)
      (setq this-command 'compilation-previous-error))
     ((and (derived-mode-p 'text-mode) (bound-and-true-p jinx-mode))
      (jinx-previous))
     (t
      (previous-error arg)
      (setq this-command 'previous-error)))))

(provide 'kam-common)
;;; kam-common.el ends here
