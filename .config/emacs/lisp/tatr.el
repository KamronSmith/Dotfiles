;;; tatr.el --- Integrate Emacs and TATR -*- lexical-binding: t; -*-

;; Copyright (C) 2026 Kamron Smith <kamrosmith@gmail.com>

;; Author: Kamron Smith <kamrosmith@gmail.com>
;; Maintainer: Kamron Smith <kamrosmith@gmail.com>
;; URL: https://github.com
;; Version: 0.0.1
;; Package-Requires: ((emacs "29.1"))
;; Keywords: convenience, tools

;; This file is NOT part of GNU Emacs.

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;; Put a longer description of your package functionality here.
;; This text is displayed when users view your package info.

;;; Code:

(defgroup tatr nil
  "Integrate Emacs and TATR"
  :group 'programming
  :prefix "tatr-")

(defcustom tatr-default-priority 100
  "Default priority when creating new tasks."
  :type 'integer
  :group 'tatr)

(defcustom tatr-default-tags '("scope")
  "Default tags when creating a new task.

Either a string or a list of strings."
  :type  '(choice (string :tag "Single tag")
                  (list string))
  :group 'tatr)

(defcustom tatr-huid-regexp "^[0-9]\\{8\\}-[0-9]\\{6\\}$"
  "Regexp to match TATR HUIDs."
  :type 'string
  :group 'tatr)

(defun tatr-new-huid ()
  (format-time-string "%Y%m%d-%H%M%S" nil t))

(defun tatr-huid-p (huid)
  (when (string-match tatr-huid-regexp huid) t))

(defvar-local tatr-directory nil
  "Location of the tasks directory of the current buffer.")

(defun tatr--find-tatr-directory ()
  "Find the location of the TATR tasks directory."
  (expand-file-name "tasks" (locate-dominating-file default-directory "tasks/")))

(defvar tatr-title-history nil
  "Minibuffer history for TATR titles.")

(defun tatr-create-from-title (title)
  "Make a new task with TITLE."
  (interactive (list (read-string "Title for new task: "
                                  nil
                                  tatr-title-history)))
  ;; TODO: Figure out what to do with calling TATR
  (tatr-create title))

(defun tatr-create (title &optional huid)
  (if-let* ((db-dir (tatr--find-tatr-directory)))
      (if-let* ((huid (if huid huid (tatr-new-huid)))
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
                                           tatr-default-priority
                                           (mapconcat #'identity tatr-default-tags))))
              (write-region task-md-content nil task-md-path))))
    (user-error "ERROR: TATR directory was not found")))

(defun tatr-find-by-huid (huid)
  (interactive (list (if (region-active-p)
                         (buffer-substring-no-properties (region-beginning) (region-end))
                       (read-string "HUID: "))))
  (if-let ((db-dir (tatr--find-tatr-directory)))
      (if (tatr-huid-p huid)
          (if-let ((task-md-path (file-name-concat db-dir huid "TASK.md")))
              (if (file-regular-p task-md-path)
                  (find-file task-md-path)
                (user-error "Task %s was not found" huid)))
        (user-error "%s is not a valid HUID" huid))
    (user-error "TATR directory was not found")))

(defun tatr-insert-task-at-point (task)
  (interactive (list)))

(defun tam-tatr-insert-task-at-point--prompt ()
  (completing-read "Task: "
                   (kam-grep-list-of-strings "^# " nil (tatr--find-tatr-directory))))

(defun tatr--task-titles ()
  "Return a list of all the titles of the tasks as a list of strings."
  (let* ((unprocessed (kam-grep-list-of-strings "^#" "-I" (tatr--find-tatr-directory))))
    (mapcar (lambda (str)
              (string-remove-prefix "# " str))
            unprocessed)))
    
(defun tatr-list ()
  (interactive)
  (compile "tatr ls"))

(defun tatr-summary ()
  (interactive)
  (compile "tatr summary"))

(provide 'tatr)
;;; tatr.el ends here
