;;; kam-theme.el --- -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:
(require 'kam-common)
(require 'spacious-padding)
;;; Spacious-padding extensions

(define-minor-mode kam-spacious-padding-subtle-mode-line-mode
  "Toggle the `spacious-padding-subtle-frame-lines' variable."
  :global t
  (if kam-spacious-padding-subtle-mode-line-mode
      (progn
        (setq spacious-padding-subtle-frame-lines
              '(:mode-line-active spacious-padding-line-active
                                  :mode-line-inactive spacious-padding-line-inactive
                                  :header-line-active spacious-padding-line-active
                                  :header-line-inactive spacious-padding-line-inactive))
        (kam-reload-mode 'spacious-padding-mode))
    (setq spacious-padding-subtle-frame-lines nil)
    (kam-reload-mode 'spacious-padding-mode)))

(provide 'kam-theme)
;;; kam-theme.el ends here
