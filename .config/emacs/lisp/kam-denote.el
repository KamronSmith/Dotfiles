;;; kam-denote.el --- -*- lexical-binding: t; -*-
;;; Summary:

;;; Commentary:

;;; Code:
(require 'denote)
(require 'denote-sequence)
(eval-when-compile
  (require 'standard-themes))

(defgroup kam-denote ()
  "Extensions for `denote'."
  :group 'denote)

(defun kam-denote-keywords ()
  "Return a list of keywords based on `denote-keyword-history'."
  (delete-dups (denote-infer-keywords-from-files)))

(defun kam-denote-first-history-keyword ()
  "Return the most recent `denote-keyword-history' element as a list of strings."
  (string-split (car denote-keyword-history) ","))

(defun kam-denote-add-known-keyword ()
  "Add the most recent created keywords to `denote-known-keywords'."
  (mapc (lambda (keyword)
          (when (not (member keyword denote-known-keywords))
            (add-to-list 'denote-known-keywords keyword)))
        (kam-denote-first-history-keyword)))

;;;###autoload
(defun kam-denote-sequence-dired-with-clone ()
  "Clone existing Dired buffer and run `denote-sequence-dired'."
  (interactive)
  (when (not (derived-mode-p 'dired-mode))
    (user-error "Not in a dired-mode buffer"))
  (let* ((prev-subdir-alist dired-subdir-alist)
         (buf (current-buffer)))
    ;; (with-current-buffer buf
    ;;   (clone-indirect-buffer "DIRED-SEQUENCE-CLONE-TEST" t)
    ;;   (setq dired-subdir-alist prev-subdir-alist)
    ;;   (denote-sequence-dired))
    (clone-indirect-buffer "TESTTEST" t)
    (with-current-buffer buf
      (setq dired-subdir-alist prev-subdir-alist)
      (denote-sequence-dired))))

(defun kam-denote-custom-faces-setup ()
  "Set up custom `denote' faces with `standard-themes'."
  (standard-themes-with-colors
    (custom-set-faces
     `(denote-faces-keywords ((,c :foreground ,magenta-warmer :weight normal)))
     `(denote-faces-year ((,c :foreground ,blue-intense)))
     `(denote-faces-month ((,c :foreground ,blue-faint)))
     `(denote-faces-day ((,c :foreground ,blue-faint)))
     `(denote-faces-time ((,c :foreground ,fg-dim)))
     `(denote-faces-hour ((,c :foreground ,fg-dim)))
     `(denote-faces-minute ((,c :foreground ,fg-dim)))
     `(denote-faces-second ((,c :foreground ,fg-dim))))))

(provide 'kam-denote)
;;; kam-denote.el ends here
