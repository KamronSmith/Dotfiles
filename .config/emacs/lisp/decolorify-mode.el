;; -*- lexical-binding: t; -*-

(require 'standard-themes)

(define-minor-mode decolorify-mode
  "Turn off the colors."
  :global t
  (if kam-decolorify-mode
      ()
    (kam-standard-themes-reload-theme)))

(provide 'decolorify-mode)
;;; decolorify-mode.el ends here
