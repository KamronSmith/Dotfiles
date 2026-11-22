;;; Commentary:

;;; Code:
(require 'vc)
(require 'ediff)
(require 'diff)
(require 'kam-common)

;;;###autoload
(defun kam-vc-diff (&optional arg)
  "Compare current buffer with its file, or file with backup or revision.
With optional prefix ARG, compare the file with a selected backup when the file
is not under version control."
  (interactive "P")
  (if (buffer-modified-p)
      (diff-buffer-with-file (current-buffer))
    (condition-case errdata (call-interactively #'vc-diff)
      (error
       (if (string-match-p "not under version control" (cadr errdata))
           (if arg
               (diff (kam-read-backup-file-name (buffer-file-name))
                     (buffer-file-name))
             (diff-backup (buffer-file-name)))
         (apply #'signal errdata))))))

(defun kam-vc-ediff (&optional arg)
  "Run Ediff on the current buffer, file, or backup.
With optional prefix ARG, compare the file with a selected backup when
the file is not under version control."
  (interactive "P")
  (setq kam-ediff--before-buffers (buffer-list))
  (unwind-protect
      (if (buffer-modified-p)
          (call-interactively #'ediff-current-file)
        (condition-case errdata (call-interactively #'vc-ediff)
          (error
           (if (string-match-p "not under version control" (cadr errdata))
               (if arg
                   (ediff-files (kam-read-backup-file-name (buffer-file-name))
                                (buffer-file-name))
                 (ediff-backup (buffer-file-name)))
             (apply #'signal errdata)))))
    ;; Ensure snapshot is cleared if Ediff aborted before startup hook ran
    (setq kam-ediff--before-buffers nil)))

;; ;;;###autoload
;; (defun kam-vc-ediff (&optional arg)
;;   "Run Ediff on the current buffer, file, or backup.
;; With optional prefix ARG, compare the file with a selected backup when
;; the file is not under version control."
;;   (interactive "P")
;;   (if (buffer-modified-p)
;;       (call-interactively #'ediff-current-file)
;;     (condition-case errdata (call-interactively #'vc-ediff)
;;       (error
;;        (if (string-match-p "not under version control" (cadr errdata))
;;            (if arg
;;                (ediff-files (kam-read-backup-file-name (buffer-file-name))
;;                             (buffer-file-name))
;;              (ediff-backup (buffer-file-name)))
;;          (apply #'signal errdata))))))

(provide 'kam-vc)
;;; kam-vc.el ends here
