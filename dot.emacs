(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

;; gui customizations
(blink-cursor-mode -1)
(column-number-mode 1)
(tool-bar-mode -1)

;; color theme
(require 'color-theme)
(color-theme-initialize)
(color-theme-dark-laptop)


;; python setup
(autoload 'python-mode "python-mode.el" "Python mode." t)
(setq auto-mode-alist (append '(("/*.\.py$" . python-mode)) auto-mode-alist))

;; org-mode
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(setq org-log-done t)
;; org-mode shortcuts
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; Auctex configuration.
;; Master file compile. In multifile latex projects, this
;; settings allows one to "compile" slave files.
;; http://www.gnu.org/software/auctex/manual/auctex/Multifile.html
(setq-default TeX-master nil) ; Query for master file.


;; Some troubleshooting for emacs shell mode
;; Found on Arch wiki
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


;;--------------------------------------------------------------------
;; Lines enabling gnuplot-mode

;; move the files gnuplot.el to someplace in your lisp load-path or
;; use a line like
;;  (setq load-path (append (list "/path/to/gnuplot") load-path))

;; these lines enable the use of gnuplot mode
(autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)
(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot mode" t)

;; this line automatically causes all files with the .gp extension to
;; be loaded into gnuplot mode
(setq auto-mode-alist (append '(("\\.gp$" . gnuplot-mode)) auto-mode-alist))

;; This line binds the function-9 key so that it opens a buffer into
;; gnuplot mode 
(global-set-key [(f9)] 'gnuplot-make-buffer)

;; end of line for gnuplot-mode
;;--------------------------------------------------------------------


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(org-agenda-files (quote ("~/organizer/agenda/research.org" "~/organizer/agenda/admin.org" "~/organizer/agenda/service.org" "~/organizer/agenda/meetings.org"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
