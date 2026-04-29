;; -*- lexical-binding: t; -*-

(require 'standard-themes)

(define-minor-mode old-mode
  "Turn Emacs into an old application."
  :global t
  (if kam-old-mode
      (progn
        (menu-bar-mode 1)
        (tool-bar-mode 1))
    (menu-bar-mode -1)
    (tool-bar-mode -1)))

(standard-themes-with-colors
  (custom-set-faces
   `(menu ((,c :foreground "#505050" :background "#505050")))
   `(tool-bar ((,c :foreground "#505050" :background "#505050")))))

(provide 'old-mode)
;;; old-mode.el ends here
