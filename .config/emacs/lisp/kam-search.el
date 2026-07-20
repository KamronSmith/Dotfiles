;;; kam-search.el --- -*- lexical-binding: t; -*-
;;; Summary:

;;; Commentary:

;;; Code:
(require 'consult)
(require 'isearch)
(require 'replace)
(require 'grep)

(defgroup kam-search ()
  "Extensions and functions related to searching."
  :group 'search)

(defcustom kam-search-outline-regexp-alist
  '((emacs-lisp-mode . "^\\((\\|;;;+ \\)")
    (org-mode . "^\\(\\*+ +\\|#\\+[Tt][Ii][Tt][Ll][Ee]:\\)"))
  "Alist of regular expressions per major mode.
To be used by `kam-occur-outline'."
  :type 'alist
  :group 'kam-search)

(defcustom kam-search-comment-keywords
  "TODO\\|FIXME\\|NOTE\\|REVIEW"
  "Regular expression that matches all the keywords in `kam-comment-keywords'."
  :type 'string
  :group 'kam-search)

(defun kam-consult-line-comment-keywords ()
  "Start a `consult-line' session with `kam-comment-keywords'."
  (interactive)
  (consult-line kam-search-comment-keywords))

;;;###autoload
(defun kam-search-occur-buffer-todo-keywords (&optional context)
  "Produce Occur buffer with `kam-search-todo-keywords'.
With optional CONTEXT, specify how many lines of context you want the
Occur search to include."
  (interactive "P")
  (let* ((case-fold-search nil)
         (num (cond
               (current-prefix-arg
                (prefix-numeric-value current-prefix-arg))
               (t (if (natnump context) context 0))))
         (bufname (format "*keywords in <%s>*" (buffer-name))))
    (occur-1 kam-search-todo-keywords num (list (current-buffer)) bufname)))

(defun kam-project-grep (command-args)
  "Perform a `grep' search for COMMAND-ARGS starting from the project root directory."
  (interactive (progn
                 (grep-compute-defaults)
                 (let ((default (grep-default-command)))
                   (list (read-shell-command
                          "Run grep (like this): "
                          (if current-prefix-arg
                              default
                            (if grep-command-position
                                (cons grep-command grep-command-position)
                              grep-command))
                          'grep-history
                          (if current-prefix-arg nil default))))))
  (let* ((proj (project-current t))
         (proj-root (project-root proj))
         (default-directory proj-root))
    (grep command-args)))

(provide 'kam-search)
;;; kam-search.el ends here
