;; -*- lexical-binding: t; -*-

(require 'kam-os)

(use-package elfeed
  :hook (elfeed-show-mode . kam-writing-mode)
  :bind
  ("C-c r" . elfeed)
  (:map elfeed-show-mode-map
        ("n" . kam-elfeed-show-next)
        ("p" . kam-elfeed-show-prev)
        ("SPC" . kam-scroll-down)
        ("<backspace>" . kam-scroll-up))
  (:map elfeed-search-mode-map
        ;; ([remap scroll-down-command] . kam-scroll-up)
        ;; ([remap scroll-up-command] . kam-scroll-down)
        ("g" . elfeed-update))
  :hook ((elfeed-search-mode . hide-cursor-mode)
         (elfeed-search-mode . lin-mode))
  :custom
  (elfeed-db-directory (expand-file-name "elfeed" kam-emacs-cache-directory))
  (elfeed-enclosure-default-dir (expand-file-name "elfeed" kam-emacs-cache-directory))
  (elfeed-search-title-max-width 125)
  (elfeed-search-title-min-width 30)
  (elfeed-search-clipboard-type 'CLIPBOARD)
  (elfeed-search-filter "@2-weeks-ago +unread")
  (elfeed-show-truncate-long-urls t)
  (elfeed-search-date-format '("%F %R" 20 :left))
  (elfeed-show-entry-switch #'pop-to-buffer)
  (elfeed-show-unique-buffers nil)
  (elfeed-use-libxml t)
  :config
  (setq elfeed-feeds
        '(("https://www.artofmanliness.com/feed/" :title "The Art Of Manliness" culture manhood)
          ("https://xkcd.com/rss.xml" science comics)
          ("https://www.brainpickings.org/feed/" :title "The Marginalian" culture art)
          ("https://donaldrobertson.name/feed/" philosophy)
          ("https://startingstrength.com/rss.rss" :title "Starting Strength" health strengthtraining)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCUMwY9iS8oMyWDYIe6_RmoA" :title "NoBoilerplate" programming technology youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCVls1GmFKf6WlTraIb_IaJg" :title "DistroTube" linux youtube)
          ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCmdlnVFzmf7Zhqm_QE-UlJw") Alex Leonidas
          ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UC68TLK0mAEzUyHx5x5k-S1Q") Jeff Nippard
          ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCIh_TPYPqjJuS_-nOfAIlfg") The Bioneer
          ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCsvn_Po0SmunchJYOWpOxMg") VideoGameDunkey
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCPdaxSov0mgwh77JvjQO2jQ" :title "Man Carrying Thing" books culture youtube) ; Man carrying thing
          ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCussGOBf--SiEXrqCh-3rfA") Expatriarch
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC2_krAagEXVPftDXZCDiVZA" :title "Kaname Naito" japanese youtube) ; Kaname Naito
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCQjBsscIa_mgEnSvWpm_9vw" :title "Odysseas" books philosophy youtube)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCPIyEJzvW7SsbiIrooixjNA" :title "Doug's Dharma" buddhism youtube)
          ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UC6biysICWOJ-C3P4Tyeggzg")
          ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UC2ME6cK8jWnRSWyUdV0yWJw")
          ;; ("https://www.theatlantic.com/feed/all/")
          ("https://www.theatlantic.com/politics/" :title "The Atlantic" politics news)
          ("https://www.theatlantic.com/science/" :title "The Atlantic" science)
          ("https://www.theatlantic.com/technology/" :title "The Atlantic" technology culture)
          ("https://www.newyorker.com/feed/news" :title "The New Yorker" news)
          ("https://www.newyorker.com/feed/culture" :title "The New Yorker" culture)
          ("https://dynomight.net/feed.xml" :title "DynoMight")
          ("https://feeds.npr.org/1020/rss.xml" :title "NPR" news)
          ("http://rss.sciam.com/sciam/mindmatters" :title "Scientific American" science)
          ("http://rss.sciam.com/sciam/feature-articles" :title "Scientific American" science)
          ("https://joshblais.com/index.xml" emacs philosophy)
          ("https://protesilaos.com/codelog.xml" :title "Protesilaos" emacs linux)
          ("https://protesilaos.com/interpretations.xml" :title "Protesilaos" art philosophy)))

  (defun kam-elfeed-show-next ()
    "Show the next entry in the same window. Do not split."
    (interactive)
    (let ((display-buffer-overriding-action '(display-buffer-use-some-window)))
      ;; (split-height-threshold nil)
      ;; (split-width-threshold nil))
      (elfeed-show-next)))

  (defun kam-elfeed-show-prev ()
    "Show the previous entry in the same window. Do not split."
    (interactive)
    (let ((display-buffer-overriding-action '(display-buffer-use-some-window)))
      ;; (split-height-threshold nil)
      ;; (split-width-threshold nil))
      (elfeed-show-prev)))

  (add-to-list 'display-buffer-alist
               '("\\*elfeed-search\\*"
                 (display-buffer-in-tab)
                 (dedicated . t)
                 (tab-name . " elfeed")
                 (window-parameters . ((no-delete-other-windows . t))))))

(use-package elfeed-tube
  :after (elfeed)
  :bind
  (:map elfeed-show-mode-map
        ("F" . elfeed-tube-fetch)
        ([remap save-buffer] . elfeed-tube-save)
        :map elfeed-search-mode-map
        ("F" . elfeed-tube-fetch)
        ([remap save-buffer] . elfeed-tube-save))
  :config
  (elfeed-tube-setup))

(use-package elfeed-tube-mpv
  :after (elfeed)
  :bind
  (:map elfeed-show-mode-map
        ("C-c C-f" . elfeed-tube-mpv-follow-mode)
        ("C-c C-w" . elfeed-tube-mpv-where)))

(use-package eww
  :bind
  (:map eww-mode-map
        ("SPC" . kam-scroll-down)
        ("<backspace>" . kam-scroll-up))
  :hook ((eww-mode . centered-cursor-mode))
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

(use-package calibredb
  ;; :commands (calibredb)
  :hook ((calibredb-search-mode . hide-cursor-mode)
         (calibredb-search-mode . lin-mode))
  :bind
  ("C-c b" . calibredb)
  (:map calibredb-search-mode-map
        ("n" . next-line)
        ("p" . previous-line)
        ("N" . calibredb-search-next-page)
        ("P" . calibredb-search-previous-page)
        ("g" . calibredb-search-refresh)
        ("r" . calibredb-filter-dispatch))
  :custom
  (calibredb-format-nerd-icons t)
  (calibredb-root-dir kam-books-directory)
  (calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir))
  (calibredb-library-alist `((,kam-books-directory)))
  (calibredb-sort-by 'title)
  (calibredb-order 'asc)
  (calibredb-id-width 6)
  (calibredb-title-width 75)
  (calibredb-format-width 7)
  :config
  (defcustom kam-books-directory (expand-file-name "Books/" kam-documents-directory)
    "Directory where all of my books live."
    :type 'string
    :group 'kam-os)

  (add-to-list 'display-buffer-alist
               '("\\*calibredb-search\\*"
                 (display-buffer-in-tab)
                 (dedicated . t)
                 (tab-name . " books")))

  (defun kam-calibredb-open-file-with-emacs (&optional candidate)
    "Open file with Emacs. Optional argument CANDIDATE is the selected item."
    (interactive "P")
    (unless candidate
      (setq candidate (car (calibredb-find-candidate-at-point))))
    (find-file (calibredb-get-file-path candidate t)))

  (defun kam-calibredb-search-books ()
    (interactive)
    (let ((consult-ripgrep-command "rg --null --ignore-case --type txt --line-number . --color always --max-columns 500 --no-heading -e ARG OPTS"))
      (consult-ripgrep calibredb-root-dir))))

;;; EMMS
(use-package emms
  :bind
  ("C-c m m" . emms-browser)
  ("C-c m s" . kam-emms-play-pause)
  ("C-c m n" . emms-next-no-error)
  ("C-c m p" . emms-previous)
  ("C-c m e" . emms)
  :custom
  (emms-info-functions '(emms-info-native
                         emms-info-metaflac
                         emms-info-ogginfo))
  (emms-player-list '(emms-player-mpv))
  (emms-player-mpv-player (executable-find "mpv"))
  (emms-source-file-default-directory kam-music-directory)
  (emms-cache-file (expand-file-name "emms/cache" kam-emacs-cache-directory))
  (emms-history-file (expand-file-name "emms/history" kam-emacs-cache-directory))
  (emms-score-file (expand-file-name "emms/scores" kam-emacs-cache-directory))
  :config
  (require 'emms-setup)
  (require 'emms-mpris)
  (emms-all)
  (emms-mpris-enable)

  ;; (setq emms-player-vlc-player (executable-find "vlc")
  ;;       emms-info-functions '(emms-info-native))
  ;; (add-to-list 'emms-player-list 'emms-player-vlc)

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
  :init
  (add-to-list 'display-buffer-alist
               `((derived-mode . emms-browser-mode)
                 (display-buffer-in-tab)
                 (dedicated . t)
                 (tab-name . " music")
                 (window-parameters . ((no-delete-other-windows . t)))))
  :hook ((emms-browser-mode . hide-cursor-mode)
         (emms-browser-mode . lin-mode))
  ;; (emms-browser-buffer-name "*Music*")
  :config
  (emms-browser-make-filter "All" 'ignore)
  (emms-browser-make-filter "Library" (emms-browser-filter-only-dir kam-music-directory)))
  ;; (emms-browser-set-filter (assoc "Library" 'emms-browser-filters)))

(use-package emms-playlist-mode
  :ensure nil
  :after (emms)
  :hook (emms-playlist-mode . hide-cursor-mode)
  :bind
  (:map emms-playlist-mode-map
        ("p" . kam-emms-previous)
        ("n" . kam-emms-next))
  :custom
  ;; (emms-playlist-buffer-name "*Playlist*")
  (emms-playlist-mode-open-playlists t)
  :config
  (add-to-list 'display-buffer-alist
               '((derived-mode . emms-playlist-mode)
                 (display-buffer-in-side-window display-buffer-reuse-window)
                 (side . right)
                 (window-width . 0.30)
                 (window-parameters . ((mode-line-format . none)))))

  (defun kam-emms-next ()
    "Start playing the next track in the EMMS playlist and move the cursor as well.
With optional ARG, go to the next song that many times."
    (interactive)
    (emms-next)
    (forward-line))

  (defun kam-emms-previous ()
    "Start playing the previous track in the EMMS playlist and move the cursor as well.
With optional ARG, go to the previous song that many times."
    (interactive)
    (emms-previous)
    (forward-line -1))

  (with-eval-after-load 'popper
    (add-to-list 'popper-reference-buffers
                 'emms-playlist-mode t)))

;;; LLM Client
(use-package gptel)

(provide 'kam-applications)
