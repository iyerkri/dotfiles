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


;; better undo?
(use-package undo-tree
  :ensure t
  :diminish undo-tree-mode
  :config
  (global-undo-tree-mode)
  (setq undo-tree-visualizer-timestamps t)
  (setq undo-tree-visualizer-diff t))

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
	 


;;; init.el ends here
