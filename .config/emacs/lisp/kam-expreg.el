(require 'expreg)

(defun kam-expreg-sexp--dim (fn)
  "Return a cons cell of the dimensions of the Expreg function FN.
These dimensions do not include the delimiters. See `kam-expreg-sexp'."
  (let* ((dim (funcall fn))
         (beg (cadr (cadr dim)))
         (end (cddr (cadr dim))))
    (cons beg end)))

(defun kam-expreg--sexp ()
  "Return a cons cell of the start and end of the at point.
Does not include the delimiters."
  (save-excursion
    (cond
     ((expreg--inside-string-p)
      (kam-expreg-sexp--dim 'expreg--string))
     ((expreg--inside-comment-p)
      (kam-expreg-sexp--dim 'expreg--comment))
     (t
      (let* ((dim (nth 1 (expreg--sort-regions (expreg--list))))
             (beg (car (cdr dim)))
             (end (cdr (cdr dim))))
        (cons beg end))))))

(defun kam-kill-inner-sexp ()
  "Kill the inside of a pair of delimiters at point.
Respects comments and strings. Powered by `kam-expreg--sexp'."
  (interactive)
  (kam--mark (kam-expreg--sexp))
  (kill-region nil nil t))
