;;; init.el ---  Initialization file for Emacs
;;; Commentary:
;;; Emacs Startup File --- initialization for Emacs

;;; Code:

;; move customizations to a separate file
;; from http://emacsblog.org/2008/12/06/quick-tip-detaching-the-custom-file/
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)


(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)



;; GUI customizations
(setq-default cursor-type 'box)
(set-cursor-color "#859900")
(blink-cursor-mode -1)
(line-number-mode 1)
(column-number-mode 1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)



;; Modified from http://emacs-fu.blogspot.com/2009/12/changing-cursor-color-and-shape.html
(setq cursor-read-only-color       "gray")
;; valid values are t, nil, box, hollow, bar, (bar . WIDTH), hbar,
;; (hbar. HEIGHT); see the docs for set-cursor-type
(setq cursor-read-only-cursor-type 'bar)
(setq cursor-overwrite-color       "red")
(setq cursor-overwrite-cursor-type 'box)
(setq cursor-normal-color          "#859900")
(setq cursor-normal-cursor-type    'box)

(defun set-cursor-according-to-mode ()
  "Change cursor color and type according to some minor modes."

  (cond
    (buffer-read-only
      (set-cursor-color cursor-read-only-color)
      (setq cursor-type cursor-read-only-cursor-type))
    (overwrite-mode
      (set-cursor-color cursor-overwrite-color)
      (setq cursor-type cursor-overwrite-cursor-type))
    (t 
      (set-cursor-color cursor-normal-color)
      (setq cursor-type cursor-normal-cursor-type))))

(add-hook 'post-command-hook 'set-cursor-according-to-mode)



;; Solarized theme + customizations
(use-package solarized-theme
  :ensure t
  :init
  (setq solarized-use-variable-pitch nil)  ;; no font size changes
  (setq solarized-emphasize-indicators nil) ;; less emphasis on errors
  (load-theme 'solarized-dark t))


;; powerline
(use-package powerline
  :ensure t
  :init (powerline-default-theme))

;; smart-mode-line
(use-package smart-mode-line
  :ensure t
  :config
  (sml/setup)
  (setq sml/theme 'automatic))


;; flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))


;; needs to happen before helm?
(use-package helm-flx
  :ensure t
  :config
  (helm-flx-mode 1))


(use-package helm
  :ensure t
  :bind (("M-x" . helm-M-x)
	 ("C-x C-f" . helm-find-files)))



;; pdf-tools
(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-page)
  (setq pdf-view-resize-factor 1.1)
  (setq pdf-annot-activate-created-annotations t))


  
;; Auctex and reftex config
;; see https://tex.stackexchange.com/questions/20843/useful-shortcuts-or-key-bindings-or-predefined-commands-for-emacsauctex for more.
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-auctex t)
;; Master file compile. In multifile latex projects, this
;; settings allows one to "compile" slave files.
;; http://www.gnu.org/software/auctex/manual/auctex/Multifile.html
(setq-default TeX-master nil) ; Query for master file.

;; Use pdf-tools to open PDF files
(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-source-correlate-start-server t)

;; Update PDF buffers after successful LaTeX runs
(add-hook 'TeX-after-compilation-finished-functions
	  #'TeX-revert-document-buffer)


;; latex-extra
(use-package latex-extra
  :ensure t
  :hook (LaTeX-mode . latex-extra-mode))

(use-package multiple-cursors
  :ensure t
  :bind (("C-." . mc/mark-next-like-this)
         ("C-," . mc/unmark-next-like-this)
	 ("C-c C-." . mc/mark-previous-like-this)
	 ("C-c C-," . mc/unmark-previous-like-this)
         ("C-S-<mouse-1>" . mc/add-cursor-on-click)))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))


;; beacon mode
(use-package beacon
  :ensure t
  :config
  (beacon-mode t)
  (setq beacon-color cursor-normal-color))


;; org-mode config
;; added from many places: David O'Toole Org tutorial
;; and Aaron Bedra's Emacs 26 Configuration
(require 'org)
(add-to-list 'org-modules "org-habit")
(setq org-habit-preceding-days 7
      org-habit-following-days 1
      org-habit-graph-column 80
      org-habit-show-habits-only-for-today t
      org-habit-show-all-today t)
		    
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t
      org-todo-keywords '((sequence "TODO" "INPROGRESS" "DONE"))
      org-todo-keyword-faces '(("INPROGRESS" . (:foreground "blue" :weight bold))))

(setq org-agenda-files 
      (list "~/Dropbox/org/work.org"  "~/Dropbox/org/research.org" "~/Dropbox/org/personal.org"))


(setq org-agenda-show-log t
      org-agenda-todo-ignore-scheduled t
      org-agenda-todo-ignore-deadlines t)

;; stolen from https://zzamboni.org/post/beautifying-org-mode-in-emacs/
(setq org-hide-emphasis-markers t)

(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(use-package org-bullets
  :ensure t
  :commands (org-bullets-mode)
  :init (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; notmuch config
(require 'notmuch)
(define-key global-map "\C-cn" 'notmuch)
;; adapted from https://notmuchmail.org/emacstips/

(defun nm-show-delete ()
  "Toggle deleted tag for message."
  (interactive)
  (if (member "deleted" (notmuch-show-get-tags))
      (notmuch-show-tag (list "-deleted"))
    (notmuch-show-tag (list "+deleted"))))

(defun nm-tree-delete ()
  "Toggle deleted tag for message."
    (interactive)
    (if (member "deleted" (notmuch-tree-get-tags))
        (notmuch-tree-tag (list "-deleted"))
      (notmuch-tree-tag (list "+deleted"))))

(defun nm-search-delete ()
  "Toggle deleted tag for message."  
    (interactive)
    (if (member "deleted" (notmuch-search-get-tags))
        (notmuch-search-tag (list "-deleted"))
      (notmuch-search-tag (list "+deleted"))))

(define-key notmuch-show-mode-map "d" 'nm-show-delete)
(define-key notmuch-tree-mode-map "d" 'nm-tree-delete)
(define-key notmuch-search-mode-map "d" 'nm-search-delete)

(define-prefix-command 'nm-show-tag-map)
(define-prefix-command 'nm-tree-tag-map)
(define-prefix-command 'nm-search-tag-map)
(define-key notmuch-show-mode-map "g" 'nm-show-tag-map)
(define-key notmuch-tree-mode-map "g" 'nm-tree-tag-map)
(define-key notmuch-search-mode-map "g" 'nm-search-tag-map)

(define-key nm-show-tag-map "t"
  (lambda ()
    "toggle courses (and current course) tag for message"
    (interactive)
    (if (member "thiscourse" (notmuch-show-get-tags))
        (notmuch-show-tag (list "-thiscourse" "-courses" "+inbox"))
      (notmuch-show-tag (list "+thiscourse" "+courses" "-inbox")))))

(define-key nm-show-tag-map "c"
  (lambda ()
    "toggle courses tag for message"
    (interactive)
    (if (member "courses" (notmuch-show-get-tags))
        (notmuch-show-tag (list "-courses" "+inbox"))
      (notmuch-show-tag (list "+courses" "-inbox")))))

(define-key nm-show-tag-map "m"
  (lambda ()
    "toggle mEng tag for message"
    (interactive)
    (if (member "mEng" (notmuch-show-get-tags))
	(notmuch-show-tag (list "-mEng" "+inbox"))
      (notmuch-show-tag (list "+mEng" "-inbox")))))

(define-key nm-show-tag-map "r"
  (lambda ()
    "toggle review tag for message"
    (interactive)
    (if (member "review" (notmuch-show-get-tags))
	(notmuch-show-tag (list "-review" "+inbox"))
      (notmuch-show-tag (list "+review" "-inbox")))))

(define-key nm-show-tag-map "g"
  (lambda ()
    "toggle grants tag for message"
    (interactive)
    (if (member "grants" (notmuch-show-get-tags))
	(notmuch-show-tag (list "-grants" "+inbox"))
      (notmuch-show-tag (list "+grants" "-inbox")))))

(define-key nm-tree-tag-map "t"
  (lambda ()
    "toggle courses (and current course) tag for message"
    (interactive)
    (if (member "thiscourse" (notmuch-tree-get-tags))
        (notmuch-tree-tag (list "-thiscourse" "-courses" "+inbox"))
      (notmuch-tree-tag (list "+thiscourse" "+courses" "-inbox")))))

(define-key nm-tree-tag-map "c"
  (lambda ()
    "toggle courses tag for message"
    (interactive)
    (if (member "courses" (notmuch-tree-get-tags))
        (notmuch-tree-tag (list "-courses" "+inbox"))
      (notmuch-tree-tag (list "+courses" "-inbox")))))

(define-key nm-tree-tag-map "m"
  (lambda ()
    "toggle mEng tag for message"
    (interactive)
    (if (member "mEng" (notmuch-tree-get-tags))
	(notmuch-tree-tag (list "-mEng" "+inbox"))
      (notmuch-tree-tag (list "+mEng" "-inbox")))))

(define-key nm-tree-tag-map "r"
  (lambda ()
    "toggle review tag for message"
    (interactive)
    (if (member "review" (notmuch-tree-get-tags))
	(notmuch-tree-tag (list "-review" "+inbox"))
      (notmuch-tree-tag (list "+review" "-inbox")))))

(define-key nm-tree-tag-map "g"
  (lambda ()
    "toggle grants tag for message"
    (interactive)
    (if (member "grants" (notmuch-tree-get-tags))
	(notmuch-tree-tag (list "-grants" "+inbox"))
      (notmuch-tree-tag (list "+grants" "-inbox")))))


(define-key nm-search-tag-map "t"
  (lambda ()
    "toggle courses (and current course) tag for message"
    (interactive)
    (if (member "thiscourse" (notmuch-search-get-tags))
        (notmuch-search-tag (list "-thiscourse" "-courses" "+inbox"))
      (notmuch-search-tag (list "+thiscourse" "+courses" "-inbox")))))

(define-key nm-search-tag-map "c"
  (lambda ()
    "toggle courses tag for message"
    (interactive)
    (if (member "courses" (notmuch-search-get-tags))
        (notmuch-search-tag (list "-courses" "+inbox"))
      (notmuch-search-tag (list "+courses" "-inbox")))))

(define-key nm-search-tag-map "m"
  (lambda ()
    "toggle mEng tag for message"
    (interactive)
    (if (member "mEng" (notmuch-search-get-tags))
	(notmuch-search-tag (list "-mEng" "+inbox"))
      (notmuch-search-tag (list "+mEng" "-inbox")))))

(define-key nm-search-tag-map "r"
  (lambda ()
    "toggle review tag for message"
    (interactive)
    (if (member "review" (notmuch-search-get-tags))
	(notmuch-search-tag (list "-review" "+inbox"))
      (notmuch-search-tag (list "+review" "-inbox")))))

(define-key nm-search-tag-map "g"
  (lambda ()
    "toggle grants tag for message"
    (interactive)
    (if (member "grants" (notmuch-search-get-tags))
	(notmuch-search-tag (list "-grants" "+inbox"))
      (notmuch-search-tag (list "+grants" "-inbox")))))










(setq notmuch-show-all-multipart/alternative-parts nil)


;; send mail through gnus
(setq message-send-mail-function 'message-send-mail-with-sendmail)
(setq sendmail-program "/usr/local/bin/msmtpq")
(setq message-sendmail-f-is-evil t)
(setq mail-host-address "DOMAIN.EDU")
(setq user-full-name "Krishnamurthy Iyer")
(setq user-mail-address "EMAIL@DOMAIN.EDU")
;; set the folder where outgoing mail must be saved
(setq notmuch-fcc-dirs "FOLDER/Sent/ +sent -new")


(setq notmuch-search-oldest-first nil
      notmuch-show-indent-messages-width 4
      message-kill-buffer-on-exit t)







;;; init.el ends here
