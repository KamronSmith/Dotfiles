;;; kam-comint.el --- -*- lexical-binding: t; -*-
;;; Summary:

;;; Commentary:

;;; Code:
(require 'comint)

(defun kam-comint--beginning-of-prompt-p ()
  "Return non-nil if the point is at the beginning of a Comint prompt."
  (if comint-use-prompt-regexp
      (looking-back comint-prompt-regexp
                    (line-beginning-position))
    (eq (point) (comint-line-beginning-position))))

(defun kam-comint--insert-and-send (&rest args)
  "Insert and execute ARGs in the last Comint prompt.
ARGS is a list of strings."
  (if (kam-comint--beginning-of-prompt-p)
      (progn
        (insert (mapconcat #'identity args " "))
        (comint-send-input))
    (user-error "Not at the beginning of prompt; won't insert: %s" args)))

(defun kam-comint--insert (&rest args)
  "Insert ARGS in the last Comint prompt.
ARGS is a list of strings."
  (if (kam-comint--beginning-of-prompt-p)
      (insert (mapconcat #'identity args " "))
    (user-error "Not at the beginning of prompt; won't insert: %s" args)))

(defun kam-comint--last-input ()
  "Return the last input as a string."
  (buffer-substring-no-properties
   comint-last-input-start
   comint-last-input-end))

(defun kam-comint--history-to-list ()
  "Returns the current Comint buffer's history as a list."
  (when (and (ring-p comint-input-ring)
             (not (ring-empty-p comint-input-ring)))
    (let (history)
      (dotimes (index (ring-length comint-input-ring))
        (push (ring-ref comint-input-ring index) history))
      (delete-dups history)
      (setq history (nreverse history))
      history)))

(defvar kam-comint--input-history-prompt nil
  "Minibuffer history of `kam-comint--input-history-prompt'.
Not to be confused with the shell input history, which is stored in the
`comint-input-ring' (see `kam-comint--history-to-list').")

(defun kam-comint--presorted-completion-table (completions)
  "Completion table for `kam-comint--input-history-prompt' with no sorting."
  (lambda (string pred action)
    (if (eq action 'metadata)
        `(metadata (display-sort-function . ,#'identity))
      (complete-with-action action completions string pred))))

(defun kam-comint--input-history-prompt ()
  "Prompt for completion against `kam-comint--history-to-list'."
  (let* ((history (kam-comint--history-to-list))
         (default (car history)))
    (completing-read
     (format-prompt "Insert command from history: " default)
     (kam-comint--presorted-completion-table history))))

;;;###autoload
(defun kam-comint-input-from-history ()
  "Insert command from the Comint input history."
  (declare (interactive-only t))
  (interactive)
  (kam-comint--insert-and-send
   (kam-comint--input-history-prompt)))

(defun kam-comint--get-args (command)
  "Gets the arguments from a given COMMAND, where COMMAND is a string."
  (let ((args (comint-arguments command 1 nil)))
    (split-string args)))

;;;###autoload
(defun kam-comint-insert-arguments-from-command (&optional arg)
  "Insert any number of arguments from a previously run command.
If there is a numerical argument, the arguments are selected from the
ARGth run command."
  (interactive "p")
  (kam-comint--insert
   (kam-comint--get-args-prompt arg)))

(defun kam-comint--get-args-prompt (&optional arg)
  "Select an argument from a previously run command.
Numerical argument ARG determines the command being selected from to
choose arguments."
  (interactive "p")
  (let* ((command-index (or (- 1 arg) 1))
         (command (nth command-index (kam-comint--history-to-list)))
         (args (kam-comint--get-args command))
         (default (car args)))
    (completing-read
     (format-prompt "Select Arg: " default)
     args
     nil
     t
     nil
     nil
     default
     nil)))

(provide 'kam-comint)
;;; kam-comint.el ends here
