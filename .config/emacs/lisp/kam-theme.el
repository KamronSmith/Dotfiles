;;; kam-theme.el --- -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:

(require 'kam-common)
(require 'spacious-padding)
(require 'standard-themes)

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

;;; Standard Themes

(defvar kam-favorite-themes
  '(standard-dark
    standard-light
    standard-light-tinted
    ef-day)
  "A list of themes that I like.")

(defun kam-standard-themes-reload-theme ()
  "Reload the current Standard theme."
  (interactive)
  (standard-themes-load-theme (modus-themes-get-current-theme)))

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

(defvar kam-favorite-fonts
  '(("Aporetic Sans Mono" . 140)
    ("Iosevka" . 140)
    ("IBM Plex Mono" . 130))
  "List of my favorite fonts and their font sizes.")

(defun kam-load-font (font)
  "Choose a font from `kam-favorite-fonts'."
  (interactive (list (completing-read
                      "Font to load: "
                      kam-favorite-fonts)))
  (let* ((font-size (cdr (assoc font kam-favorite-fonts))))
    (set-face-attribute 'default nil :font font :height font-size :weight 'regular :width 'regular)
    (set-face-attribute 'fixed-pitch nil :font font :height 1.0 :weight 'regular :width 'regular)))

;;; Decolorify Mode
(defvar-local kam-decolorify--bg-main-cookie nil)

(defvar-local kam-decolorify--builtin-cookie nil)

(defvar-local kam-decolorify--constant-cookie nil)

(defvar-local kam-decolorify--function-call-cookie nil)

(defvar-local kam-decolorify--function-name-cookie nil)

(defvar-local kam-decolorify--variable-use-cookie nil)

(defvar-local kam-decolorify--variable-name-cookie nil)

(defvar-local kam-decolorify--property-use-cookie nil)

(defvar-local kam-decolorify--property-name-cookie nil)

(defvar-local kam-decolorify--preprocessor-cookie nil)

(defvar-local kam-decolorify--type-cookie nil)

(defvar-local kam-decolorify--keyword-cookie nil)

(defvar-local kam-decolorify-cookies nil
  "List of all `kam-decolorify-mode' cookies")

(define-minor-mode kam-decolorify-mode
  "Turn off the colors used in font lock highlighting.
The intended effect is a much less colorful typing and programming experience."
  :global nil
  :init-value nil
  (if kam-decolorify-mode
      (kam-decolorify--turn-off-colors)
    (kam-decolorify--turn-on-colors)))

(define-minor-mode kam-global-decolorify-mode
  "Turn off the colors used in font lock highlighting in all buffers.
The intended effect is a much less colorful typing and programming experience."
  :global nil
  :init-value nil
  (if kam-global-decolorify-mode
      (seq-remove #'kam-buffer-hidden-p (buffer-list))))

(defun kam-decolorify--turn-off-colors ()
  "Turn off the colors."
  (standard-themes-with-colors
    (setq kam-decolorify--builtin-cookie (face-remap-add-relative 'font-lock-type-face :foreground fg-dim))
    (push kam-decolorify--builtin-cookie kam-decolorify-cookies)
    (setq kam-decolorify--constant-cookie (face-remap-add-relative 'font-lock-constant-face :foreground fg-dim))
    (push kam-decolorify--constant-cookie kam-decolorify-cookies)
    (setq kam-decolorify--function-call-cookie (face-remap-add-relative 'font-lock-function-call-face :foreground fg-main))
    (push kam-decolorify--function-call-cookie kam-decolorify-cookies)
    (setq kam-decolorify--function-name-cookie (face-remap-add-relative 'font-lock-function-name-face :foreground fg-main))
    (push kam-decolorify--function-name-cookie kam-decolorify-cookies)
    (setq kam-decolorify--variable-use-cookie (face-remap-add-relative 'font-lock-variable-use-face :foreground fg-main))
    (push kam-decolorify--variable-use-cookie kam-decolorify-cookies)
    (setq kam-decolorify--variable-name-cookie (face-remap-add-relative 'font-lock-variable-name-face :foreground fg-main))
    (push kam-decolorify--variable-name-cookie kam-decolorify-cookies)
    (setq kam-decolorify--property-use-cookie (face-remap-add-relative 'font-lock-property-use-face :foreground fg-main))
    (push kam-decolorify--property-use-cookie kam-decolorify-cookies)
    (setq kam-decolorify--property-name-cookie (face-remap-add-relative 'font-lock-property-name-face :foreground fg-main))
    (push kam-decolorify--property-name-cookie kam-decolorify-cookies)
    (setq kam-decolorify--preprocessor-cookie (face-remap-add-relative 'font-lock-preprocessor-face :foreground fg-dim))
    (push kam-decolorify--preprocessor-cookie kam-decolorify-cookies)
    (setq kam-decolorify--keyword-cookie (face-remap-add-relative 'font-lock-keyword-face :foreground fg-main :weight 'regular))
    (push kam-decolorify--keyword-cookie kam-decolorify-cookies)
    (setq kam-decolorify--type-cookie (face-remap-add-relative 'font-lock-type-face :foreground keyword :weight 'regular))
    (push kam-decolorify--type-cookie kam-decolorify-cookies)))

(defun kam-decolorify--turn-on-colors ()
  "Turn on the colors."
  (dolist (cookie kam-decolorify-cookies)
    (face-remap-remove-relative cookie)
    (setq cookie nil))
  (setq kam-decolorify-cookies nil))

;;; text scale
(defvar kam-text-scale-adjust-history nil
  "Minibuffer history for `kam-text-scale-adjust'.")

(defun kam-text-scale-adjust--prompt ()
  "Prompt for `kam-text-scale-adjust'."
  (let ((default (car kam-text-scale-adjust-history)))
    (read-number (format-prompt "Scale to adjust to"
                                default)
                 (- (string-to-number default))
                 'kam-text-scale-adjust-history)))

(defun kam-text-scale-adjust (increment)
  "Adjust the text scale.
INCREMENT should be a number."
  (interactive (list (kam-text-scale-adjust--prompt)))
  (text-scale-adjust increment))

(advice-add #'kam-text-scale-adjust :around #'kam-call-function-quietly)

(define-minor-mode kam-old-mode
  "Turn Emacs into an old application."
  :global t
  (if kam-old-mode
      (progn
        (menu-bar-mode 1)
        (tool-bar-mode 1))
    (menu-bar-mode -1)
    (tool-bar-mode -1)))

(define-minor-mode kam-documentation-mode
  "Minor mode for buffers that display documentation."
  :global nil
  (if kam-documentation-mode
      (progn
        (face-remap-add-relative 'default :family "IBM Plex Mono" :height 130 :width 'regular)
        (hide-cursor-mode 1))
    (hide-cursor-mode -1)))

(provide 'kam-theme)
;;; kam-theme.el ends here
