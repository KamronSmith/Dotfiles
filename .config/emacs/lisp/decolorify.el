;;; decolorify.el --- -*- lexical-binding: t; -*-
;;; Summary:

;;; Commentary:

;;; Code:
(require 'face-remap)
(require 'standard-themes)

(defgroup decolorify ()
  "Turn off the colors used in font lock highlighting in all buffers."
  :group 'convenience)

(defcustom decolorify-faces
  '((font-lock-builtin-face . (:color fg-dim))
    (font-lock-constant-face . (:color fg-dim))
    (font-lock-function-call-face . (:color fg-main))
    (font-lock-function-name-face . (:color fg-main))
    (font-lock-variable-use-face . (:color fg-main))
    (font-lock-variable-name-face . (:color fg-main))
    (font-lock-property-use-face . (:color fg-main))
    (font-lock-property-name-face . (:color fg-main))
    (font-lock-preprocessor-face . (:color fg-main))
    (font-lock-keyword-face . (:color fg-main :weight regular))
    (font-lock-type-face . (:color fg-main)))
  "Alist of faces that decolorify should turn off."
  :type '(alist :key-type symbol :value-type (plist :key-type symbol :value-type symbol))
  :group 'decolorify)

(defvar-local decolorify-cookies nil)

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

(defun decolorify--turn-off-color (face color weight)
  (setq cookie (face-remap-add-relative face
                                        :foreground (modus-themes-get-color-value `,color)
                                        :weight `,weight))
  (push cookie decolorify-cookies))

(defun decolorify--turn-off-colors ()
  "Turn off the colors."
  (dolist (face decolorify-faces)
    (let* ((face-name (car face))
           (color (plist-get (cdr face) :color))
           (weight (plist-get (cdr face) :weight)))
      (decolorify--turn-off-color face-name
                                  color
                                  weight))))


(defun decolorify--setup ()
  "Setup function for `decolorify-mode'."
  (decolorify--turn-off-colors))

(defun decolorify--teardown ()
  "Teardown function for `decolorify-mode'."
  (dolist (cookie decolorify-cookies)
    (face-remap-remove-relative cookie))
  (setq-local decolorify-cookies nil))

(define-minor-mode decolorify-mode
  "Turn off the colors used in font lock highlighting.
The intended effect is a much less colorful typing and programming experience."
  :global nil
  :init-value nil
  (if decolorify-mode
      (decolorify--setup)
    (decolorify--teardown)))

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

(provide 'decolorify)
;;; decolorify.el ends here
