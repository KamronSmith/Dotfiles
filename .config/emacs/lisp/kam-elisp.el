;;; kam-elisp.el --- -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:

(defun kam-elisp-header ()
  "Return the file's header as a string."
  (concat
   ";;; "
   (file-name-nondirectory (buffer-file-name))
   " --- -*- lexical-binding: t; -*-"))

(defun kam-elisp-middle ()
  "Return the main part of an Elisp file as a string."
  (concat
   ";;; Summary: \n\n"
   ";;; Commentary: \n\n"
   ";;; Code: \n"))

(defun kam-elisp-footer ()
  "Return the file's footer as a string."
  (concat
   "(provide '"
   (file-name-base (buffer-file-name))
   ")\n;;; "
   (file-name-nondirectory (buffer-file-name))
   " ends here"))

;;;###autoload
(defun kam-elisp-insert-boilerplate ()
  "Insert the boilerplate necessary for an Elisp file."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (insert (kam-elisp-header))
    (newline)
    (insert (kam-elisp-middle))
    (goto-char (point-max))
    (insert (kam-elisp-footer))))

(provide 'kam-elisp)
;;; kam-elisp.el ends here
