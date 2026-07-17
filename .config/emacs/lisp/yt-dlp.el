;; -*- lexical-binding: t; -*-
(require 'kam-os)

(defvar kam-ytdlp-download-music-history nil
  "Minibuffer history of `kam-ytdlp-download-music'.")

;;;###autoload
(defun kam-ytdlp-download-music (url)
  "Download a music video from YouTube, given URL."
  (interactive (list (kam-ytdlp--download-prompt kam-ytdlp-download-music-history)))
  (let* ((default-directory kam-music-directory))
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

;;;###autoload
(defun kam-ytdlp-download-video (url)
  "Download a video from the internet."
  (interactive (list (kam-ytdlp--download-prompt kam-ytdlp-download-video-history)))
  (let ((default-directory kam-videos-directory))
    (async-shell-command
     (concat
      "yt-dlp "
      "-t mp4 "
      (shell-quote-argument url)))))
