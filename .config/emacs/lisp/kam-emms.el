;; -*- lexical-binding: t; -*-

(require 'emms)

(use-package emms
  :bind
  ("C-c m m" . emms-browser)
  ("C-c m s" . kam-emms-play-pause)
  ("C-c m n" . emms-next-no-error)
  ("C-c m p" . emms-previous)
  ("C-c m e" . emms)
  :custom
  (emms-source-file-default-directory "~/Music/")
  (emms-playlist-buffer-name "*Playlist*")
  :config
  (emms-all)
  (defvar kam-music-library-directory "~/Music/"
    "Default location where music is stored.")

  (setq emms-cache-file (expand-file-name "emms/cache" kam-emacs-cache-directory))
  (setq emms-history-file (expand-file-name "emms/history" kam-emacs-cache-directory))
  (setq emms-score-file (expand-file-name "emms/scores" kam-emacs-cache-directory))

  (setq emms-player-vlc-player (executable-find "vlc")
        emms-info-functions '(emms-info-native))
  (add-to-list 'emms-player-list 'emms-player-vlc)

  (defun kam-emms-add-track-to-playlist (buffer)
    (interactive
     (list (let* ((buf-list (mapcar #'(lambda (buf)
                                        (list (buffer-name buf)))
                                    (emms-playlist-buffer-list)))
                  (sorted-buf-list (sort buf-list
                                         #'(lambda (lbuf rbuf)
                                             (< (length (car lbuf))
                                                (length (car rbuf)))))))
             (emms-completing-read "Playlist buffer to add track: "
                                   sorted-buf-list nil t))))
    (let ((previous-buffer emms-playlist-buffer)
          (previous-selection (overlay-start emms-playlist-mode-selected-overlay)))
      (emms-playlist-ensure-playlist-buffer)
      (emms-playlist-set-playlist-buffer buffer)
      (emms-playlist-mode-add-contents)
      (emms-playlist-set-playlist-buffer previous-buffer)
      (emms-playlist-select previous-selection)))

  (defun kam-emms-insert-track-to-playlist ()
    "Add the current track at point to the playlist set in `kam-emms-insert-track-to-playlist-destination'.
When a prefix is used, ask where to insert the track and place it there."
    (interactive)
    (let* ((name (emms-track-get (emms-playlist-track-at) 'name))
           (prev-playlist emms-playlist-buffer)
           (dest-playlist (if (not current-prefix-arg)
                              kam-emms-insert-track-to-playlist-destination
                            (completing-read
                             "Insert track in: "
                             (mapcar #'buffer-name emms-playlist-buffers) nil t))))
      (unless (eq kam-emms-insert-track-to-playlist-destination dest-playlist)
        (setq kam-emms-insert-track-to-playlist-destination dest-playlist))
      (emms-playlist-set-playlist-buffer dest-playlist)
      (emms-insert-file name)
      (emms-playlist-set-playlist-buffer prev-playlist)
      (message "Added to: %s" dest-playlist)))

  (defun kam-emms-play-pause ()
    "If music from EMMS is playing, pause it.
Otherwise, play."
    (interactive)
    (if emms-player-playing-p
        (emms-pause)
      (emms-start)))

  (defvar-keymap kam-music-map
    :repeat t
    :doc "Repeat map for music"
    "p" 'emms-previous
    "n" 'emms-next))

(use-package emms-browser
  :ensure nil
  :after (emms)
  :hook ((emms-browser-mode . hide-cursor-mode)
         (emms-browser-mode . lin-mode))
  :custom
  (emms-browser-buffer-name "*Music*")
  :config
  (emms-browser-make-filter "All" 'ignore)
  (emms-browser-make-filter "Library" (emms-browser-filter-only-dir kam-music-library-directory))
  ;; (emms-browser-set-filter (assoc "Library" 'emms-browser-filters))

  (add-to-list 'display-buffer-alist
               `((derived-mode . emms-browser-mode)
                 (display-buffer-in-side-window)
                 (mode emms-browser-mode)
                 (side . right)
                 (window-width . 0.3)
                 (window-parameters . ((mode-line-format . none))))))

(use-package emms-playlist-mode
  :ensure nil
  :after (emms)
  :hook ((emms-playlist-mode . hide-cursor-mode)
         (emms-playlist-mode . lin-mode))
  :custom
  (emms-playlist-mode-open-playlists t)
  :config
  (add-to-list 'display-buffer-alist
               '("\\*Playlist\\*"
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (window-height . 0.35)
                 (window-parameters . ((mode-line-format . none))))))

(provide 'kam-emms)
;;; kam-emms.el ends here
