;;; kam-window.el --- Extensions for the windowing system in Emacs -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:
(require 'ace-window)

(defgroup kam-window ()
  "Extensions for the windowing system in Emacs."
  :group 'window)

(defun kam-window-bounds ()
  "Return the start and end points of the current window as a cons cell."
  (cons (window-start) (window-end)))

(defun kam-three-or-more-windows-p (&optional frame)
  "Return non-nil if three or more windows occupy FRAME.
If FRAME is non-nil, inspect the current frame."
  (>= (length (window-list frame :no-minibuffer)) 3))

(defun kam-two-windows-p (&optional frame)
  "Return non-nil if two windows occupy FRAME.
If FRAME is non-nil, inspect the current frame."
  (= (length (window-list frame :no-minibuffer)) 2))

(defun kam-window-narrow-p ()
  "Return non-nil if the window is narrow.
Check if the `window-width' is less than `split-width-threshold'."
  (and (numberp split-width-threshold)
       (< (window-total-width) split-width-threshold)))

(defun kam-window-small-p ()
  "Return non-nil if the window is small.
Check if the `window-width' or the `window-height' is less than
`split-width-threshold' or `split-height-threshold', respectively."
  (or (and (numberp split-width-threshold)
           (< (window-total-width) split-width-threshold))
      (and (numberp split-height-threshold)
           (> (window-total-height) split-height-threshold))))

;;;###autoload
(defun kam-quit-window (&optional arg)
  "Quit the window.
With optional ARG, kill the buffer."
  (interactive)
  (quit-window arg))

;;;###autoload
(defun kam-scroll-down (&optional arg)
  "Scroll down a half screen.
With optional ARG, scroll down that many times.
Please see "
  (interactive)
  (scroll-up arg))

;;;###autoload
(defun kam-scroll-up (&optional arg)
  "Scroll up.
With optional ARG, scroll up that many times."
  (interactive)
  (scroll-down arg))

;;;###autoload
(defun kam-delete-window-dwim (&optional arg)
  "Do what I mean to delete the current thing.
When there is one window, THING is a window.
When optional prefix ARG (\\[universal-argument]) is provided, kill the buffer that window holds.
When there is more than one `tab-bar-mode' tabs, THING is a tab."
  (declare (interactive-only t))
  (interactive "P")
  (cond
   ((length> (window-list) 1)
    (delete-window))
   ((and (length> (window-list) 1)
         arg)
    (kill-buffer-and-window))
   ((and (featurep 'tab-bar)
         (length> (tab-bar-tabs) 1))
    (tab-close))
   (t
    (user-error "Nothing to delete"))))

;;;###autoload
(defun kam-split-window-right ()
  "Like the normal `split-window-right' but selects the newly formed window."
  (interactive)
  (split-window-right)
  (windmove-right))

;;;###autoload
(defun kam-split-window-below ()
  "Like the normal `split-window-below', but splits the window at the root if there are two windows.
Additionally, select the newly formed window."
  (interactive)
  (if (kam-two-windows-p)
      (split-root-window-below)
    (split-window-below)))

;;;###autoload
(defun kam-alternate-buffer (&optional window)
  "Switch back and forth between current and last buffer in the current window."
  (interactive)
  (let ((current-buffer (window-buffer window)))
    (switch-to-buffer
     (cl-find-if (lambda (buffer)
                   (not (eq buffer current-buffer)))
                 (mapcar #'car (window-prev-buffers window)))
     nil t)))

;;;###autoload
(defun kam-ace-window ()
  "Like the normal `ace-window' command, but splits the window if there is only one window."
  (interactive)
  (if (one-window-p) 
      (kam-split-window-right)
    (call-interactively 'ace-window)))

(defun kam-recenter-advice (&ignore _)
  (recenter))
;;;###autoload
(defun kam-next-buffer (&optional arg)
  "Switch to the next ARGth buffer.
With universal prefix ARG, run in the next window."
  (interactive "P")
  (if-let* (((equal arg '(4)))
            (win (other-window-for-scrolling)))
      (with-selected-window win
        (next-buffer)
        (setq prefix-arg current-prefix-arg))
    (next-buffer arg)))

;;;###autoload
(defun kam-prev-buffer (&optional arg)
  "Switch to the previous ARGth buffer.
With universal prefix ARG, run in the next window."
  (interactive "P")
  (if-let* (((equal arg '(4)))
            (win (other-window-for-scrolling)))
      (with-selected-window win
        (previous-buffer)
        (setq prefix-arg current-prefix-arg))
    (previous-buffer arg)))

(defun kam-get-alternate-buffer (&optional window)
  "Return the last buffer WINDOW has displayed other than the current one."
  (let* ((prev-buffers (window-prev-buffers))
         (head (car prev-buffers)))
    (if (eq (car head) (window-buffer window))
        (cadr prev-buffers)
      head)))

;;;###autoload
(defun kam-switch-to-alternate-buffer ()
  "Switch to the last buffer used."
  (interactive)
  (let* ((alt-buffer (kam-get-alternate-buffer)))
    (switch-to-buffer alt-buffer)))

(defun kam-display-command-same-window (orig-fn &rest args)
  "Call ORIG-FN with ARGS while displaying everything in the same window."
  (let ((switch-to-buffer-obey-display-actions t)
        (display-buffer-overriding-action '(display-buffer-reuse-window
                                            display-buffer-same-window)))
    (apply orig-fn args)))

(defun kam-split-window-conservatively (&optional window)
  "Split WINDOW only if absolutely necessary.
Only split if there is no split, and only split into left and right windows."
  (interactive)
  (let ((window (or window (selected-window))))
    (if (and
         (window-splittable-p window t)
         (= (length (window-list)) 1))
        (with-selected-window window
          (split-window-right))
      nil)))

;;;###autoload
(defun kam-toggle-delete-other-windows ()
  "Delete other windows in the frame if any, or restore previous window config."
  (interactive)
  (if (and winner-mode
           (equal (selected-window) (next-window)))
      (winner-undo)
    (delete-other-windows)))

;;;###autoload
(defun kam-clone-buffer-and-narrow ()
  "Clone the current buffer and narrow it."
  (interactive)
  (clone-indirect-buffer-other-window nil 'pop-to-buffer)
  (kam-narrow-or-widen-dwim))

(defun kam-no-split-window ()
  "Use in `split-window-preferred-function' to disable window splitting."
  nil)

(defun kam-aw-consult-buffer (window)
  "Perform `consult-buffer' in AW selected WINDOW."
  (aw-switch-to-window window)
  (consult-buffer))

(defun kam-aw-delete-window-dwim (window)
  "Perform `kam-delete-window-dwim' in the AW-selected WINDOW."
  (aw-switch-to-window window)
  (kam-delete-window-dwim))

(defun kam-aw-execute-extended-command (window)
  "Perform `execute-extended-command' in the AW-selected WINDOW."
  (aw-switch-to-window window)
  (call-interactively 'execute-extended-command))

(defun kam-aw-one-command (window)
  "Run a command in the AW-selected WINDOW."
  (aw-switch-to-window window)
  (with-selected-window window
    (let* ((command (key-binding
                     (read-key-sequence
                      (format "Run in %s..." (buffer-name)))))
           (this-command command))
      (call-interactively command))))

(provide 'kam-window)
;;; kam-window.el ends here
