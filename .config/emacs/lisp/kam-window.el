;; -*- lexical-binding: t; -*-

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

(defun kam-split-window-below ()
  "Like the normal `split-window-below', but splits the window at the root if there are two windows.
Additionally,select the newly formed window."
  (interactive)
  (if (kam-two-windows-p)
      (split-root-window-below)
    (split-window-below)))

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
  "Define interactive function which calls COMMAND in a new fraeme.
Make the new frame have the `kam-window-popup-frame-paramter."
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

(provide 'kam-window)
;;; kam-window.el ends here
