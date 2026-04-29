;; -*- lexical-binding: t; -*-

(require 'calibredb)

(use-package calibredb
  :commands (calibredb)
  :bind
  ("C-c b" . calibredb)
  (:map calibredb-search-mode-map
        ("n" . next-line)
        ("p" . previous-line))
  :config
  (setq calibredb-format-nerd-icons t
        calibredb-root-dir "~/Documents/Resources/Books"
        calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir)
        calibredb-library-alist '(("~/Documents/Resources/Books"))
        calibredb-sort-by 'title)

  (defun kam-calibredb-open-file-with-emacs (&optional candidate)
    "Open file with Emacs. Optional argument CANDIDATE is the selected item."
    (interactive "P")
    (unless candidate
      (setq candidate (car (calibredb-find-candidate-at-point))))
    (find-file (calibredb-get-file-path candidate t)))

  (defun kam-calibredb-search-books ()
    (interactive)
    (let ((consult-ripgrep-command "rg --null --ignore-case --type txt --line-number . --color always --max-columns 500 --no-heading -e ARG OPTS"))
      (consult-ripgrep calibredb-root-dir))))

(provide 'kam-calibredb)
;;; kam-calibredb.el ends here
