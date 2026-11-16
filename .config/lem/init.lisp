(in-package :lem-user)

(add-hook *prompt-after-activate-hook*
          (lambda ()
            (setf lem/completion-mode::*completion-reverse* t)
            (call-command 'lem/prompt-window::prompt-completion nil)))

(add-hook *prompt-deactivate-hook*
          (lambda ()
            (setf lem/completion-mode::*completion-reverse* nil)
            (lem/completion-mode:completion-end)))

(setf lem-core::*default-prompt-gravity* :bottom-display)
(setf lem/prompt-window::*prompt-completion-window-gravity* :horizontally-above-window)
(setf lem/prompt-window::*fill-width* t)

(setf lem-dashboard:*dashboard-enable* nil)

(defvar *keymap*
  (make-keymap :name '*help-keymap*)
  "Keymap for help commands.")

(define-key *global-keymap* "C-h" *keymap*)

(define-keys *keymap*
  ("b" 'lem-core/commands/help:describe-bindings)
  ("f" 'lem-lisp-mode/internal:lisp-describe-symbol)
  ("k" 'lem-core/commands/help::describe-key)
  ("m" 'lem-core/commands/help::describe-mode))

