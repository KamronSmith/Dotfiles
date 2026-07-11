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

(defun kam-quit-window ()
  "Quit the window and kill it."
  (interactive)
  (quit-window t))

;;;###autoload
(defun kam-delete-window-dwim ()
  "Do What I Mean to delete the current thing.
When there is one window, THING is a window.
When there is more than one `tab-bar-mode' tabs, THING is a tab."
  (declare (interactive-only t))
  (interactive)
  (cond
   ((length> (window-list) 1)
    (delete-window))
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
Additionally,select the newly formed window."
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

(defun kam-window-delete-popup-frame (&rest _)
  "Kill selected frame if it has the parameter `kam-window-popup-frame'.
Use this function via a hook."
  (when (frame-parameter nil 'kam-window-popup-frame)
    (delete-frame)))

(defmacro kam-window-define-with-popup-frame (command)
  "Define interactive function which calls COMMAND in a new frame.
Make the new frame have the `kam-window-popup-frame-parameter'."
  `(defun ,(intern (format "kam-window-popup-%s" command)) ()
     ,(format "Run `%s' in a popup frame with `kam-window-popup-frame' parameter.
Also see `kam-window-delete-popup-frame'." command)
     (interactive)
     (let ((frame (make-frame '((kam-window-popup-frame . t)))))
       (select-frame frame)
       (switch-to-buffer " kam-window-hidden-buffer-for-popup-frame")
       (condition-case nil
           (call-interactively ',command)
         ((quit error user-error)
          (delete-frame frame))))))

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

(defun kam-consult-buffer (&optional arg)
  "Perform `consult-buffer', but disable `vertico-sort-function'.
If optional ARG is provided, perform the buffer switch in the other window."
  (interactive "P")
  (if-let* (((equal arg '(4)))
            (win (other-window-for-scrolling)))
      (with-selected-window win
        (let ((vertico-sort-function 'identity))
          (consult-buffer)))
    (let ((vertico-sort-function 'identity))
      (consult-buffer))))

(defun kam-get-alternate-buffer (&optional window)
  "Return the last buffer WINDOW has displayed other than the current one."
  (let* ((prev-buffers (window-prev-buffers))
         (head (car prev-buffers)))
    (if (eq (car head) (window-buffer window))
        (cadr prev-buffers)
      head)))

(defun kam-ace-window (&optional arg)
  "Perform the normal `ace-window' command, but with optional extras.
When optional ARG is provided, if there is only one window in the frame,
create a new window and switch to it."
  (interactive "P")
  ;; TODO 2026-05-21: Implement `kam-ace-window' command
  )

;;;###autoload
(defun kam-switch-to-alternate-buffer ()
  "Switch to the last window used."
  (interactive)
  (let* ((alt-buffer (kam-get-alternate-buffer)))
    (switch-to-buffer alt-buffer)))

;;;###autoload
(defun kam-clone-buffer-and-narrow ()
  (interactive)
  (clone-indirect-buffer-other-window nil 'pop-to-buffer)
  (cond ((region-active-p)
         (narrow-to-region (region-beginning) (region-end)))
        ((derived-mode-p 'org-mode) (org-narrow-to-subtree))
        (t (narrow-to-defun))))

(provide 'kam-window)
;;; kam-window.el ends here
