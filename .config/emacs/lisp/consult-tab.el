;; -*- lexical-binding: t; -*-


(defun kam-tab-bar--make-completion-list (tab-list)
  "Return completion list of strings formatted from TAB-LIST."
  (mapcar (lambda (tab)
            (let ((index (1+ (tab-bar--tab-index tab)))
                  (name (alist-get 'name tab)))
              (format "%d %s" index name)))
          tab-list))

(defun kam-tab-bar--completion-list-recent ()
  "Return completion list of recent tabs (current not included)."
  (kam-tab-bar--make-completion-list (tab-bar--tabs-recent)))

(defun kam-tab-bar--index-from-candidate (cand)
  "Return prefix index of CAND."
  (let ((match (string-match "^[[:digit:]]+" cand)))
    (when match
      (string-to-number (match-string match cand)))))

(defun kam-tab-bar--tab-from-index (index)
  "Return tab from `(tab-bar-tabs)' by index of CAND."
  (when index
    (nth (1- index) (tab-bar-tabs))))

(defun kam-consult--tab-preview ()
  "Preview function for tabs."
  (let ((orig-wc (current-window-configuration)))
    (lambda (action cand)
      (if (eq action 'exit)
          (set-window-configuration orig-wc nil t)
        (when cand
          (let* ((index (kam-tab-bar--index-from-candidate cand))
                 (tab (kam-tab-bar--tab-from-index index)))
            (when tab
              (if (eq (car tab) 'current-tab)
                  (set-window-configuration orig-wc nil t)
                (set-window-configuration (alist-get 'wc tab) nil t)))))))))

(defun kam-consult--tab-annotate (cand)
  "Annotate current tab."
  (when (equal (car (kam-tab-bar--tab-from-index (kam-tab-bar--index-from-candidate cand))) 'current-tab)
    "Current"))

(defun kam-consult--tab-action-select (cand)
  "Select tab from CAND."
  (tab-bar-select-tab (kam-tab-bar--index-from-candidate cand)))

(defvar kam-consult--tab-history
  "History of tab completion selections.")

(defvar kam-consult--source-tab-recent
  (list :name "Tab"
        :category 'tab
        :narrow ?t
        :default t
        :history 'kam-consult--tab-history
        :items 'kam-tab-bar--completion-list-recent
        :annotate 'kam-consult--tab-annotate
        :action 'kam-consult--tab-action-select
        :state  'kam-consult--tab-preview))

(defun kam-consult-tab ()
  "Select tab with completion and preview."
  (interactive)
  (consult--multi '(kam-consult--source-tab-recent) :prompt "Select tab: "))

(defun kam-consult-tab-close ()
  "Select tab to close it."
  (interactive)
  (tab-bar-close-tab (kam-tab-bar--index-from-candidate (car (consult--multi '(kam-consult--source-tab-recent) :prompt "Close tab: ")))))
