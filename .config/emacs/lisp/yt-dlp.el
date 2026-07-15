;; -*- lexical-binding: t; -*-
(require 'kam-os)

(defvar kam-ytdlp-download-music-history nil
  "Minibuffer history of `kam-ytdlp-download-music'.")

(defun kam-ytdlp-download-music (url)
  "Download a music video from YouTube, given URL."
  (interactive
   (list (read-string "URL from Youtube: " nil kam-ytdlp-download-music-history (car kam-ytdlp-download-music-history))))
  (let* ((default-directory "~/Music"))
    (async-shell-command
     (concat
      "yt-dlp "
      (shell-quote-argument url)
      " -t mp3 --audio-quality 0 "
      "--embed-thumbnail "
      "--no-playlist"))))

(defvar kam-ytdlp-download-video-history nil
  "Minibuffer history for `kam-ytdlp-download-video'.")

(defun kam-ytdlp--download-prompt (hist)
  "Prompt for getting the URL for the user.
HIST is a variable that corresponds to what history the prompt is for,
music or video."
  (let ((default (car hist)))
    (read-string (format-prompt "URL" default)
                 nil hist default)))

(defun kam-ytdlp-download-video (url)
  "Download a video from the internet."
  (interactive (list (kam-ytdlp--download-prompt kam-ytdlp-download-video-history)))
  (let ((default-directory kam-videos-directory))
    (async-shell-command
     (concat
      "yt-dlp "
      "-t mp4 "
      (shell-quote-argument url)))))
