;;; kam-emms.el --- -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:
(require 'emms)

(defgroup kam-emms ()
  "Extensions for `emms'."
  :group 'emms)

;;;###autoload
(defun kam-emms-play-pause ()
  "If music from EMMS is playing, pause it.
Otherwise, play."
  (interactive)
  (if emms-player-playing-p
      (emms-pause)
    (emms-start)))

;;;###autoload
(defun kam-emms-next ()
  "Start playing the next track in the EMMS playlist and move the cursor as well.
With optional ARG, go to the next song that many times."
  (interactive)
  (emms-next)
  (forward-line))

;;;###autoload
(defun kam-emms-previous ()
  "Start playing the previous track in the EMMS playlist and move the cursor as well.
With optional ARG, go to the previous song that many times."
  (interactive)
  (emms-previous)
  (forward-line -1))

(provide 'kam-emms)
;;; kam-emms.el ends here
