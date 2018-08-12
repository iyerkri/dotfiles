(require 'package)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

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
(setq cursor-read-only-cursor-type 'hbar)
(setq cursor-overwrite-color       "red")
(setq cursor-overwrite-cursor-type 'box)
(setq cursor-normal-color          "#859900")
(setq cursor-normal-cursor-type    'box)

(defun set-cursor-according-to-mode ()
  "change cursor color and type according to some minor modes."

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


;; Solarized theme
(load-theme 'solarized-dark t)


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


;; pdf-tools
(pdf-tools-install)


;; flycheck
(require 'flycheck)
(add-hook 'after-init-hook 'global-flycheck-mode)


;; powerline
(require 'powerline)
(powerline-default-theme)



;; move customizations to a separate file
;; from http://emacsblog.org/2008/12/06/quick-tip-detaching-the-custom-file/
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)
