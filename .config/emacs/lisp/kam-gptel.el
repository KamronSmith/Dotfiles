;;; kam-gptel.el --- -*- lexical-binding: t; -*-
;;; Summary: 

;;; Commentary: 

;;; Code:
(require 'gptel)

(defun chatgpt ()
  "Get a ChatGPT buffer."
  (interactive)
  (gptel "*ChatGPT*")
  (pop-to-buffer "*ChatGPT*"))

(defun claude ()
  "Get a Claude buffer."
  (interactive)
  (pop-to-buffer (gptel "*Claude*")))

(provide 'kam-gptel)
;;; kam-gptel.el ends here
