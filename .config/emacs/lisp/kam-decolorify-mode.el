;; -*- lexical-binding: t; -*-

(require 'standard-themes)

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
     `(font-lock-constant-face ((,c :foreground ,fg-main :weight regular)))
     `(font-lock-function-call-face ((,c :foreground ,fg-main :weight regular)))
     `(font-lock-function-name-face ((,c :foreground ,fnname :weight regular)))
     `(font-lock-variable-use-face ((,c :foreground ,fg-main :weight regular)))
     `(font-lock-variable-name-face ((,c :foreground ,fg-main :weight regular)))
     `(font-lock-property-use-face ((,c :foreground ,fg-main :weight regular)))
     `(font-lock-property-name-face ((,c :foreground ,fg-main :weight regular)))
     `(font-lock-preprocessor-face ((,c :foreground ,fg-main)))
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
