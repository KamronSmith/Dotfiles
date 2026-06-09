;;; kam-writing.el --- -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:
(require 'org)
(require 'tab-bar)
(require 'kam-theme)

(defun kam-org-insert-notes-drawer ()
  "Generate or open a NOTES drawer under the current heading.
If a drawer exists for this section, a new line is created at the end of
the current note."
  (interactive)
  (push-mark)
  (org-previous-visible-heading 1)
  (forward-line)
  (if (looking-at-p "^[ \t]*:NOTES:")
      (progn
        (org-fold-hide-drawer-toggle 'off)
        (re-search-forward "^[ \t]*:END:" nil t)
        (forward-line -1)
        (org-end-of-line)
        (org-return))
    (org-insert-drawer nil "NOTES")))

(define-minor-mode kam-writing-mode
  "My writing mode."
  :global nil
  (if kam-writing-mode
      (progn
        (visual-fill-column-mode -1)
        (logos-focus-mode 1)
        (tab-bar-mode -1)
        (kam-standard-themes-reload-theme)
        (hl-line-mode -1))
    (visual-fill-column-mode 1)
    (logos-focus-mode -1)
    (tab-bar-mode 1)
    (kam-standard-themes-reload-theme)
    (hl-line-mode 1)))

(provide 'kam-writing)
;;; kam-writing.el ends here
