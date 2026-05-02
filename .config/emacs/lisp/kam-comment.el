;;; kam-comment.el --- Extensions for Emacs commenting commands -*- lexical-binding: t; -*-

;;; Summary:

;;; Commentary:

;;; Code:

(require 'kam-common)

(defgroup kam-comment ()
  "Extensions for commenting commands."
  :group 'comment)

(defcustom kam-comment-timestamp "%F"
  "String representing the timestamp in `kam-comment-timestamp-keyword'."
  :type 'string
  :group 'kam-comment)

(defcustom kam-comment-keywords '("TODO" "FIXME" "NOTE" "REVIEW")
  "List of strings that represents various comment keywords."
  :type 'string
  :group 'kam-comment)

(defvar kam-comment--keyword-history nil
  "Minibuffer history of `kam-comment--keyword-prompt'.")

(defun kam-comment--keyword-prompt (keywords)
  "Prompt for candidate among KEYWORDS per `kam-comment-timestap-keyword'."
  (let ((default (car kam-comment--keyword-history)))
    (completing-read
     (format "Select KEYWORD [%s]: " default)
     keywords nil nil nil 'kam-comment--keyword-history default)))

(defun kam-comment--format-date ()
  "Format date using `format-time-string'."
  (format-time-string kam-comment-timestamp))

(defun kam-comment--timestamp (keyword)
  "Format string using current time KEYWORD."
  (format "%s %s: " keyword (kam-comment--format-date)))

(defun kam-comment--format-comment (string)
  "Format comment STRING per `kam-comment-timestamp-keyword'.
STRING is a combination of a keyword and a timestamp."
  (concat comment-start
          (make-string comment-add (string-to-char comment-start))
          comment-padding
          string
          comment-end))

(defun kam-comment--maybe-newline ()
  "Call `newline' if current line is not empty."
  (unless (kam-line-regexp-p 'empty 1)
    (save-excursion (newline))))

(defun kam-comment-timestamp-keyword (keyword)
  "Add timestamped comment with KEYWORD.

If the point is at the beginning of the line or if the line is empty (no
characters at all or just indentation), the comment is started there in
accordance with `comment-style'. Any existing text after the point will
be pushed to a newline and will not be turned into a comment.

If point is anywhere else on the line and the line is not empty, the
comment is appended to the line with `comment-indent'."
  (interactive
   (list
    (kam-comment--keyword-prompt kam-comment-keywords)))
  (let ((string (kam-comment--timestamp keyword))
        (beg (point)))
    (cond
     ((kam-line-regexp-p 'empty)
      (insert (kam-comment--format-comment string)))
     ((eq beg (line-beginning-position))
      (insert (kam-comment--format-comment string))
      (indent-region beg (point))
      (kam-comment--maybe-newline))
     (t
      (comment-indent t)
      (insert " " string)))))

(defun kam-comment-dwim (n)
  "Comment N lines, defaulting to the current line.
When the region is active, comment its lines instead."
  (interactive "p")
  (if (region-active-p)
      (comment-or-uncomment-region
       (region-beginning) (region-end))
    (comment-line n)))

(provide 'kam-comment)
;;; kam-comment.el ends here
