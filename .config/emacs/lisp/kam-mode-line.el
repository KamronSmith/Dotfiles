;; -*- lexical-binding: t; -*-

(defgroup kam-mode-line nil
  "My custom mode-line."
  :group 'mode-line)

(defgroup kam-mode-line-faces nil
  "Faces for my custom mode-line."
  :group 'kam-mode-line)

(defvar kam-mode-line-string-truncate-length 15
  "String length after which truncation should be done in small windows.")

(defface kam-mode-line-indicator-button nil
  "Generic face for indicators that have a background.")

(defface kam-mode-line-indicator-red
  '((default :inherit bold)
    (((class color) (min-colors 88) (background light))
     :foreground "#880000")
    (((class color) (min-colors 88) (background dark))
     :foreground "#ff9f9f")
    (t :foreground "red"))
  "Face for mode-line indicators."
  :group 'kam-mode-line-faces)

(defface kam-mode-line-indicator-red-bg
  '((default :inherit (bold kam-mode-line-indicator-button))
    (((class color) (min-colors 88) (background light))
     :background "#aa1111" :foreground "white")
    (((class color) (min-colors 88) (background dark))
     :background "#ff9090" :foreground "black")
    (t :background "red" :foreground "black"))
  "Face for mode-line indicators with a background."
  :group 'kam-mode-line-faces)

(defface kam-mode-line-indicator-green
  '((default :inherit bold)
    (((class color) (min-colors 88) (background light))
     :foreground "#005f00")
    (((class color) (min-colors 88) (background dark))
     :foreground "#73fa7f")
    (t :foreground "green"))
  "Face for mode-line indicators."
  :group 'kam-mode-line-faces)

(defface kam-mode-line-indicator-yellow
  '((default :inherit bold)
    (((class color) (min-colors 88) (background light))
     :foreground "#6f4000")
    (((class color) (min-colors 88) (background dark))
     :foreground "#f0c526")
    (t :foreground "yellow"))
  "Face for mode-line indicators."
  :group 'kam-mode-line-faces)

(defface kam-mode-line-indicator-yellow-bg
  '((default :inherit (bold kam-mode-line-indicator-button))
    (((class color) (min-colors 88) (background light))
     :background "#805000" :foreground "white")
    (((class color) (min-colors 88) (background dark))
     :background "#ffc800" :foreground "black")
    (t :background "yellow" :foreground "black"))
  "Face for mode-line indicators with a background."
  :group 'kam-mode-line-faces)

(defface kam-mode-line-indicator-orange
  '((default :inherit bold)
    (((class color) (min-colors 88) (background light))
     :foreground "#6f4000")
    (((class color) (min-colors 88) (background dark))
     :foreground "#f0c526")
    (t :foreground "orange"))
  "Face for mode-line indicators."
  :group 'kam-mode-line-faces)

(defface kam-mode-line-indicator-orange-bg
  '((default :inherit (bold kam-mode-line-indicator-button))
    (((class color) (min-colors 88) (background light))
     :background "#FFBF00" :foreground "white")
    (((class color) (min-colors 88) (background dark))
     :background "#FFBF00" :foreground "black")
    (t :background "orange" :foreground "black"))
  "Face for mode-line indicators with a background."
  :group 'kam-mode-line-faces)

(defface kam-mode-line-indicator-blue
  '((default :inherit bold)
    (((class color) (min-colors 88) (background light))
     :foreground "#00228a")
    (((class color) (min-colors 88) (background dark))
     :foreground "#88bfff")
    (t :foreground "blue"))
  "Face for mode-line indicators."
  :group 'kam-mode-line-faces)

(defface kam-mode-line-indicator-blue-bg
  '((default :inherit (bold kam-mode-line-indicator-button))
    (((class color) (min-colors 88) (background light))
     :background "#0000aa" :foreground "white")
    (((class color) (min-colors 88) (background dark))
     :background "#77aaff" :foreground "black")
    (t :background "blue" :foreground "black"))
  "Face for mode-line indicators with a background."
  :group 'kam-mode-line-faces)

(defface kam-mode-line-indicator-magenta
  '((default :inherit bold)
    (((class color) (min-colors 88) (background light))
     :foreground "#6a1aaf")
    (((class color) (min-colors 88) (background dark))
     :foreground "#e0a0ff")
    (t :foreground "magenta"))
  "Face for mode-line indicators."
  :group 'kam-mode-line-faces)

(defface kam-mode-line-indicator-magenta-bg
  '((default :inherit (bold kam-mode-line-indicator-button))
    (((class color) (min-colors 88) (background light))
     :background "#6f0f9f" :foreground "white")
    (((class color) (min-colors 88) (background dark))
     :background "#e3a2ff" :foreground "black")
    (t :background "magenta" :foreground "black"))
  "Face for mode-line indicators with a background."
  :group 'kam-mode-line-faces)

(defface kam-mode-line-indicator-cyan
  '((default :inherit bold)
    (((class color) (min-colors 88) (background light))
     :foreground "#004060")
    (((class color) (min-colors 88) (background dark))
     :foreground "#30b7cc")
    (t :foreground "cyan"))
  "Face for mode-line indicators."
  :group 'kam-mode-line-faces)

(defface kam-mode-line-indicator-cyan-bg
  '((default :inherit (bold kam-mode-line-indicator-button))
    (((class color) (min-colors 88) (background light))
     :background "#006080" :foreground "white")
    (((class color) (min-colors 88) (background dark))
     :background "#40c0e0" :foreground "black")
    (t :background "cyan" :foreground "black"))
  "Face for mode-line indicators with a background."
  :group 'kam-mode-line-faces)

(defface kam-mode-line-indicator-gray
  '((t :inherit shadow))
  "Face for mode-line indicators."
  :group 'kam-mode-line-faces)

(defface kam-mode-line-indicator-gray-bg
  '((default :inherit (bold kam-mode-line-indicator-button))
    (((class color) (min-colors 88) (background light))
     :background "#808080" :foreground "white")
    (((class color) (min-colors 88) (background dark))
     :background "#a0a0a0" :foreground "black")
    (t :inverse-video t))
  "Face for mode-line indicators with a background."
  :group 'kam-mode-line-faces)

(defun kam-mode-line--string-truncate-p (str)
  "Return non-nil if the string should be truncated."
  (cond
   ((or (not (stringp str))
        (string-empty-p str)
        (string-blank-p str))
    nil)
   ((and (kam-window-narrow-p)
         (> (length str) kam-mode-line-string-truncate-length)
         (not (one-window-p :no-minibuffer))))))

(defun kam-mode-line--truncate-p ()
  "Return non-nil if the truncation should happen."
  (and (kam-window-narrow-p)
       (not (one-window-p :no-minibuffer))))

(defun kam-mode-line-string-cut-end (str)
  "Return truncated STR, if appropriate, else return non-truncated STR.
Cut off the end of STR by counding from its start up to `kam-mode-line-string-truncate-length'."
  (if (kam-mode-line--string-truncate-p str)
      (concat (substring str 0 kam-mode-line-string-truncate-length) "...")
    str))

(defun kam-mode-line-string-cut-beginning (str)
  "Return truncated STR, if appropriate, else return non-truncated STR.
Cut off the beginning of STR by counting from its end up to `kam-mode-line-string-truncate-length'."
  (if (kam-mode-line--string-truncate-p str)
      (concat "..." (substring str (- kam-mode-line-string-truncate-length)))
    str))

(defun kam-mode-line-string-cut-middle (str)
  "Return truncated STR, if appropriate, else return non-truncated STR.
Cut off the middle of STR by counting half of `kam-mode-line-string-truncate-length' from both its beginning and end."
  (let ((half (floor kam-mode-line-string-truncate-length 2)))
    (if (kam-mode-line--string-truncate-p str)
        (concat (substring str 0 half) "..." (substring str (- half)))
      str)))

(defun kam-mode-line-string-abbreviate-but-last (str nthlast)
  "Abbreviate STR, keeping NTHLAST words intact.
Also see `kam-mode-line-string-abbreviate'."
  (if (kam-mode-line--string-truncate-p str)
      (let* ((all-strings (split-string str "[_-]"))
             (nbutlast-strings (nbutlast (copy-sequence all-strings) nthlast))
             (last-strings (nreverse (ntake nthlast (nreverse (copy-sequence all-strings)))))
             (first-component (mapconcat #'kam-first-char nbutlast-strings "-"))
             (last-component (mapconcat #'identity last-strings "-")))
        (if (string-empty-p first-component)
            last-component
          (concat first-component "-" last-component)))
    str))

(defun kam-mode-line-string-abbreviate (str)
  "Abbreviate STR individual hyphen or underscore separated words.
Also see `kam-mode-line-string-abbreviate-but-last'."
  (if (kam-mode-line--string-truncate-p str)
      (mapconcat #'kam-mode-line--first-char (split-string str "[_-]") "-")
    str))

(defun kam-mode-line-buffer-lines ()
  "Return how many lines there are in the current buffer."
  (car (buffer-line-statistics)))

(defvar-local kam-mode-line-logo
  '(:eval
    (cond
     ((eq system-type 'gnu/linux)
      (propertize "󰣇 " 'face 'shadow))
     ((eq system-type 'darwin)
      (propertize " " 'face 'shadow))))
  "Mode line construct to display the logo of the current system.")

(defvar-local kam-mode-line-kbd-macro
  '(:eval
    (if (and (mode-line-window-selected-p) defining-kbd-macro)
        (propertize " 󰻃 " 'face 'kam-mode-line-indicator-orange-bg)
      ""))
  "Mode line construct displaying `mode-line-defining-kbd-macro'.
Specific to the current window's mode-line.")

(defvar-local kam-mode-line-rectangle-mark
  '(:eval
    (if (bound-and-true-p rectangle-mark-mode)
        (propertize " 󰹟 " 'face 'kam-mode-line-indicator-orange-bg)
      ""))
  "Mode line construct displaying `rectangle-mark-mode'.")

(defvar-local kam-mode-line-narrow
  '(:eval
    (if (and (mode-line-window-selected-p)
             (buffer-narrowed-p)
             (not (derived-mode-p 'Info-mode 'help-mode 'special-mode 'message-mode)))
        (propertize " Narrowed " 'face 'kam-mode-line-indicator-cyan-bg)
      ""))
  "Mode line construct to report the narrowed state of the current buffer.")

(defvar-local kam-mode-line-remote-file
  '(:eval
    (if (file-remote-p default-directory)
        (propertize "󰢹 "
                    'face 'kam-mode-line-indicator-blue-bg
                    'mouse-face 'mode-line-highlight)
      ""))
  "Mode line construct for showing remote file name.")

(defun kam-mode-line-buffer-identification-face ()
  "Return appropriate face or face list for `kam-mode-line-buffer-identification'."
  (when (mode-line-window-selected-p)
    'mode-line-buffer-id))

(defun kam-mode-line--buffer-name ()
  "Return `buffer-name', truncating it if necessary.
See `kam-mode-line-string-cut-middle'."
  (when-let* ((name (buffer-name)))
    (kam-mode-line-string-cut-middle name)))

(defun kam-mode-line-buffer-name ()
  "Return buffer name, with read-only indicator if relevant."
  (let ((name (kam-mode-line--buffer-name)))
    (if buffer-read-only
        (format "󱀰 %s" name)
      name)))

(defun kam-mode-line-buffer-name-help-echo ()
  "Return `help-echo' value for `kam-mode-line-buffer-identification'."
  (concat
   (propertize (buffer-name) 'face 'mode-line-buffer-id)
   "\n"
   (propertize
    (or (buffer-file-name)
        (format "No underlying file.\nDirectory is: %s" default-directory))
    'face 'font-lock-doc-face)))

(defun kam-mode-line-buffer-modified ()
  "Return a buffer modified icon if the buffer has been modified."
  (if (buffer-modified-p)
      "󰉉"
    ""))

(defvar-local kam-mode-line-buffer-modified
  '(:eval
    (propertize (kam-mode-line-buffer-modified)
                'face 'kam-mode-line-indicator-gray
                'mouse-face 'mode-line-highlight
                'help-echo (kam-mode-line-buffer-name-help-echo)))
  "Mode line construct for displaying the status of buffer modification.")

(defvar-local kam-mode-line-buffer-identification
  '(:eval
    (propertize (kam-mode-line-buffer-name)
                'face (kam-mode-line-buffer-identification-face)
                'mouse-face 'mode-line-highlight
                'help-echo (kam-mode-line-buffer-name-help-echo)))
  "Mode line construct for identifying the buffers being displayed.")

(defun kam-mode-line-major-mode-indicator ()
  "Return the appropriate propertized mode line indicator for the major mode."
  (let ((indicator (cond
                    ((derived-mode-p 'text-mode) "§ ")
                    ((derived-mode-p 'prog-mode) "󰘧 ")
                    ((derived-mode-p 'comint-mode) "󰆍 ")
                    (t " "))))
    (propertize indicator 'face 'shadow)))

(defun kam-mode-line-major-mode-name ()
  "Return capitalized `major-mode' without the -mode suffix."
  (concat
   (nerd-icons-icon-for-mode major-mode)
   "  "
   (capitalize
    (string-replace "-mode" "" (symbol-name major-mode)))))

(defun kam-mode-line-major-mode-help-echo ()
  "Return `help-echo' value for `kam-mode-line-major-mode'."
  (if-let* ((parent (get major-mode 'derived-mode-parent)))
      (format "Symbol: `%s'. Derived from: `%s'" major-mode parent)
    (format "Symbol: `%s'." major-mode)))

(defvar-local kam-mode-line-major-mode
  '(:eval
    (concat
     (kam-mode-line-major-mode-indicator)
     " "
     (propertize
      (kam-mode-line-string-abbreviate-but-last
       (kam-mode-line-major-mode-name)
       2)
      'mouse-face 'mode-line-highlight
      'help-echo (kam-mode-line-major-mode-help-echo))))
  "Mode line construct for displaying major modes.")

(defun kam-mode-line-buffer-line-stats ()
  "Return the propertized mode line indicators for the line stats in the current buffer."
  (concat
   (propertize " " 'face 'shadow)
   " "
   (number-to-string (line-number-at-pos))
   (propertize " 󱨄" 'face 'shadow)
   " "
   (kam-mode-line--number-to-string-maybe (kam-mode-line--buffer-percentage))
   (propertize " " 'face 'shadow)
   " "
   (kam-mode-line--buffer-size)))

(defun kam-mode-line--buffer-percentage ()
  "Return the percentage of how far through the current buffer the point is."
  (let ((percent (round (* (/
                            (float (line-number-at-pos))
                            (float (kam-mode-line-buffer-lines)))
                           100))))
    (cond
     ((= percent 0)
      "Top")
     ((= percent 100)
      "Bot")
     (t percent))))

(defun kam-mode-line--number-to-string-maybe (input)
  "If INPUT is a number, turn it into a string.
Or if its a string, keep it as it is."
  (if (natnump input)
      (number-to-string input)
    input))

(defun kam-mode-line--buffer-size ()
  "Return the size of the current buffer."
  (upcase (file-size-human-readable (buffer-size))))

(defvar-local kam-mode-line-buffer-stats-var
  '(:eval
    (kam-mode-line-buffer-line-stats))
  "Mode-line construct for the buffer stats indicator.")

(defvar-local kam-mode-line-process
  '(:eval
    (list '("" mode-line-process))
    "Mode line construct for the running process indicator."))

(declare-function vc-git--symbolic-ref "vc-git" (file))

(defun kam-mode-line--vc-branch-name (file backend)
  "Return capitalized VC branch name for FILE with BACKEND."
  (when-let* ((rev (vc-working-revision file backend))
              (branch (or (vc-git--symbolic-ref file)
                          (substring rev 0 7))))
    (capitalize branch)))

(defun kam-mode-line-diffstat (file)
  "Return shortened Git diff numstat for FILE."
  (when-let* ((output (shell-command-to-string (format "git diff --numstat %s"file)))
              (stats (split-string output "[\s\t]" :omit-nulls "[\s\f\t\n\r\v]+"))
              (added (nth 0 stats))
              (deleted (nth 1 stats)))
    (cond
     ((and (equal added "0") (equal deleted "0"))
      "")
     ((and (not (equal added "0")) (equal deleted "0"))
      (propertize (format "+%s" added) 'face 'kam-mode-line-indicator-green))
     ((and (equal added "0") (not (equal deleted "0")))
      (propertize (format "-%s" deleted) 'face 'kam-mode-line-indicator-red))
     (t
      (concat
       (propertize (format "+%s" added) 'face 'kam-mode-line-indicator-green)
       " "
       (propertize (format "-%s" deleted) 'face 'kam-mode-line-indicator-red))))))

(declare-function vc-git-working-revision "vc-git" (file))

(defvar kam-mode-line-vc-map
  (let ((map (make-sparse-keymap)))
    (define-key map [mode-line down-mouse-1] 'vc-diff)
    (define-key map [mode-line down-mouse-3] 'vc-root-diff)
    map)
  "Keymap used to display a VC indicator.")

(defun kam-mode-line--vc-help-echo (file)
  "Return `help-echo' message for FILE tracked by version control."
  (format "Revision: %s\nmouse-1: `vc-diff'\nmouse-3: `vc-root-diff'"
          (vc-git-working-revision file)))

(defun kam-mode-line--vc-text (file branch &optional face)
  "Prepare text for Git controlled FILE, given BRANCH.
With optional FACE, use it to propertize BRANCH."
  (concat
   (propertize "" 'face 'shadow)
   " "
   (propertize branch
               'face face
               'mouse-face 'mode-line-highlight
               'help-echo (kam-mode-line--vc-help-echo file)
               'local-map kam-mode-line-vc-map)
   " "
   (kam-mode-line-diffstat file)))

(defun kam-mode-line--vc-details (file branch &optional face)
  "Return Git BRANCH details for FILE, truncating it if necessary.
The string is truncated if the width of the window is smaller than `split-width-threshold'."
  (kam-mode-line-string-cut-end
   (kam-mode-line--vc-text file branch face)))

(defvar kam-mode-line--vc-faces
  '((added . vc-locally-added-state)
    (edited . vc-edited-state)
    (removed . vc-removed-state)
    (missing . vc-missing-state)
    (conflict . vc-conflict-state)
    (locked . vc-locked-state)
    (up-to-date . vc-up-to-date-state))
  "VC state faces.")

(defun kam-mode-line--vc-get-face (key)
  "Get face from KEY in `kam-mode-line--vc-faces'."
  (alist-get key kam-mode-line--vc-faces 'up-to-date))

(defun kam-mode-line--vc-face (file backend)
  "Return version control state face for FILE with BACKEND."
  (kam-mode-line--vc-get-face (vc-state file backend)))

(defvar-local kam-mode-line-vc-branch
  '(:eval
    (when-let* (((mode-line-window-selected-p))
                (file (buffer-file-name))
                (backend (vc-backend file))
                ;; ((vc-git-registered file))
                (branch (kam-mode-line--vc-branch-name file backend))
                (face (kam-mode-line--vc-face file backend)))
      (kam-mode-line--vc-details file branch face)))
  "Mode line construct to return propertized VC branch.")

(defun kam-mode-line--compilation-in-progress-p ()
  "Return t if Emacs is compiling something."
  (not (null compilation-in-progress)))

(defun kam-mode-line--recursive-edit-in-progress-p ()
  "Return t if Emacs is in a recursive edit.
Minibuffer counts as a recursive edit, so recursion depth has to be greater than 1."
  (when (> (recursion-depth) 1)
    t))

(defvar-local kam-mode-line-compile
  '(:eval
    (if (kam-mode-line--compilation-in-progress-p)
        (propertize " Compiling "
                    'face 'kam-mode-line-indicator-green
                    'mouse-face 'mode-line-highlight)
      ""))
  "Mode line construct for displaying if Emacs is compiling something.")

(defvar-local kam-mode-line-recursive-edit
  '(:eval
    (if (kam-mode-line--recursive-edit-in-progress-p)
        (propertize " Recursive"
                    'face 'kam-mode-line-indicator-orange-bg)
      ""))
  "Mode line construct for displaying if Emacs is in a recursive edit.")
