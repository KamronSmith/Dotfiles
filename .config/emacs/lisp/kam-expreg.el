;;; kam-expreg.el --- -*- lexical-binding: t; -*-
;;; Summary:

;;; Commentary:

;;; Code:
(require 'expreg)
;; (require 'org)

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
(defun kam-forward-out-sexp (&optional arg)
  "Move forward out of one level of delimiters.
With optional numeric prefix argument ARG, do it that many times."
  (interactive "p")
  (dotimes (_ arg)
    (let* ((dim (kam-expreg--sexp))
           (out (cdr dim)))
      (goto-char (1+ out)))))

;;;###autoload
(defun kam-mark-inner-sexp ()
  "Mark the inside of a pair of delimiters at point.
Respects comments and strings. Powered by `kam-expreg--sexp'."
  (interactive)
  (kam-mark (kam-expreg--sexp)))

;;;###autoload
(defun kam-kill-inner-sexp ()
  "Kill the inside of a pair of delimiters at point.
Respects comments and strings. Powered by `kam-expreg--sexp'."
  (interactive)
  (kam-mark (kam-expreg--sexp))
  (kill-region nil nil t))

;;;###autoload
(defun kam-expreg-end-of-sexp (&optional arg)
  "Move forward to next end of sexp.
With optional numeric prefix ARG, do it that many times. Powered by
`kam-expreg--sexp'."
  (interactive "p")
  (dotimes (_ arg)
    (goto-char (cdr (kam-expreg--sexp)))))

;;;###autoload
(defun kam-expreg-beginning-of-sexp (&optional arg)
  "Move backward to the beginning of a sexp.
With optional numeric prefix ARG, do it that many times. Powered by
`kam-expreg--sexp'."
  (interactive "p")
  (dotimes (_ arg)
    (goto-char (car (kam-expreg--sexp)))))

(declare-function 'org-element-context "org-element")
(declare-function 'org-element-property "org-element-ast")
(declare-function 'org-element-type "org-element-ast")

(defun kam-expreg--org-elements ()
  "Return a list of regions containing `org-mode' elements."
  (when (derived-mode-p 'org-mode)
    (let ((node (org-element-context))
          regions)
      (while node
        (let ((beg (org-element-property :begin node))
              (end (org-element-property :end node))
              (cbeg (org-element-property :contents-begin node))
              (cend (org-element-property :contents-end node)))
          ;; Add the full element/object bounds (excluding org-data root)
          (when (and beg end
                     (not (eq (org-element-type node) 'org-data)))
            (push `(,(org-element-type node) ,beg . ,end) regions))
          ;; Also add inner contents bounds (e.g., link description, bold text, block body)
          (when (and cbeg cend)
            (push `(,(org-element-type node) ,cbeg . ,cend) regions)))
        (setq node (org-element-property :parent node)))
      regions)))

(defun kam-expreg--org-element ()
  (let* ((dim (nth 1 (expreg--sort-regions (kam-expreg--org-elements))))
         (beg (car (cdr dim)))
         (end (cdr (cdr dim))))
    (cons beg end)))

(provide 'kam-expreg)
;;; kam-expreg.el ends here
