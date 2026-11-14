;;; kam-consult.el --- Extensions to consult.el -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:
(require 'consult)
(require 'org)
(require 'kam-common)
(require 'kam-org)
(require 'info)

(defgroup kam-consult ()
  "Extensions for `consult'."
  :group 'consult)

(defcustom kam-consult-ripgrep-or-line-limit 300000
  "Buffer size threshold for `kam-consult-ripgrep-or-line'.
When the number of characters in a buffer exceeds this threshold,
`consult-ripgrep' will be used instead of `consult-line'."
  :type 'integer)

(defvar kam-consult-source-neighbor-file
  `(:name     "File in current directory"
              :narrow   ?.
              :category 'file
              :face     consult-file
              :history  file-name-history
              :state    ,#'consult--file-state
              :new      ,#'consult--file-action
              :items
              ,(lambda ()
                 (let ((ht (consult--buffer-file-hash)) items)
                   (dolist (file (completion-pcm--filename-try-filter
                                  (directory-files "." 'full "\\`[^.]" nil 100))
                                 (nreverse items))
                     (unless (or (gethash file ht) (not (file-regular-p file)))
                       (push (file-name-nondirectory file) items))))))
  "Neighboring file source for `consult-buffer'.")

(defun kam-consult-imenu--select (prompt)
  "Return a selection from `consult-imenu'. using PROMPT."
  (let ((items (consult-imenu--items)))
    (consult-imenu--deduplicate items)
    (consult--read
     (or items (user-error "Imenu is empty"))
     :state
     (let* ((preview (consult--jump-preview)))
       `(lambda (action cand)
          (funcall ',preview action (and (markerp (cdr cand)) (cdr cand)))))
     :narrow
     (when-let* (narrow (consult-imenu--narrow))
       (list :predicate
             (lambda (cand)
               (eq (get-text-property 0 'consult-type (car cand))
                   consult--narrow))
             :keys narrow))
     :group (consult-imenu--group)
     :prompt prompt
     :require-match t
     :category 'imenu
     :history 'consult-imenu--history
     :add-history 'consult-imenu--history
     :lookup #'consult--lookup-cons
     :sort nil)))

(defmacro kam-consult-imenu--action (prompt &rest body)
  "Execute forms in BODY at the location of an `consult-imenu' selection.
PROMPT is the prompt of `consult-imenu'."
  `(let ((item (kam-consult-imenu--select ',prompt)))
     (pcase item
       (`(,name ,pos ,fn . ,args)
        (push-mark nil t)
        (apply fn name pos args))
       (`(,_ . ,pos)
        (save-excursion
          (consult--jump pos)
          ,@body))
       (_ (error "Unknown Imenu item: %S" item)))))

(defmacro kam-consult-org-heading--action (&rest body)
  "Execute forms in BODY at the location of an `consult-org-heading' selection."
  `(let* ((headings (consult-org-heading)))
     ,@body))

;;;###autoload
(defun kam-consult-org-heading-link ()
  "Insert a link at point to the location of an Org heading using minibuffer completion."
  (interactive)
  (save-excursion
    (kam-consult-org-heading--action (org-store-link nil t)))
  (kam-org-insert-last-stored-link-with-prompt))

(defun kam-consult-vertico--update-choose (&rest _)
  "Pick the nearest candidate rather than the first after updating candidates."
  (when (and kam-consult--previous-point
             (memq current-minibuffer-command
                   '(consult-org-heading consult-outline)))
    (setq vertico--index
          (max 0
               (1- (or (seq-position
                        vertico--candidates
                        kam-consult--previous-point
                        (lambda (cand point-pos)
                          (> (cl-case current-minibuffer-command
                               (consult-outline
                                (car (consult--get-location cand)))
                               (consult-org-heading
                                (get-text-property 0 'consult--candidate cand)))
                             point-pos)))
                       (length vertico--candidates)))))))

;;;###autoload
(defun kam-consult-ripgrep-or-line ()
  "Call `consult-line' for small buffers and `consult-ripgrep' for large files."
  (interactive)
  (if (or (not buffer-file-name)
          (buffer-narrowed-p)
          (ignore-errors
            (file-remote-p buffer-file-name))
          (jka-compr-get-compression-info buffer-file-name)
          (>= (buffer-size)
              (/ kam-consult-ripgrep-or-line-limit
                 (if (eq major-mode 'org-mode) 4 1))))
      (progn
        (let ((consult)))
        (consult-line)
        (setq this-command 'consult-line))
    (when (file-writable-p buffer-file-name)
      (save-buffer))
    (let ((consult-ripgrep-args
           (concat consult-ripgrep-args
                   " -g "
                   (shell-quote-argument (file-name-nondirectory buffer-file-name))
                   " ")))
      (consult-ripgrep))))

;;;###autoload
(defun kam-consult-line-symbol-at-point ()
  "Start a `consult-line' search with the symbol at point."
  (interactive)
  (consult-line
   (or (thing-at-point 'symbol))))

;;;###autoload
(defun kam-consult-isearch ()
  "Start a `consult-line' search within an Isearch session."
  (interactive)
  (consult-line isearch-string))

;;;###autoload
(defun kam-consult-ripgrep-symbol-at-point ()
  "Start a `consult-ripgrep' search with the symbol at point."
  (interactive)
  (let ((consult-ripgrep-command "rg --null --ignore-case --type txt --line-number . --color always --max-columns 500 --no-heading -e ARG OPTS"))
    (consult-ripgrep nil (thing-at-point 'symbol))))

;;;###autoload
(defun kam-consult-search-emacs-info-pages ()
  "Search through the Emacs info pages."
  (interactive)
  (consult-info "emacs" "efaq"))

;;;###autoload
(defun kam-consult-search-elisp-info-pages ()
  "Search through the Emacs Lisp pages."
  (interactive)
  (consult-info "elisp" "eintr"))

;;;###autoload
(defun kam-consult-search-org-info-pages ()
  "Search through the Org info pages."
  (interactive)
  (consult-info "org"))

;;;###autoload
(defun kam-consult-search-manual (manual)
  "Search through MANUAL, which is prompted for by `completing-read'."
  (interactive
   (list
    (progn
      (info-initialize)
      (completing-read "Manual name: "
                       (info--filter-manual-names
                        (info--manual-names current-prefix-arg))
                       nil t))))
  (consult-info manual))

(defun kam-consult--get-projects ()
  "Return an alist of project names and their corresponding directories."
  (let ((dirs))
    (dolist (dir (consult--project-known-roots))
      (push (cons (file-name-base (directory-file-name dir)) dir)
            dirs))
    dirs))

(defun kam-consult--project-dirs (list)
  "Return a list of project directories from LIST.
This function is intended to be used with `kam-consult--get-projects'."
  (let ((dirs))
    (dolist (dir list)
      (push (cdr dir) dirs))
    dirs))

(defvar kam-consult-search-ignored-dirs
  '("SCCS"
    "RCS"
    "CVS"
    "MCVS"
    ".src"
    ".svn"
    ".jj"
    ".git"
    ".hg"
    ".bzr"
    "_MTN"
    "_darcs"
    "{arch}"
    "node_modules"
    "build"
    "dist")
  "A list of directories to ignore when performing searches using Consult.")

(defvar kam-consult-source-project
  `( :name "Project"
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
     ,(lambda () (kam-consult--project-dirs (kam-consult--get-projects))))
  "Source for listing projects and their roots.")

(defvar kam-consult-source-bookmark
  `( :name     "Bookmark"
     :hidden   t
     :narrow   ?m
     :category bookmark
     :face     consult-bookmark
     :history  bookmark-history
     :items    ,#'bookmark-all-names
     :state    ,#'consult--bookmark-state)
  "Bookmark source for `consult-buffer'.
Hidden by default.")

(defvar kam-consult-source-recent-file
  `( :name     "Recent Files"
     ;; :hidden   t
     :narrow   ?r
     :category file
     :face     consult-file
     :history  file-name-history
     :state    ,#'consult--file-state
     :new      ,#'consult--file-action
     :enabled  ,(lambda () recentf-mode)
     :items
     ,(lambda ()
        (let ((ht (consult--buffer-file-hash))
              items)
          (dolist (file (bound-and-true-p recentf-list) (seq-take (nreverse items) 25))
            (unless (eq (aref file 0) ?/)
              (let (file-name-handler-alist) ;; No Tramp slowdown please.
                (setq file (expand-file-name file))))
            (unless (gethash file ht)
              (push (consult--fast-abbreviate-file-name file) items))))))
  "Recent file source for `consult-buffer'.
Copied from the Consult code but adjusted to only take the top 25 candidates.")

(defvar kam-consult-source-project-files
  `(:name "Project Files"
          :narrow ?f
          :hidden t
          :category file
          :face consult-file
          :history kam-consult-source-project-files-history
          ;; :state ,#'consult--file-state     creates new files before the action is completed
          :new ,#'consult--file-action
          :enabled ,(lambda () (kam-buffer-has-project-p (current-buffer)))
          :action ,(lambda (file)
                     (find-file (expand-file-name file (project-root (project-current nil)))))
          :items ,#'kam-project-files)
  "Project file source for `consult-buffer'.
This source is only enabled when the current buffer belongs to a project.")

(defvar kam-consult-source-project-files-history nil
  "Minibuffer history for `kam-consult-source-project-files'.")

(defvar kam-consult-source-dired-history
  `(:name "Dired History"
          :narrow ?d
          :category file
          :face consult-file
          :history kam-dired-directory-history
          :state ,#'consult--file-state
          :items (lambda () (mapcar #'identity kam-dired-directory-history))))

;;;###autoload
(defun kam-consult-project-imenu ()
  "Run `consult-imenu' for either the buffer or project."
  (interactive)
  (if (kam-buffer-has-project-p (current-buffer))
      (consult-imenu-multi)
    (consult-imenu)))

(provide 'kam-consult)
;;; kam-consult.el ends here
