;; -*- lexical-binding: t; -*-

(require 'eww)

(use-package eww
  :custom
  (browse-url-browser-function 'eww-browse-url)
  (eww-auto-rename-buffer 'title)
  (eww-header-line-format nil)
  (eww-bookmarks-directory (expand-file-name "eww/" kam-emacs-cache-directory))
  (eww-history-limit 150)
  (eww-use-external-browser-for-content-type
   "\\`\\(video/\\|audio\\)")
  :config
  (dolist (command '( eww-list-bookmarks eww-add-bookmark eww-bookmark-mode
                      eww-list-buffers eww-toggle-fonts eww-toggle-colors
                      eww-switch-to-buffer))
    (put command 'disabled t)))

(provide 'kam-eww)
;;; kam-eww.el ends here
