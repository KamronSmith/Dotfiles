;; -*- lexical-binding: t; -*-
(define-minor-mode kam-writing-mode
  "My writing mode"
  :global nil
  (if kam-writing-mode
      (progn
        (visual-fill-column-mode -1)
        (logos-focus-mode 1)
        ;; (tab-bar-mode -1)
        (kam-standard-themes-reload-theme)
        (hl-line-mode -1))
    (visual-fill-column-mode 1)
    (logos-focus-mode -1)
    ;; (tab-bar-mode 1)
    (kam-standard-themes-reload-theme)
    (hl-line-mode 1)))
