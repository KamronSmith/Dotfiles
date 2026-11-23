;;; kam-writing.el --- -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:
(require 'kam-theme)
;; (require 'org)
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

(provide 'kam-writing)
;;; kam-writing.el ends here
