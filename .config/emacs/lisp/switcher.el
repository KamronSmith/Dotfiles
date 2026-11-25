;;; switcher.el --- -*- lexical-binding: t; -*-
;;; Summary:

;;; Commentary:

;;; Code:
(defgroup switcher ()
  "Make switching buffers more like switching apps."
  :group 'window)

(defcustom switcher-timer-time 5
  "How long the timer to set the next buffer should run."
  :type 'natnum)

(defvar-local switcher-timer nil)

(defun switcher--set-next-buffers ()
  "Set the current window's next buffers."
  (set-window-next-buffers (selected-window) nil))

(defun switcher--cleanup ()
  (when (timerp switcher-timer)
    (cancel-timer switcher-timer))
  (setq switcher-timer nil))

;;;###autoload
(defun switcher-next-buffer ()
  (interactive)
  (if (eq (window-next-buffers) nil)
      (user-error "At the bottom of the buffer list")
    (next-buffer)))

(defvar switcher-mode-map (make-sparse-keymap)
  "Keymap for `switcher-mode'.")

(define-minor-mode switcher-mode
  "Make switching buffers more like using a phone."
  :init-value nil
  :global t
  :keymap switcher-mode-map
  (if switcher-mode
      (progn
        (switcher--set-next-buffers)
        (setq switcher-timer (run-with-idle-timer switcher-timer-time t 'switcher--set-next-buffers)))
    (switcher--cleanup)))

(provide 'switcher)
;;; switcher.el ends here
