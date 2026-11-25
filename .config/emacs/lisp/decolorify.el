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

(defmacro decolorify-turn-off-color (cookie font-lock-face color)
  `(progn (setq ,cookie (face-remap-add-relative ',font-lock-face :foreground (modus-themes-get-color-value ',color)))
          (push ,cookie decolorify-cookies)))

(defun decolorify--turn-off-colors ()
  "Turn off the colors."
  (decolorify-turn-off-color decolorify--builtin-cookie font-lock-builtin-face fg-dim)
  (decolorify-turn-off-color decolorify--constant-cookie font-lock-constant-face fg-dim)
  (decolorify-turn-off-color decolorify--function-call-cookie font-lock-function-call-face fg-main)
  (decolorify-turn-off-color decolorify--function-name-cookie font-lock-function-name-face fg-main)
  (decolorify-turn-off-color decolorify--variable-use-cookie font-lock-variable-use-face fg-main)
  (decolorify-turn-off-color decolorify--variable-name-cookie font-lock-variable-name-face fg-main)
  (decolorify-turn-off-color decolorify--property-use-cookie font-lock-property-use-face fg-main)
  (decolorify-turn-off-color decolorify--property-name-cookie font-lock-property-name-face fg-main)
  (decolorify-turn-off-color decolorify--preprocessor-cookie font-lock-preprocessor-face fg-dim)
  (decolorify-turn-off-color decolorify--keyword-cookie font-lock-keyword-face fg-dim)
  (decolorify-turn-off-color decolorify--type-cookie font-lock-type-face fg-dim)
  (decolorify-turn-off-color decolorify--heading-0-cookie modus-themes-heading-0 fg-main)
  (decolorify-turn-off-color decolorify--heading-1-cookie modus-themes-heading-1 fg-main)
  (decolorify-turn-off-color decolorify--heading-2-cookie modus-themes-heading-2 fg-main)
  (decolorify-turn-off-color decolorify--heading-3-cookie modus-themes-heading-3 fg-main)
  (decolorify-turn-off-color decolorify--heading-4-cookie modus-themes-heading-4 fg-main))

(defun decolorify--turn-on-colors ()
  "Turn on the colors, or in other words, disable `decolorify-cookies'."
  (dolist (cookie decolorify-cookies)
    (face-remap-remove-relative cookie)
    (setq cookie nil))
  (setq decolorify-cookies nil))

(provide 'decolorify)
;;; decolorify.el ends here
