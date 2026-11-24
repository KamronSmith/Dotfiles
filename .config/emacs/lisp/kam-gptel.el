;;; kam-gptel.el --- -*- lexical-binding: t; -*-
;;; Summary:

;;; Commentary:

;;; Code:
(require 'gptel)

;;;###autoload
(defun chatgpt ()
  "Get a ChatGPT buffer."
  (interactive)
  (gptel "*ChatGPT*")
  (pop-to-buffer "*ChatGPT*"))

;;;###autoload
(defun claude ()
  "Get a Claude buffer."
  (interactive)
  (pop-to-buffer (gptel "*Claude*")))

(provide 'kam-gptel)
;;; kam-gptel.el ends here
