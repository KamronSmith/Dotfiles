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


;;; Decolorify Mode
(define-minor-mode kam-decolorify-mode
  "Turn off the colors used in font lock highlighting.
The intended effect is a much less colorful typing and programming experience."
  :global t
  (if kam-decolorify-mode
      (kam-decolorify--turn-off-colors)
    (kam-decolorify--turn-on-colors)))

(defun kam-decolorify--turn-off-colors ()
  "Function to disable much of the colors used in syntax highlighting.
Please see `kam-decolorify-mode'."
  (standard-themes-with-colors
    (custom-set-faces
     `(font-lock-builtin-face ((,c :foreground ,fg-main :weight regular)))
     `(font-lock-constant-face ((,c :foreground ,fg-dim :weight regular)))
     `(font-lock-function-call-face ((,c :foreground ,fg-main :weight regular)))
     `(font-lock-function-name-face ((,c :foreground ,fg-main :weight regular)))
     `(font-lock-variable-use-face ((,c :foreground ,fg-main :weight regular)))
     `(font-lock-variable-name-face ((,c :foreground ,fg-main :weight regular)))
     `(font-lock-property-use-face ((,c :foreground ,fg-main :weight regular)))
     `(font-lock-property-name-face ((,c :foreground ,fg-main :weight regular)))
     `(font-lock-preprocessor-face ((,c :foreground ,fg-dim)))
     ;; `(font-lock-keyword-face ((,c :foreground ,cursor)))
     `(font-lock-type-face ((,c :foreground ,fg-dim))))))

(defun kam-decolorify--turn-on-colors ()
  "Function to reenable much of the colors used in syntax highlighting.
Please see `kam-decolorify-mode'."
  (standard-themes-with-colors
    (custom-set-faces
     `(font-lock-builtin-face ((,c :foreground ,builtin)))
     `(font-lock-constant-face ((,c :foreground ,constant)))
     `(font-lock-function-call-face ((,c :foreground ,fnname-call)))
     `(font-lock-function-name-face ((,c :foreground ,fnname)))
     `(font-lock-variable-use-face ((,c :foreground ,variable-use)))
     `(font-lock-variable-name-face ((,c :foreground ,variable)))
     `(font-lock-property-use-face ((,c :foreground ,property)))
     `(font-lock-property-name-face ((,c :foreground ,property)))
     `(font-lock-preprocessor-face ((,c :foreground ,preprocessor)))
     `(font-lock-type-face ((,c :foreground ,type))))))

(provide 'kam-theme)
;;; kam-theme.el ends here
