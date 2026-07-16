;;; kam-writing.el --- -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:
(require 'kam-theme)
(require 'org)
(require 'tab-bar)
(require 'logos)
(require 'visual-fill-column)

(define-minor-mode kam-writing-mode
  "My writing mode."
  :global nil
  (if kam-writing-mode
      (progn
        (visual-fill-column-mode -1)
        (logos-focus-mode 1)
        (kam-standard-themes-reload-theme)
        (hl-line-mode -1))
    (visual-fill-column-mode 1)
    (logos-focus-mode -1)
    (kam-standard-themes-reload-theme)
    (hl-line-mode 1)))

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

(provide 'kam-writing)
;;; kam-writing.el ends here
