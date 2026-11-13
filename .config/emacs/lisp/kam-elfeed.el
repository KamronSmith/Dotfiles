;;; kam-elfeed.el --- -*- lexical-binding: t; -*-
;;; Summary: 

;;; Commentary: 

;;; Code: 
(require 'elfeed)

;;;###autoload
(defun kam-elfeed-show-next ()
  "Show the next entry in the same window. Do not split."
  (interactive)
  (let ((display-buffer-overriding-action '(display-buffer-use-some-window)))
    ;; (split-height-threshold nil)
    ;; (split-width-threshold nil))
    (elfeed-show-next)))

;;;###autoload
(defun kam-elfeed-show-prev ()
  "Show the previous entry in the same window. Do not split."
  (interactive)
  (let ((display-buffer-overriding-action '(display-buffer-use-some-window)))
    ;; (split-height-threshold nil)
    ;; (split-width-threshold nil))
    (elfeed-show-prev)))

(provide 'kam-elfeed)
;;; kam-elfeed.el ends here
