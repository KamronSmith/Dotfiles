;;; kam-simple.el --- -*- lexical-binding: t; -*-
;;; Summary:

;;; Commentary:

;;; Code:
(require 'kam-common)

;;;###autoload
(defun kam-find-init-file ()
  "Open `user-init-file'."
  (interactive)
  (find-file user-init-file))

;;;###autoload
(defun kam-execute-command-on-file-buffer (cmd)
  "Execute CMD on the buffer and associated file."
  (interactive "sCommand to execute: ")
  (let* ((file-name (buffer-file-name))
         (full-cmd (concat cmd " " file-name)))
    (async-shell-command full-cmd)))

;;;###autoload
(defun kam-sudo-find-file (file)
  "Edit FILE using Sudo."
  (when (file-writable-p file)
    (user-error "File is user writeable, aborting sudo"))
  (find-file (if (file-remote-p file)
                 (concat "/" (file-remote-p file 'method) ":"
                         (file-remote-p file 'user) "@" (file-remote-p file 'host)
                         "|sudo:root@"
                         (file-remote-p file 'host) ":" (file-remote-p file 'localname))
               (concat "/sudo:root@localhost:" file))))

;;;###autoload
(defun kam-push-mark-no-activate ()
  "Push the mark at point, but don't activate it."
  (interactive)
  (push-mark (point) t nil))

;;;###autoload
(defun kam-push-mark-no-message ()
  "Push the mark at point, but don't display a message."
  (interactive)
  (push-mark (point) t t))

;;;###autoload
(defun kam-rename-file-and-buffer (name)
  "Apply NAME to the current file and rename its buffer."
  (interactive
   (list (read-file-name "Rename current file: " (buffer-file-name))))
  (let ((file (buffer-file-name)))
    (if (vc-registered file)
        (vc-rename-file file name))
    (set-visited-file-name name t t)))

;;;###autoload
(defun kam-revert-buffer ()
  "Revert the current buffer from its file without asking for confirmation."
  (interactive)
  (revert-buffer t t t)
  (message "Reverted buffer `%s'" (buffer-name (current-buffer))))

;;;###autoload
(defun kam-smart-beginning-of-line ()
  "Move point to first non-whitespace character or beginning-of-line.
If point was already at that position, move point to beginning of
line."
  (interactive)
  (let ((oldpos (point)))
    (back-to-indentation)
    (and (= oldpos (point))
         (beginning-of-line))))

;;;###autoload
(defun kam-mark-line (&optional arg allow-extend)
  "Set mark ARG lines from point or move point one line.
With numeric prefix argument ARG, put mark on the end of a following
line, so that the number of marked lines is equal to 1 + ARG. This is so
that with `display-line-numbers' set to relative, the user can easily
judge how many lines they would like to mark.

If ARG is negative, the mark is put at the beginning of previous lines."
  (interactive "P\np")
  (cond ((and allow-extend
              (or (and (eq last-command this-command)
                       (mark t))
                  (and transient-mark-mode
                       mark-active)))
         (setq arg (if arg (prefix-numeric-value arg)
                     (if (< (mark) (point)) -1 1)))
         (if visual-line-mode
             (kam-mark
              (cons (point)
                    (save-excursion
                      (goto-char (mark))
                      (line-move-visual (prefix-numeric-value arg))
                      (point))))
           (kam-mark
            (cons (point)
                  (save-excursion
                    (goto-char (mark))
                    (forward-line (prefix-numeric-value arg))
                    (point))))))
        (t (progn
             (when (> (prefix-numeric-value arg) 1)
               (setq arg (1+ (prefix-numeric-value arg))))
             (if visual-line-mode
                 (kam-mark
                  (cons (beginning-of-visual-line)
                        (save-excursion
                          (line-move-visual (prefix-numeric-value arg))
                          (beginning-of-visual-line)
                          (point))))
               (kam-mark
                (cons (line-beginning-position)
                      (save-excursion
                        (forward-line (prefix-numeric-value arg))
                        (line-beginning-position)))))))))

;;;###autoload
(defun kam-mark-point-to-end-of-line ()
  "Set the mark at the end of the line, regardless of where the cursor is on the line."
  (interactive)
  (if visual-line-mode
      (kam-mark
       (cons (point)
             (save-excursion
               (end-of-visual-line)
               (point))))
    (kam-mark
     (cons (point)
           (line-end-position)))))

;;;###autoload
(defun kam-mark-point-to-end-of-buffer ()
  "Mark from point to the end of the buffer."
  (interactive)
  (kam-mark
   (cons (point)
         (point-max))))

;;;###autoload
(defun kam-copy-line-as-kill (&optional arg)
  "Copy ARG lines to the `kill-ring'.
When called interactively without a numeric prefix argument, ARG is 1."
  (interactive "p")
  (save-excursion
    (kam-mark-line arg)
    (kill-ring-save nil nil t)))

;;;###autoload
(defun kam-kill-line (&optional arg)
  "Kill ARG lines, regardless of where the point is on the line.
When called interactively without a prefix numeric argument, ARG is 1."
  (interactive "p")
  (kam-mark-line arg)
  (kill-region (region-beginning) (region-end)))

;;;###autoload
(defun kam-kill-dwim (&optional arg)
  "A DWIM command for killing.
If the region is active, kill the region. Else, kill ARG lines.
When called interactively without a numeric prefix argument, ARG is 1."
  (interactive "p")
  (cond ((region-active-p)
         (kill-region nil nil t)
         (setq this-command 'kill-region))
        (t
         (kam-kill-line arg)
         (setq this-command 'kill-region))))

;;;###autoload
(defun kam-kill-ring-save-dwim (&optional arg)
  "A DWIM command for copying.
If the region is active, copy the region. Else, copy ARG lines to the
`kill-ring'. When called interactively without a numeric prefix
argument, ARG is 1."
  (interactive "p")
  (cond ((region-active-p)
         (kill-ring-save nil nil t)
         (setq this-command 'kill-ring-save))
        (t
         (kam-copy-line-as-kill arg)
         (setq this-command 'kill-ring-save))))

;;;###autoload
(defun kam-yank (&optional arg)
  "Yank function that emulates the pasting functionality in Vim.
If the most current kill contains a newline character, create a new
line below the point and insert the string to be yanked there. Else,
just insert the yank.

With optional prefix ARG (\\[universal-argument]), call `kam-yank-replace-line-or-region'
instead."
  (interactive "P")
  (cond (arg
         (kam-yank-replace-line-or-region))
        ((or (bolp)
             (kam-line-empty-before-point-p))
         (yank))
        ((string-search "\n" (current-kill 0 t))
         (kam-insert-new-line-below 1)
         (yank))
        (t (yank))))

;;;###autoload
(defun kam-duplicate-dwim (&optional arg)
  "Duplicate line or region.
With optional numeric prefix ARG, duplicate ARGth line from point. When
optional prefix argument (\\[universal-prefix-argument]) ARG
is given, duplicate the line immediately above point."
  (interactive "P")
  (cond ((consp arg)
         (let ((text))
           (save-excursion
             (forward-line -1)
             (setq text (string-trim
                         (buffer-substring-no-properties (line-beginning-position) (line-end-position)))))
           (kam-insert-new-line-above 1)
           (kam-push-mark-no-activate)
           (insert text)
           (setq this-command 'copy-from-above-command)))
        ((integerp arg)
         (let ((text))
           (save-excursion
             (forward-line (- arg))
             (setq text (string-trim
                         (buffer-substring-no-properties (line-beginning-position) (line-end-position)) t t)))
           (kam-push-mark-no-activate)
           (insert text)
           (setq this-command 'copy-from-above-command)))
        ((region-active-p)
         (duplicate-dwim)
         (deactivate-mark t)
         (setq this-command 'duplicate-dwim))
        (t (duplicate-line))))

;;;###autoload
(defun kam-delete-pair-dwim ()
  "Delete pair following or preceding point."
  (interactive)
  (if (eq (point) (cdr (bounds-of-thing-at-point 'sexp)))
      (delete-pair -1)
    (delete-pair 1)))

;;;###autoload
(defun kam-insert-new-line-below (&optional arg)
  "Create ARG empty lines below the current one.
When called interactively without a prefix numeric argument, ARG is 1."
  (interactive "p")
  (goto-char (line-end-position))
  (dotimes (_ arg) (newline-and-indent)))

;;;###autoload
(defun kam-insert-new-line-above (&optional arg)
  "Create ARG empty lines above the current one.
When called interactively without a prefix numeric argument, ARG is 1."
  (interactive "p")
  (let ((point-min (point-min)))
    (if (or (bobp)
            (eq (point) point-min)
            (eq (line-number-at-pos point-min) 1))
        (progn
          (goto-char (line-beginning-position))
          (forward-line (- arg))
          (dotimes (_ arg) (kam-insert-new-line-below arg)))
      (forward-line (- arg))
      (kam-insert-new-line-below arg))))

;;;###autoload
(defun kam-join-line-dwim (&optional arg)
  "Join ARG lines.
When called interactively without a prefix numeric argument, ARG is 1."
  (interactive "p")
  (save-excursion
    (set-mark (point))
    (forward-line arg)
    (join-line nil (region-beginning) (region-end)))
  (indent-according-to-mode))

;;;###autoload
(defun kam-open-line-dwim (&optional arg)
  "Open ARG lines and indent them to the proper place.
When called interactively without a prefix numeric argument, ARG is 1."
  (interactive "p")
  (save-excursion
    (open-line arg)
    (forward-line arg)
    (indent-according-to-mode))
  (indent-according-to-mode))

;;;###autoload
(defun kam-yank-replace-line-or-region ()
  "Replace line or region with the latest kill.
This command can be followed by the standard `yank-pop' (default is
bound to \\[yank-pop])."
  (interactive)
  (if (use-region-p)
      (delete-region (region-beginning) (region-end))
    (delete-region (line-beginning-position) (line-end-position)))
  (yank)
  (setq this-command 'yank))

;;;###autoload
(defun kam-kill-from-point-to-beginning-of-line ()
  "Kill from the point to the beginning of the line."
  (interactive)
  (kill-region (line-beginning-position) (point)))

;;;###autoload
(defun kam-delete-from-point-to-beginning-text ()
  "Delete from the point up to and including the text."
  (interactive)
  (while (or (not (kam-line-only-spaces-or-symbols-p))
             (bolp))
    (delete-char -1)))

;;;###autoload
(defun kam-control-backspace ()
  "Kill the word behind point. If the line is empty, join it with the previous line."
  (interactive)
  (if (or (kam-line-empty-before-point-p)
          (bolp))
      (join-line)
    (backward-kill-word 1)))

;;;###autoload
(defun kam-transpose-chars ()
  "Interchange the two characters behind the point."
  (interactive)
  (cond
   ((eolp) (transpose-chars 1))
   (t (transpose-chars -1) (forward-char 1))))

;;;###autoload
(defun kam-transpose-words ()
  "Interchange the words behind the point."
  (interactive)
  (forward-word -1)
  (transpose-words 1))

;;;###autoload
(defun kam-indent-dwim ()
  "Indent the current defun in `prog-mode' or paragraph in `text-mode'.
If the region is active, indent the region."
  (interactive)
  (if (region-active-p)
      (indent-region (region-beginning) (region-end))
    (save-excursion
      (cond
       ((derived-mode-p 'prog-mode)
        (mark-defun))
       ((derived-mode-p 'text-mode)
        (mark-paragraph)))
      (indent-region (region-beginning) (region-end))
      (deactivate-mark t))))

;;;###autoload
(defun kam-indent-line ()
  "Indent the line using `indent-line-function'."
  (interactive)
  (funcall indent-line-function))

;;;###autoload
(defun kam-narrow-or-widen-dwim (&optional p)
  "If the buffer is narrowed, it widens. Otherwise, it narrows intelligently.
Intelligently means: region, subtree, or defun, whichever applies first."
  (interactive "P")
  (declare (interactive-only t))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p)
         (narrow-to-region (region-beginning) (region-end)))
        (t (narrow-to-defun))))

;;;###autoload
(defun kam-eval-current-sexp ()
  "Evaluate the current sexp at point.
Additionally, if the region is active, evaluate the region. Unlike
`eval-last-sexp', the point doesn't need to be at the end of the
expression, but can be at the beginning (on the parenthesis) or
somewhere inside."
  (interactive)
  (if (region-active-p)
      (eval-region (region-beginning) (region-end))
    (eval-expression (kam-current-elisp-sexp))))

;;;###autoload
(defun kam-insert-quote (&optional arg)
  "Enclose following ARG sexps in quotes."
  (interactive "P")
  (insert-pair arg ?\" ?\"))

;;;###autoload
(defun kam-yank-undo (&optional arg)
  "Undo the yank you just did.
Reverses the direction you are going in the kill ring. With optional
numeric prefix ARG, repeat the undos that many times."
  (interactive "p")
  (yank-pop (- arg)))

;;;###autoload
(defun kam-query-replace-dwim ()
  "Query replace, DWIM.
If the region is active, query replace the thing in the region. Else,
use the symbol at point."
  (interactive)
  (let* ((sym (or (when (region-active-p)
                    (buffer-substring-no-properties
                     (region-beginning) (region-end)))
                  (thing-at-point 'symbol)))
         (to-string (read-regexp (format "Query replace %s with: " sym))))
    (deactivate-mark)
    (query-replace-regexp sym to-string)))

(declare-function 'kmacro-keyboard-quit "kmacro")

;;;###autoload
(defun kam-keyboard-escape-quit-dwim ()
  "A better `keyboard-escape-quit'."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   (current-prefix-arg
    nil)
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   ((identity defining-kbd-macro)
    (kmacro-keyboard-quit))
   (t
    (kam-keyboard-escape-quit))))

(defun kam-keyboard-escape-quit ()
  "Perform `keyboard-escape-quit' without disturbing the window configuration."
  (let ((buffer-quit-function (or buffer-quit-function
                                  #'ignore)))
    (keyboard-escape-quit)
    (message "Quit")))

;;;###autoload
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

(provide 'kam-simple)
;;; kam-simple.el ends here
