;;; kam-ediff.el --- -*- lexical-binding: t; -*-
;;; Summary:

;;; Commentary:

;;; Code:
(require 'ediff)

(defgroup kam-ediff ()
  "Extensions for `ediff'."
  :group 'ediff)

(defvar kam-ediff--before-buffers nil
  "Snapshot of `buffer-list' before `kam-vc-ediff' starts.")

(defvar-local kam-ediff--kill-on-quit nil
  "Non-nil if this buffer was temporarily created by `kam-vc-ediff'.")

(defun kam-ediff-mode-setup ()
  "Setup function for `ediff-mode'."
  (kam-ediff--mark-new-variants))

(defun kam-ediff-cleanup ()
  "Clean up `ediff' buffers after exiting."
  (kam-ediff--cleanup-temp-variants)
  (when-let* ((buf (get-buffer "*Ediff Registry*")))
    (kill-buffer buf)))

(defun kam-ediff--mark-new-variants ()
  "Mark newly created Ediff variant buffers for cleanup on quit."
  (when kam-ediff--before-buffers
    (dolist (buf (list ediff-buffer-A ediff-buffer-B ediff-buffer-C))
      (when (and (buffer-live-p buf)
                 (not (memq buf kam-ediff--before-buffers)))
        (with-current-buffer buf
          (setq-local kam-ediff--kill-on-quit t))))
    (setq kam-ediff--before-buffers nil)))

(defun kam-ediff--cleanup-temp-variants ()
  "Silently kill temporary variant buffers marked by `kam-vc-ediff'."
  (dolist (buf (list ediff-buffer-A ediff-buffer-B ediff-buffer-C))
    (when (and (buffer-live-p buf)
               (buffer-local-value 'kam-ediff--kill-on-quit buf))
      (with-current-buffer buf
        (set-buffer-modified-p nil))
      (kill-buffer buf))))

(defun kam-ediff-store-layout ()
  "Store current frame window configuration as a frame parameter.
Add this function to the `ediff-before-setup-hook'."
  (let ((frame (selected-frame)))
    (set-frame-parameter
     frame
     'kam-ediff-last-layout
     (current-window-configuration frame))))

(defun kam-ediff-restore-layout ()
  "Restore the frame's window configuration.
Add this function to the `ediff-quit-hook'."
  (if-let* ((layout (frame-parameter (selected-frame) 'kam-ediff-last-layout)))
      (set-window-configuration layout)
    (message "No Ediff window configuration for the current frame")))

(provide 'kam-ediff)
;;; kam-ediff.el ends here
