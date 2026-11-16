;;; kam-search.el --- -*- lexical-binding: t; -*-
;;; Summary:

;;; Commentary:

;;; Code:
(require 'consult)
(require 'isearch)
(require 'replace)
(require 'grep)
(require 'kam-window)
(require 'project)
(require 'hide-cursor-mode)

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

(defun kam-grep-mode-setup ()
  "Setup function for `grep-mode'."
  (hide-cursor-mode 1)
  (hl-line-mode 1))

(defun kam-grep-edit-mode-setup ()
  "Setup function for `grep-edit-mode'."
  (hide-cursor-mode -1)
  (hl-line-mode -1))

(defun kam-occur-mode-setup ()
  "Setup function for `occur-mode'."
  (hide-cursor-mode 1)
  (hl-line-mode 1))

(defun kam-occur-edit-mode-setup ()
  "Setup function for `occur-edit-mode'."
  (hide-cursor-mode -1)
  (hl-line-mode -1))

(defun kam-get-buffers-matching-mode (mode)
  "Returns a list of the buffers where their major-mode is equal to MODE."
  (let ((buffer-mode-matches '()))
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (eq mode major-mode)
          (push buf buffer-mode-matches))))
    buffer-mode-matches))

;;;###autoload
(defun kam-multi-occur-in-this-mode ()
  "Show all lines matching REGEXP in buffers with the current buffer's major-mode."
  (interactive)
  (multi-occur
   (kam-get-buffers-matching-mode major-mode)
   (car (occur-read-primary-args))))

;;;###autoload
(defun kam-grep-symbol-at-point ()
  "Start a `grep' search for the symbol at point.
If the current buffer belongs to a project, run the grep command in the
project directory."
  (interactive)
  (let* ((sym (thing-at-point 'symbol t))
         (command (concat grep-command sym))
         (default-directory (or (when (kam-buffer-has-project-p (current-buffer))
                                  (project-root (project-current)))
                                default-directory)))
    (grep command)))

;;;###autoload
(defun kam-consult-line-comment-keywords ()
  "Start a `consult-line' session with `kam-comment-keywords'."
  (interactive)
  (consult-line kam-search-comment-keywords))

;;;###autoload
(defun kam-occur-todo-keywords (&optional context)
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

;;;###autoload
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

(defun kam-grep-list-of-strings (regexp &optional grep-args directory)
  "Return a list of grep results as a list of strings using REGEXP.
GREP-ARGS is a string to pass to ripgrep, and DIRECTORY is the directory
where to run the command."
  (let* ((default-directory (if directory directory default-directory))
         (output (shell-command-to-string (concat
                                           "rg"
                                           " "
                                           grep-args
                                           " "
                                           regexp)))
         (strings (split-string output "\n" t)))
    strings))

;;;###autoload
(defun kam-compile-goto-error ()
  "Like `compile-goto-error' but does not split the window."
  (interactive)
  (let ((split-window-preferred-function #'kam-no-split-window)
        (display-buffer-overriding-action '(kam-display-buffer-in-mru-window)))
    (compile-goto-error)))

;;;###autoload
(defun kam-next-error-no-select (&optional n)
  "Like `next-error-no-select' but will not split the window.
Additionally, it will also always only use the currently selected window."
  (interactive)
  (let ((split-window-preferred-function #'kam-no-split-window)
        (display-buffer-base-action '(kam-display-buffer-in-mru-window)))
    (next-error-no-select n)))

;;;###autoload
(defun kam-previous-error-no-select (&optional n)
  "Like `previous-error-no-select' but will not split the window.
Additionally, it will always only use the currently selected window."
  (interactive)
  (let ((split-window-preferred-function #'kam-no-split-window)
        (display-buffer-base-action '(kam-display-buffer-in-mru-window)))
    (previous-error-no-select n)))

(provide 'kam-search)
;;; kam-search.el ends here
