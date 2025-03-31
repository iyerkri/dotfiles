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
(setq package-enable-at-startup nil)


;; Install 'use-package' if necessary
;; from CachesToCaches
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;; Enable use-package
(eval-when-compile (require 'use-package))
(require 'bind-key)                ;; if you use any :bind variant


;; recentf
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-c\ \C-r" 'recentf-open-files)

;; Install 'no-littering' to keep emacs.d clearn
;; https://manueluberti.eu/emacs/2017/06/17/nolittering/
;; note: no-littering moves the backup files to 'no-littering-var-directory'
(use-package no-littering
  :ensure t
  :config
  (require 'recentf)
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory))


;; native compilation delete old files
(setq native-compile-prune-cache t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GUI customizations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tool-bar-mode -1)
(menu-bar-mode 1)
(scroll-bar-mode -1)
(line-number-mode 1)
(column-number-mode 1)
(blink-cursor-mode -1)

(setq inhibit-startup-screen t
      initial-scratch-message nil
      initial-major-mode 'org-mode
      use-dialog-box nil)


;; Emacs for you
;; https://github.com/susam/emfy
(setq-default show-trailing-whitespace t)
(setq-default indicate-empty-lines t)
(setq-default indicate-buffer-boundaries 'left)
(setq sentence-end-double-space nil)

(load-theme 'modus-vivendi)

;; Set default font
;; little complicated with daemon mode, as one must
;; set the font after the first FRAME is created.
;; So, we create a function, add it to a hook, and
;; remove it after first run. See, e.g.,
;; emacs.stackexchange.com/questions/59791/font-and-frame-configuration-in-daemon-mode

(defun my-set-font (FRAME)
  "Set font given initial FRAME.
Intended for `after-make-frame-functions'. Remove self after
first run."
  (with-selected-frame FRAME
    (set-frame-font "Iosevka NFM 12" nil t)
    (remove-hook 'after-make-frame-functions #'my-set-font)))

(add-hook 'after-make-frame-functions #'my-set-font)

;; Change cursor color when entering overwrite mode
;; Inspiration from http://emacs-fu.blogspot.com/2009/12/changing-cursor-color-and-shape.html
;; The code there had issues, so this is a complete overhaul (but does less).

(defvar cursor-previous-color (face-attribute 'cursor :background)
  "Previous cursor color.")

(defun overwrite-cursor-warning ()
  "Toggle the cursor to red color if entering overwrite mode."

  (if (eval overwrite-mode)
      (progn
	(setq cursor-previous-color (face-attribute 'cursor :background))
	(set-cursor-color "red"))
    (progn
      (set-cursor-color cursor-previous-color))))

(add-hook 'overwrite-mode-hook 'overwrite-cursor-warning)



;; text scaling on hidpi
;; hopefully temporary
(defun text-scale-shortcut ()
  "Increase font size to reasonable size and back."
  (interactive)

  (if (eval text-scale-mode)
      (text-scale-increase 0)
    (text-scale-increase 3)))

(text-scale-increase 0) ;; call needed to set text-scale-mode
(global-set-key (kbd "C-x y") 'text-scale-shortcut)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Miscellaneous
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq history-length 25)
(savehist-mode 1)
(save-place-mode 1)
(set-language-environment "UTF-8")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;; endless unfill
;; http://endlessparentheses.com/fill-and-unfill-paragraphs-with-a-single-key.html
(defun endless/fill-or-unfill ()
  "Like `fill-paragraph', but unfill if used twice."
  (interactive)
  (let ((fill-column
         (if (eq last-command 'endless/fill-or-unfill)
             (progn (setq this-command nil)
                    (point-max))
           fill-column)))
    (call-interactively #'fill-paragraph)))

(global-set-key [remap fill-paragraph] #'endless/fill-or-unfill)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Solarized theme + customizations
;; (use-package solarized-theme
;;  :ensure t
;;  :init
;;  (setq solarized-use-variable-pitch nil)  ;; no font size changes
;;  (setq solarized-emphasize-indicators nil) ;; less emphasis on errors
;;  (load-theme 'solarized-dark t))


;; smart-mode-line
(use-package smart-mode-line
  :ensure t
  :config
  (setq sml/theme 'automatic)
  (sml/setup))

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
	 ("C-x C-f" . helm-find-files)
	 ("C-c C-r" . helm-recentf)))

;; pdf-tools
(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-page)
  (setq pdf-view-resize-factor 1.1)
  (setq pdf-annot-activate-created-annotations t))




;; auctex
;; https://www.gnu.org/software/auctex/manual/auctex.html#Installation
(use-package tex
  :ensure auctex
  :config
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
  (setq reftex-plug-into-auctex t)
  ;; http://www.gnu.org/software/auctex/manual/auctex/Multifile.html
  (setq-default TeX-master nil) ; Query for master file.
  ;; Use pdf-tools to open PDF files
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
	TeX-source-correlate-start-server t)
  ;; Update PDF buffers after successful LaTeX runs
  (add-hook 'TeX-after-compilation-finished-functions
	    #'TeX-revert-document-buffer))


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
  (beacon-mode t))

;; which-key
(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (which-key-setup-side-window-right-bottom))


;; (use-package org-bullets
;;   :ensure t
;;   :commands (org-bullets-mode)
;;   :init (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))


(use-package org-modern
  :ensure t
  :init (add-hook 'org-mode-hook  'org-modern-mode))


;; org-mode config
;; GTD setup inspired from https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(setq org-agenda-files
      '("~/Dropbox/org/inbox.org"
	"~/Dropbox/org/gtd.org"
	"~/Dropbox/org/tickler.org"))


(setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "DELEGATED(g)" "|" "DONE(d)" "CANCELLED(c)")))
(setq org-log-done "time")
(add-hook 'org-trigger-hook 'save-buffer)

(setq org-capture-templates
      '(("t" "Todo [inbox]" entry
	 (file+headline "~/Dropbox/org/inbox.org" "Tasks") "* TODO %i%?")
        ("T" "Tickler" entry
	 (file+headline "~/Dropbox/org/tickler.org" "Tickler")  "* %i%? \n %U")))

(setq org-refile-targets '(("~/Dropbox/org/gtd.org" :maxlevel . 3)
                           ("~/Dropbox/org/someday.org" :level . 1)
                           ("~/Dropbox/org/tickler.org" :maxlevel . 2)))


(setq org-agenda-warning-days 7
      org-agenda-todo-ignore-scheduled "future"
      org-agenda-todo-ignore-deadlines "far")

;; stolen from https://zzamboni.org/post/beautifying-org-mode-in-emacs/
(setq org-hide-emphasis-markers t)

(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))



(use-package expand-region
  :ensure t
  :bind ("C-'" . er/expand-region)
  :bind ("C-\"" . er/contract-region))


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



;;(define-key nm-tag-map "c"
;;  (lambda ()
;;    "toggle courses tag for message"
;;    (interactive)
;;    (if (member "courses" (notmuch-tree-get-tags))
;;        (notmuch-tree-tag (list "-courses" "+inbox"))
;;      (notmuch-tree-tag (list "+courses" "-inbox")))))

;;(define-key notmuch-tree-mode-map "o"
  ;; (lambda ()
  ;;   "toggle courses (and current course) tag for message"
  ;;   (interactive)
  ;;   (if (member "thiscourse" (notmuch-tree-get-tags))
  ;; 	(notmuch-tree-tag (list "-thiscourse" "-courses" "+inbox"))
  ;;     (notmuch-tree-tag (list "+thiscourse" "+courses" "-inbox")))))

;; (define-key notmuch-search-mode-map "o"
;;   (lambda ()
;;     "toggle courses (and current course) tag for thread"
;;     (interactive)
;;     (if (member "thiscourse" (notmuch-tree-get-tags))
;;         (notmuch-tree-tag (list "-thiscourse" "-courses" "+inbox"))
;;       (notmuch-tree-tag (list "+thiscourse" "+courses" "-inbox")))))






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
