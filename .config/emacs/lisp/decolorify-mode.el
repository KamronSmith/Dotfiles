;; -*- lexical-binding: t; -*-

(define-minor-mode kam-decolorify-mode
  "Turn off the colors."
  :global t
  (if kam-decolorify-mode
      ()
        (kam-standard-themes-reload-theme)))
