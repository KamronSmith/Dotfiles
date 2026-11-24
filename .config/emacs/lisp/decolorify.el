;;; decolorify.el --- -*- lexical-binding: t; -*-
;;; Summary:

;;; Commentary:

;;; Code:
(require 'face-remap)
(require 'standard-themes)

(defgroup decolorify ()
  "Turn off the colors used in font lock highlighting in all buffers."
  :group 'convenience)

(defvar-local decolorify--bg-main-cookie nil)

(defvar-local decolorify--builtin-cookie nil)

(defvar-local decolorify--constant-cookie nil)

(defvar-local decolorify--function-call-cookie nil)

(defvar-local decolorify--function-name-cookie nil)

(defvar-local decolorify--variable-use-cookie nil)

(defvar-local decolorify--variable-name-cookie nil)

(defvar-local decolorify--property-use-cookie nil)

(defvar-local decolorify--property-name-cookie nil)

(defvar-local decolorify--preprocessor-cookie nil)

(defvar-local decolorify--type-cookie nil)

(defvar-local decolorify--keyword-cookie nil)

(defvar-local decolorify--heading-0-cookie nil)

(defvar-local decolorify--heading-1-cookie nil)

(defvar-local decolorify--heading-2-cookie nil)

(defvar-local decolorify--heading-3-cookie nil)

(defvar-local decolorify--heading-4-cookie nil)

(defvar-local decolorify-cookies nil
  "List of all `decolorify-mode' cookies.")

(defun decolorify--buffer-hidden-p (buf)
  "Return non-nil if BUF is hidden."
  (string-prefix-p " " (buffer-name buf)))

(defun decolorify--non-hidden-buffers ()
  "Return a list of all buffers that are not hidden."
  (seq-remove (lambda (buf) (decolorify--buffer-hidden-p buf))
              (buffer-list)))

(defun decolorify--mode-disable (buffer)
  "Disable `decolorify-mode' in BUFFER."
  (with-current-buffer buffer
    (decolorify-mode -1)))

(defun decolorify--mode-enable (buffer)
  "Enable `decolorify-mode' in BUFFER."
  (with-current-buffer buffer
    (decolorify-mode 1)))

(define-minor-mode decolorify-mode
  "Turn off the colors used in font lock highlighting.
The intended effect is a much less colorful typing and programming experience."
  :global nil
  :init-value nil
  (if decolorify-mode
      (decolorify--turn-off-colors)
    (decolorify--turn-on-colors)))

(define-minor-mode global-decolorify-mode
  "Turn off the colors used in font lock highlighting in all buffers.
The intended effect is a much less colorful typing and programming experience."
  :global nil
  :init-value nil
  (if global-decolorify-mode
      (mapc (lambda (buf)
              (decolorify--mode-enable buf))
            (decolorify--non-hidden-buffers))
    (mapc (lambda (buf)
            (decolorify--mode-disable buf))
          (decolorify--non-hidden-buffers))))

(defun decolorify--turn-off-colors ()
  "Turn off the colors."
  (standard-themes-with-colors
    (setq decolorify--builtin-cookie (face-remap-add-relative 'font-lock-type-face :foreground fg-dim))
    (push decolorify--builtin-cookie decolorify-cookies)
    (setq decolorify--constant-cookie (face-remap-add-relative 'font-lock-constant-face :foreground fg-dim))
    (push decolorify--constant-cookie decolorify-cookies)
    (setq decolorify--function-call-cookie (face-remap-add-relative 'font-lock-function-call-face :foreground fg-main))
    (push decolorify--function-call-cookie decolorify-cookies)
    (setq decolorify--function-name-cookie (face-remap-add-relative 'font-lock-function-name-face :foreground fg-main))
    (push decolorify--function-name-cookie decolorify-cookies)
    (setq decolorify--variable-use-cookie (face-remap-add-relative 'font-lock-variable-use-face :foreground fg-main))
    (push decolorify--variable-use-cookie decolorify-cookies)
    (setq decolorify--variable-name-cookie (face-remap-add-relative 'font-lock-variable-name-face :foreground fg-main))
    (push decolorify--variable-name-cookie decolorify-cookies)
    (setq decolorify--property-use-cookie (face-remap-add-relative 'font-lock-property-use-face :foreground fg-main))
    (push decolorify--property-use-cookie decolorify-cookies)
    (setq decolorify--property-name-cookie (face-remap-add-relative 'font-lock-property-name-face :foreground fg-main))
    (push decolorify--property-name-cookie decolorify-cookies)
    (setq decolorify--preprocessor-cookie (face-remap-add-relative 'font-lock-preprocessor-face :foreground fg-dim))
    (push decolorify--preprocessor-cookie decolorify-cookies)
    (setq decolorify--keyword-cookie (face-remap-add-relative 'font-lock-keyword-face :foreground fg-main :weight 'regular))
    (push decolorify--keyword-cookie decolorify-cookies)
    (setq decolorify--type-cookie (face-remap-add-relative 'font-lock-type-face :foreground keyword :weight 'regular))
    (push decolorify--type-cookie decolorify-cookies)
    (setq decolorify--heading-0-cookie (face-remap-add-relative 'modus-themes-heading-0 :foreground fg-main))
    (push decolorify--heading-0-cookie decolorify-cookies)
    (setq decolorify--heading-1-cookie (face-remap-add-relative 'modus-themes-heading-1 :foreground fg-main))
    (push decolorify--heading-1-cookie decolorify-cookies)
    (setq decolorify--heading-2-cookie (face-remap-add-relative 'modus-themes-heading-2 :foreground fg-main))
    (push decolorify--heading-2-cookie decolorify-cookies)
    (setq decolorify--heading-3-cookie (face-remap-add-relative 'modus-themes-heading-3 :foreground fg-main))
    (push decolorify--heading-3-cookie decolorify-cookies)
    (setq decolorify--heading-4-cookie (face-remap-add-relative 'modus-themes-heading-4 :foreground fg-main))
    (push decolorify--heading-4-cookie decolorify-cookies)))

(defun decolorify--turn-on-colors ()
  "Turn on the colors, or in other words, disable `decolorify-cookies'."
  (dolist (cookie decolorify-cookies)
    (face-remap-remove-relative cookie)
    (setq cookie nil))
  (setq decolorify-cookies nil))

(provide 'decolorify)
;;; decolorify.el ends here
