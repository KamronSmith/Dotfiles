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

(defvar kam-favorite-themes
  '(standard-dark
    standard-light
    standard-light-tinted
    ef-day)
  "A list of themes that I like.")

;;;###autoload
(defun kam-standard-themes-reload-theme ()
  "Reload the current Standard theme."
  (interactive)
  (standard-themes-load-theme (modus-themes-get-current-theme)))

;;;###autoload
(defun kam-load-theme ()
  "Load a theme that I like.
See `kam-favorite-themes'."
  (interactive)
  (standard-themes-load-theme
   (intern (completing-read
            "Theme to load: "
            kam-favorite-themes))))

(defvar kam-theme-face-change-functions
  '(kam-denote-custom-faces-setup
    kam-standard-themes-custom-faces-setup
    kam-olivetti-custom-faces-setup
    kam-hl-line-custom-faces-setup
    kam-org-custom-faces-setup)
  "List of functions that update faces across the configuration.
See `kam-theme-update-custom-faces'.")

(defun kam-theme-update-custom-faces ()
  "Function to update faces on theme change."
  (dolist (func kam-theme-face-change-functions)
    (funcall func))
  (when kam-decolorify-mode
    (kam-decolorify--turn-off-colors)))

(defun kam-standard-themes-custom-faces-setup ()
  "Set up custom faces with `standard-themes'."
  (standard-themes-with-colors
    (custom-set-faces
     `(region ((,c :extend t)))
     `(fringe ((,c :background ,bg-main)))
     `(modus-themes-button ((,c :inherit fixed-pitch))))))

(defun kam-olivetti-custom-faces-setup ()
  "Set up custom `olivetti' faces with `standard-themes'."
  (standard-themes-with-colors
    (custom-set-faces
     `(olivetti-fringe ((,c :background ,bg-main))))))

(defun kam-hl-line-custom-faces-setup ()
  "Set up custom `hl-line-mode' faces with `standard-themes'."
  (standard-themes-with-colors
    (custom-set-faces
     `(hl-line ((,c :background ,bg-dim)))
     `(hl-line-nonselected ((,c :background ,bg-main))))))

;;; fonts
(defvar kam-favorite-fonts
  '(("Aporetic Sans Mono" . 150)
    ("Iosevka" . 160)
    ("IBM Plex Mono" . 140)
    ("JetBrains Mono" . 140))
  "Alist of my favorite fonts and their font sizes.")

;;;###autoload
(defun kam-load-font (font)
  "Choose a font from `kam-favorite-fonts'."
  (interactive (list (completing-read
                      "Load font: "
                      kam-favorite-fonts)))
  (let* ((font-size (cdr (assoc font kam-favorite-fonts))))
    (set-face-attribute 'default nil :font font :height font-size :weight 'regular :width 'regular)
    (set-face-attribute 'fixed-pitch nil :font font :height 1.0 :weight 'regular :width 'regular)))

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

;;;###autoload
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
