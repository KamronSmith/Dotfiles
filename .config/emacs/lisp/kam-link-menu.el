;;; kam-link-menu.el --- -*- lexical-binding: t; -*-
;;; Summary: 

;;; Commentary: 

;;; Code: 
(require 'link-hint)

(defun link-menu--bounds-of-buffer ()
  "Return a cons cell of `point-min' and `point-max'."
  (cons (point-min)) (point-max))

(defun link-menu--collect-links-buffer ()
  (let (all-link-positions)
    (dolist (bounds (link-hint--find-visible-regions (point-min)
                                                     (point-max)))
      (dolist (type link-hint-types)
        (when (link-hint--type-valid-p type)
          (setq all-link-positions
                (append all-link-positions
                        (link-hint--collect (car bounds) (cdr bounds) type))))))
    (sort (cl-delete-duplicates all-link-positions
                                :test #'link-hint--equal
                                ;; types earlier in `link-hint-types' have
                                ;; higher priority
                                :from-end t)
          #'link-hint--<)))

(defun link-menu--collect-links-window ()
  (let (all-link-positions)
    (dolist (bounds (link-hint--find-visible-regions (point-min)
                                                     (point-max)))
      (dolist (type link-hint-types)
        (when (link-hint--type-valid-p type)
          (setq all-link-positions
                (append all-link-positions
                        (link-hint--collect (car bounds) (cdr bounds) type))))))
    (sort (cl-delete-duplicates all-link-positions
                                :test #'link-hint--equal
                                ;; types earlier in `link-hint-types' have
                                ;; higher priority
                                :from-end t)
          #'link-hint--<)))

(defun link-menu--get-links ()
  (let (links)
    (setq links (append links (link-menu--collect-links-buffer)))
    (if links
        links
      (when link-hint-message
        (funcall link-hint-message "No links found."))
      nil)))

(defun link-menu--get-names (links)
  (mapcar (lambda (link)
            (plist-get link :args))
          links))

(defun link-menu--return-link-from-menu (link-name links)
  "Return the link that matches LINK-NAME from LINKS."
  (let* ((chosen))
    (mapcar (lambda (link)
              (when (string-equal (plist-get link :args) link-name)
                (setq chosen link)))
            links)
    chosen))

;;;###autoload
(defun link-menu-open ()
  "test"
  (interactive)
  (let* ((links (link-menu--get-links))
         (names (link-menu--get-names links))
         (chosen (completing-read "test: "
                                  names))
         (link (link-menu--return-link-from-menu chosen links)))
    (link-hint--action :open link)))

(provide 'kam-link-menu)
;;; kam-link-menu.el ends here
