(use-package elfeed
  :bind
  ("C-c r" . elfeed)
  (:map elfeed-search-mode-map
        ("g" . 'elfeed-update))
  :custom
  (elfeed-db-directory (expand-file-name "elfeed" kam-emacs-cache-directory))
  (elfeed-enclosure-default-dir (expand-file-name "elfeed" kam-emacs-cache-directory))
  (elfeed-search-title-max-width 125)
  (elfeed-search-title-min-width 30)
  (elfeed-search-clipboard-type 'CLIPBOARD)
  (elfeed-search-filter "@2-weeks-ago +unread")
  (elfeed-show-truncate-long-urls t)
  (elfeed-search-date-format '("%F %R" 20 :left))
  :config
  (setq elfeed-feeds
        '(("https://www.artofmanliness.com/feed/" culture manhood)
          ("https://xkcd.com/rss.xml" science comics)
          ("https://www.brainpickings.org/feed/" culture art)
          ("https://donaldrobertson.name/feed/" philosophy)
          ("https://startingstrength.com/rss.rss" health strengthtraining)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCUMwY9iS8oMyWDYIe6_RmoA" programming technology noboilerplate)
          ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCVls1GmFKf6WlTraIb_IaJg")
          ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCmdlnVFzmf7Zhqm_QE-UlJw")
          ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UC68TLK0mAEzUyHx5x5k-S1Q")
          ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCIh_TPYPqjJuS_-nOfAIlfg")
          ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCsvn_Po0SmunchJYOWpOxMg")
          ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCPdaxSov0mgwh77JvjQO2jQ")
          ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCussGOBf--SiEXrqCh-3rfA")
          ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UC2_krAagEXVPftDXZCDiVZA")
          ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCQjBsscIa_mgEnSvWpm_9vw")
          ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCPIyEJzvW7SsbiIrooixjNA")
          ("http://fetchrss.com/rss/6487d899dbb9ac6a9330dfb26487da4f4d89b76b7c38ece2.xml")
          ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UC6biysICWOJ-C3P4Tyeggzg")
          ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UC2ME6cK8jWnRSWyUdV0yWJw")
          ;; ("https://www.theatlantic.com/feed/all/")
          ("https://www.theatlantic.com/politics/" politics news theatlantic)
          ("https://www.theatlantic.com/science/" science theatlantic)
          ("https://www.theatlantic.com/technology/" technology theatlantic)
          ("https://www.newyorker.com/feed/news" news newyorker)
          ("https://www.newyorker.com/feed/culture" culture newyorker)
          ("https://dynomight.net/feed.xml")
          ("https://every.to/superorganizers/feed.xml")
          ("https://feeds.npr.org/1020/rss.xml")
          ("http://rss.sciam.com/ScientificAmerican-Global" science scientificamerican)
          ("http://rss.sciam.com/sciam/mindmatters" science scientificamerican)
          ("http://rss.sciam.com/sciam/feature-articles" science scientificamerican)
          ("https://joshblais.com/index.xml" emacs philosophy)
          ("https://protesilaos.com/codelog.xml" emacs linux protesilaos)
          ("https://protesilaos.com/interpretations.xml" art philosophy protesilaos))))

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

(use-package calibredb
  :commands (calibredb)
  :bind
  ("C-c b" . calibredb)
  (:map calibredb-search-mode-map
        ("n" . next-line)
        ("p" . previous-line))
  :config
  (setq calibredb-format-nerd-icons t
        calibredb-root-dir "~/Documents/Resources/Books"
        calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir)
        calibredb-library-alist '(("~/Documents/Resources/Books"))
        calibredb-sort-by 'title)

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
