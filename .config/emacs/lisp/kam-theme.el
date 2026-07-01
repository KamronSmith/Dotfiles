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

(defvar kam-favorite-themes
  '(standard-dark
    standard-light
    standard-light-tinted
    ef-day)
  "A list of themes that I like.")

(defun kam-load-theme ()
  "Load a theme that I like.
See `kam-favorite-themes'."
  (interactive)
  (standard-themes-load-theme
   (intern (completing-read
            "Theme to load: "
            kam-favorite-themes))))

(defvar kam-theme-face-change-functions
  '(kam-notes-set-custom-faces
    kam-set-custom-faces
    kam-org-set-custom-faces
    kam-olivetti-update-fringe-color
    kam-hl-line-set-custom-faces)
  "List of functions that update faces across the configuration.
See `kam-theme-update-custom-faces'.")

(defun kam-theme-update-custom-faces ()
  "Function to update faces on theme change."
  (dolist (func kam-theme-face-change-functions)
    (funcall func))
  (when kam-decolorify-mode
    (kam-decolorify--turn-off-colors)))

(provide 'kam-theme)
;;; kam-theme.el ends here
