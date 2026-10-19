;;; kam-tatr.el --- -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:
;;; Code:

(defvar kam-tatr-title-history nil
  "Minibuffer history for Tatr titles.")

(defun kam-tatr-new-task (title &optional priority tags)
  "Make a new task with TITLE."
  (interactive (list (read-string "Title for new task: "
                                  nil
                                  kam-tatr-title-history)))
  ;; TODO: Figure out what to do with calling TATR
  (call-process "tatr" nil nil t (concat "new " title)))

(defun kam-tatr-list ()
  (interactive)
  (compile "tatr ls"))

(defun kam-tatr-summary ()
  (interactive)
  (compile "tatr summary"))

(provide 'kam-tatr)
;;; kam-tatr.el ends here
