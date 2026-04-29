;; -*- lexical-binding: t; -*-
(defun kam-ytdlp-download-music-video (url)
  "Download a music video from YouTube."
  (interactive
   (list (read-string "URL from Youtube: ")))
  (let* ((default-directory "~/Music"))
    (async-shell-command
     (concat
      "yt-dlp "
      (shell-quote-argument url)
      " -t mp3 --audio-quality 0 "
      "--embed-thumbnail "
      "--no-playlist"))))
