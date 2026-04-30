(require 'elfeed)

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

  (elfeed-show-entry-switch #'pop-to-buffer)
  (elfeed-show-unique-buffers t)
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
          ("http://rss.sciam.com/sciam/mindmatters" science scientificamerican)
          ("http://rss.sciam.com/sciam/feature-articles" science scientificamerican)
          ("https://joshblais.com/index.xml" emacs philosophy)
          ("https://protesilaos.com/codelog.xml" emacs linux protesilaos)
          ("https://protesilaos.com/interpretations.xml" art philosophy protesilaos)))

  (add-to-list 'display-buffer-alist
               `("\\*elfeed-search\\*"
                 (display-buffer-in-tab)
                 (dedicated . t)
                 (tab-name . "Elfeed"))))

(provide 'kam-elfeed)
;;; kam-elfeed.el ends here
