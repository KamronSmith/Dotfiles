;;; kam-org.el --- -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:

(require 'org)
(require 'consult)

(defun kam-org-metaup ()
  "Go to the previous heading or item, or to a higher level heading.
If not on a heading or item, finds the previous heading backwards. If
already on a heading, goes up higher in the tree."
  (interactive)
  (cond
   ((org-at-block-p) (org-up-element))
   ((org-in-src-block-p) (org-babel-goto-src-block-head))
   ((kam-org--level-one-heading-p) (org-backward-heading-same-level 1))
   (t (org-up-element))))

(defun kam-org-metadown ()
  "Go to the next heading or item, or to a higher level heading.
If not on a heading or item, finds the next heading forwards. If already
on a heading, goes up a level."
  (interactive)
  (cond
   ((org-at-block-p) (org-down-element))
   ((org-in-src-block-p) (kam-org-babel-goto-src-block-foot))
   ((kam-org--level-one-heading-p) (org-forward-heading-same-level 1))
   (t (org-next-visible-heading 1))))

(defun kam-org-control-metaup (&optional arg)
  (interactive "p")
  (if (org-at-heading-p)
      (org-metaup arg)
    (backward-up-list arg)))

(defun kam-org-control-metadown (&optional arg)
  (interactive "p")
  (if (org-at-heading-p)
      (org-metadown arg)
    (down-list arg)))

(defun kam-org-item-bounds ()
  "Return a cons cell of the bounds of the item at point."
  (if (org-in-item-p)
      (cons (save-excursion
              (org-beginning-of-item)
              (point))
            (save-excursion
              (org-end-of-item)
              (point)))
    (user-error "%s" "Point is not in an Org item")))

(defun kam-org-insert-super-heading (arg)
  (interactive "P")
  (org-insert-heading arg)
  (cond
   ((org-at-heading-p) (org-promote))
   ((org-at-item-p) (org-indent-item))))

(defun kam-org-mark-item ()
  "Mark the Org item at point."
  (interactive)
  (kam--mark (kam-org-item-bounds)))

(defun kam-org-kill-item ()
  "Kill the Org item at point."
  (interactive)
  (let ((bounds (kam-org-item-bounds)))
    (kill-region (car bounds) (cdr bounds))))

(defun kam-org--level-one-heading-p ()
  "Return non-nil if the point is on a level one Org heading."
  (if (eq (nth 1 (org-heading-components)) 1)
      t
    nil))

(defun kam-org-promote-subtrees ()
  "Promote the subtree and all subtrees under it at point."
  (interactive)
  (org-map-entries
   (org-promote-subtree)
   nil
   'tree))

(defun kam-org-demote-subtrees ()
  "Demote the subtree and all subtrees at point."
  (interactive)
  (org-map-entries
   (org-demote-subtree)
   nil
   'tree))

(defun kam-org-up-heading ()
  "Move up a heading."
  (interactive "p")
  (cond
   ((org-in-src-block-p) (org-babel-goto-src-block-head))
   ((kam-org--level-one-heading-p) (org-backward-heading-same-level arg))
   (t (org-up-element))))

(defun kam-org-insert-date-range ()
  (interactive)
  (org-time-stamp nil)
  (insert "--")
  (org-time-stamp nil))

(defun kam-org-archive-done-tasks ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from
           (org-element-property :begin (org-element-at-point))))
   "/DONE" 'file))

(defun kam-org-agenda-skip-entry-if-not-headline (headline)
  "Skip an agenda entry if it is not under the headline HEADLINE.
HEADLINE should be a string."
  (let* ((parent-heading (save-excursion
                           (org-up-heading-all 1)
                           (org-heading-components)))
         (header (nth 4 parent-heading))
         ;; (level (nth 0 parent-heading))
         (end (org-entry-end-position)))
    (if (string= header headline)
        nil
      end)))

(defun kam-org-agenda-skip-entry-if-property (prop val)
  "Skip an agenda entry if it marked with PROP property with the value VAL.
PROP and VAL should both be a string."
  (let* ((end (org-entry-end-position))
         (prop-regexp (org-re-property prop nil nil val)))
    (if (re-search-forward prop-regxep end t)
        nil
      end)))

(defun kam-org-skip-subtree-if-priority (priority)
  "Skip an agenda subtree if it has a priority of PRIORITY.
PRIORITY may be one of the characters ?A, ?B, or ?C."
  (let ((subtree-end (save-excursion (org-end-of-subtree t)))
        (pri-value (* 1000 (- org-lowest-priority priority)))
        (pri-current (org-get-priority (thing-at-point 'line t))))
    (if (= pri-value pri-current)
        subtree-end
      nil)))

(defun kam-org-refile-to-current-file ()
  "Refile the heading under the point to a heading in the current file only."
  (interactive)
  (let ((org-refile-targets '((nil . (:maxlevel . 10)))))
    (org-refile)))

(defvar kam-org-refile-region-format "\n\n%s")

(defvar kam-org-refile-region-position 'bottom
  "Where to refile a region. Use 'top to refile the region at the beginning of the subtree.")

(defun kam-consult-org-refile-region (beg end &optional copy)
  "Refile the active region with minibuffer completion.
If no region is active, refile the current paragraph.
With prefix arg C-u, copy region instead of killing it."
  (interactive "r\nP")
  (unless (use-region-p)
    (setq beg (save-excursion
                (backward-paragraph)
                (skip-chars-forward "\n\t ")
                (point))
          end (save-excursion
                (forward-paragraph)
                (skip-chars-forward "\n\t ")
                (point))))
  (deactivate-mark)
  (let* ((text (buffer-substring-no-properties beg end))
         (target (save-excursion (consult-org-heading)))
         (buffer (marker-buffer target))
         (pos (marker-position target)))
    (unless copy (kill-region beg end))
    (deactivate-mark)
    (with-current-buffer buffer
      (save-excursion
        (goto-char pos)
        (if (eq kam-org-refile-region-position 'bottom)
            (org-end-of-subtree)
          (org-end-of-meta-data-and-drawers))
        (insert (format kam-org-refile-region-format text))))))

(defvar kam-org-end-block-regexp "#\\+end_\\w+"
  "Regexp that matches the end of an Org Babel block.")

(defun kam-org-babel-goto-src-block-foot ()
  "Go to the end of an Org Babel block."
  (interactive)
  (goto-char (re-search-forward kam-org-end-block-regexp)))

(provide 'kam-org)
;;; kam-org.el ends here
