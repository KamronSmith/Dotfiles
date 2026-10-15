(require 'expreg)
(require 'org)

(defun kam-expreg--sexp-dim (fn)
  "Return a cons cell of the dimensions of the Expreg function FN.
These dimensions do not include the delimiters. See `kam-expreg-sexp'."
  (let* ((dim (funcall fn))
         (beg (cadr (cadr dim)))
         (end (cddr (cadr dim))))
    (cons beg end)))

(defun kam-expreg--sexp ()
  "Return a cons cell of the start and end of the sexp at point.
Does not include the delimiters."
  (save-excursion
    (cond
     ((expreg--inside-string-p)
      (kam-expreg--sexp-dim 'expreg--string))
     ((expreg--inside-comment-p)
      (kam-expreg--sexp-dim 'expreg--comment))
     (t
      (let* ((dim (nth 1 (expreg--sort-regions (expreg--list))))
             (beg (car (cdr dim)))
             (end (cdr (cdr dim))))
        (cons beg end))))))

;;;###autoload
(defun kam-mark-inner-sexp ()
  "Mark the inside of a pair of delimiters at point.
Respects comments and strings. Powered by `kam-expreg--sexp'."
  (interactive)
  (kam--mark (kam-expreg--sexp)))

;;;###autoload
(defun kam-kill-inner-sexp ()
  "Kill the inside of a pair of delimiters at point.
Respects comments and strings. Powered by `kam-expreg--sexp'."
  (interactive)
  (kam--mark (kam-expreg--sexp))
  (kill-region nil nil t))

(defun kam-end-of-sexp (&optional arg)
  "Move forward to next end of sexp.
With optional ARG, do it that many times."
  (interactive "p")
  (dotimes (_ arg)
    (goto-char (cdr (kam-expreg--sexp)))))

(defun kam-beginning-of-sexp (&optional arg)
  "Move backward to the beginning of a sexp.
With optional ARG, do it that many times."
  (interactive "p")
  (dotimes (_ arg)
    (goto-char (car (kam-expreg--sexp)))))

(defun kam-expreg--org-heading ()
  "Return a list of regions containing surrounding `org-mode' headings."
  (ignore-errors
    (let (beg end)
      (org-previous-visible-heading 1)
      (setq beg (point))
      (org-next-visible-heading 1)
      (setq end (point))
      `((heading . ,(cons beg end))))))

(defun kam-expreg--org-element ()
  "Return a list of regions containing org items."
  (ignore-errors
    (let (beg end)
      (org-backward-element)
      (setq beg (point))
      (org-forward-element)
      (setq end (point))
      `((element . ,(cons beg end))))))

(provide 'kam-expreg)
