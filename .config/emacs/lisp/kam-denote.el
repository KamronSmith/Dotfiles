;;; kam-denote.el --- -*- lexical-binding: t; -*-
;;; Summary:

;;; Commentary:

;;; Code:
(require 'denote)
(require 'denote-sequence)

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

(provide 'kam-denote)
;;; kam-denote.el ends here
