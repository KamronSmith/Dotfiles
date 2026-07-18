;;; kam-consult-tab.el --- Extensions to consult.el to manage tabs -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:
(require 'consult)
(require 'marginalia)

(defgroup kam-consult-tab ()
  "Extensions for `consult' to manage tabs."
  :group 'kam-consult)

(defcustom kam-consult-tab-icon "󰓩"
  "Icon to prefix tabs in `kam-consult-tab'."
  :type 'string
  :group 'kam-consult-tab)

(defvar kam-consult--tab-index-current-tab-name nil
  "The name of the current tab. Needed for marginalia annotations when previewing tabs.
Because we are changing the current window configuration when previewing tabs, we are
also changing the name of the current tab unless it's not an explicit name. To prevent
this, we can store the name of the current tab before calling consult command and use
this saved name in marginalia annotations of the current tab.")

(defvar kam-consult--tab-index-current-tab-bufs nil
  "List of current tab buffer names. Needed for marginalia annotations when previewing tabs.
Because we are changing the current window configuration when previewing tabs, we need to
save the current list of buffers displayed in windows before calling consult command and
use this saved list in marginalia annotations of the current tab.")

(defvar kam-consult-source-tab
  `( :name "Tabs"
     :narrow ?t
     :annotate ,'kam-marginalia-annotate-tab
     ;; :state ,#'kam-consult-tab--state
     :items
     ,(lambda ()
        (mapcar (lambda (tab) (concat kam-consult-tab-icon " " (alist-get 'name tab)))
                (tab-bar-tabs))))
  "Source for all tabs.")

(defvar kam-consult-source-project-tabs
  `( :name "Projects"
     :narrow ?p
     :category project-file
     :face consult-file
     :history file-name-history
     ;; :annotation ,#'marginalia-annotate-project-file
     ;; TODO 2026-07-18: When enabled this fucks up switching tabs
     ;; :state ,#'consult--file-state
     :action
     ,(lambda (proj)
        (project-switch-project proj))
     :items
     ,(lambda () (kam-consult-tab--project-dirs (kam-consult-tab--get-projects))))
  "Source for listing projects and their roots.
This source does not include projects that have a tab that contains
them.
As such, this source should not be used for listing all known project
root sources.
Please see `consult-source-project-root' instead.")

(defun kam-marginalia-annotate-tab (cand)
  "Annotate named tab CAND with a tab index, window, and buffer information."
  (when-let* ((tabs (funcall tab-bar-tabs-function))
              (index (seq-position
                      tabs nil
                      (lambda (tab _) (equal (alist-get 'name tab) (kam-consult-tab--string-deiconify cand))))))
    (let* ((tab (nth index tabs))
           (ws (alist-get 'ws tab))
           (bufs (window-state-buffers ws)))
      ;; When the buffer key is present in the window state it is added in front
      ;; of the window buffer list and gets duplicated.
      (when (cadr (assq 'buffer ws)) (pop bufs))
      (marginalia--fields
       (:left (1+ index) :format "(%s)" :face 'marginalia-key)
       ((if (eq (car tab) 'current-tab)
            (length (window-list nil 'no-minibuf))
          (length bufs))
        :format "win:%s" :face 'marginalia-size)
       ((or (alist-get 'group tab) 'none)
        :format "group:%s" :face 'marginalia-type :truncate 20)
       ((if (eq (car tab) 'current-tab)
            "(current tab)"
          (string-join bufs " "))
        :face 'marginalia-documentation)))))

(defun kam-consult-tab--state ()
  "Preview function for `kam-consult-tab'."
  (let ((orig-wc (current-window-configuration)))
    (lambda (action cand)
      (if (eq action 'exit)
          (set-window-configuration orig-wc nil t)
        (when cand
          (set-window-configuration
           (alist-get 'wc (nth (tab-bar--tab-index-by-name cand)
                               (tab-bar-tabs))
                      ;; default to original wc if
                      ;; there is no tab wc (usually current tab)
                      orig-wc)
           nil t))))))

(defun kam-consult-tab--string-deiconify (str)
  "Return a version of STR without any icons or whitespace, just ASCII."
  (string-trim (string-remove-prefix kam-consult-tab-icon str)))

(defun kam-consult-tab--get-projects ()
  "Return an alist of project names and their corresponding directories.
If there is a tab that contains a project among the known project list,
it will not be included in the list."
  (let ((dirs))
    (dolist (dir (consult--project-known-roots))
      (unless (seq-contains-p (kam-consult-tab--tab-names) (file-name-base (directory-file-name dir)))
        (push (cons (file-name-base (directory-file-name dir)) dir)
              dirs)))
    dirs))

(defun kam-consult-tab--project-names (list)
  "Return a list of project names from LIST.
This function is intended to be used with `kam-consult-tab--get-projects'."
  (let ((dirs))
    (dolist (dir list)
      (push (car dir) dirs))
    dirs))

(defun kam-consult-tab--project-dirs (list)
  "Return a list of project directories from LIST.
This function is intended to be used with `kam-consult-tab--get-projects'."
  (let ((dirs))
    (dolist (dir list)
      (push (cdr dir) dirs))
    dirs))

(defun kam-consult-tab--tab-names ()
  "Return a list of tab names from TAB-LIST.
This function is intended to be used with `kam-consult-tab--get-projects'."
  (let ((tabs))
    (dolist (tab (tab-bar-tabs))
      (push (alist-get 'name tab) tabs))
    tabs))

(defun kam-consult-tab--prompt ()
  "Prompt for tab selection and return the name of the selected candidate as a string."
  (let ((marginalia-align-offset 15)
        (kam-consult--tab-index-current-tab-name (alist-get 'name (tab-bar--current-tab)))
        (kam-consult--tab-index-current-tab-bufs (mapcar #'buffer-name
                                                         (mapcar #'window-buffer
                                                                 (window-list)))))
    (car (consult--multi '(kam-consult-source-tab kam-consult-source-project-tabs)
                         ;; disable sorting
                         :sort nil
                         :require-match t))))

;;;###autoload
(defun kam-consult-tab (&optional arg)
  "Select tab and switch to it, with completion enhanced by `completing-read'.
With optional ARG, switch to that tab's absolute position."
  (interactive "P")
  (if arg
      (tab-bar-select-tab arg)
    (tab-bar-switch-to-tab (file-name-base (directory-file-name
                                            (kam-consult-tab--string-deiconify (kam-consult-tab--prompt)))))))

(provide 'kam-consult-tab)
;;; kam-consult-tab.el ends here
