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

(defun kam-call-function-quietly (orig-fun &rest args)
  "Call ORIG-FN with ARGS while suppressing any generated messages."
  (let ((inhibit-message t))
    (apply orig-fun args)))

(defun kam-execute-command-on-file-buffer (cmd)
  "Execute CMD on the buffer and associated file."
  (interactive "sCommand to execute: ")
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
If KEEP-MATCHING is non-nil, keep lines that match; otherwise, remove them.
Returns the filtered string."
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

(defun kam--mark (bounds)
  "Mark between BOUNDS as a cons cell of beginning and end positions."
  (push-mark (car bounds))
  (goto-char (cdr bounds))
  (activate-mark))

(defun kam-grep-list-of-strings (regexp &optional grep-args directory)
  "Return a list of grep results as a list of strings using REGEXP."
  (let* ((default-directory (if directory directory default-directory))
         (output (shell-command-to-string (concat
                                           "rg"
                                           " "
                                           grep-args
                                           " "
                                           regexp)))
         (strings (split-string output "\n" t)))
    strings))

(defun kam-read-backup-file-name (file)
  (if-let* ((backup-files (file-backup-file-names file)))
      (completing-read "Backup version: " backup-files nil t)
    (user-error "No backup files available for file %s" (buffer-file-name))))

(defun kam-rename-file (name)
  "Apply NAME to the current file and rename its buffer."
  (interactive
   (list (read-string "Rename current file: " (file-relative-name (buffer-file-name)))))
  (let ((file (buffer-file-name)))
    (if (vc-registered file)
        (vc-rename-file file name))
    (set-visited-file-name name t t)))

(defun kam-revert-buffer ()
  "Revert the current buffer from its file without asking for confirmation."
  (interactive)
  (revert-buffer t t t)
  (message "Reverted buffer `%s'" (buffer-name (current-buffer))))

(defun kam-mark-line (&optional arg allow-extend)
  "Put mark at the beginning of the next line, point at the beginning.

With argument ARG, put mark at the end of a following line, so that the
number of lines is equal to 1 + ARG. This is so that with relative line
numbers the user can easily judge how many lines they would like to
mark.

If ARG is negative, point is put at end of this line, mark is put
it marks the next ARG lines after the ones already marked."
  (interactive "P\np")
  (cond ((and allow-extend
              (or (and (eq last-command this-command) (mark t))
                  (and transient-mark-mode mark-active)))
         (setq arg (if arg (prefix-numeric-value arg)
                     (if (< (mark) (point)) -1 1)))
         (set-mark
          (save-excursion
            (goto-char (mark))
            (forward-line arg)
            (point))))
        (t (progn
             (when (> (prefix-numeric-value arg) 1)
               (setq arg (1+ (prefix-numeric-value arg))))
             (beginning-of-line)
             (push-mark
              (save-excursion
                (forward-line arg)
                (point))
              t t)))))

(defun kam-mark-point-to-end-of-line ()
  "Set the mark at the end of the line, regardless of where the cursor is on the line."
  (interactive)
  (if (eq visual-line-mode t)
      (push-mark
       (save-excursion
         (end-of-visual-line)
         (point))
       t t)
    (push-mark
     (line-end-position)
     nil t)))

(defun kam-mark-point-to-end-of-buffer ()
  "Mark from the point to the end of the buffer."
  (interactive)
  (push-mark
   (save-excursion
     (goto-char (point-max))
     (point))
   t t))

(defun kam-copy-line-as-kill (&optional n)
  "Copy N lines to the `kill-ring'."
  (interactive "p")
  (save-excursion
    (kam-mark-line n)
    (kill-ring-save nil nil t)))

(defun kam-kill-line (&optional n)
  "Kill the current line, regardless of where the point is on the line."
  (interactive "p")
  (kam-mark-line n)
  (kill-region nil nil t))

(defun kam-kill-dwim (&optional n)
  "A DWIM command for killing.

If the region is active, kill the region. Else, kill the current line.
When called interactively without a prefix numeric argument, N is 1,
which controls how many lines will be cut."
  (interactive "p")
  (cond ((region-active-p)
         (kill-region nil nil t)
         (setq this-command 'kill-region))
        (t
         (kam-kill-line n)
         )))

(defun kam-kill-ring-save-dwim (&optional n)
  "A DWIM command for copying.

If the region is active, copy the region. Else, copy the line. When
called interactively without a prefix numeric argument, N is 1."
  (interactive "p")
  (cond ((region-active-p)
         (kill-ring-save nil nil t)
         (setq this-command 'kill-ring-save))
        (t
         (kam-copy-line-as-kill n)
         (setq this-command 'kill-ring-save))))

(defun kam-yank (orig-fn &rest args)
  "Custom yank function.

`kam-yank' emulates the pasting functionality in Vim. If the most
current kill contains a newline character, create a new line below the
point and insert the string to be yanked there. Else, just insert the
yank."
  (interactive)
  (cond ((kam-line-regexp-p 'empty)
         (save-excursion
           (apply orig-fn args)))
        ((string-search "\n" (current-kill 0 t))
         (kam-insert-new-line-below 1)
         (save-excursion
           (apply orig-fn args)))
        (t (save-excursion
             (apply orig-fn args)))))

(defun kam-delete-pair-dwim ()
  "Delete pair following or preceding point."
  (interactive)
  (if (eq (point) (cdr (bounds-of-thing-at-point 'sexp)))
      (delete-pair -1)
    (delete-pair 1)))

(defun kam-insert-new-line-below (&optional n)
  "Create N empty lines below the current one.

When called interactively without a prefix numeric argument, N is 1."
  (interactive "p")
  (goto-char (line-end-position))
  (dotimes (_ n) (newline-and-indent)))

(defun kam-insert-new-line-above (&optional n)
  "Create N empty lines above the current one.

When called interactively without a prefix numeric argument, N is 1."
  (interactive "p")
  (let ((point-min (point-min)))
    (if (or (bobp)
            (eq (point) point-min)
            (eq (line-number-at-pos point-min) 1))
        (progn
          (goto-char (line-beginning-position))
          (forward-line (- n))
          (dotimes (_ n) (kam-insert-new-line-below n)))
      (forward-line (- n))
      (kam-insert-new-line-below n))))

(defun kam-join-line-dwim (n)
  "Join lines.

When called interactively without a prefix numeric argument, N is 1."
  (interactive "P")
  (let ((numeric-arg (prefix-numeric-value n)))
    (save-excursion
      (set-mark (point))
      (forward-line numeric-arg)
      (join-line nil (region-beginning) (region-end)))
    (indent-according-to-mode)))

(defun kam-open-line-dwim (n)
  "Open the line and indent it to the proper place.

When called interactively without a prefix numeric argument, N is 1."
  (interactive "P")
  (let ((arg (prefix-numeric-value n)))
    (save-excursion
      (open-line arg)
      (forward-line arg)
      (indent-according-to-mode))
    (indent-according-to-mode)))

(defun kam-yank-replace-line-or-region ()
  "Replace line or region with the latest kill.

This command can be followed by the standard `yank-pop' (default is
bound to \\[yank-pop])."
  (interactive)
  (if (use-region-p)
      (delete-region (region-beginning) (region-end))
    (delete-region (line-beginning-position) (line-end-position)))
  (yank)
  (setq this-command 'yank)
  (kam-indent-dwim))

(defun kam-kill-from-point-to-beginning-of-line ()
  "Kill from the point to the beginning of the line."
  (interactive)
  (kill-region (line-beginning-position) (point)))

(defun kam-delete-from-point-to-beginning-text ()
  "Delete from the point up to and including the text."
  (interactive)
  (while (or (not (kam-line-only-spaces-or-symbols-p))
             (bolp))
    (delete-char -1)))

(defun kam-control-backspace ()
  "Kill the word behind point. If the line is empty, join it with the previous line."
  (interactive)
  (if (or (kam-line-empty-before-point-p)
          (bolp))
      (join-line)
    (backward-kill-word 1)))

(defun kam-transpose-chars ()
  "Interchange the two characters behind the point."
  (interactive)
  (cond
   ((eolp) (transpose-chars 1))
   (t (transpose-chars -1) (forward-char 1))))

(defun kam-transpose-words ()
  "Interchange the words behind the point."
  (interactive)
  (forward-word -1)
  (transpose-words 1))

(defun kam-indent-dwim ()
  "Indent the current defun in `prog-mode' or paragraph in `text-mode'."
  (interactive)
  (save-excursion
    (cond
     ((derived-mode-p 'prog-mode)
      (mark-defun))
     ((derived-mode-p 'text-mode)
      (mark-paragraph)))
    (indent-for-tab-command)
    (deactivate-mark)))

(defun kam-end-of-string ()
  (interactive)
  (while (in-string-p)
    (forward-char 1))
  (point))

(defun kam-beginning-of-string ()
  (interactive)
  (while (in-string-p)
    (forward-char -1))
  (point))

(defun kam-narrow-or-widen-dwim (p)
  "If the buffer is narrowed, it widens. Otherwise, it narrows intelligently.

Intelligently means: region, subtree, or defun, whichever applies first."
  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p)
         (narrow-to-region (region-beginning) (region-end)))
        ((derived-mode-p 'org-mode) (org-narrow-to-subtree))
        (t (narrow-to-defun))))

(defun kam-current-elisp-sexp ()
  "Returns the current Elisp expression based on the position of the point."
  (cond
   ((looking-at "(") (sexp-at-point))
   ((looking-back ")" 1) (elisp--preceding-sexp))
   (t (save-excursion
        (search-backward "(")
        (sexp-at-point)))))

(defun kam-eval-current-sexp ()
  "Evaluates the current sexp at point.

Additionally, if the region is active, evaluate the region.
Unlike `eval-last-sexp', the point doesn't need to be at the end of the
expression, but can be at the beginning (on the parenthesis) or
somewhere inside."
  (interactive)
  (if (region-active-p)
      (progn
        (eval-region (region-beginning) (region-end))
        (message "Evaluated region"))
    (eval-expression (kam-current-elisp-sexp))))

(defun kam-insert-quote (&optional arg)
  "Enclose following ARG sexps in quotes."
  (interactive "P")
  (insert-pair arg ?\" ?\"))

(defun kam-indent-region-advice (&rest ignored)
  (let ((deactivate deactivate-mark))
    (if (region-active-p)
        (indent-region (region-beginning) (region-end))
      (indent-region (line-beginning-position) (line-end-position)))
    (setq deactivate-mark deactivate)))

(defun kam-yank-undo (&optional arg)
  "Undo the yank you just did.

Reverses the direction you are going in the kill ring.
With optional ARG, repeat the undos that many times."
  (interactive "p")
  (yank-pop (- arg)))

(defun kam-query-replace-dwim ()
  "Query replace, DWIM.

If the region is active, query replace the thing in the region.
Else, use the symbol at point."
  (interactive)
  (let* ((sym (or (when (region-active-p)
                    (buffer-substring-no-properties
                     (region-beginning) (region-end)))
                  (thing-at-point 'symbol)))
         (to-string (read-string (format "Query replace %s with: " sym))))
    (deactivate-mark)
    (query-replace sym to-string)))

(defun kam-keyboard-escape-quit-dwim ()
  "A better keyboard quit."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   ((identity defining-kbd-macro)
    (kmacro-keyboard-quit))
   (t
    (keyboard-escape-quit))))

(defun kam-keyboard-escape-quit (orig-fn &rest args)
  "Perform `keyboard-escape-quit' without disturbing the window configuration."
  (let ((buffer-quit-function (or buffer-quit-function
                                  #'ignore)))
    (apply orig-fn args)))

(defun kam-kill-current-buffer (&optional arg)
  "Kill the current buffer, without prompting the user.

With optional prefix ARG (\\[universal-argument]), delete the buffer's
window as well. This command works similarly to
`kam-delete-window-dwim', just in reverse."
  (interactive "P")
  (let ((kill-buffer-query-functions nil))
    (if arg
        (kill-buffer-and-window)
      (kill-buffer))))

(provide 'kam-common)
;;; kam-common.el ends here
