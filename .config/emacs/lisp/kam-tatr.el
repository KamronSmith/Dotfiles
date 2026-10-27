;;; kam-tatr.el --- -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:
(require 'kam-common)

(defvar kam-tatr-default-priority 100)

(defvar kam-tatr-default-tags '("scope"))

(defvar kam-tatr-huid-regexp "^[0-9]\\{8\\}-[0-9]\\{6\\}$")

(defun kam-tatr-new-huid ()
  (format-time-string "%Y%m%d-%H%M%S" nil t))

(defun kam-tatr-huid-p (huid)
  (when (string-match kam-tatr-huid-regexp huid) t))

(defvar-local kam-tatr-directory nil
  "Location of the tasks directory of the current buffer.")

(defun kam-tatr--find-tatr-directory ()
  "Find the location of the TATR tasks directory."
  (expand-file-name "tasks" (locate-dominating-file default-directory "tasks/")))

(defvar kam-tatr-title-history nil
  "Minibuffer history for TATR titles.")

(defun kam-tatr-create-from-title (title)
  "Make a new task with TITLE."
  (interactive (list (read-string "Title for new task: "
                                  nil
                                  kam-tatr-title-history)))
  ;; TODO: Figure out what to do with calling TATR
  (kam-tatr-create title))

(defun kam-tatr-create (title &optional huid)
  (if-let* ((db-dir (kam-tatr--find-tatr-directory)))
      (if-let* ((huid (if huid huid (kam-tatr-new-huid)))
                (task-path (expand-file-name huid db-dir)))
          (if (file-exists-p task-path)
              (user-error "ERROR: %s already exists" task-path)
            (make-directory task-path)
            (let ((task-md-path (expand-file-name "TASK.md" task-path))
                  (task-md-content (format (concat
                                            "# %s\n"
                                            "\n"
                                            "- STATUS: OPEN\n"
                                            "- PRIORITY: %s\n"
                                            "- TAGS: %s\n")
                                           title
                                           kam-tatr-default-priority
                                           (mapconcat #'identity kam-tatr-default-tags))))
              (write-region task-md-content nil task-md-path))))
    (user-error "ERROR: TATR directory was not found")))

(defun kam-tatr-find-by-huid (huid)
  (interactive (list (if (region-active-p)
                         (buffer-substring-no-properties (region-beginning) (region-end))
                       (read-string "HUID: "))))
  (if-let ((db-dir (kam-tatr--find-tatr-directory)))
      (if (kam-tatr-huid-p huid)
          (if-let ((task-md-path (file-name-concat db-dir huid "TASK.md")))
              (if (file-regular-p task-md-path)
                  (find-file task-md-path)
                (user-error "Task %s was not found" huid)))
        (user-error "%s is not a valid HUID" huid))
    (user-error "TATR directory was not found")))

(defun kam-tatr-insert-task-at-point (task)
  (interactive (list)))

(defun tam-tatr-insert-task-at-point--prompt ()
  (completing-read "Task: "
                   (kam-grep-list-of-strings "^# " nil (kam-tatr--find-tatr-directory))))

(defun kam-tatr--task-titles ()
  "Return a list of all the titles of the tasks as a list of strings."
  (let* ((unprocessed (kam-grep-list-of-strings "^#" "-I" (kam-tatr--find-tatr-directory))))
    (mapcar (lambda (str)
              (string-remove-prefix "# " str))
            unprocessed)))
    
(defun kam-tatr-list ()
  (interactive)
  (compile "tatr ls"))

(defun kam-tatr-summary ()
  (interactive)
  (compile "tatr summary"))

(provide 'kam-tatr)
;;; kam-tatr.el ends here
